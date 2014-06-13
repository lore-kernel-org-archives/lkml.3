Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbaFMPhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:37:54 -0400
Received: from mail-ie0-f202.google.com ([209.85.223.202]:44943 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaFMPhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:37:52 -0400
Date: Fri, 13 Jun 2014 08:37:51 -0700 (PDT)
From: Tom Herbert <therbert@google.com>
To: geert@linux-m68k.org
cc: davem@davemloft.net, linux-next@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [-next] Regression: ssh log in slowdown
Message-ID: <alpine.DEB.2.02.1406130829370.23090@tomh.mtv.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thanks, I applied the series "[PATCH 0/4] Checksum fixes", and the fix
> above, but it doesn't help.
>
> Note that I'm also using NFS root, which doesn't seem to be affected.
> I can happily run "ls -R /" on the serial console during the 10 s delay 
in ssh.
>
Geert,

Thanks for your patience!

Can you try one more patch below with the series applied? Also, can you 
look at 'netstat -s' to see if UDP checksum errors are being reported.

Thanks,
Tom 

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index fdb510c..4b722bc 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2820,8 +2820,8 @@ static inline __sum16 __skb_checksum_validate_complete(struct sk_buff *skb,
 	if (complete || skb->len <= CHECKSUM_BREAK) {
 		__sum16 csum;
 
+		/* skb->csum valid set in __skb_checksum_complete */
 		csum = __skb_checksum_complete(skb);
-		skb->csum_valid = !csum;
 		return csum;
 	}
 
diff --git a/net/core/datagram.c b/net/core/datagram.c
index cf6cc4e..488dd1a 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -744,6 +744,7 @@ __sum16 __skb_checksum_complete_head(struct sk_buff *skb, int len)
 		    !skb->csum_complete_sw)
 			netdev_rx_csum_fault(skb->dev);
 	}
+	skb->csum_valid = !sum;
 	return sum;
 }
 EXPORT_SYMBOL(__skb_checksum_complete_head);
@@ -767,6 +768,7 @@ __sum16 __skb_checksum_complete(struct sk_buff *skb)
 	skb->csum = csum;
 	skb->ip_summed = CHECKSUM_COMPLETE;
 	skb->csum_complete_sw = 1;
+	skb->csum_valid = !sum;
 
 	return sum;
 }
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
