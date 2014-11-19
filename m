Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934092AbaKSVSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:18:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933946AbaKSVO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:14:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3.10 44/70] netfilter: nfnetlink_log: fix maximum packet length logged to userspace
Date: Wed, 19 Nov 2014 12:52:35 -0800
Message-Id: <20141119205212.391336181@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205210.913169042@linuxfoundation.org>
References: <20141119205210.913169042@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit c1e7dc91eed0ed1a51c9b814d648db18bf8fc6e9 upstream.

don't try to queue payloads > 0xffff - NLA_HDRLEN, it does not work.
The nla length includes the size of the nla struct, so anything larger
results in u16 integer overflow.

This patch is similar to
9cefbbc9c8f9abe (netfilter: nfnetlink_queue: cleanup copy_range usage).

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nfnetlink_log.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -45,7 +45,8 @@
 #define NFULNL_NLBUFSIZ_DEFAULT	NLMSG_GOODSIZE
 #define NFULNL_TIMEOUT_DEFAULT 	100	/* every second */
 #define NFULNL_QTHRESH_DEFAULT 	100	/* 100 packets */
-#define NFULNL_COPY_RANGE_MAX	0xFFFF	/* max packet size is limited by 16-bit struct nfattr nfa_len field */
+/* max packet size is limited by 16-bit struct nfattr nfa_len field */
+#define NFULNL_COPY_RANGE_MAX	(0xFFFF - NLA_HDRLEN)
 
 #define PRINTR(x, args...)	do { if (net_ratelimit()) \
 				     printk(x, ## args); } while (0);
@@ -255,6 +256,8 @@ nfulnl_set_mode(struct nfulnl_instance *
 
 	case NFULNL_COPY_PACKET:
 		inst->copy_mode = mode;
+		if (range == 0)
+			range = NFULNL_COPY_RANGE_MAX;
 		inst->copy_range = min_t(unsigned int,
 					 range, NFULNL_COPY_RANGE_MAX);
 		break;
@@ -677,8 +680,7 @@ nfulnl_log_packet(struct net *net,
 		break;
 
 	case NFULNL_COPY_PACKET:
-		if (inst->copy_range == 0
-		    || inst->copy_range > skb->len)
+		if (inst->copy_range > skb->len)
 			data_len = skb->len;
 		else
 			data_len = inst->copy_range;


