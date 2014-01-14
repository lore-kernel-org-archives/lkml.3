Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbaANHbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 02:31:35 -0500
Received: from smtprelay0009.hostedemail.com ([216.40.44.9]:38557 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752379AbaANHba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 02:31:30 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:960:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3867:3871:3872:4321:5007:6119:6120:7652:7903:8603:10004:10400:10848:11026:11232:11658:11914:12296:12517:12519:12555:13069:13146:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: route42_64459adde4a21
X-Filterd-Recvd-Size: 1950
Message-ID: <1389684687.24849.39.camel@joe-AO722>
Subject: [RFC PATCH] audit: Use hex_byte_pack_upper
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 13 Jan 2014 23:31:27 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the generic kernel function causes the
object size to increase with gcc 4.8.1.

$ size kernel/audit.o*
   text	   data	    bss	    dec	    hex	filename
  18577	   6079	   8436	  33092	   8144	kernel/audit.o.new
  18579	   6015	   8420	  33014	   80f6	kernel/audit.o.old

Unsigned...
---
Generally, it makes sense to use generic functions
but when it increases object size?  blech.

 kernel/audit.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 2dc7573..af8ad29 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1455,7 +1455,6 @@ void audit_log_n_hex(struct audit_buffer *ab, const unsigned char *buf,
 	int i, avail, new_len;
 	unsigned char *ptr;
 	struct sk_buff *skb;
-	static const unsigned char *hex = "0123456789ABCDEF";
 
 	if (!ab)
 		return;
@@ -1473,10 +1472,8 @@ void audit_log_n_hex(struct audit_buffer *ab, const unsigned char *buf,
 	}
 
 	ptr = skb_tail_pointer(skb);
-	for (i=0; i<len; i++) {
-		*ptr++ = hex[(buf[i] & 0xF0)>>4]; /* Upper nibble */
-		*ptr++ = hex[buf[i] & 0x0F];	  /* Lower nibble */
-	}
+	for (i = 0; i < len; i++)
+		ptr = hex_byte_pack_upper(ptr, buf[i]);
 	*ptr = 0;
 	skb_put(skb, len << 1); /* new string is twice the old string */
 }


