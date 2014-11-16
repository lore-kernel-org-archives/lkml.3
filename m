Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaKPWBS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:01:18 -0500
Received: from 1wt.eu ([62.212.114.60]:47967 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbaKPWBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:01:11 -0500
Message-Id: <20141116215330.185008446@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:54:05 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 37/48] netfilter: nfnetlink_log: fix maximum packet length
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 logged to userspace

From: Florian Westphal <fw@strlen.de>

don't try to queue payloads > 0xffff - NLA_HDRLEN, it does not work.
The nla length includes the size of the nla struct, so anything larger
results in u16 integer overflow.

This patch is similar to
9cefbbc9c8f9abe (netfilter: nfnetlink_queue: cleanup copy_range usage).

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
(cherry picked from commit c1e7dc91eed0ed1a51c9b814d648db18bf8fc6e9)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/netfilter/nfnetlink_log.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index a5f02eb..ebcbf07 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -41,7 +41,8 @@
 #define NFULNL_NLBUFSIZ_DEFAULT	NLMSG_GOODSIZE
 #define NFULNL_TIMEOUT_DEFAULT 	100	/* every second */
 #define NFULNL_QTHRESH_DEFAULT 	100	/* 100 packets */
-#define NFULNL_COPY_RANGE_MAX	0xFFFF	/* max packet size is limited by 16-bit struct nfattr nfa_len field */
+/* max packet size is limited by 16-bit struct nfattr nfa_len field */
+#define NFULNL_COPY_RANGE_MAX	(0xFFFF - NLA_HDRLEN)
 
 #define PRINTR(x, args...)	do { if (net_ratelimit()) \
 				     printk(x, ## args); } while (0);
@@ -221,6 +222,8 @@ nfulnl_set_mode(struct nfulnl_instance *inst, u_int8_t mode,
 
 	case NFULNL_COPY_PACKET:
 		inst->copy_mode = mode;
+		if (range == 0)
+			range = NFULNL_COPY_RANGE_MAX;
 		inst->copy_range = min_t(unsigned int,
 					 range, NFULNL_COPY_RANGE_MAX);
 		break;
@@ -609,8 +612,7 @@ nfulnl_log_packet(u_int8_t pf,
 		break;
 
 	case NFULNL_COPY_PACKET:
-		if (inst->copy_range == 0
-		    || inst->copy_range > skb->len)
+		if (inst->copy_range > skb->len)
 			data_len = skb->len;
 		else
 			data_len = inst->copy_range;
-- 
1.7.12.2.21.g234cd45.dirty



