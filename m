Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaBJUB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:01:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34944 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088AbaBJTqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:46:19 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Annie Li <annie.li@oracle.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 121/124] xen-netfront: fix resource leak in netfront
Date: Mon, 10 Feb 2014 11:41:01 -0800
Message-Id: <1392061264-28124-122-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Annie Li <annie.li@oracle.com>

[ Upstream commit cefe0078eea52af17411eb1248946a94afb84ca5 ]

This patch removes grant transfer releasing code from netfront, and uses
gnttab_end_foreign_access to end grant access since
gnttab_end_foreign_access_ref may fail when the grant entry is
currently used for reading or writing.

* clean up grant transfer code kept from old netfront(2.6.18) which grants
pages for access/map and transfer. But grant transfer is deprecated in current
netfront, so remove corresponding release code for transfer.

* fix resource leak, release grant access (through gnttab_end_foreign_access)
and skb for tx/rx path, use get_page to ensure page is released when grant
access is completed successfully.

Xen-blkfront/xen-tpmfront/xen-pcifront also have similar issue, but patches
for them will be created separately.

V6: Correct subject line and commit message.

V5: Remove unecessary change in xennet_end_access.

V4: Revert put_page in gnttab_end_foreign_access, and keep netfront change in
single patch.

V3: Changes as suggestion from David Vrabel, ensure pages are not freed untill
grant acess is ended.

V2: Improve patch comments.

Signed-off-by: Annie Li <annie.li@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/xen-netfront.c | 88 ++++++++++++++--------------------------------
 1 file changed, 26 insertions(+), 62 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 49b6c78..116a41a 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -107,6 +107,7 @@ struct netfront_info {
 	} tx_skbs[NET_TX_RING_SIZE];
 	grant_ref_t gref_tx_head;
 	grant_ref_t grant_tx_ref[NET_TX_RING_SIZE];
+	struct page *grant_tx_page[NET_TX_RING_SIZE];
 	unsigned tx_skb_freelist;
 
 	spinlock_t   rx_lock ____cacheline_aligned_in_smp;
@@ -387,6 +388,7 @@ static void xennet_tx_buf_gc(struct net_device *dev)
 			gnttab_release_grant_reference(
 				&np->gref_tx_head, np->grant_tx_ref[id]);
 			np->grant_tx_ref[id] = GRANT_INVALID_REF;
+			np->grant_tx_page[id] = NULL;
 			add_id_to_freelist(&np->tx_skb_freelist, np->tx_skbs, id);
 			dev_kfree_skb_irq(skb);
 		}
@@ -443,6 +445,7 @@ static void xennet_make_frags(struct sk_buff *skb, struct net_device *dev,
 		gnttab_grant_foreign_access_ref(ref, np->xbdev->otherend_id,
 						mfn, GNTMAP_readonly);
 
+		np->grant_tx_page[id] = virt_to_page(data);
 		tx->gref = np->grant_tx_ref[id] = ref;
 		tx->offset = offset;
 		tx->size = len;
@@ -488,6 +491,7 @@ static void xennet_make_frags(struct sk_buff *skb, struct net_device *dev,
 							np->xbdev->otherend_id,
 							mfn, GNTMAP_readonly);
 
+			np->grant_tx_page[id] = page;
 			tx->gref = np->grant_tx_ref[id] = ref;
 			tx->offset = offset;
 			tx->size = bytes;
@@ -588,6 +592,7 @@ static int xennet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	mfn = virt_to_mfn(data);
 	gnttab_grant_foreign_access_ref(
 		ref, np->xbdev->otherend_id, mfn, GNTMAP_readonly);
+	np->grant_tx_page[id] = virt_to_page(data);
 	tx->gref = np->grant_tx_ref[id] = ref;
 	tx->offset = offset;
 	tx->size = len;
@@ -1126,10 +1131,11 @@ static void xennet_release_tx_bufs(struct netfront_info *np)
 			continue;
 
 		skb = np->tx_skbs[i].skb;
-		gnttab_end_foreign_access_ref(np->grant_tx_ref[i],
-					      GNTMAP_readonly);
-		gnttab_release_grant_reference(&np->gref_tx_head,
-					       np->grant_tx_ref[i]);
+		get_page(np->grant_tx_page[i]);
+		gnttab_end_foreign_access(np->grant_tx_ref[i],
+					  GNTMAP_readonly,
+					  (unsigned long)page_address(np->grant_tx_page[i]));
+		np->grant_tx_page[i] = NULL;
 		np->grant_tx_ref[i] = GRANT_INVALID_REF;
 		add_id_to_freelist(&np->tx_skb_freelist, np->tx_skbs, i);
 		dev_kfree_skb_irq(skb);
@@ -1138,78 +1144,35 @@ static void xennet_release_tx_bufs(struct netfront_info *np)
 
 static void xennet_release_rx_bufs(struct netfront_info *np)
 {
-	struct mmu_update      *mmu = np->rx_mmu;
-	struct multicall_entry *mcl = np->rx_mcl;
-	struct sk_buff_head free_list;
-	struct sk_buff *skb;
-	unsigned long mfn;
-	int xfer = 0, noxfer = 0, unused = 0;
 	int id, ref;
 
-	dev_warn(&np->netdev->dev, "%s: fix me for copying receiver.\n",
-			 __func__);
-	return;
-
-	skb_queue_head_init(&free_list);
-
 	spin_lock_bh(&np->rx_lock);
 
 	for (id = 0; id < NET_RX_RING_SIZE; id++) {
-		ref = np->grant_rx_ref[id];
-		if (ref == GRANT_INVALID_REF) {
-			unused++;
-			continue;
-		}
+		struct sk_buff *skb;
+		struct page *page;
 
 		skb = np->rx_skbs[id];
-		mfn = gnttab_end_foreign_transfer_ref(ref);
-		gnttab_release_grant_reference(&np->gref_rx_head, ref);
-		np->grant_rx_ref[id] = GRANT_INVALID_REF;
-
-		if (0 == mfn) {
-			skb_shinfo(skb)->nr_frags = 0;
-			dev_kfree_skb(skb);
-			noxfer++;
+		if (!skb)
 			continue;
-		}
 
-		if (!xen_feature(XENFEAT_auto_translated_physmap)) {
-			/* Remap the page. */
-			const struct page *page =
-				skb_frag_page(&skb_shinfo(skb)->frags[0]);
-			unsigned long pfn = page_to_pfn(page);
-			void *vaddr = page_address(page);
+		ref = np->grant_rx_ref[id];
+		if (ref == GRANT_INVALID_REF)
+			continue;
 
-			MULTI_update_va_mapping(mcl, (unsigned long)vaddr,
-						mfn_pte(mfn, PAGE_KERNEL),
-						0);
-			mcl++;
-			mmu->ptr = ((u64)mfn << PAGE_SHIFT)
-				| MMU_MACHPHYS_UPDATE;
-			mmu->val = pfn;
-			mmu++;
+		page = skb_frag_page(&skb_shinfo(skb)->frags[0]);
 
-			set_phys_to_machine(pfn, mfn);
-		}
-		__skb_queue_tail(&free_list, skb);
-		xfer++;
-	}
-
-	dev_info(&np->netdev->dev, "%s: %d xfer, %d noxfer, %d unused\n",
-		 __func__, xfer, noxfer, unused);
+		/* gnttab_end_foreign_access() needs a page ref until
+		 * foreign access is ended (which may be deferred).
+		 */
+		get_page(page);
+		gnttab_end_foreign_access(ref, 0,
+					  (unsigned long)page_address(page));
+		np->grant_rx_ref[id] = GRANT_INVALID_REF;
 
-	if (xfer) {
-		if (!xen_feature(XENFEAT_auto_translated_physmap)) {
-			/* Do all the remapping work and M2P updates. */
-			MULTI_mmu_update(mcl, np->rx_mmu, mmu - np->rx_mmu,
-					 NULL, DOMID_SELF);
-			mcl++;
-			HYPERVISOR_multicall(np->rx_mcl, mcl - np->rx_mcl);
-		}
+		kfree_skb(skb);
 	}
 
-	__skb_queue_purge(&free_list);
-
 	spin_unlock_bh(&np->rx_lock);
 }
 
@@ -1344,6 +1307,7 @@ static struct net_device *xennet_create_dev(struct xenbus_device *dev)
 	for (i = 0; i < NET_RX_RING_SIZE; i++) {
 		np->rx_skbs[i] = NULL;
 		np->grant_rx_ref[i] = GRANT_INVALID_REF;
+		np->grant_tx_page[i] = NULL;
 	}
 
 	/* A grant for every tx ring slot */
-- 
1.8.3.2

