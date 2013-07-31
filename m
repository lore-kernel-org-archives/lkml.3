Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965Ab3GaN27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:28:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47163 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759907Ab3GaN0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:26:14 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Neil Horman" <nhorman@tuxdriver.com>,
        "Jay Cliburn" <jcliburn@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Chris Snook" <chris.snook@gmail.com>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.671946400@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [20/84] atl1e: fix dma mapping warnings
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

[ Upstream commit 352900b583b2852152a1e05ea0e8b579292e731e ]

Recently had this backtrace reported:
WARNING: at lib/dma-debug.c:937 check_unmap+0x47d/0x930()
Hardware name: System Product Name
ATL1E 0000:02:00.0: DMA-API: device driver failed to check map error[device
address=0x00000000cbfd1000] [size=90 bytes] [mapped as single]
Modules linked in: xt_conntrack nf_conntrack ebtable_filter ebtables
ip6table_filter ip6_tables snd_hda_codec_hdmi snd_hda_codec_realtek iTCO_wdt
iTCO_vendor_support snd_hda_intel acpi_cpufreq mperf coretemp btrfs zlib_deflate
snd_hda_codec snd_hwdep microcode raid6_pq libcrc32c snd_seq usblp serio_raw xor
snd_seq_device joydev snd_pcm snd_page_alloc snd_timer snd lpc_ich i2c_i801
soundcore mfd_core atl1e asus_atk0110 ata_generic pata_acpi radeon i2c_algo_bit
drm_kms_helper ttm drm i2c_core pata_marvell uinput
Pid: 314, comm: systemd-journal Not tainted 3.9.0-0.rc6.git2.3.fc19.x86_64 #1
Call Trace:
 <IRQ>  [<ffffffff81069106>] warn_slowpath_common+0x66/0x80
 [<ffffffff8106916c>] warn_slowpath_fmt+0x4c/0x50
 [<ffffffff8138151d>] check_unmap+0x47d/0x930
 [<ffffffff810ad048>] ? sched_clock_cpu+0xa8/0x100
 [<ffffffff81381a2f>] debug_dma_unmap_page+0x5f/0x70
 [<ffffffff8137ce30>] ? unmap_single+0x20/0x30
 [<ffffffffa01569a1>] atl1e_intr+0x3a1/0x5b0 [atl1e]
 [<ffffffff810d53fd>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff81119636>] handle_irq_event_percpu+0x56/0x390
 [<ffffffff811199ad>] handle_irq_event+0x3d/0x60
 [<ffffffff8111cb6a>] handle_fasteoi_irq+0x5a/0x100
 [<ffffffff8101c36f>] handle_irq+0xbf/0x150
 [<ffffffff811dcb2f>] ? file_sb_list_del+0x3f/0x50
 [<ffffffff81073b10>] ? irq_enter+0x50/0xa0
 [<ffffffff8172738d>] do_IRQ+0x4d/0xc0
 [<ffffffff811dcb2f>] ? file_sb_list_del+0x3f/0x50
 [<ffffffff8171c6b2>] common_interrupt+0x72/0x72
 <EOI>  [<ffffffff810db5b2>] ? lock_release+0xc2/0x310
 [<ffffffff8109ea04>] lg_local_unlock_cpu+0x24/0x50
 [<ffffffff811dcb2f>] file_sb_list_del+0x3f/0x50
 [<ffffffff811dcb6d>] fput+0x2d/0xc0
 [<ffffffff811d8ea1>] filp_close+0x61/0x90
 [<ffffffff811fae4d>] __close_fd+0x8d/0x150
 [<ffffffff811d8ef0>] sys_close+0x20/0x50
 [<ffffffff81725699>] system_call_fastpath+0x16/0x1b

The usual straighforward failure to check for dma_mapping_error after a map
operation is completed.

This patch should fix it, the reporter wandered off after filing this bz:
https://bugzilla.redhat.com/show_bug.cgi?id=954170

and I don't have hardware to test, but the fix is pretty straightforward, so I
figured I'd post it for review.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: Jay Cliburn <jcliburn@gmail.com>
CC: Chris Snook <chris.snook@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c | 28 ++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index dd893b3..ec08ccd 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -1685,8 +1685,8 @@ check_sum:
 	return 0;
 }
 
-static void atl1e_tx_map(struct atl1e_adapter *adapter,
-		      struct sk_buff *skb, struct atl1e_tpd_desc *tpd)
+static int atl1e_tx_map(struct atl1e_adapter *adapter,
+			struct sk_buff *skb, struct atl1e_tpd_desc *tpd)
 {
 	struct atl1e_tpd_desc *use_tpd = NULL;
 	struct atl1e_tx_buffer *tx_buffer = NULL;
@@ -1697,6 +1697,7 @@ static void atl1e_tx_map(struct atl1e_adapter *adapter,
 	u16 nr_frags;
 	u16 f;
 	int segment;
+	int ring_start = adapter->tx_ring.next_to_use;
 
 	nr_frags = skb_shinfo(skb)->nr_frags;
 	segment = (tpd->word3 >> TPD_SEGMENT_EN_SHIFT) & TPD_SEGMENT_EN_MASK;
@@ -1709,6 +1710,9 @@ static void atl1e_tx_map(struct atl1e_adapter *adapter,
 		tx_buffer->length = map_len;
 		tx_buffer->dma = pci_map_single(adapter->pdev,
 					skb->data, hdr_len, PCI_DMA_TODEVICE);
+		if (dma_mapping_error(&adapter->pdev->dev, tx_buffer->dma))
+			return -ENOSPC;
+
 		ATL1E_SET_PCIMAP_TYPE(tx_buffer, ATL1E_TX_PCIMAP_SINGLE);
 		mapped_len += map_len;
 		use_tpd->buffer_addr = cpu_to_le64(tx_buffer->dma);
@@ -1735,6 +1739,13 @@ static void atl1e_tx_map(struct atl1e_adapter *adapter,
 		tx_buffer->dma =
 			pci_map_single(adapter->pdev, skb->data + mapped_len,
 					map_len, PCI_DMA_TODEVICE);
+
+		if (dma_mapping_error(&adapter->pdev->dev, tx_buffer->dma)) {
+			/* Reset the tx rings next pointer */
+			adapter->tx_ring.next_to_use = ring_start;
+			return -ENOSPC;
+		}
+
 		ATL1E_SET_PCIMAP_TYPE(tx_buffer, ATL1E_TX_PCIMAP_SINGLE);
 		mapped_len  += map_len;
 		use_tpd->buffer_addr = cpu_to_le64(tx_buffer->dma);
@@ -1770,6 +1781,13 @@ static void atl1e_tx_map(struct atl1e_adapter *adapter,
 							  (i * MAX_TX_BUF_LEN),
 							  tx_buffer->length,
 							  DMA_TO_DEVICE);
+
+			if (dma_mapping_error(&adapter->pdev->dev, tx_buffer->dma)) {
+				/* Reset the ring next to use pointer */
+				adapter->tx_ring.next_to_use = ring_start;
+				return -ENOSPC;
+			}
+
 			ATL1E_SET_PCIMAP_TYPE(tx_buffer, ATL1E_TX_PCIMAP_PAGE);
 			use_tpd->buffer_addr = cpu_to_le64(tx_buffer->dma);
 			use_tpd->word2 = (use_tpd->word2 & (~TPD_BUFLEN_MASK)) |
@@ -1787,6 +1805,7 @@ static void atl1e_tx_map(struct atl1e_adapter *adapter,
 	/* The last buffer info contain the skb address,
 	   so it will be free after unmap */
 	tx_buffer->skb = skb;
+	return 0;
 }
 
 static void atl1e_tx_queue(struct atl1e_adapter *adapter, u16 count,
@@ -1854,10 +1873,13 @@ static netdev_tx_t atl1e_xmit_frame(struct sk_buff *skb,
 		return NETDEV_TX_OK;
 	}
 
-	atl1e_tx_map(adapter, skb, tpd);
+	if (atl1e_tx_map(adapter, skb, tpd))
+		goto out;
+
 	atl1e_tx_queue(adapter, tpd_req, tpd);
 
 	netdev->trans_start = jiffies; /* NETIF_F_LLTX driver :( */
+out:
 	spin_unlock_irqrestore(&adapter->tx_lock, flags);
 	return NETDEV_TX_OK;
 }

