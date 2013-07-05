Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab3GEJGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 05:06:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55742 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757135Ab3GEJGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 05:06:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.5.y.z extended stable] Linux 3.5.7.16
Date: Fri,  5 Jul 2013 10:06:38 +0100
Message-Id: <1373015198-11904-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373015198-11904-1-git-send-email-luis.henriques@canonical.com>
References: <1373015198-11904-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index ddb7313..058db1d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 5
 SUBLEVEL = 7
-EXTRAVERSION = .15
+EXTRAVERSION = .16
 NAME = Saber-toothed Squirrel
 
 # *DOCUMENTATION*
diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index e4448e1..76d7f24 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -305,9 +305,7 @@ static inline void flush_anon_page(struct vm_area_struct *vma,
 }
 
 #define ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE
-static inline void flush_kernel_dcache_page(struct page *page)
-{
-}
+extern void flush_kernel_dcache_page(struct page *);
 
 #define flush_dcache_mmap_lock(mapping) \
 	spin_lock_irq(&(mapping)->tree_lock)
diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
index 40ca11e..8f0d285 100644
--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -299,6 +299,39 @@ void flush_dcache_page(struct page *page)
 EXPORT_SYMBOL(flush_dcache_page);
 
 /*
+ * Ensure cache coherency for the kernel mapping of this page. We can
+ * assume that the page is pinned via kmap.
+ *
+ * If the page only exists in the page cache and there are no user
+ * space mappings, this is a no-op since the page was already marked
+ * dirty at creation.  Otherwise, we need to flush the dirty kernel
+ * cache lines directly.
+ */
+void flush_kernel_dcache_page(struct page *page)
+{
+	if (cache_is_vivt() || cache_is_vipt_aliasing()) {
+		struct address_space *mapping;
+
+		mapping = page_mapping(page);
+
+		if (!mapping || mapping_mapped(mapping)) {
+			void *addr;
+
+			addr = page_address(page);
+			/*
+			 * kmap_atomic() doesn't set the page virtual
+			 * address for highmem pages, and
+			 * kunmap_atomic() takes care of cache
+			 * flushing already.
+			 */
+			if (!IS_ENABLED(CONFIG_HIGHMEM) || addr)
+				__cpuc_flush_dcache_area(addr, PAGE_SIZE);
+		}
+	}
+}
+EXPORT_SYMBOL(flush_kernel_dcache_page);
+
+/*
  * Flush an anonymous page so that users of get_user_pages()
  * can safely access the data.  The expected sequence is:
  *
diff --git a/arch/arm/mm/nommu.c b/arch/arm/mm/nommu.c
index d51225f..eb5293a 100644
--- a/arch/arm/mm/nommu.c
+++ b/arch/arm/mm/nommu.c
@@ -57,6 +57,12 @@ void flush_dcache_page(struct page *page)
 }
 EXPORT_SYMBOL(flush_dcache_page);
 
+void flush_kernel_dcache_page(struct page *page)
+{
+	__cpuc_flush_dcache_area(page_address(page), PAGE_SIZE);
+}
+EXPORT_SYMBOL(flush_kernel_dcache_page);
+
 void copy_to_user_page(struct vm_area_struct *vma, struct page *page,
 		       unsigned long uaddr, void *dst, const void *src,
 		       unsigned long len)
diff --git a/arch/tile/lib/exports.c b/arch/tile/lib/exports.c
index dd5f0a3..b05d919 100644
--- a/arch/tile/lib/exports.c
+++ b/arch/tile/lib/exports.c
@@ -82,4 +82,6 @@ uint64_t __ashrdi3(uint64_t, unsigned int);
 EXPORT_SYMBOL(__ashrdi3);
 uint64_t __ashldi3(uint64_t, unsigned int);
 EXPORT_SYMBOL(__ashldi3);
+int __ffsdi2(uint64_t);
+EXPORT_SYMBOL(__ffsdi2);
 #endif
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b2b22a6..eebd0d9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2150,6 +2150,7 @@ source "fs/Kconfig.binfmt"
 config IA32_EMULATION
 	bool "IA32 Emulation"
 	depends on X86_64
+	select BINFMT_ELF
 	select COMPAT_BINFMT_ELF
 	---help---
 	  Include code to run legacy 32-bit programs under a
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a7c8796..671e5df 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -555,8 +555,6 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 	if (index != XCR_XFEATURE_ENABLED_MASK)
 		return 1;
 	xcr0 = xcr;
-	if (kvm_x86_ops->get_cpl(vcpu) != 0)
-		return 1;
 	if (!(xcr0 & XSTATE_FP))
 		return 1;
 	if ((xcr0 & XSTATE_YMM) && !(xcr0 & XSTATE_SSE))
@@ -570,7 +568,8 @@ int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 
 int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 {
-	if (__kvm_set_xcr(vcpu, index, xcr)) {
+	if (kvm_x86_ops->get_cpl(vcpu) != 0 ||
+	    __kvm_set_xcr(vcpu, index, xcr)) {
 		kvm_inject_gp(vcpu, 0);
 		return 1;
 	}
diff --git a/drivers/bluetooth/btmrvl_main.c b/drivers/bluetooth/btmrvl_main.c
index dc304de..2c63a21 100644
--- a/drivers/bluetooth/btmrvl_main.c
+++ b/drivers/bluetooth/btmrvl_main.c
@@ -496,6 +496,10 @@ static int btmrvl_service_main_thread(void *data)
 		add_wait_queue(&thread->wait_q, &wait);
 
 		set_current_state(TASK_INTERRUPTIBLE);
+		if (kthread_should_stop()) {
+			BT_DBG("main_thread: break from main thread");
+			break;
+		}
 
 		if (adapter->wakeup_tries ||
 				((!adapter->int_count) &&
@@ -511,11 +515,6 @@ static int btmrvl_service_main_thread(void *data)
 
 		BT_DBG("main_thread woke up");
 
-		if (kthread_should_stop()) {
-			BT_DBG("main_thread: break from main thread");
-			break;
-		}
-
 		spin_lock_irqsave(&priv->driver_lock, flags);
 		if (adapter->int_count) {
 			adapter->int_count = 0;
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 9a1eb0c..10fdb69 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1538,6 +1538,7 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
 		/* XXX the notifier code should handle this better */
 		if (!cn->notifier_head.head) {
 			srcu_cleanup_notifier_head(&cn->notifier_head);
+			list_del(&cn->node);
 			kfree(cn);
 		}
 
diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
index 727ebfe..03c203f 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -224,6 +224,13 @@ int radeon_ring_alloc(struct radeon_device *rdev, struct radeon_ring *ring, unsi
 		return -ENOMEM;
 	/* Align requested size with padding so unlock_commit can
 	 * pad safely */
+	radeon_ring_free_size(rdev, ring);
+	if (ring->ring_free_dw == (ring->ring_size / 4)) {
+		/* This is an empty ring update lockup info to avoid
+		 * false positive.
+		 */
+		radeon_ring_lockup_update(ring);
+	}
 	ndw = (ndw + ring->align_mask) & ~ring->align_mask;
 	while (ndw > (ring->ring_free_dw - 1)) {
 		radeon_ring_free_size(rdev, ring);
diff --git a/drivers/input/touchscreen/cyttsp_core.c b/drivers/input/touchscreen/cyttsp_core.c
index f030d9e..3f505d5 100644
--- a/drivers/input/touchscreen/cyttsp_core.c
+++ b/drivers/input/touchscreen/cyttsp_core.c
@@ -133,7 +133,7 @@ static int cyttsp_exit_bl_mode(struct cyttsp *ts)
 	memcpy(bl_cmd, bl_command, sizeof(bl_command));
 	if (ts->pdata->bl_keys)
 		memcpy(&bl_cmd[sizeof(bl_command) - CY_NUM_BL_KEYS],
-			ts->pdata->bl_keys, sizeof(bl_command));
+			ts->pdata->bl_keys, CY_NUM_BL_KEYS);
 
 	error = ttsp_write_block_data(ts, CY_REG_BASE,
 				      sizeof(bl_cmd), bl_cmd);
diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 0f59c15..38e72fb 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -704,6 +704,12 @@ static struct slave *rlb_arp_xmit(struct sk_buff *skb, struct bonding *bond)
 	struct arp_pkt *arp = arp_pkt(skb);
 	struct slave *tx_slave = NULL;
 
+	/* Don't modify or load balance ARPs that do not originate locally
+	 * (e.g.,arrive via a bridge).
+	 */
+	if (!bond_slave_has_mac(bond, arp->mac_src))
+		return NULL;
+
 	if (arp->op_code == htons(ARPOP_REPLY)) {
 		/* the arp must be sent on the selected
 		* rx channel
diff --git a/drivers/net/bonding/bonding.h b/drivers/net/bonding/bonding.h
index 4581aa5..a9fd3de 100644
--- a/drivers/net/bonding/bonding.h
+++ b/drivers/net/bonding/bonding.h
@@ -22,6 +22,7 @@
 #include <linux/in6.h>
 #include <linux/netpoll.h>
 #include <linux/inetdevice.h>
+#include <linux/etherdevice.h>
 #include "bond_3ad.h"
 #include "bond_alb.h"
 
@@ -450,6 +451,18 @@ static inline void bond_destroy_proc_dir(struct bond_net *bn)
 }
 #endif
 
+static inline struct slave *bond_slave_has_mac(struct bonding *bond,
+					       const u8 *mac)
+{
+	int i = 0;
+	struct slave *tmp;
+
+	bond_for_each_slave(bond, tmp, i)
+		if (ether_addr_equal_64bits(mac, tmp->dev->dev_addr))
+			return tmp;
+
+	return NULL;
+}
 
 /* exported from bond_main.c */
 extern int bond_net_id;
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 8a0b948..504b4f0 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -689,6 +689,9 @@ static int tg3_ape_lock(struct tg3 *tp, int locknum)
 		status = tg3_ape_read32(tp, gnt + off);
 		if (status == bit)
 			break;
+		if (pci_channel_offline(tp->pdev))
+			break;
+
 		udelay(10);
 	}
 
@@ -1466,6 +1469,9 @@ static void tg3_wait_for_event_ack(struct tg3 *tp)
 	for (i = 0; i < delay_cnt; i++) {
 		if (!(tr32(GRC_RX_CPU_EVENT) & GRC_RX_CPU_DRIVER_EVENT))
 			break;
+		if (pci_channel_offline(tp->pdev))
+			break;
+
 		udelay(8);
 	}
 }
@@ -1639,6 +1645,9 @@ static int tg3_poll_fw(struct tg3 *tp)
 		for (i = 0; i < 200; i++) {
 			if (tr32(VCPU_STATUS) & VCPU_STATUS_INIT_DONE)
 				return 0;
+			if (pci_channel_offline(tp->pdev))
+				return -ENODEV;
+
 			udelay(100);
 		}
 		return -ENODEV;
@@ -1649,6 +1658,15 @@ static int tg3_poll_fw(struct tg3 *tp)
 		tg3_read_mem(tp, NIC_SRAM_FIRMWARE_MBOX, &val);
 		if (val == ~NIC_SRAM_FIRMWARE_MBOX_MAGIC1)
 			break;
+		if (pci_channel_offline(tp->pdev)) {
+			if (!tg3_flag(tp, NO_FWARE_REPORTED)) {
+				tg3_flag_set(tp, NO_FWARE_REPORTED);
+				netdev_info(tp->dev, "No firmware running\n");
+			}
+
+			break;
+		}
+
 		udelay(10);
 	}
 
@@ -3305,6 +3323,8 @@ static int tg3_halt_cpu(struct tg3 *tp, u32 offset)
 			tw32(offset + CPU_MODE,  CPU_MODE_HALT);
 			if (tr32(offset + CPU_MODE) & CPU_MODE_HALT)
 				break;
+			if (pci_channel_offline(tp->pdev))
+				return -EBUSY;
 		}
 
 		tw32(offset + CPU_STATE, 0xffffffff);
@@ -3316,6 +3336,8 @@ static int tg3_halt_cpu(struct tg3 *tp, u32 offset)
 			tw32(offset + CPU_MODE,  CPU_MODE_HALT);
 			if (tr32(offset + CPU_MODE) & CPU_MODE_HALT)
 				break;
+			if (pci_channel_offline(tp->pdev))
+				return -EBUSY;
 		}
 	}
 
@@ -7723,6 +7745,14 @@ static int tg3_stop_block(struct tg3 *tp, unsigned long ofs, u32 enable_bit, int
 	tw32_f(ofs, val);
 
 	for (i = 0; i < MAX_WAIT_CNT; i++) {
+		if (pci_channel_offline(tp->pdev)) {
+			dev_err(&tp->pdev->dev,
+				"tg3_stop_block device offline, "
+				"ofs=%lx enable_bit=%x\n",
+				ofs, enable_bit);
+			return -ENODEV;
+		}
+
 		udelay(100);
 		val = tr32(ofs);
 		if ((val & enable_bit) == 0)
@@ -7746,6 +7776,13 @@ static int tg3_abort_hw(struct tg3 *tp, int silent)
 
 	tg3_disable_ints(tp);
 
+	if (pci_channel_offline(tp->pdev)) {
+		tp->rx_mode &= ~(RX_MODE_ENABLE | TX_MODE_ENABLE);
+		tp->mac_mode &= ~MAC_MODE_TDE_ENABLE;
+		err = -ENODEV;
+		goto err_no_dev;
+	}
+
 	tp->rx_mode &= ~RX_MODE_ENABLE;
 	tw32_f(MAC_RX_MODE, tp->rx_mode);
 	udelay(10);
@@ -7794,6 +7831,7 @@ static int tg3_abort_hw(struct tg3 *tp, int silent)
 	err |= tg3_stop_block(tp, BUFMGR_MODE, BUFMGR_MODE_ENABLE, silent);
 	err |= tg3_stop_block(tp, MEMARB_MODE, MEMARB_MODE_ENABLE, silent);
 
+err_no_dev:
 	for (i = 0; i < tp->irq_cnt; i++) {
 		struct tg3_napi *tnapi = &tp->napi[i];
 		if (tnapi->hw_status)
diff --git a/drivers/net/ethernet/freescale/gianfar_ptp.c b/drivers/net/ethernet/freescale/gianfar_ptp.c
index d81c7af..d98b3f2 100644
--- a/drivers/net/ethernet/freescale/gianfar_ptp.c
+++ b/drivers/net/ethernet/freescale/gianfar_ptp.c
@@ -521,6 +521,7 @@ static int gianfar_ptp_probe(struct platform_device *dev)
 	return 0;
 
 no_clock:
+	iounmap(etsects->regs);
 no_ioremap:
 	release_resource(etsects->rsrc);
 no_resource:
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index e0490ad..d9ef667 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1116,6 +1116,7 @@ static void cp_clean_rings (struct cp_private *cp)
 			cp->dev->stats.tx_dropped++;
 		}
 	}
+	netdev_reset_queue(cp->dev);
 
 	memset(cp->rx_ring, 0, sizeof(struct cp_desc) * CP_RX_RING_SIZE);
 	memset(cp->tx_ring, 0, sizeof(struct cp_desc) * CP_TX_RING_SIZE);
diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index f250232..915e104 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5497,7 +5497,20 @@ err_out:
 	return -EIO;
 }
 
-static inline void rtl8169_tso_csum(struct rtl8169_private *tp,
+static bool rtl_skb_pad(struct sk_buff *skb)
+{
+	if (skb_padto(skb, ETH_ZLEN))
+		return false;
+	skb_put(skb, ETH_ZLEN - skb->len);
+	return true;
+}
+
+static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp, struct sk_buff *skb)
+{
+	return skb->len < ETH_ZLEN && tp->mac_version == RTL_GIGA_MAC_VER_34;
+}
+
+static inline bool rtl8169_tso_csum(struct rtl8169_private *tp,
 				    struct sk_buff *skb, u32 *opts)
 {
 	const struct rtl_tx_desc_info *info = tx_desc_info + tp->txd_version;
@@ -5510,13 +5523,20 @@ static inline void rtl8169_tso_csum(struct rtl8169_private *tp,
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		const struct iphdr *ip = ip_hdr(skb);
 
+		if (unlikely(rtl_test_hw_pad_bug(tp, skb)))
+			return skb_checksum_help(skb) == 0 && rtl_skb_pad(skb);
+
 		if (ip->protocol == IPPROTO_TCP)
 			opts[offset] |= info->checksum.tcp;
 		else if (ip->protocol == IPPROTO_UDP)
 			opts[offset] |= info->checksum.udp;
 		else
 			WARN_ON_ONCE(1);
+	} else {
+		if (unlikely(rtl_test_hw_pad_bug(tp, skb)))
+			return rtl_skb_pad(skb);
 	}
+	return true;
 }
 
 static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
@@ -5540,6 +5560,12 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	if (unlikely(le32_to_cpu(txd->opts1) & DescOwn))
 		goto err_stop_0;
 
+	opts[1] = cpu_to_le32(rtl8169_tx_vlan_tag(tp, skb));
+	opts[0] = DescOwn;
+
+	if (!rtl8169_tso_csum(tp, skb, opts))
+		goto err_update_stats;
+
 	len = skb_headlen(skb);
 	mapping = dma_map_single(d, skb->data, len, DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(d, mapping))) {
@@ -5551,11 +5577,6 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	tp->tx_skb[entry].len = len;
 	txd->addr = cpu_to_le64(mapping);
 
-	opts[1] = cpu_to_le32(rtl8169_tx_vlan_tag(tp, skb));
-	opts[0] = DescOwn;
-
-	rtl8169_tso_csum(tp, skb, opts);
-
 	frags = rtl8169_xmit_frags(tp, skb, opts);
 	if (frags < 0)
 		goto err_dma_1;
@@ -5608,6 +5629,7 @@ err_dma_1:
 	rtl8169_unmap_tx_skb(d, tp->tx_skb + entry, txd);
 err_dma_0:
 	dev_kfree_skb(skb);
+err_update_stats:
 	dev->stats.tx_dropped++;
 	return NETDEV_TX_OK;
 
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 79bf09b..2ff4f0b 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -1027,16 +1027,23 @@ static int sh_eth_rx(struct net_device *ndev, u32 intr_status)
 		desc_status = edmac_to_cpu(mdp, rxdesc->status);
 		pkt_len = rxdesc->frame_length;
 
-#if defined(CONFIG_ARCH_R8A7740)
-		desc_status >>= 16;
-#endif
-
 		if (--boguscnt < 0)
 			break;
 
 		if (!(desc_status & RDFEND))
 			ndev->stats.rx_length_errors++;
 
+#if defined(CONFIG_ARCH_R8A7740)
+		/*
+		 * In case of almost all GETHER/ETHERs, the Receive Frame State
+		 * (RFS) bits in the Receive Descriptor 0 are from bit 9 to
+		 * bit 0. However, in case of the R8A7740's GETHER, the RFS
+		 * bits are from bit 25 to bit 16. So, the driver needs right
+		 * shifting by 16.
+		 */
+		desc_status >>= 16;
+#endif
+
 		if (desc_status & (RD_RFS1 | RD_RFS2 | RD_RFS3 | RD_RFS4 |
 				   RD_RFS5 | RD_RFS6 | RD_RFS10)) {
 			ndev->stats.rx_errors++;
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index c61ae35..acd3ec3 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -817,8 +817,8 @@ static int team_port_add(struct team *team, struct net_device *port_dev)
 	}
 
 	port->index = -1;
-	team_port_enable(team, port);
 	list_add_tail_rcu(&port->list, &team->port_list);
+	team_port_enable(team, port);
 	team_adjust_ops(team);
 	__team_compute_features(team);
 	__team_port_change_check(port, !!netif_carrier_ok(port_dev));
diff --git a/drivers/net/team/team_mode_roundrobin.c b/drivers/net/team/team_mode_roundrobin.c
index 6abfbdc..d9a5e45 100644
--- a/drivers/net/team/team_mode_roundrobin.c
+++ b/drivers/net/team/team_mode_roundrobin.c
@@ -52,6 +52,8 @@ static bool rr_transmit(struct team *team, struct sk_buff *skb)
 
 	port_index = rr_priv(team)->sent_packets++ % team->en_port_count;
 	port = team_get_port_by_index_rcu(team, port_index);
+	if (unlikely(!port))
+		goto drop;
 	port = __get_first_port_up(team, port);
 	if (unlikely(!port))
 		goto drop;
diff --git a/drivers/net/wan/dlci.c b/drivers/net/wan/dlci.c
index 147614e..6a8a382 100644
--- a/drivers/net/wan/dlci.c
+++ b/drivers/net/wan/dlci.c
@@ -384,21 +384,37 @@ static int dlci_del(struct dlci_add *dlci)
 	struct frad_local	*flp;
 	struct net_device	*master, *slave;
 	int			err;
+	bool			found = false;
+
+	rtnl_lock();
 
 	/* validate slave device */
 	master = __dev_get_by_name(&init_net, dlci->devname);
-	if (!master)
-		return -ENODEV;
+	if (!master) {
+		err = -ENODEV;
+		goto out;
+	}
+
+	list_for_each_entry(dlp, &dlci_devs, list) {
+		if (dlp->master == master) {
+			found = true;
+			break;
+		}
+	}
+	if (!found) {
+		err = -ENODEV;
+		goto out;
+	}
 
 	if (netif_running(master)) {
-		return -EBUSY;
+		err = -EBUSY;
+		goto out;
 	}
 
 	dlp = netdev_priv(master);
 	slave = dlp->slave;
 	flp = netdev_priv(slave);
 
-	rtnl_lock();
 	err = (*flp->deassoc)(slave, master);
 	if (!err) {
 		list_del(&dlp->list);
@@ -407,8 +423,8 @@ static int dlci_del(struct dlci_add *dlci)
 
 		dev_put(slave);
 	}
+out:
 	rtnl_unlock();
-
 	return err;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index beaf5fa..b1100b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -1393,7 +1393,7 @@ void iwlagn_chain_noise_reset(struct iwl_priv *priv)
 	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
 	int ret;
 
-	if (!(priv->calib_disabled & IWL_CHAIN_NOISE_CALIB_DISABLED))
+	if (priv->calib_disabled & IWL_CHAIN_NOISE_CALIB_DISABLED)
 		return;
 
 	if ((data->state == IWL_CHAIN_NOISE_ALIVE) &&
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 6c864ea..9016350 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -702,8 +702,12 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 		 * For FCP_READ with CHECK_CONDITION status, clear cmd->bufflen
 		 * for qla_tgt_xmit_response LLD code
 		 */
+		if (se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) {
+			se_cmd->se_cmd_flags &= ~SCF_OVERFLOW_BIT;
+			se_cmd->residual_count = 0;
+		}
 		se_cmd->se_cmd_flags |= SCF_UNDERFLOW_BIT;
-		se_cmd->residual_count = se_cmd->data_length;
+		se_cmd->residual_count += se_cmd->data_length;
 
 		cmd->bufflen = 0;
 	}
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 1a02016..e768bfa 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -834,11 +834,11 @@ extern int iscsit_stop_time2retain_timer(struct iscsi_session *sess)
 		return 0;
 
 	sess->time2retain_timer_flags |= ISCSI_TF_STOP;
-	spin_unlock_bh(&se_tpg->session_lock);
+	spin_unlock(&se_tpg->session_lock);
 
 	del_timer_sync(&sess->time2retain_timer);
 
-	spin_lock_bh(&se_tpg->session_lock);
+	spin_lock(&se_tpg->session_lock);
 	sess->time2retain_timer_flags &= ~ISCSI_TF_RUNNING;
 	pr_debug("Stopped Time2Retain Timer for SID: %u\n",
 			sess->sid);
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 558ce85..4798e94 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1034,22 +1034,37 @@ static unsigned int dma_handle_tx(struct eg20t_port *priv)
 static void pch_uart_err_ir(struct eg20t_port *priv, unsigned int lsr)
 {
 	u8 fcr = ioread8(priv->membase + UART_FCR);
+	struct uart_port *port = &priv->port;
+	struct tty_struct *tty = tty_port_tty_get(&port->state->port);
+	char   *error_msg[5] = {};
+	int    i = 0;
 
 	/* Reset FIFO */
 	fcr |= UART_FCR_CLEAR_RCVR;
 	iowrite8(fcr, priv->membase + UART_FCR);
 
 	if (lsr & PCH_UART_LSR_ERR)
-		dev_err(&priv->pdev->dev, "Error data in FIFO\n");
+		error_msg[i++] = "Error data in FIFO\n";
 
-	if (lsr & UART_LSR_FE)
-		dev_err(&priv->pdev->dev, "Framing Error\n");
+	if (lsr & UART_LSR_FE) {
+		port->icount.frame++;
+		error_msg[i++] = "  Framing Error\n";
+	}
 
-	if (lsr & UART_LSR_PE)
-		dev_err(&priv->pdev->dev, "Parity Error\n");
+	if (lsr & UART_LSR_PE) {
+		port->icount.parity++;
+		error_msg[i++] = "  Parity Error\n";
+	}
 
-	if (lsr & UART_LSR_OE)
-		dev_err(&priv->pdev->dev, "Overrun Error\n");
+	if (lsr & UART_LSR_OE) {
+		port->icount.overrun++;
+		error_msg[i++] = "  Overrun Error\n";
+	}
+
+	if (tty == NULL) {
+		for (i = 0; error_msg[i] != NULL; i++)
+			dev_err(&priv->pdev->dev, error_msg[i]);
+	}
 }
 
 static irqreturn_t pch_uart_interrupt(int irq, void *dev_id)
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index d9f43247..a8c03e6 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -178,7 +178,8 @@ static struct usb_device_id ti_id_table_3410[15+TI_EXTRA_VID_PID_COUNT+1] = {
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_4543_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454B_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454C_PRODUCT_ID) },
-	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_PRODUCT_ID) },
+	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STEREO_PLUG_ID) },
+	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STRIP_PORT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, FRI2_PRODUCT_ID) },
 };
 
diff --git a/drivers/usb/serial/ti_usb_3410_5052.h b/drivers/usb/serial/ti_usb_3410_5052.h
index b353e7e..4a2423e 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.h
+++ b/drivers/usb/serial/ti_usb_3410_5052.h
@@ -52,7 +52,9 @@
 
 /* Abbott Diabetics vendor and product ids */
 #define ABBOTT_VENDOR_ID		0x1a61
-#define ABBOTT_PRODUCT_ID		0x3410
+#define ABBOTT_STEREO_PLUG_ID		0x3410
+#define ABBOTT_PRODUCT_ID		ABBOTT_STEREO_PLUG_ID
+#define ABBOTT_STRIP_PORT_ID		0x3420
 
 /* Commands */
 #define TI_GET_VERSION			0x01
diff --git a/fs/exec.c b/fs/exec.c
index 5a76464..832763a 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1162,13 +1162,6 @@ void setup_new_exec(struct linux_binprm * bprm)
 			set_dumpable(current->mm, suid_dumpable);
 	}
 
-	/*
-	 * Flush performance counters when crossing a
-	 * security domain:
-	 */
-	if (!get_dumpable(current->mm))
-		perf_event_exit_task(current);
-
 	/* An exec changes our domain. We are no longer part of the thread
 	   group */
 
@@ -1232,6 +1225,15 @@ void install_exec_creds(struct linux_binprm *bprm)
 
 	commit_creds(bprm->cred);
 	bprm->cred = NULL;
+
+	/*
+	 * Disable monitoring for regular users
+	 * when executing setuid binaries. Must
+	 * wait until new credentials are committed
+	 * by commit_creds() above
+	 */
+	if (get_dumpable(current->mm) != SUID_DUMP_USER)
+		perf_event_exit_task(current);
 	/*
 	 * cred_guard_mutex must be held at least to this point to prevent
 	 * ptrace_attach() from altering our determination of the task's
diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index aeed93a..9560fd7 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -1033,15 +1033,6 @@ static int ncp_rmdir(struct inode *dir, struct dentry *dentry)
 	DPRINTK("ncp_rmdir: removing %s/%s\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name);
 
-	/*
-	 * fail with EBUSY if there are still references to this
-	 * directory.
-	 */
-	dentry_unhash(dentry);
-	error = -EBUSY;
-	if (!d_unhashed(dentry))
-		goto out;
-
 	len = sizeof(__name);
 	error = ncp_io2vol(server, __name, &len, dentry->d_name.name,
 			   dentry->d_name.len, !ncp_preserve_case(dir));
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index a6d42ef..1ce4953 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -349,31 +349,50 @@ static unsigned int vfs_dent_type(uint8_t type)
 static int ubifs_readdir(struct file *file, void *dirent, filldir_t filldir)
 {
 	int err, over = 0;
+	loff_t pos = file->f_pos;
 	struct qstr nm;
 	union ubifs_key key;
 	struct ubifs_dent_node *dent;
 	struct inode *dir = file->f_path.dentry->d_inode;
 	struct ubifs_info *c = dir->i_sb->s_fs_info;
 
-	dbg_gen("dir ino %lu, f_pos %#llx", dir->i_ino, file->f_pos);
+	dbg_gen("dir ino %lu, f_pos %#llx", dir->i_ino, pos);
 
-	if (file->f_pos > UBIFS_S_KEY_HASH_MASK || file->f_pos == 2)
+	if (pos > UBIFS_S_KEY_HASH_MASK || pos == 2)
 		/*
 		 * The directory was seek'ed to a senseless position or there
 		 * are no more entries.
 		 */
 		return 0;
 
+	if (file->f_version == 0) {
+		/*
+		 * The file was seek'ed, which means that @file->private_data
+		 * is now invalid. This may also be just the first
+		 * 'ubifs_readdir()' invocation, in which case
+		 * @file->private_data is NULL, and the below code is
+		 * basically a no-op.
+		 */
+		kfree(file->private_data);
+		file->private_data = NULL;
+	}
+
+	/*
+	 * 'generic_file_llseek()' unconditionally sets @file->f_version to
+	 * zero, and we use this for detecting whether the file was seek'ed.
+	 */
+	file->f_version = 1;
+
 	/* File positions 0 and 1 correspond to "." and ".." */
-	if (file->f_pos == 0) {
+	if (pos == 0) {
 		ubifs_assert(!file->private_data);
 		over = filldir(dirent, ".", 1, 0, dir->i_ino, DT_DIR);
 		if (over)
 			return 0;
-		file->f_pos = 1;
+		file->f_pos = pos = 1;
 	}
 
-	if (file->f_pos == 1) {
+	if (pos == 1) {
 		ubifs_assert(!file->private_data);
 		over = filldir(dirent, "..", 2, 1,
 			       parent_ino(file->f_path.dentry), DT_DIR);
@@ -389,7 +408,7 @@ static int ubifs_readdir(struct file *file, void *dirent, filldir_t filldir)
 			goto out;
 		}
 
-		file->f_pos = key_hash_flash(c, &dent->key);
+		file->f_pos = pos = key_hash_flash(c, &dent->key);
 		file->private_data = dent;
 	}
 
@@ -397,17 +416,16 @@ static int ubifs_readdir(struct file *file, void *dirent, filldir_t filldir)
 	if (!dent) {
 		/*
 		 * The directory was seek'ed to and is now readdir'ed.
-		 * Find the entry corresponding to @file->f_pos or the
-		 * closest one.
+		 * Find the entry corresponding to @pos or the closest one.
 		 */
-		dent_key_init_hash(c, &key, dir->i_ino, file->f_pos);
+		dent_key_init_hash(c, &key, dir->i_ino, pos);
 		nm.name = NULL;
 		dent = ubifs_tnc_next_ent(c, &key, &nm);
 		if (IS_ERR(dent)) {
 			err = PTR_ERR(dent);
 			goto out;
 		}
-		file->f_pos = key_hash_flash(c, &dent->key);
+		file->f_pos = pos = key_hash_flash(c, &dent->key);
 		file->private_data = dent;
 	}
 
@@ -419,7 +437,7 @@ static int ubifs_readdir(struct file *file, void *dirent, filldir_t filldir)
 			     ubifs_inode(dir)->creat_sqnum);
 
 		nm.len = le16_to_cpu(dent->nlen);
-		over = filldir(dirent, dent->name, nm.len, file->f_pos,
+		over = filldir(dirent, dent->name, nm.len, pos,
 			       le64_to_cpu(dent->inum),
 			       vfs_dent_type(dent->type));
 		if (over)
@@ -435,9 +453,17 @@ static int ubifs_readdir(struct file *file, void *dirent, filldir_t filldir)
 		}
 
 		kfree(file->private_data);
-		file->f_pos = key_hash_flash(c, &dent->key);
+		file->f_pos = pos = key_hash_flash(c, &dent->key);
 		file->private_data = dent;
 		cond_resched();
+
+		if (file->f_version == 0)
+			/*
+			 * The file was seek'ed meanwhile, lets return and start
+			 * reading direntries from the new position on the next
+			 * invocation.
+			 */
+			return 0;
 	}
 
 out:
@@ -448,15 +474,13 @@ out:
 
 	kfree(file->private_data);
 	file->private_data = NULL;
+	/* 2 is a special value indicating that there are no more direntries */
 	file->f_pos = 2;
 	return 0;
 }
 
-/* If a directory is seeked, we have to free saved readdir() state */
 static loff_t ubifs_dir_llseek(struct file *file, loff_t offset, int origin)
 {
-	kfree(file->private_data);
-	file->private_data = NULL;
 	return generic_file_llseek(file, offset, origin);
 }
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c145c45..c65c7d1 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -952,8 +952,7 @@ struct perf_event {
 	/* mmap bits */
 	struct mutex			mmap_mutex;
 	atomic_t			mmap_count;
-	int				mmap_locked;
-	struct user_struct		*mmap_user;
+
 	struct ring_buffer		*rb;
 	struct list_head		rb_entry;
 
diff --git a/include/linux/rculist_nulls.h b/include/linux/rculist_nulls.h
index 2ae1371..1c33dd7 100644
--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -105,9 +105,14 @@ static inline void hlist_nulls_add_head_rcu(struct hlist_nulls_node *n,
  * @head:	the head for your list.
  * @member:	the name of the hlist_nulls_node within the struct.
  *
+ * The barrier() is needed to make sure compiler doesn't cache first element [1],
+ * as this loop can be restarted [2]
+ * [1] Documentation/atomic_ops.txt around line 114
+ * [2] Documentation/RCU/rculist_nulls.txt around line 146
  */
 #define hlist_nulls_for_each_entry_rcu(tpos, pos, head, member)			\
-	for (pos = rcu_dereference_raw(hlist_nulls_first_rcu(head));		\
+	for (({barrier();}),							\
+	     pos = rcu_dereference_raw(hlist_nulls_first_rcu(head));		\
 		(!is_a_nulls(pos)) &&						\
 		({ tpos = hlist_nulls_entry(pos, typeof(*tpos), member); 1; }); \
 		pos = rcu_dereference_raw(hlist_nulls_next_rcu(pos)))
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 2a32b9d..3d3ca9d 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -336,6 +336,9 @@ extern int put_cmsg(struct msghdr*, int level, int type, int len, void *data);
 
 struct timespec;
 
+/* The __sys_...msg variants allow MSG_CMSG_COMPAT */
+extern long __sys_recvmsg(int fd, struct msghdr __user *msg, unsigned flags);
+extern long __sys_sendmsg(int fd, struct msghdr __user *msg, unsigned flags);
 extern int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 			  unsigned int flags, struct timespec *timeout);
 extern int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1a6deb7..f5505f7 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -193,9 +193,6 @@ static void cpu_ctx_sched_in(struct perf_cpu_context *cpuctx,
 static void update_context_time(struct perf_event_context *ctx);
 static u64 perf_event_time(struct perf_event *event);
 
-static void ring_buffer_attach(struct perf_event *event,
-			       struct ring_buffer *rb);
-
 void __weak perf_event_print_debug(void)	{ }
 
 extern __weak const char *perf_pmu_name(void)
@@ -2853,6 +2850,7 @@ static void free_event_rcu(struct rcu_head *head)
 }
 
 static void ring_buffer_put(struct ring_buffer *rb);
+static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb);
 
 static void free_event(struct perf_event *event)
 {
@@ -2877,15 +2875,30 @@ static void free_event(struct perf_event *event)
 		if (has_branch_stack(event)) {
 			static_key_slow_dec_deferred(&perf_sched_events);
 			/* is system-wide event */
-			if (!(event->attach_state & PERF_ATTACH_TASK))
+			if (!(event->attach_state & PERF_ATTACH_TASK)) {
 				atomic_dec(&per_cpu(perf_branch_stack_events,
 						    event->cpu));
+			}
 		}
 	}
 
 	if (event->rb) {
-		ring_buffer_put(event->rb);
-		event->rb = NULL;
+		struct ring_buffer *rb;
+
+		/*
+		 * Can happen when we close an event with re-directed output.
+		 *
+		 * Since we have a 0 refcount, perf_mmap_close() will skip
+		 * over us; possibly making our ring_buffer_put() the last.
+		 */
+		mutex_lock(&event->mmap_mutex);
+		rb = event->rb;
+		if (rb) {
+			rcu_assign_pointer(event->rb, NULL);
+			ring_buffer_detach(event, rb);
+			ring_buffer_put(rb); /* could be last */
+		}
+		mutex_unlock(&event->mmap_mutex);
 	}
 
 	if (is_cgroup_event(event))
@@ -3123,30 +3136,13 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 	unsigned int events = POLL_HUP;
 
 	/*
-	 * Race between perf_event_set_output() and perf_poll(): perf_poll()
-	 * grabs the rb reference but perf_event_set_output() overrides it.
-	 * Here is the timeline for two threads T1, T2:
-	 * t0: T1, rb = rcu_dereference(event->rb)
-	 * t1: T2, old_rb = event->rb
-	 * t2: T2, event->rb = new rb
-	 * t3: T2, ring_buffer_detach(old_rb)
-	 * t4: T1, ring_buffer_attach(rb1)
-	 * t5: T1, poll_wait(event->waitq)
-	 *
-	 * To avoid this problem, we grab mmap_mutex in perf_poll()
-	 * thereby ensuring that the assignment of the new ring buffer
-	 * and the detachment of the old buffer appear atomic to perf_poll()
+	 * Pin the event->rb by taking event->mmap_mutex; otherwise
+	 * perf_event_set_output() can swizzle our rb and make us miss wakeups.
 	 */
 	mutex_lock(&event->mmap_mutex);
-
-	rcu_read_lock();
-	rb = rcu_dereference(event->rb);
-	if (rb) {
-		ring_buffer_attach(event, rb);
+	rb = event->rb;
+	if (rb)
 		events = atomic_xchg(&rb->poll, 0);
-	}
-	rcu_read_unlock();
-
 	mutex_unlock(&event->mmap_mutex);
 
 	poll_wait(file, &event->waitq, wait);
@@ -3462,16 +3458,12 @@ static void ring_buffer_attach(struct perf_event *event,
 		return;
 
 	spin_lock_irqsave(&rb->event_lock, flags);
-	if (!list_empty(&event->rb_entry))
-		goto unlock;
-
-	list_add(&event->rb_entry, &rb->event_list);
-unlock:
+	if (list_empty(&event->rb_entry))
+		list_add(&event->rb_entry, &rb->event_list);
 	spin_unlock_irqrestore(&rb->event_lock, flags);
 }
 
-static void ring_buffer_detach(struct perf_event *event,
-			       struct ring_buffer *rb)
+static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb)
 {
 	unsigned long flags;
 
@@ -3490,13 +3482,10 @@ static void ring_buffer_wakeup(struct perf_event *event)
 
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
-	if (!rb)
-		goto unlock;
-
-	list_for_each_entry_rcu(event, &rb->event_list, rb_entry)
-		wake_up_all(&event->waitq);
-
-unlock:
+	if (rb) {
+		list_for_each_entry_rcu(event, &rb->event_list, rb_entry)
+			wake_up_all(&event->waitq);
+	}
 	rcu_read_unlock();
 }
 
@@ -3525,18 +3514,10 @@ static struct ring_buffer *ring_buffer_get(struct perf_event *event)
 
 static void ring_buffer_put(struct ring_buffer *rb)
 {
-	struct perf_event *event, *n;
-	unsigned long flags;
-
 	if (!atomic_dec_and_test(&rb->refcount))
 		return;
 
-	spin_lock_irqsave(&rb->event_lock, flags);
-	list_for_each_entry_safe(event, n, &rb->event_list, rb_entry) {
-		list_del_init(&event->rb_entry);
-		wake_up_all(&event->waitq);
-	}
-	spin_unlock_irqrestore(&rb->event_lock, flags);
+	WARN_ON_ONCE(!list_empty(&rb->event_list));
 
 	call_rcu(&rb->rcu_head, rb_free_rcu);
 }
@@ -3546,26 +3527,100 @@ static void perf_mmap_open(struct vm_area_struct *vma)
 	struct perf_event *event = vma->vm_file->private_data;
 
 	atomic_inc(&event->mmap_count);
+	atomic_inc(&event->rb->mmap_count);
 }
 
+/*
+ * A buffer can be mmap()ed multiple times; either directly through the same
+ * event, or through other events by use of perf_event_set_output().
+ *
+ * In order to undo the VM accounting done by perf_mmap() we need to destroy
+ * the buffer here, where we still have a VM context. This means we need
+ * to detach all events redirecting to us.
+ */
 static void perf_mmap_close(struct vm_area_struct *vma)
 {
 	struct perf_event *event = vma->vm_file->private_data;
 
-	if (atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex)) {
-		unsigned long size = perf_data_size(event->rb);
-		struct user_struct *user = event->mmap_user;
-		struct ring_buffer *rb = event->rb;
+	struct ring_buffer *rb = event->rb;
+	struct user_struct *mmap_user = rb->mmap_user;
+	int mmap_locked = rb->mmap_locked;
+	unsigned long size = perf_data_size(rb);
+
+	atomic_dec(&rb->mmap_count);
+
+	if (!atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex))
+		return;
+
+	/* Detach current event from the buffer. */
+	rcu_assign_pointer(event->rb, NULL);
+	ring_buffer_detach(event, rb);
+	mutex_unlock(&event->mmap_mutex);
+
+	/* If there's still other mmap()s of this buffer, we're done. */
+	if (atomic_read(&rb->mmap_count)) {
+		ring_buffer_put(rb); /* can't be last */
+		return;
+	}
+
+	/*
+	 * No other mmap()s, detach from all other events that might redirect
+	 * into the now unreachable buffer. Somewhat complicated by the
+	 * fact that rb::event_lock otherwise nests inside mmap_mutex.
+	 */
+again:
+	rcu_read_lock();
+	list_for_each_entry_rcu(event, &rb->event_list, rb_entry) {
+		if (!atomic_long_inc_not_zero(&event->refcount)) {
+			/*
+			 * This event is en-route to free_event() which will
+			 * detach it and remove it from the list.
+			 */
+			continue;
+		}
+		rcu_read_unlock();
 
-		atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
-		vma->vm_mm->pinned_vm -= event->mmap_locked;
-		rcu_assign_pointer(event->rb, NULL);
-		ring_buffer_detach(event, rb);
+		mutex_lock(&event->mmap_mutex);
+		/*
+		 * Check we didn't race with perf_event_set_output() which can
+		 * swizzle the rb from under us while we were waiting to
+		 * acquire mmap_mutex.
+		 *
+		 * If we find a different rb; ignore this event, a next
+		 * iteration will no longer find it on the list. We have to
+		 * still restart the iteration to make sure we're not now
+		 * iterating the wrong list.
+		 */
+		if (event->rb == rb) {
+			rcu_assign_pointer(event->rb, NULL);
+			ring_buffer_detach(event, rb);
+			ring_buffer_put(rb); /* can't be last, we still have one */
+		}
 		mutex_unlock(&event->mmap_mutex);
+		put_event(event);
 
-		ring_buffer_put(rb);
-		free_uid(user);
+		/*
+		 * Restart the iteration; either we're on the wrong list or
+		 * destroyed its integrity by doing a deletion.
+		 */
+		goto again;
 	}
+	rcu_read_unlock();
+
+	/*
+	 * It could be there's still a few 0-ref events on the list; they'll
+	 * get cleaned up by free_event() -- they'll also still have their
+	 * ref on the rb and will free it whenever they are done with it.
+	 *
+	 * Aside from that, this buffer is 'fully' detached and unmapped,
+	 * undo the VM accounting.
+	 */
+
+	atomic_long_sub((size >> PAGE_SHIFT) + 1, &mmap_user->locked_vm);
+	vma->vm_mm->pinned_vm -= mmap_locked;
+	free_uid(mmap_user);
+
+	ring_buffer_put(rb); /* could be last */
 }
 
 static const struct vm_operations_struct perf_mmap_vmops = {
@@ -3615,12 +3670,24 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		return -EINVAL;
 
 	WARN_ON_ONCE(event->ctx->parent_ctx);
+again:
 	mutex_lock(&event->mmap_mutex);
 	if (event->rb) {
-		if (event->rb->nr_pages == nr_pages)
-			atomic_inc(&event->rb->refcount);
-		else
+		if (event->rb->nr_pages != nr_pages) {
 			ret = -EINVAL;
+			goto unlock;
+		}
+
+		if (!atomic_inc_not_zero(&event->rb->mmap_count)) {
+			/*
+			 * Raced against perf_mmap_close() through
+			 * perf_event_set_output(). Try again, hope for better
+			 * luck.
+			 */
+			mutex_unlock(&event->mmap_mutex);
+			goto again;
+		}
+
 		goto unlock;
 	}
 
@@ -3661,12 +3728,16 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		ret = -ENOMEM;
 		goto unlock;
 	}
-	rcu_assign_pointer(event->rb, rb);
+
+	atomic_set(&rb->mmap_count, 1);
+	rb->mmap_locked = extra;
+	rb->mmap_user = get_current_user();
 
 	atomic_long_add(user_extra, &user->locked_vm);
-	event->mmap_locked = extra;
-	event->mmap_user = get_current_user();
-	vma->vm_mm->pinned_vm += event->mmap_locked;
+	vma->vm_mm->pinned_vm += extra;
+
+	ring_buffer_attach(event, rb);
+	rcu_assign_pointer(event->rb, rb);
 
 	perf_event_update_userpage(event);
 
@@ -3675,7 +3746,11 @@ unlock:
 		atomic_inc(&event->mmap_count);
 	mutex_unlock(&event->mmap_mutex);
 
-	vma->vm_flags |= VM_RESERVED;
+	/*
+	 * Since pinned accounting is per vm we cannot allow fork() to copy our
+	 * vma.
+	 */
+	vma->vm_flags |= VM_DONTCOPY | VM_RESERVED;
 	vma->vm_ops = &perf_mmap_vmops;
 
 	return ret;
@@ -6164,6 +6239,8 @@ set:
 	if (atomic_read(&event->mmap_count))
 		goto unlock;
 
+	old_rb = event->rb;
+
 	if (output_event) {
 		/* get the rb we want to redirect to */
 		rb = ring_buffer_get(output_event);
@@ -6171,16 +6248,28 @@ set:
 			goto unlock;
 	}
 
-	old_rb = event->rb;
-	rcu_assign_pointer(event->rb, rb);
 	if (old_rb)
 		ring_buffer_detach(event, old_rb);
+
+	if (rb)
+		ring_buffer_attach(event, rb);
+
+	rcu_assign_pointer(event->rb, rb);
+
+	if (old_rb) {
+		ring_buffer_put(old_rb);
+		/*
+		 * Since we detached before setting the new rb, so that we
+		 * could attach the new rb, we could have missed a wakeup.
+		 * Provide it now.
+		 */
+		wake_up_all(&event->waitq);
+	}
+
 	ret = 0;
 unlock:
 	mutex_unlock(&event->mmap_mutex);
 
-	if (old_rb)
-		ring_buffer_put(old_rb);
 out:
 	return ret;
 }
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index bb38c4d..fc8bfcf 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -147,7 +147,7 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 		return;
 	}
 
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		unsigned int nr;
 
 		nr = per_cpu(nr_cpu_bp_pinned[type], cpu);
@@ -233,7 +233,7 @@ toggle_bp_slot(struct perf_event *bp, bool enable, enum bp_type_idx type,
 	if (cpu >= 0) {
 		toggle_bp_task_slot(bp, cpu, enable, type, weight);
 	} else {
-		for_each_online_cpu(cpu)
+		for_each_possible_cpu(cpu)
 			toggle_bp_task_slot(bp, cpu, enable, type, weight);
 	}
 
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index b0b107f..b400e64 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -30,6 +30,10 @@ struct ring_buffer {
 	spinlock_t			event_lock;
 	struct list_head		event_list;
 
+	atomic_t			mmap_count;
+	unsigned long			mmap_locked;
+	struct user_struct		*mmap_user;
+
 	struct perf_event_mmap_page	*user_page;
 	void				*data_pages[0];
 };
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 6204170..bfaec3c 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -2191,6 +2191,9 @@ static struct sk_buff *l2cap_build_cmd(struct l2cap_conn *conn,
 	BT_DBG("conn %p, code 0x%2.2x, ident 0x%2.2x, len %d",
 			conn, code, ident, dlen);
 
+	if (conn->mtu < L2CAP_HDR_SIZE + L2CAP_CMD_HDR_SIZE)
+		return NULL;
+
 	len = L2CAP_HDR_SIZE + L2CAP_CMD_HDR_SIZE + dlen;
 	count = min_t(unsigned int, conn->mtu, len);
 
diff --git a/net/compat.c b/net/compat.c
index 74ed1d7..9c816e8 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -735,19 +735,25 @@ static unsigned char nas[21] = {
 
 asmlinkage long compat_sys_sendmsg(int fd, struct compat_msghdr __user *msg, unsigned int flags)
 {
-	return sys_sendmsg(fd, (struct msghdr __user *)msg, flags | MSG_CMSG_COMPAT);
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+	return __sys_sendmsg(fd, (struct msghdr __user *)msg, flags | MSG_CMSG_COMPAT);
 }
 
 asmlinkage long compat_sys_sendmmsg(int fd, struct compat_mmsghdr __user *mmsg,
 				    unsigned int vlen, unsigned int flags)
 {
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
 	return __sys_sendmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
 			      flags | MSG_CMSG_COMPAT);
 }
 
 asmlinkage long compat_sys_recvmsg(int fd, struct compat_msghdr __user *msg, unsigned int flags)
 {
-	return sys_recvmsg(fd, (struct msghdr __user *)msg, flags | MSG_CMSG_COMPAT);
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+	return __sys_recvmsg(fd, (struct msghdr __user *)msg, flags | MSG_CMSG_COMPAT);
 }
 
 asmlinkage long compat_sys_recv(int fd, void __user *buf, size_t len, unsigned int flags)
@@ -769,6 +775,9 @@ asmlinkage long compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
 	int datagrams;
 	struct timespec ktspec;
 
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+
 	if (COMPAT_USE_64BIT_TIME)
 		return __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
 				      flags | MSG_CMSG_COMPAT,
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index f49047b..37000b5 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -743,6 +743,7 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
 		tiph = &tunnel->parms.iph;
 	}
 
+	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	if ((dst = tiph->daddr) == 0) {
 		/* NBMA tunnel */
 
@@ -886,7 +887,6 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
 	skb_reset_transport_header(skb);
 	skb_push(skb, gre_hlen);
 	skb_reset_network_header(skb);
-	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED |
 			      IPSKB_REROUTED);
 	skb_dst_drop(skb);
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 2d0f99b..d614b42 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -465,6 +465,7 @@ static netdev_tx_t ipip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (tos & 1)
 		tos = old_iph->tos;
 
+	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	if (!dst) {
 		/* NBMA tunnel */
 		if ((rt = skb_rtable(skb)) == NULL) {
@@ -547,7 +548,6 @@ static netdev_tx_t ipip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev)
 	skb->transport_header = skb->network_header;
 	skb_push(skb, sizeof(struct iphdr));
 	skb_reset_network_header(skb);
-	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED |
 			      IPSKB_REROUTED);
 	skb_dst_drop(skb);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 1a763b7..75936ee 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3294,8 +3294,11 @@ int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
 
 	for (i = 0; i < shi->nr_frags; ++i) {
 		const struct skb_frag_struct *f = &shi->frags[i];
-		struct page *page = skb_frag_page(f);
-		sg_set_page(&sg, page, skb_frag_size(f), f->page_offset);
+		unsigned int offset = f->page_offset;
+		struct page *page = skb_frag_page(f) + (offset >> PAGE_SHIFT);
+
+		sg_set_page(&sg, page, skb_frag_size(f),
+			    offset_in_page(offset));
 		if (crypto_hash_update(desc, &sg, skb_frag_size(f)))
 			return 1;
 	}
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e8139f8..3d5ffe0 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3108,8 +3108,8 @@ static void tcp_enter_recovery(struct sock *sk, bool ece_ack)
  * tcp_xmit_retransmit_queue().
  */
 static void tcp_fastretrans_alert(struct sock *sk, int pkts_acked,
-				  int prior_sacked, bool is_dupack,
-				  int flag)
+				  int prior_sacked, int prior_packets,
+				  bool is_dupack, int flag)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -3175,7 +3175,8 @@ static void tcp_fastretrans_alert(struct sock *sk, int pkts_acked,
 				tcp_add_reno_sack(sk);
 		} else
 			do_lost = tcp_try_undo_partial(sk, pkts_acked);
-		newly_acked_sacked = pkts_acked + tp->sacked_out - prior_sacked;
+		newly_acked_sacked = prior_packets - tp->packets_out +
+				     tp->sacked_out - prior_sacked;
 		break;
 	case TCP_CA_Loss:
 		if (flag & FLAG_DATA_ACKED)
@@ -3197,7 +3198,8 @@ static void tcp_fastretrans_alert(struct sock *sk, int pkts_acked,
 			if (is_dupack)
 				tcp_add_reno_sack(sk);
 		}
-		newly_acked_sacked = pkts_acked + tp->sacked_out - prior_sacked;
+		newly_acked_sacked = prior_packets - tp->packets_out +
+				     tp->sacked_out - prior_sacked;
 
 		if (icsk->icsk_ca_state <= TCP_CA_Disorder)
 			tcp_try_undo_dsack(sk);
@@ -3816,9 +3818,10 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	bool is_dupack = false;
 	u32 prior_in_flight;
 	u32 prior_fackets;
-	int prior_packets;
+	int prior_packets = tp->packets_out;
 	int prior_sacked = tp->sacked_out;
 	int pkts_acked = 0;
+	int previous_packets_out = 0;
 	bool frto_cwnd = false;
 
 	/* If the ack is older than previous acks
@@ -3898,14 +3901,14 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	sk->sk_err_soft = 0;
 	icsk->icsk_probes_out = 0;
 	tp->rcv_tstamp = tcp_time_stamp;
-	prior_packets = tp->packets_out;
 	if (!prior_packets)
 		goto no_queue;
 
 	/* See if we can take anything off of the retransmit queue. */
+	previous_packets_out = tp->packets_out;
 	flag |= tcp_clean_rtx_queue(sk, prior_fackets, prior_snd_una);
 
-	pkts_acked = prior_packets - tp->packets_out;
+	pkts_acked = previous_packets_out - tp->packets_out;
 
 	if (tp->frto_counter)
 		frto_cwnd = tcp_process_frto(sk, flag);
@@ -3920,7 +3923,7 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 			tcp_cong_avoid(sk, ack, prior_in_flight);
 		is_dupack = !(flag & (FLAG_SND_UNA_ADVANCED | FLAG_NOT_DUP));
 		tcp_fastretrans_alert(sk, pkts_acked, prior_sacked,
-				      is_dupack, flag);
+				      prior_packets, is_dupack, flag);
 	} else {
 		if ((flag & FLAG_DATA_ACKED) && !frto_cwnd)
 			tcp_cong_avoid(sk, ack, prior_in_flight);
@@ -3935,7 +3938,7 @@ no_queue:
 	/* If data was DSACKed, see if we can undo a cwnd reduction. */
 	if (flag & FLAG_DSACKING_ACK)
 		tcp_fastretrans_alert(sk, pkts_acked, prior_sacked,
-				      is_dupack, flag);
+				      prior_packets, is_dupack, flag);
 	/* If this ack opens up a zero window, clear backoff.  It was
 	 * being used to time the probes, and is probably far higher than
 	 * it needs to be for normal retransmission.
@@ -3955,7 +3958,7 @@ old_ack:
 	if (TCP_SKB_CB(skb)->sacked) {
 		flag |= tcp_sacktag_write_queue(sk, skb, prior_snd_una);
 		tcp_fastretrans_alert(sk, pkts_acked, prior_sacked,
-				      is_dupack, flag);
+				      prior_packets, is_dupack, flag);
 	}
 
 	SOCK_DEBUG(sk, "Ack %u before %u:%u\n", ack, tp->snd_una, tp->snd_nxt);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index ae12c92..4a1e840 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -836,11 +836,13 @@ static int tcp_transmit_skb(struct sock *sk, struct sk_buff *skb, int clone_it,
 							   &md5);
 	tcp_header_size = tcp_options_size + sizeof(struct tcphdr);
 
-	if (tcp_packets_in_flight(tp) == 0) {
+	if (tcp_packets_in_flight(tp) == 0)
 		tcp_ca_event(sk, CA_EVENT_TX_START);
-		skb->ooo_okay = 1;
-	} else
-		skb->ooo_okay = 0;
+
+	/* if no packet is in qdisc/device queue, then allow XPS to select
+	 * another queue.
+	 */
+	skb->ooo_okay = sk_wmem_alloc_get(sk) == 0;
 
 	skb_push(skb, tcp_header_size);
 	skb_reset_transport_header(skb);
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 2078f4e..f67075b 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2435,8 +2435,10 @@ static void init_loopback(struct net_device *dev)
 			sp_rt = addrconf_dst_alloc(idev, &sp_ifa->addr, 0);
 
 			/* Failure cases are ignored */
-			if (!IS_ERR(sp_rt))
+			if (!IS_ERR(sp_rt)) {
+				sp_ifa->rt = sp_rt;
 				ip6_ins_rt(sp_rt);
+			}
 		}
 		read_unlock_bh(&idev->lock);
 	}
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 4703c70..ccb2adb 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1242,7 +1242,7 @@ int ip6_append_data(struct sock *sk, int getfrag(void *from, char *to,
 			if (WARN_ON(np->cork.opt))
 				return -EINVAL;
 
-			np->cork.opt = kmalloc(opt->tot_len, sk->sk_allocation);
+			np->cork.opt = kzalloc(opt->tot_len, sk->sk_allocation);
 			if (unlikely(np->cork.opt == NULL))
 				return -ENOBUFS;
 
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 46c7cc7..ea7e244 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -345,19 +345,19 @@ static int pppol2tp_sendmsg(struct kiocb *iocb, struct socket *sock, struct msgh
 	skb_put(skb, 2);
 
 	/* Copy user data into skb */
-	error = memcpy_fromiovec(skb->data, m->msg_iov, total_len);
+	error = memcpy_fromiovec(skb_put(skb, total_len), m->msg_iov,
+				 total_len);
 	if (error < 0) {
 		kfree_skb(skb);
 		goto error_put_sess_tun;
 	}
-	skb_put(skb, total_len);
 
 	l2tp_xmit_skb(session, skb, session->hdr_len);
 
 	sock_put(ps->tunnel_sock);
 	sock_put(sk);
 
-	return error;
+	return total_len;
 
 error_put_sess_tun:
 	sock_put(ps->tunnel_sock);
diff --git a/net/netlabel/netlabel_domainhash.c b/net/netlabel/netlabel_domainhash.c
index d8d4243..6bb1d42 100644
--- a/net/netlabel/netlabel_domainhash.c
+++ b/net/netlabel/netlabel_domainhash.c
@@ -245,6 +245,71 @@ static void netlbl_domhsh_audit_add(struct netlbl_dom_map *entry,
 	}
 }
 
+/**
+ * netlbl_domhsh_validate - Validate a new domain mapping entry
+ * @entry: the entry to validate
+ *
+ * This function validates the new domain mapping entry to ensure that it is
+ * a valid entry.  Returns zero on success, negative values on failure.
+ *
+ */
+static int netlbl_domhsh_validate(const struct netlbl_dom_map *entry)
+{
+	struct netlbl_af4list *iter4;
+	struct netlbl_domaddr4_map *map4;
+#if IS_ENABLED(CONFIG_IPV6)
+	struct netlbl_af6list *iter6;
+	struct netlbl_domaddr6_map *map6;
+#endif /* IPv6 */
+
+	if (entry == NULL)
+		return -EINVAL;
+
+	switch (entry->type) {
+	case NETLBL_NLTYPE_UNLABELED:
+		if (entry->type_def.cipsov4 != NULL ||
+		    entry->type_def.addrsel != NULL)
+			return -EINVAL;
+		break;
+	case NETLBL_NLTYPE_CIPSOV4:
+		if (entry->type_def.cipsov4 == NULL)
+			return -EINVAL;
+		break;
+	case NETLBL_NLTYPE_ADDRSELECT:
+		netlbl_af4list_foreach(iter4, &entry->type_def.addrsel->list4) {
+			map4 = netlbl_domhsh_addr4_entry(iter4);
+			switch (map4->type) {
+			case NETLBL_NLTYPE_UNLABELED:
+				if (map4->type_def.cipsov4 != NULL)
+					return -EINVAL;
+				break;
+			case NETLBL_NLTYPE_CIPSOV4:
+				if (map4->type_def.cipsov4 == NULL)
+					return -EINVAL;
+				break;
+			default:
+				return -EINVAL;
+			}
+		}
+#if IS_ENABLED(CONFIG_IPV6)
+		netlbl_af6list_foreach(iter6, &entry->type_def.addrsel->list6) {
+			map6 = netlbl_domhsh_addr6_entry(iter6);
+			switch (map6->type) {
+			case NETLBL_NLTYPE_UNLABELED:
+				break;
+			default:
+				return -EINVAL;
+			}
+		}
+#endif /* IPv6 */
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /*
  * Domain Hash Table Functions
  */
@@ -311,6 +376,10 @@ int netlbl_domhsh_add(struct netlbl_dom_map *entry,
 	struct netlbl_af6list *tmp6;
 #endif /* IPv6 */
 
+	ret_val = netlbl_domhsh_validate(entry);
+	if (ret_val != 0)
+		return ret_val;
+
 	/* XXX - we can remove this RCU read lock as the spinlock protects the
 	 *       entire function, but before we do we need to fixup the
 	 *       netlbl_af[4,6]list RCU functions to do "the right thing" with
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 4137d01..1522b93 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2854,12 +2854,11 @@ static int packet_getname_spkt(struct socket *sock, struct sockaddr *uaddr,
 		return -EOPNOTSUPP;
 
 	uaddr->sa_family = AF_PACKET;
+	memset(uaddr->sa_data, 0, sizeof(uaddr->sa_data));
 	rcu_read_lock();
 	dev = dev_get_by_index_rcu(sock_net(sk), pkt_sk(sk)->ifindex);
 	if (dev)
-		strncpy(uaddr->sa_data, dev->name, 14);
-	else
-		memset(uaddr->sa_data, 0, 14);
+		strlcpy(uaddr->sa_data, dev->name, sizeof(uaddr->sa_data));
 	rcu_read_unlock();
 	*uaddr_len = sizeof(*uaddr);
 
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 0716290..8259db2 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -205,6 +205,8 @@ static inline int sctp_cacc_skip(struct sctp_transport *primary,
  */
 void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q)
 {
+	memset(q, 0, sizeof(struct sctp_outq));
+
 	q->asoc = asoc;
 	INIT_LIST_HEAD(&q->out_chunk_list);
 	INIT_LIST_HEAD(&q->control_chunk_list);
@@ -212,13 +214,7 @@ void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q)
 	INIT_LIST_HEAD(&q->sacked);
 	INIT_LIST_HEAD(&q->abandoned);
 
-	q->fast_rtx = 0;
-	q->outstanding_bytes = 0;
 	q->empty = 1;
-	q->cork  = 0;
-
-	q->malloced = 0;
-	q->out_qlen = 0;
 }
 
 /* Free the outqueue structure and any related pending chunks.
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 957bb6e..7e40284 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3929,6 +3929,12 @@ SCTP_STATIC void sctp_destroy_sock(struct sock *sk)
 
 	/* Release our hold on the endpoint. */
 	sp = sctp_sk(sk);
+	/* This could happen during socket init, thus we bail out
+	 * early, since the rest of the below is not setup either.
+	 */
+	if (sp->ep == NULL)
+		return;
+
 	if (sp->do_auto_asconf) {
 		sp->do_auto_asconf = 0;
 		list_del(&sp->auto_asconf_list);
diff --git a/net/socket.c b/net/socket.c
index bce45cc..cd51a03 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1898,7 +1898,7 @@ struct used_address {
 	unsigned int name_len;
 };
 
-static int __sys_sendmsg(struct socket *sock, struct msghdr __user *msg,
+static int ___sys_sendmsg(struct socket *sock, struct msghdr __user *msg,
 			 struct msghdr *msg_sys, unsigned int flags,
 			 struct used_address *used_address)
 {
@@ -2013,22 +2013,30 @@ out:
  *	BSD sendmsg interface
  */
 
-SYSCALL_DEFINE3(sendmsg, int, fd, struct msghdr __user *, msg, unsigned int, flags)
+long __sys_sendmsg(int fd, struct msghdr __user *msg, unsigned flags)
 {
 	int fput_needed, err;
 	struct msghdr msg_sys;
-	struct socket *sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	struct socket *sock;
 
+	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;
 
-	err = __sys_sendmsg(sock, msg, &msg_sys, flags, NULL);
+	err = ___sys_sendmsg(sock, msg, &msg_sys, flags, NULL);
 
 	fput_light(sock->file, fput_needed);
 out:
 	return err;
 }
 
+SYSCALL_DEFINE3(sendmsg, int, fd, struct msghdr __user *, msg, unsigned int, flags)
+{
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+	return __sys_sendmsg(fd, msg, flags);
+}
+
 /*
  *	Linux sendmmsg interface
  */
@@ -2059,15 +2067,16 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 
 	while (datagrams < vlen) {
 		if (MSG_CMSG_COMPAT & flags) {
-			err = __sys_sendmsg(sock, (struct msghdr __user *)compat_entry,
-					    &msg_sys, flags, &used_address);
+			err = ___sys_sendmsg(sock, (struct msghdr __user *)compat_entry,
+					     &msg_sys, flags, &used_address);
 			if (err < 0)
 				break;
 			err = __put_user(err, &compat_entry->msg_len);
 			++compat_entry;
 		} else {
-			err = __sys_sendmsg(sock, (struct msghdr __user *)entry,
-					    &msg_sys, flags, &used_address);
+			err = ___sys_sendmsg(sock,
+					     (struct msghdr __user *)entry,
+					     &msg_sys, flags, &used_address);
 			if (err < 0)
 				break;
 			err = put_user(err, &entry->msg_len);
@@ -2091,10 +2100,12 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 SYSCALL_DEFINE4(sendmmsg, int, fd, struct mmsghdr __user *, mmsg,
 		unsigned int, vlen, unsigned int, flags)
 {
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
 	return __sys_sendmmsg(fd, mmsg, vlen, flags);
 }
 
-static int __sys_recvmsg(struct socket *sock, struct msghdr __user *msg,
+static int ___sys_recvmsg(struct socket *sock, struct msghdr __user *msg,
 			 struct msghdr *msg_sys, unsigned int flags, int nosec)
 {
 	struct compat_msghdr __user *msg_compat =
@@ -2186,23 +2197,31 @@ out:
  *	BSD recvmsg interface
  */
 
-SYSCALL_DEFINE3(recvmsg, int, fd, struct msghdr __user *, msg,
-		unsigned int, flags)
+long __sys_recvmsg(int fd, struct msghdr __user *msg, unsigned flags)
 {
 	int fput_needed, err;
 	struct msghdr msg_sys;
-	struct socket *sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	struct socket *sock;
 
+	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;
 
-	err = __sys_recvmsg(sock, msg, &msg_sys, flags, 0);
+	err = ___sys_recvmsg(sock, msg, &msg_sys, flags, 0);
 
 	fput_light(sock->file, fput_needed);
 out:
 	return err;
 }
 
+SYSCALL_DEFINE3(recvmsg, int, fd, struct msghdr __user *, msg,
+		unsigned int, flags)
+{
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+	return __sys_recvmsg(fd, msg, flags);
+}
+
 /*
  *     Linux recvmmsg interface
  */
@@ -2240,17 +2259,18 @@ int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 		 * No need to ask LSM for more than the first datagram.
 		 */
 		if (MSG_CMSG_COMPAT & flags) {
-			err = __sys_recvmsg(sock, (struct msghdr __user *)compat_entry,
-					    &msg_sys, flags & ~MSG_WAITFORONE,
-					    datagrams);
+			err = ___sys_recvmsg(sock, (struct msghdr __user *)compat_entry,
+					     &msg_sys, flags & ~MSG_WAITFORONE,
+					     datagrams);
 			if (err < 0)
 				break;
 			err = __put_user(err, &compat_entry->msg_len);
 			++compat_entry;
 		} else {
-			err = __sys_recvmsg(sock, (struct msghdr __user *)entry,
-					    &msg_sys, flags & ~MSG_WAITFORONE,
-					    datagrams);
+			err = ___sys_recvmsg(sock,
+					     (struct msghdr __user *)entry,
+					     &msg_sys, flags & ~MSG_WAITFORONE,
+					     datagrams);
 			if (err < 0)
 				break;
 			err = put_user(err, &entry->msg_len);
@@ -2317,6 +2337,9 @@ SYSCALL_DEFINE5(recvmmsg, int, fd, struct mmsghdr __user *, mmsg,
 	int datagrams;
 	struct timespec timeout_sys;
 
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+
 	if (!timeout)
 		return __sys_recvmmsg(fd, mmsg, vlen, flags, NULL);
 
diff --git a/sound/usb/card.c b/sound/usb/card.c
index aa25e04..51241f4 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -150,14 +150,32 @@ static int snd_usb_create_stream(struct snd_usb_audio *chip, int ctrlif, int int
 		return -EINVAL;
 	}
 
+	alts = &iface->altsetting[0];
+	altsd = get_iface_desc(alts);
+
+	/*
+	 * Android with both accessory and audio interfaces enabled gets the
+	 * interface numbers wrong.
+	 */
+	if ((chip->usb_id == USB_ID(0x18d1, 0x2d04) ||
+	     chip->usb_id == USB_ID(0x18d1, 0x2d05)) &&
+	    interface == 0 &&
+	    altsd->bInterfaceClass == USB_CLASS_VENDOR_SPEC &&
+	    altsd->bInterfaceSubClass == USB_SUBCLASS_VENDOR_SPEC) {
+		interface = 2;
+		iface = usb_ifnum_to_if(dev, interface);
+		if (!iface)
+			return -EINVAL;
+		alts = &iface->altsetting[0];
+		altsd = get_iface_desc(alts);
+	}
+
 	if (usb_interface_claimed(iface)) {
 		snd_printdd(KERN_INFO "%d:%d:%d: skipping, already claimed\n",
 						dev->devnum, ctrlif, interface);
 		return -EINVAL;
 	}
 
-	alts = &iface->altsetting[0];
-	altsd = get_iface_desc(alts);
 	if ((altsd->bInterfaceClass == USB_CLASS_AUDIO ||
 	     altsd->bInterfaceClass == USB_CLASS_VENDOR_SPEC) &&
 	    altsd->bInterfaceSubClass == USB_SUBCLASS_MIDISTREAMING) {
diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index a3308e1..3e513a8 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -841,6 +841,7 @@ static void volume_control_quirks(struct usb_mixer_elem_info *cval,
 
 	case USB_ID(0x046d, 0x0808):
 	case USB_ID(0x046d, 0x0809):
+	case USB_ID(0x046d, 0x081b): /* HD Webcam c310 */
 	case USB_ID(0x046d, 0x081d): /* HD Webcam c510 */
 	case USB_ID(0x046d, 0x0825): /* HD Webcam c270 */
 	case USB_ID(0x046d, 0x0991):
