Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaKYLpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:45:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58295 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbaKYKlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 065/254] netfilter: nfnetlink_log: fix maximum packet length logged to userspace
Date: Tue, 25 Nov 2014 10:36:55 +0000
Message-Id: <1416912004-5928-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netfilter/nfnetlink_log.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index ebff1ec79ea2..8f415d6889fe 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -43,7 +43,8 @@
 #define NFULNL_NLBUFSIZ_DEFAULT	NLMSG_GOODSIZE
 #define NFULNL_TIMEOUT_DEFAULT 	100	/* every second */
 #define NFULNL_QTHRESH_DEFAULT 	100	/* 100 packets */
-#define NFULNL_COPY_RANGE_MAX	0xFFFF	/* max packet size is limited by 16-bit struct nfattr nfa_len field */
+/* max packet size is limited by 16-bit struct nfattr nfa_len field */
+#define NFULNL_COPY_RANGE_MAX	(0xFFFF - NLA_HDRLEN)
 
 #define PRINTR(x, args...)	do { if (net_ratelimit()) \
 				     printk(x, ## args); } while (0);
@@ -252,6 +253,8 @@ nfulnl_set_mode(struct nfulnl_instance *inst, u_int8_t mode,
 
 	case NFULNL_COPY_PACKET:
 		inst->copy_mode = mode;
+		if (range == 0)
+			range = NFULNL_COPY_RANGE_MAX;
 		inst->copy_range = min_t(unsigned int,
 					 range, NFULNL_COPY_RANGE_MAX);
 		break;
@@ -679,8 +682,7 @@ nfulnl_log_packet(struct net *net,
 		break;
 
 	case NFULNL_COPY_PACKET:
-		if (inst->copy_range == 0
-		    || inst->copy_range > skb->len)
+		if (inst->copy_range > skb->len)
 			data_len = skb->len;
 		else
 			data_len = inst->copy_range;
-- 
2.1.0

