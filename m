Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbaHZT1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 15:27:43 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35121 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbaHZT1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 15:27:40 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v3 4/4] tg3: Fix tx_pending checks for tg3_tso_bug
Date: Tue, 26 Aug 2014 12:26:18 -0700
Message-Id: <1409081178-4877-4-git-send-email-bpoirier@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409081178-4877-1-git-send-email-bpoirier@suse.de>
References: <1409081178-4877-1-git-send-email-bpoirier@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In tg3_set_ringparam(), the tx_pending test to cover the cases where
tg3_tso_bug() is entered has two problems
1) the check is only done for certain hardware whereas the workaround
is now used more broadly. IOW, the check may not be performed when it
is needed.
2) the check is too optimistic.

For example, with a 5761 (SHORT_DMA_BUG), tg3_set_ringparam() skips over the
"tx_pending <= (MAX_SKB_FRAGS * 3)" check because TSO_BUG is false. Even if it
did do the check, with a full sized skb, frag_cnt_est = 135 but the check is
for <= MAX_SKB_FRAGS * 3 (= 17 * 3 = 51). So the check is insufficient. This
leads to the following situation: by setting, ex. tx_pending = 100, there can
be an skb that triggers tg3_tso_bug() and that is large enough to cause
tg3_tso_bug() to stop the queue even when it is empty. We then end up with a
netdev watchdog transmit timeout.

Given that 1) some of the conditions tested for in tg3_tx_frag_set() apply
regardless of the chipset flags and that 2) it is difficult to estimate ahead
of time the max possible number of frames that a large skb may be split into
by gso, we instead take the approach of adjusting dev->gso_max_segs according
to the requested tx_pending size.

This puts us in the exceptional situation that a single skb that triggers
tg3_tso_bug() may require the entire tx ring. Usually the tx queue is woken up
when at least a quarter of it is available (TG3_TX_WAKEUP_THRESH) but that
would be insufficient now. To avoid useless wakeups, the tx queue wake up
threshold is made dynamic. Likewise, usually the tx queue is stopped as soon
as an skb with max frags may overrun it. Since the skbs submitted from
tg3_tso_bug() use a controlled number of descriptors, the tx queue stop
threshold may be lowered.

Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
---

Changes v1->v2
* in tg3_set_ringparam(), reduce gso_max_segs further to budget 3 descriptors
  per gso seg instead of only 1 as in v1
* in tg3_tso_bug(), check that this estimation (3 desc/seg) holds, otherwise
  linearize some skbs as needed
* in tg3_start_xmit(), make the queue stop threshold a parameter, for the
  reason explained in the commit description

Changes v2->v3
* use tg3_maybe_stop_txq() instead of repeatedly open coding it
* add the requested tp->tx_dropped++ stat increase in tg3_tso_bug() if
  skb_linearize() fails and we must abort
* in the same code block, add an additional check to stop the queue with the
  default threshold. Otherwise, the netdev_err message at the start of
  __tg3_start_xmit() could be triggered when the next frame is transmitted.
  That is because the previous calls to __tg3_start_xmit() in tg3_tso_bug()
  may have been using a stop_thresh=segs_remaining that is < MAX_SKB_FRAGS +
  1.

For v3, I repeated the same rr latency test I had done for v2. Once again, I
did not measure a significant impact.

* without patches
	rr values: 6297.2 6851.71 6928.61 6907.2 6682.71 6808.54 6920.69 6906.56 6890.48 6891.39
	sample size: 10
	mean: 6808.509
	standard deviation: 194.1019
	quantiles: 6297.2 6819.332 6890.935 6907.04 6928.61
	6800±200

 Performance counter stats for 'netperf -H 192.168.9.30 -l60 -T 0,0 -t omni -- -d rr' (10 runs):

     480672.401297 task-clock                #    8.001 CPUs utilized            ( +-  0.01% ) [100.00%]
           840,080 context-switches          #    0.002 M/sec                    ( +-  0.88% ) [100.00%]
               598 CPU-migrations            #    0.000 M/sec                    ( +- 10.27% ) [100.00%]
               552 page-faults               #    0.000 M/sec                    ( +- 81.33% )
   275,174,355,207 cycles                    #    0.572 GHz                      ( +-  7.02% ) [15.38%]
   791,022,327,544 stalled-cycles-frontend   #  287.46% frontend cycles idle     ( +-  4.74% ) [24.88%]
   686,658,715,636 stalled-cycles-backend    #  249.54% backend  cycles idle     ( +-  4.93% ) [34.88%]
   114,236,655,920 instructions              #    0.42  insns per cycle
                                             #    6.92  stalled cycles per insn  ( +-  5.02% ) [44.88%]
    25,562,621,872 branches                  #   53.181 M/sec                    ( +-  5.23% ) [50.00%]
       200,879,548 branch-misses             #    0.79% of all branches          ( +-  0.85% ) [50.00%]
    27,266,292,729 L1-dcache-loads           #   56.725 M/sec                    ( +-  4.94% ) [50.00%]
       360,072,063 L1-dcache-load-misses     #    1.32% of all L1-dcache hits    ( +-  0.39% ) [49.88%]
        85,199,150 LLC-loads                 #    0.177 M/sec                    ( +-  1.20% ) [40.00%]
            27,617 LLC-load-misses           #    0.03% of all LL-cache hits     ( +- 49.75% ) [ 5.00%]

      60.078218016 seconds time elapsed                                          ( +-  0.01% )

* with patches
	rr values: 6849.21 6872.63 6848.53 6889.81 6889.85 6873.16 6831.34 6918.74 6878.89 6908.51
	sample size: 10
	mean: 6876.067
	standard deviation: 27.40782
	quantiles: 6831.34 6855.065 6876.025 6889.84 6918.74
	6880±30

 Performance counter stats for 'netperf -H 192.168.9.30 -l60 -T 0,0 -t omni -- -d rr' (10 runs):

     480644.699898 task-clock                #    8.001 CPUs utilized            ( +-  0.00% ) [100.00%]
           848,240 context-switches          #    0.002 M/sec                    ( +-  0.13% ) [100.00%]
               627 CPU-migrations            #    0.000 M/sec                    ( +-  9.33% ) [100.00%]
               417 page-faults               #    0.000 M/sec                    ( +- 75.42% )
   286,712,301,611 cycles                    #    0.597 GHz                      ( +-  4.51% ) [15.01%]
   793,756,649,085 stalled-cycles-frontend   #  276.85% frontend cycles idle     ( +-  2.74% ) [25.01%]
   692,444,350,996 stalled-cycles-backend    #  241.51% backend  cycles idle     ( +-  2.76% ) [35.01%]
   116,273,550,243 instructions              #    0.41  insns per cycle
                                             #    6.83  stalled cycles per insn  ( +-  3.29% ) [45.00%]
    26,158,199,645 branches                  #   54.423 M/sec                    ( +-  3.63% ) [50.00%]
       194,639,162 branch-misses             #    0.74% of all branches          ( +-  0.82% ) [50.00%]
    27,866,571,166 L1-dcache-loads           #   57.977 M/sec                    ( +-  3.43% ) [50.00%]
       359,443,756 L1-dcache-load-misses     #    1.29% of all L1-dcache hits    ( +-  0.62% ) [50.00%]
        81,806,786 LLC-loads                 #    0.170 M/sec                    ( +-  1.36% ) [40.00%]
             9,063 LLC-load-misses           #    0.01% of all LL-cache hits     ( +- 44.72% ) [ 5.00%]

      60.074340899 seconds time elapsed                                          ( +-  0.00% )

I reproduced this bug using the same approach explained in patch 1.
The bug reproduces with tx_pending <= 135
---
 drivers/net/ethernet/broadcom/tg3.c | 62 +++++++++++++++++++++++++++++--------
 drivers/net/ethernet/broadcom/tg3.h |  1 +
 2 files changed, 50 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 5d39554..070acff 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -204,6 +204,10 @@ static inline void _tg3_flag_clear(enum TG3_FLAGS flag, unsigned long *bits)
 /* minimum number of free TX descriptors required to wake up TX process */
 #define TG3_TX_WAKEUP_THRESH(tnapi)	max_t(u32, (tnapi)->tx_pending / 4, \
 					      MAX_SKB_FRAGS + 1)
+/* estimate a certain number of descriptors per gso segment */
+#define TG3_TX_DESC_PER_SEG(seg_nb)	((seg_nb) * 3)
+#define TG3_TX_SEG_PER_DESC(desc_nb)	((desc_nb) / 3)
+
 #define TG3_TX_BD_DMA_MAX_2K		2048
 #define TG3_TX_BD_DMA_MAX_4K		4096
 
@@ -6609,10 +6613,10 @@ static void tg3_tx(struct tg3_napi *tnapi)
 	smp_mb();
 
 	if (unlikely(netif_tx_queue_stopped(txq) &&
-		     (tg3_tx_avail(tnapi) > TG3_TX_WAKEUP_THRESH(tnapi)))) {
+		     (tg3_tx_avail(tnapi) > tnapi->wakeup_thresh))) {
 		__netif_tx_lock(txq, smp_processor_id());
 		if (netif_tx_queue_stopped(txq) &&
-		    (tg3_tx_avail(tnapi) > TG3_TX_WAKEUP_THRESH(tnapi)))
+		    (tg3_tx_avail(tnapi) > tnapi->wakeup_thresh))
 			netif_tx_wake_queue(txq);
 		__netif_tx_unlock(txq);
 	}
@@ -7830,6 +7834,8 @@ static int tigon3_dma_hwbug_workaround(struct tg3_napi *tnapi,
 }
 
 static netdev_tx_t tg3_start_xmit(struct sk_buff *, struct net_device *);
+static netdev_tx_t __tg3_start_xmit(struct sk_buff *, struct net_device *,
+				    u32);
 
 static inline bool tg3_maybe_stop_txq(struct tg3_napi *tnapi,
 				      struct netdev_queue *txq,
@@ -7841,14 +7847,16 @@ static inline bool tg3_maybe_stop_txq(struct tg3_napi *tnapi,
 		if (!netif_tx_queue_stopped(txq)) {
 			stopped = true;
 			netif_tx_stop_queue(txq);
-			BUG_ON(wakeup_thresh >= tnapi->tx_pending);
+			tnapi->wakeup_thresh = wakeup_thresh;
+			BUG_ON(tnapi->wakeup_thresh >= tnapi->tx_pending);
 		}
 		/* netif_tx_stop_queue() must be done before checking tx index
 		 * in tg3_tx_avail(), because in tg3_tx(), we update tx index
-		 * before checking for netif_tx_queue_stopped().
+		 * before checking for netif_tx_queue_stopped(). The memory
+		 * barrier also synchronizes wakeup_thresh changes.
 		 */
 		smp_mb();
-		if (tg3_tx_avail(tnapi) > wakeup_thresh)
+		if (tg3_tx_avail(tnapi) > tnapi->wakeup_thresh)
 			netif_tx_wake_queue(txq);
 	}
 	return stopped;
@@ -7861,10 +7869,10 @@ static int tg3_tso_bug(struct tg3 *tp, struct tg3_napi *tnapi,
 		       struct netdev_queue *txq, struct sk_buff *skb)
 {
 	struct sk_buff *segs, *nskb;
-	u32 frag_cnt_est = skb_shinfo(skb)->gso_segs * 3;
+	unsigned int segs_remaining = skb_shinfo(skb)->gso_segs;
+	u32 desc_cnt_est = TG3_TX_DESC_PER_SEG(segs_remaining);
 
-	/* Estimate the number of fragments in the worst case */
-	tg3_maybe_stop_txq(tnapi, txq, frag_cnt_est, frag_cnt_est);
+	tg3_maybe_stop_txq(tnapi, txq, desc_cnt_est, desc_cnt_est);
 	if (netif_tx_queue_stopped(txq))
 		return NETDEV_TX_BUSY;
 
@@ -7874,10 +7882,32 @@ static int tg3_tso_bug(struct tg3 *tp, struct tg3_napi *tnapi,
 		goto tg3_tso_bug_end;
 
 	do {
+		unsigned int desc_cnt = skb_shinfo(segs)->nr_frags + 1;
+
 		nskb = segs;
 		segs = segs->next;
 		nskb->next = NULL;
-		tg3_start_xmit(nskb, tp->dev);
+
+		if (tg3_tx_avail(tnapi) <= segs_remaining - 1 + desc_cnt &&
+		    skb_linearize(nskb)) {
+			tp->tx_dropped++;
+			nskb->next = segs;
+			segs = nskb;
+			do {
+				nskb = segs->next;
+
+				dev_kfree_skb_any(segs);
+				segs = nskb;
+			} while (segs);
+			tg3_maybe_stop_txq(tnapi, txq, MAX_SKB_FRAGS + 1,
+					   TG3_TX_WAKEUP_THRESH(tnapi));
+			goto tg3_tso_bug_end;
+		}
+		segs_remaining--;
+		if (segs_remaining)
+			__tg3_start_xmit(nskb, tp->dev, segs_remaining);
+		else
+			tg3_start_xmit(nskb, tp->dev);
 	} while (segs);
 
 tg3_tso_bug_end:
@@ -7889,6 +7919,12 @@ tg3_tso_bug_end:
 /* hard_start_xmit for all devices */
 static netdev_tx_t tg3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
+	return __tg3_start_xmit(skb, dev, MAX_SKB_FRAGS + 1);
+}
+
+static netdev_tx_t __tg3_start_xmit(struct sk_buff *skb,
+				    struct net_device *dev, u32 stop_thresh)
+{
 	struct tg3 *tp = netdev_priv(dev);
 	u32 len, entry, base_flags, mss, vlan = 0;
 	u32 budget;
@@ -8096,7 +8132,7 @@ static netdev_tx_t tg3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	tw32_tx_mbox(tnapi->prodmbox, entry);
 
 	tnapi->tx_prod = entry;
-	tg3_maybe_stop_txq(tnapi, txq, MAX_SKB_FRAGS + 1,
+	tg3_maybe_stop_txq(tnapi, txq, stop_thresh,
 			   TG3_TX_WAKEUP_THRESH(tnapi));
 
 	mmiowb();
@@ -12318,9 +12354,7 @@ static int tg3_set_ringparam(struct net_device *dev, struct ethtool_ringparam *e
 	if ((ering->rx_pending > tp->rx_std_ring_mask) ||
 	    (ering->rx_jumbo_pending > tp->rx_jmb_ring_mask) ||
 	    (ering->tx_pending > TG3_TX_RING_SIZE - 1) ||
-	    (ering->tx_pending <= MAX_SKB_FRAGS + 1) ||
-	    (tg3_flag(tp, TSO_BUG) &&
-	     (ering->tx_pending <= (MAX_SKB_FRAGS * 3))))
+	    (ering->tx_pending <= MAX_SKB_FRAGS + 1))
 		return -EINVAL;
 
 	if (netif_running(dev)) {
@@ -12340,6 +12374,7 @@ static int tg3_set_ringparam(struct net_device *dev, struct ethtool_ringparam *e
 	if (tg3_flag(tp, JUMBO_RING_ENABLE))
 		tp->rx_jumbo_pending = ering->rx_jumbo_pending;
 
+	dev->gso_max_segs = TG3_TX_SEG_PER_DESC(ering->tx_pending - 1);
 	for (i = 0; i < tp->irq_max; i++)
 		tp->napi[i].tx_pending = ering->tx_pending;
 
@@ -17816,6 +17851,7 @@ static int tg3_init_one(struct pci_dev *pdev,
 		else
 			sndmbx += 0xc;
 	}
+	dev->gso_max_segs = TG3_TX_SEG_PER_DESC(TG3_DEF_TX_RING_PENDING - 1);
 
 	tg3_init_coal(tp);
 
diff --git a/drivers/net/ethernet/broadcom/tg3.h b/drivers/net/ethernet/broadcom/tg3.h
index 461acca..6a7e13d 100644
--- a/drivers/net/ethernet/broadcom/tg3.h
+++ b/drivers/net/ethernet/broadcom/tg3.h
@@ -3006,6 +3006,7 @@ struct tg3_napi {
 	u32				tx_pending;
 	u32				last_tx_cons;
 	u32				prodmbox;
+	u32				wakeup_thresh;
 	struct tg3_tx_buffer_desc	*tx_ring;
 	struct tg3_tx_ring_info		*tx_buffers;
 
-- 
1.8.4.5

