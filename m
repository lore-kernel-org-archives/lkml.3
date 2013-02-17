Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab3BQTEC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 14:04:02 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:42701 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab3BQTD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 14:03:59 -0500
Date: Sun, 17 Feb 2013 11:04:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 3.0.65
Message-ID: <20130217190416.GB5719@kroah.com>
References: <20130217190404.GA5719@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130217190404.GA5719@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 1a4a8cd..cdba5c1 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 3
 PATCHLEVEL = 0
-SUBLEVEL = 64
+SUBLEVEL = 65
 EXTRAVERSION =
 NAME = Sneaky Weasel
 
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 884507e..6be9909 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -142,6 +142,11 @@ static inline unsigned long pmd_pfn(pmd_t pmd)
 	return (pmd_val(pmd) & PTE_PFN_MASK) >> PAGE_SHIFT;
 }
 
+static inline unsigned long pud_pfn(pud_t pud)
+{
+	return (pud_val(pud) & PTE_PFN_MASK) >> PAGE_SHIFT;
+}
+
 #define pte_page(pte)	pfn_to_page(pte_pfn(pte))
 
 static inline int pmd_large(pmd_t pte)
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index bbaaa00..44b93da 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -831,6 +831,9 @@ int kern_addr_valid(unsigned long addr)
 	if (pud_none(*pud))
 		return 0;
 
+	if (pud_large(*pud))
+		return pfn_valid(pud_pfn(*pud));
+
 	pmd = pmd_offset(pud, addr);
 	if (pmd_none(*pmd))
 		return 0;
diff --git a/arch/x86/xen/xen-asm_32.S b/arch/x86/xen/xen-asm_32.S
index b040b0e..7328f71 100644
--- a/arch/x86/xen/xen-asm_32.S
+++ b/arch/x86/xen/xen-asm_32.S
@@ -88,11 +88,11 @@ ENTRY(xen_iret)
 	 */
 #ifdef CONFIG_SMP
 	GET_THREAD_INFO(%eax)
-	movl TI_cpu(%eax), %eax
-	movl __per_cpu_offset(,%eax,4), %eax
-	mov xen_vcpu(%eax), %eax
+	movl %ss:TI_cpu(%eax), %eax
+	movl %ss:__per_cpu_offset(,%eax,4), %eax
+	mov %ss:xen_vcpu(%eax), %eax
 #else
-	movl xen_vcpu, %eax
+	movl %ss:xen_vcpu, %eax
 #endif
 
 	/* check IF state we're restoring */
@@ -105,11 +105,11 @@ ENTRY(xen_iret)
 	 * resuming the code, so we don't have to be worried about
 	 * being preempted to another CPU.
 	 */
-	setz XEN_vcpu_info_mask(%eax)
+	setz %ss:XEN_vcpu_info_mask(%eax)
 xen_iret_start_crit:
 
 	/* check for unmasked and pending */
-	cmpw $0x0001, XEN_vcpu_info_pending(%eax)
+	cmpw $0x0001, %ss:XEN_vcpu_info_pending(%eax)
 
 	/*
 	 * If there's something pending, mask events again so we can
@@ -117,7 +117,7 @@ xen_iret_start_crit:
 	 * touch XEN_vcpu_info_mask.
 	 */
 	jne 1f
-	movb $1, XEN_vcpu_info_mask(%eax)
+	movb $1, %ss:XEN_vcpu_info_mask(%eax)
 
 1:	popl %eax
 
diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index 97f46ac..a5d98a3 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -4521,11 +4521,13 @@ void igb_update_stats(struct igb_adapter *adapter,
 	bytes = 0;
 	packets = 0;
 	for (i = 0; i < adapter->num_rx_queues; i++) {
-		u32 rqdpc_tmp = rd32(E1000_RQDPC(i)) & 0x0FFF;
+		u32 rqdpc = rd32(E1000_RQDPC(i));
 		struct igb_ring *ring = adapter->rx_ring[i];
 
-		ring->rx_stats.drops += rqdpc_tmp;
-		net_stats->rx_fifo_errors += rqdpc_tmp;
+		if (rqdpc) {
+			ring->rx_stats.drops += rqdpc;
+			net_stats->rx_fifo_errors += rqdpc;
+		}
 
 		do {
 			start = u64_stats_fetch_begin_bh(&ring->rx_syncp);
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 7f87bee..f53da9e 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -19,6 +19,8 @@ static void pci_free_resources(struct pci_dev *dev)
 
 static void pci_stop_dev(struct pci_dev *dev)
 {
+	pci_pme_active(dev, false);
+
 	if (dev->is_added) {
 		pci_proc_detach_device(dev);
 		pci_remove_sysfs_dev_files(dev);
