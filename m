Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab3ETKxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:53:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56367 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab3ETKxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 092/115] packet: tpacket_v3: do not trigger bug() on wrong header status
Date: Mon, 20 May 2013 11:51:32 +0100
Message-Id: <1369047116-9378-93-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

commit 8da3056c04bfc5f69f840ab038a38389e2de8189 upstream.

Jakub reported that it is fairly easy to trigger the BUG() macro
from user space with TPACKET_V3's RX_RING by just giving a wrong
header status flag. We already had a similar situation in commit
7f5c3e3a80e6654 (``af_packet: remove BUG statement in
tpacket_destruct_skb'') where this was the case in the TX_RING
side that could be triggered from user space. So really, don't use
BUG() or BUG_ON() unless there's really no way out, and i.e.
don't use it for consistency checking when there's user space
involved, no excuses, especially not if you're slapping the user
with WARN + dump_stack + BUG all at once. The two functions are
of concern:

  prb_retire_current_block() [when block status != TP_STATUS_KERNEL]
  prb_open_block() [when block_status != TP_STATUS_KERNEL]

Calls to prb_open_block() are guarded by ealier checks if block_status
is really TP_STATUS_KERNEL (racy!), but the first one BUG() is easily
triggable from user space. System behaves still stable after they are
removed. Also remove that yoda condition entirely, since it's already
guarded.

Reported-by: Jakub Zawadzki <darkjames-ws@darkjames.pl>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/packet/af_packet.c | 54 +++++++++++++++++++++-----------------------------
 1 file changed, 23 insertions(+), 31 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 02b1ef8..4137d01 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -812,37 +812,33 @@ static void prb_open_block(struct tpacket_kbdq_core *pkc1,
 
 	smp_rmb();
 
-	if (likely(TP_STATUS_KERNEL == BLOCK_STATUS(pbd1))) {
+	/* We could have just memset this but we will lose the
+	 * flexibility of making the priv area sticky
+	 */
 
-		/* We could have just memset this but we will lose the
-		 * flexibility of making the priv area sticky
-		 */
-		BLOCK_SNUM(pbd1) = pkc1->knxt_seq_num++;
-		BLOCK_NUM_PKTS(pbd1) = 0;
-		BLOCK_LEN(pbd1) = BLK_PLUS_PRIV(pkc1->blk_sizeof_priv);
-		getnstimeofday(&ts);
-		h1->ts_first_pkt.ts_sec = ts.tv_sec;
-		h1->ts_first_pkt.ts_nsec = ts.tv_nsec;
-		pkc1->pkblk_start = (char *)pbd1;
-		pkc1->nxt_offset = (char *)(pkc1->pkblk_start +
-		BLK_PLUS_PRIV(pkc1->blk_sizeof_priv));
-		BLOCK_O2FP(pbd1) = (__u32)BLK_PLUS_PRIV(pkc1->blk_sizeof_priv);
-		BLOCK_O2PRIV(pbd1) = BLK_HDR_LEN;
-		pbd1->version = pkc1->version;
-		pkc1->prev = pkc1->nxt_offset;
-		pkc1->pkblk_end = pkc1->pkblk_start + pkc1->kblk_size;
-		prb_thaw_queue(pkc1);
-		_prb_refresh_rx_retire_blk_timer(pkc1);
+	BLOCK_SNUM(pbd1) = pkc1->knxt_seq_num++;
+	BLOCK_NUM_PKTS(pbd1) = 0;
+	BLOCK_LEN(pbd1) = BLK_PLUS_PRIV(pkc1->blk_sizeof_priv);
 
-		smp_wmb();
+	getnstimeofday(&ts);
 
-		return;
-	}
+	h1->ts_first_pkt.ts_sec = ts.tv_sec;
+	h1->ts_first_pkt.ts_nsec = ts.tv_nsec;
 
-	WARN(1, "ERROR block:%p is NOT FREE status:%d kactive_blk_num:%d\n",
-		pbd1, BLOCK_STATUS(pbd1), pkc1->kactive_blk_num);
-	dump_stack();
-	BUG();
+	pkc1->pkblk_start = (char *)pbd1;
+	pkc1->nxt_offset = pkc1->pkblk_start + BLK_PLUS_PRIV(pkc1->blk_sizeof_priv);
+
+	BLOCK_O2FP(pbd1) = (__u32)BLK_PLUS_PRIV(pkc1->blk_sizeof_priv);
+	BLOCK_O2PRIV(pbd1) = BLK_HDR_LEN;
+
+	pbd1->version = pkc1->version;
+	pkc1->prev = pkc1->nxt_offset;
+	pkc1->pkblk_end = pkc1->pkblk_start + pkc1->kblk_size;
+
+	prb_thaw_queue(pkc1);
+	_prb_refresh_rx_retire_blk_timer(pkc1);
+
+	smp_wmb();
 }
 
 /*
@@ -933,10 +929,6 @@ static void prb_retire_current_block(struct tpacket_kbdq_core *pkc,
 		prb_close_block(pkc, pbd, po, status);
 		return;
 	}
-
-	WARN(1, "ERROR-pbd[%d]:%p\n", pkc->kactive_blk_num, pbd);
-	dump_stack();
-	BUG();
 }
 
 static int prb_curr_blk_in_use(struct tpacket_kbdq_core *pkc,
-- 
1.8.1.2

