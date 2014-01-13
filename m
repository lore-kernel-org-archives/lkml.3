Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbaAMMBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 07:01:48 -0500
Received: from endeavour.telenet.dn.ua ([195.39.211.45]:55611 "EHLO
	endeavour.telenet.dn.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaAMMBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 07:01:46 -0500
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jan 2014 07:01:46 EST
Message-ID: <52D3D3E5.8080602@telenet.dn.ua>
Date: Mon, 13 Jan 2014 13:54:13 +0200
From: "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] GARP protocol should not send PDUs larger than MTU
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a network interface has many vlan sub-interfaces (~400 or more) with enabled
GVRP, PDUs may become larger than the interface PDU. GARP packet generator
can send multiple PDUs, but it relies heavily on skb_tailroom() not
exceeding maximal packet size.

Patch to fix this issue is proposed, I'm not sure if it's a correct
way to handle this situation, but after a short test looks like it
works - now I get multiple PDUs with maximum size of a 1514 bytes
(1500 MTU) and switch recognizes them now.

MRP protocol can have the same problem, but I can't test it.


Signed-Off-By: Vitaly V. Bursov <vitalyb@telenet.dn.ua>

--- a/net/802/garp.c	2014-01-13 12:55:07.000000000 +0200
+++ b/net/802/garp.c	2014-01-13 12:58:30.000000000 +0200
@@ -210,6 +210,7 @@
  {
  	struct sk_buff *skb;
  	struct garp_pdu_hdr *gp;
+	int extra_size;

  #define LLC_RESERVE	sizeof(struct llc_pdu_un)
  	skb = alloc_skb(app->dev->mtu + LL_RESERVED_SPACE(app->dev),
@@ -221,6 +222,13 @@
  	skb->protocol = htons(ETH_P_802_2);
  	skb_reserve(skb, LL_RESERVED_SPACE(app->dev) + LLC_RESERVE);

+	/* Reserve extra space to avoid PDUs larger than MTU,
+	 * Other code depends on skb_tailroom() to return exact
+	 * usable packet space left */
+	extra_size = skb_tailroom(skb) - (app->dev->mtu - LLC_RESERVE);
+	if (extra_size > 0)
+	    skb_reserve(skb, extra_size);
+
  	gp = (struct garp_pdu_hdr *)__skb_put(skb, sizeof(*gp));
  	put_unaligned(htons(GARP_PROTOCOL_ID), &gp->protocol);
