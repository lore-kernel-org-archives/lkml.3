Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbaIHWKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:10:21 -0400
Received: from omr2.cc.vt.edu ([198.82.141.100]:51541 "EHLO omr2.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665AbaIHWKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:10:20 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Bolle <pebolle@tiscali.nl>
cc: Jerry Chuang <jerry-chuang@realtek.com>, devel@driverdev.osuosl.org,
        nick <xerofoify@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] staging/rtl8192u - check for skb alloc failure
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Mon, 08 Sep 2014 18:09:48 -0400
Message-ID: <75005.1410214188@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible for dev_alloc_skb() to fail. Propagate the error to the caller,
so it can clean up and drop the packet. The sender should end up retransmitting
the packet, hopefully at a time we're prepared to allocate skb's again.

Reported-By: Nicholas Krause <xerofoify@gmail.com>
Signed-Off-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c	2014-09-05 15:51:00.005660044 -0400
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c	2014-09-08 17:42:16.773748142 -0400
@@ -847,6 +847,8 @@ static u8 parse_subframe(struct sk_buff
 #else
 			/* Allocate new skb for releasing to upper layer */
 			sub_skb = dev_alloc_skb(nSubframe_Length + 12);
+			if (!sub_skb)
+				return 0;
 			skb_reserve(sub_skb, 12);
 			data_ptr = (u8 *)skb_put(sub_skb, nSubframe_Length);
 			memcpy(data_ptr, skb->data, nSubframe_Length);


