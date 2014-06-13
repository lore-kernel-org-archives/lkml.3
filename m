Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbaFMIWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 04:22:05 -0400
Received: from mail-qa0-f73.google.com ([209.85.216.73]:42232 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaFMIV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 04:21:58 -0400
Date: Fri, 13 Jun 2014 01:21:57 -0700 (PDT)
From: Tom Herbert <therbert@google.com>
To: geert@linux-m68k.org
cc: davem@davemloft.net, linux-next@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [-next] Regression: ssh log in slowdown
Message-ID: <alpine.DEB.2.02.1406130111280.1551@tomh.mtv.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I assume this is the series "[PATCH 0/4] Checksum fixes"
> (marc.info/?l=linux-netdev&m=140261417832399&w=2)?
>
Yes.

> As I'm not subscribed to netdev, I cannot reply to that thread.
>
> "[PATCH 1/4] net: Fix save software checksum complete" fixes the issue
> for me.
> However, "[PATCH 2/4] udp: call __skb_checksum_complete when doing full
> checksum" reintroduces the exact same bad behavior :-(
>
This implies the problem is happening in UDP path. AFAICT skb->csum is 
correct, and I don't seem to be able to reproduce the issue on my setup. 
It is possible that an skb copy is happening in which case we don't copy
csum_valid so that checksum_unnecessary would fail in this case.

Can you try with the patch below. Thanks!

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index bf92824..9cd5344 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -689,6 +689,9 @@ static void __copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
 	new->ooo_okay		= old->ooo_okay;
 	new->no_fcs		= old->no_fcs;
 	new->encapsulation	= old->encapsulation;
+	new->encap_hdr_csum	= old->encap_hdr_csum;
+	new->csum_valid		= old->csum_valid;
+	new->csum_complete_sw	= old->csum_complete_sw;
 #ifdef CONFIG_XFRM
 	new->sp			= secpath_get(old->sp);
 #endif
