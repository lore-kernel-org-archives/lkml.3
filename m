Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaIQEMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 00:12:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50529 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbaIQEMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 00:12:45 -0400
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, jbeulich@suse.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V2 1/3] xen: sync some headers with xen tree
Date: Wed, 17 Sep 2014 06:12:35 +0200
Message-Id: <1410927157-15069-2-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1410927157-15069-1-git-send-email-jgross@suse.com>
References: <1410927157-15069-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be able to use an initially unmapped initrd with xen the following
header files must be synced to a newer version from the xen tree:

include/xen/interface/elfnote.h
include/xen/interface/xen.h

As the KEXEC and DUMPCORE related ELFNOTES are not relevant for the
kernel they are omitted from elfnote.h.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 include/xen/interface/elfnote.h |  48 ++++++-
 include/xen/interface/xen.h     | 272 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 294 insertions(+), 26 deletions(-)

diff --git a/include/xen/interface/elfnote.h b/include/xen/interface/elfnote.h
index 6f4eae3..f90b034 100644
--- a/include/xen/interface/elfnote.h
+++ b/include/xen/interface/elfnote.h
@@ -3,6 +3,24 @@
  *
  * Definitions used for the Xen ELF notes.
  *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to
+ * deal in the Software without restriction, including without limitation the
+ * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
+ * sell copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
  * Copyright (c) 2006, Ian Campbell, XenSource Ltd.
  */
 
@@ -18,12 +36,13 @@
  *
  * LEGACY indicated the fields in the legacy __xen_guest string which
  * this a note type replaces.
+ *
+ * String values (for non-legacy) are NULL terminated ASCII, also known
+ * as ASCIZ type.
  */
 
 /*
  * NAME=VALUE pair (string).
- *
- * LEGACY: FEATURES and PAE
  */
 #define XEN_ELFNOTE_INFO           0
 
@@ -137,10 +156,30 @@
 
 /*
  * Whether or not the guest supports cooperative suspend cancellation.
+ * This is a numeric value.
+ *
+ * Default is 0
  */
 #define XEN_ELFNOTE_SUSPEND_CANCEL 14
 
 /*
+ * The (non-default) location the initial phys-to-machine map should be
+ * placed at by the hypervisor (Dom0) or the tools (DomU).
+ * The kernel must be prepared for this mapping to be established using
+ * large pages, despite such otherwise not being available to guests.
+ * The kernel must also be able to handle the page table pages used for
+ * this mapping not being accessible through the initial mapping.
+ * (Only x86-64 supports this at present.)
+ */
+#define XEN_ELFNOTE_INIT_P2M      15
+
+/*
+ * Whether or not the guest can deal with being passed an initrd not
+ * mapped through its initial page tables.
+ */
+#define XEN_ELFNOTE_MOD_START_PFN 16
+
+/*
  * The features supported by this kernel (numeric).
  *
  * Other than XEN_ELFNOTE_FEATURES on pre-4.2 Xen, this note allows a
@@ -153,6 +192,11 @@
  */
 #define XEN_ELFNOTE_SUPPORTED_FEATURES 17
 
+/*
+ * The number of the highest elfnote defined.
+ */
+#define XEN_ELFNOTE_MAX XEN_ELFNOTE_SUPPORTED_FEATURES
+
 #endif /* __XEN_PUBLIC_ELFNOTE_H__ */
 
 /*
diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index de08213..f68719f 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -3,6 +3,24 @@
  *
  * Guest OS interface to Xen.
  *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to
+ * deal in the Software without restriction, including without limitation the
+ * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
+ * sell copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
  * Copyright (c) 2004, K A Fraser
  */
 
@@ -73,13 +91,23 @@
  * VIRTUAL INTERRUPTS
  *
  * Virtual interrupts that a guest OS may receive from Xen.
+ * In the side comments, 'V.' denotes a per-VCPU VIRQ while 'G.' denotes a
+ * global VIRQ. The former can be bound once per VCPU and cannot be re-bound.
+ * The latter can be allocated only once per guest: they must initially be
+ * allocated to VCPU0 but can subsequently be re-bound.
  */
-#define VIRQ_TIMER      0  /* Timebase update, and/or requested timeout.  */
-#define VIRQ_DEBUG      1  /* Request guest to dump debug info.           */
-#define VIRQ_CONSOLE    2  /* (DOM0) Bytes received on emergency console. */
-#define VIRQ_DOM_EXC    3  /* (DOM0) Exceptional event for some domain.   */
-#define VIRQ_DEBUGGER   6  /* (DOM0) A domain has paused for debugging.   */
-#define VIRQ_PCPU_STATE 9  /* (DOM0) PCPU state changed                   */
+#define VIRQ_TIMER      0  /* V. Timebase update, and/or requested timeout.  */
+#define VIRQ_DEBUG      1  /* V. Request guest to dump debug info.           */
+#define VIRQ_CONSOLE    2  /* G. (DOM0) Bytes received on emergency console. */
+#define VIRQ_DOM_EXC    3  /* G. (DOM0) Exceptional event for some domain.   */
+#define VIRQ_TBUF       4  /* G. (DOM0) Trace buffer has records available.  */
+#define VIRQ_DEBUGGER   6  /* G. (DOM0) A domain has paused for debugging.   */
+#define VIRQ_XENOPROF   7  /* V. XenOprofile interrupt: new sample available */
+#define VIRQ_CON_RING   8  /* G. (DOM0) Bytes received on console            */
+#define VIRQ_PCPU_STATE 9  /* G. (DOM0) PCPU state changed                   */
+#define VIRQ_MEM_EVENT  10 /* G. (DOM0) A memory event has occured           */
+#define VIRQ_XC_RESERVED 11 /* G. Reserved for XenClient                     */
+#define VIRQ_ENOMEM     12 /* G. (DOM0) Low on heap memory       */
 
 /* Architecture-specific VIRQ definitions. */
 #define VIRQ_ARCH_0    16
@@ -92,24 +120,68 @@
 #define VIRQ_ARCH_7    23
 
 #define NR_VIRQS       24
+
 /*
- * MMU-UPDATE REQUESTS
- *
- * HYPERVISOR_mmu_update() accepts a list of (ptr, val) pairs.
- * A foreigndom (FD) can be specified (or DOMID_SELF for none).
- * Where the FD has some effect, it is described below.
- * ptr[1:0] specifies the appropriate MMU_* command.
+ * enum neg_errnoval HYPERVISOR_mmu_update(const struct mmu_update reqs[],
+ *                                         unsigned count, unsigned *done_out,
+ *                                         unsigned foreigndom)
+ * @reqs is an array of mmu_update_t structures ((ptr, val) pairs).
+ * @count is the length of the above array.
+ * @pdone is an output parameter indicating number of completed operations
+ * @foreigndom[15:0]: FD, the expected owner of data pages referenced in this
+ *                    hypercall invocation. Can be DOMID_SELF.
+ * @foreigndom[31:16]: PFD, the expected owner of pagetable pages referenced
+ *                     in this hypercall invocation. The value of this field
+ *                     (x) encodes the PFD as follows:
+ *                     x == 0 => PFD == DOMID_SELF
+ *                     x != 0 => PFD == x - 1
  *
+ * Sub-commands: ptr[1:0] specifies the appropriate MMU_* command.
+ * -------------
  * ptr[1:0] == MMU_NORMAL_PT_UPDATE:
- * Updates an entry in a page table. If updating an L1 table, and the new
- * table entry is valid/present, the mapped frame must belong to the FD, if
- * an FD has been specified. If attempting to map an I/O page then the
- * caller assumes the privilege of the FD.
+ * Updates an entry in a page table belonging to PFD. If updating an L1 table,
+ * and the new table entry is valid/present, the mapped frame must belong to
+ * FD. If attempting to map an I/O page then the caller assumes the privilege
+ * of the FD.
  * FD == DOMID_IO: Permit /only/ I/O mappings, at the priv level of the caller.
  * FD == DOMID_XEN: Map restricted areas of Xen's heap space.
  * ptr[:2]  -- Machine address of the page-table entry to modify.
  * val      -- Value to write.
  *
+ * There also certain implicit requirements when using this hypercall. The
+ * pages that make up a pagetable must be mapped read-only in the guest.
+ * This prevents uncontrolled guest updates to the pagetable. Xen strictly
+ * enforces this, and will disallow any pagetable update which will end up
+ * mapping pagetable page RW, and will disallow using any writable page as a
+ * pagetable. In practice it means that when constructing a page table for a
+ * process, thread, etc, we MUST be very dilligient in following these rules:
+ *  1). Start with top-level page (PGD or in Xen language: L4). Fill out
+ *      the entries.
+ *  2). Keep on going, filling out the upper (PUD or L3), and middle (PMD
+ *      or L2).
+ *  3). Start filling out the PTE table (L1) with the PTE entries. Once
+ *      done, make sure to set each of those entries to RO (so writeable bit
+ *      is unset). Once that has been completed, set the PMD (L2) for this
+ *      PTE table as RO.
+ *  4). When completed with all of the PMD (L2) entries, and all of them have
+ *      been set to RO, make sure to set RO the PUD (L3). Do the same
+ *      operation on PGD (L4) pagetable entries that have a PUD (L3) entry.
+ *  5). Now before you can use those pages (so setting the cr3), you MUST also
+ *      pin them so that the hypervisor can verify the entries. This is done
+ *      via the HYPERVISOR_mmuext_op(MMUEXT_PIN_L4_TABLE, guest physical frame
+ *      number of the PGD (L4)). And this point the HYPERVISOR_mmuext_op(
+ *      MMUEXT_NEW_BASEPTR, guest physical frame number of the PGD (L4)) can be
+ *      issued.
+ * For 32-bit guests, the L4 is not used (as there is less pagetables), so
+ * instead use L3.
+ * At this point the pagetables can be modified using the MMU_NORMAL_PT_UPDATE
+ * hypercall. Also if so desired the OS can also try to write to the PTE
+ * and be trapped by the hypervisor (as the PTE entry is RO).
+ *
+ * To deallocate the pages, the operations are the reverse of the steps
+ * mentioned above. The argument is MMUEXT_UNPIN_TABLE for all levels and the
+ * pagetable MUST not be in use (meaning that the cr3 is not set to it).
+ *
  * ptr[1:0] == MMU_MACHPHYS_UPDATE:
  * Updates an entry in the machine->pseudo-physical mapping table.
  * ptr[:2]  -- Machine address within the frame whose mapping to modify.
@@ -119,6 +191,72 @@
  * ptr[1:0] == MMU_PT_UPDATE_PRESERVE_AD:
  * As MMU_NORMAL_PT_UPDATE above, but A/D bits currently in the PTE are ORed
  * with those in @val.
+ *
+ * @val is usually the machine frame number along with some attributes.
+ * The attributes by default follow the architecture defined bits. Meaning that
+ * if this is a X86_64 machine and four page table layout is used, the layout
+ * of val is:
+ *  - 63 if set means No execute (NX)
+ *  - 46-13 the machine frame number
+ *  - 12 available for guest
+ *  - 11 available for guest
+ *  - 10 available for guest
+ *  - 9 available for guest
+ *  - 8 global
+ *  - 7 PAT (PSE is disabled, must use hypercall to make 4MB or 2MB pages)
+ *  - 6 dirty
+ *  - 5 accessed
+ *  - 4 page cached disabled
+ *  - 3 page write through
+ *  - 2 userspace accessible
+ *  - 1 writeable
+ *  - 0 present
+ *
+ *  The one bits that does not fit with the default layout is the PAGE_PSE
+ *  also called PAGE_PAT). The MMUEXT_[UN]MARK_SUPER arguments to the
+ *  HYPERVISOR_mmuext_op serve as mechanism to set a pagetable to be 4MB
+ *  (or 2MB) instead of using the PAGE_PSE bit.
+ *
+ *  The reason that the PAGE_PSE (bit 7) is not being utilized is due to Xen
+ *  using it as the Page Attribute Table (PAT) bit - for details on it please
+ *  refer to Intel SDM 10.12. The PAT allows to set the caching attributes of
+ *  pages instead of using MTRRs.
+ *
+ *  The PAT MSR is as follows (it is a 64-bit value, each entry is 8 bits):
+ *                    PAT4                 PAT0
+ *  +-----+-----+----+----+----+-----+----+----+
+ *  | UC  | UC- | WC | WB | UC | UC- | WC | WB |  <= Linux
+ *  +-----+-----+----+----+----+-----+----+----+
+ *  | UC  | UC- | WT | WB | UC | UC- | WT | WB |  <= BIOS (default when machine boots)
+ *  +-----+-----+----+----+----+-----+----+----+
+ *  | rsv | rsv | WP | WC | UC | UC- | WT | WB |  <= Xen
+ *  +-----+-----+----+----+----+-----+----+----+
+ *
+ *  The lookup of this index table translates to looking up
+ *  Bit 7, Bit 4, and Bit 3 of val entry:
+ *
+ *  PAT/PSE (bit 7) ... PCD (bit 4) .. PWT (bit 3).
+ *
+ *  If all bits are off, then we are using PAT0. If bit 3 turned on,
+ *  then we are using PAT1, if bit 3 and bit 4, then PAT2..
+ *
+ *  As you can see, the Linux PAT1 translates to PAT4 under Xen. Which means
+ *  that if a guest that follows Linux's PAT setup and would like to set Write
+ *  Combined on pages it MUST use PAT4 entry. Meaning that Bit 7 (PAGE_PAT) is
+ *  set. For example, under Linux it only uses PAT0, PAT1, and PAT2 for the
+ *  caching as:
+ *
+ *   WB = none (so PAT0)
+ *   WC = PWT (bit 3 on)
+ *   UC = PWT | PCD (bit 3 and 4 are on).
+ *
+ * To make it work with Xen, it needs to translate the WC bit as so:
+ *
+ *  PWT (so bit 3 on) --> PAT (so bit 7 is on) and clear bit 3
+ *
+ * And to translate back it would:
+ *
+ * PAT (bit 7 on) --> PWT (bit 3 on) and clear bit 7.
  */
 #define MMU_NORMAL_PT_UPDATE      0 /* checked '*ptr = val'. ptr is MA.       */
 #define MMU_MACHPHYS_UPDATE       1 /* ptr = MA of frame to modify entry for  */
@@ -127,7 +265,12 @@
 /*
  * MMU EXTENDED OPERATIONS
  *
- * HYPERVISOR_mmuext_op() accepts a list of mmuext_op structures.
+ * enum neg_errnoval HYPERVISOR_mmuext_op(mmuext_op_t uops[],
+ *                                        unsigned int count,
+ *                                        unsigned int *pdone,
+ *                                        unsigned int foreigndom)
+ */
+/* HYPERVISOR_mmuext_op() accepts a list of mmuext_op structures.
  * A foreigndom (FD) can be specified (or DOMID_SELF for none).
  * Where the FD has some effect, it is described below.
  *
@@ -164,9 +307,23 @@
  * cmd: MMUEXT_FLUSH_CACHE
  * No additional arguments. Writes back and flushes cache contents.
  *
+ * cmd: MMUEXT_FLUSH_CACHE_GLOBAL
+ * No additional arguments. Writes back and flushes cache contents
+ * on all CPUs in the system.
+ *
  * cmd: MMUEXT_SET_LDT
  * linear_addr: Linear address of LDT base (NB. must be page-aligned).
  * nr_ents: Number of entries in LDT.
+ *
+ * cmd: MMUEXT_CLEAR_PAGE
+ * mfn: Machine frame number to be cleared.
+ *
+ * cmd: MMUEXT_COPY_PAGE
+ * mfn: Machine frame number of the destination page.
+ * src_mfn: Machine frame number of the source page.
+ *
+ * cmd: MMUEXT_[UN]MARK_SUPER
+ * mfn: Machine frame number of head of superpage to be [un]marked.
  */
 #define MMUEXT_PIN_L1_TABLE      0
 #define MMUEXT_PIN_L2_TABLE      1
@@ -183,12 +340,18 @@
 #define MMUEXT_FLUSH_CACHE      12
 #define MMUEXT_SET_LDT          13
 #define MMUEXT_NEW_USER_BASEPTR 15
+#define MMUEXT_CLEAR_PAGE       16
+#define MMUEXT_COPY_PAGE        17
+#define MMUEXT_FLUSH_CACHE_GLOBAL 18
+#define MMUEXT_MARK_SUPER       19
+#define MMUEXT_UNMARK_SUPER     20
 
 #ifndef __ASSEMBLY__
 struct mmuext_op {
 	unsigned int cmd;
 	union {
-		/* [UN]PIN_TABLE, NEW_BASEPTR, NEW_USER_BASEPTR */
+		/* [UN]PIN_TABLE, NEW_BASEPTR, NEW_USER_BASEPTR
+		 * CLEAR_PAGE, COPY_PAGE, [UN]MARK_SUPER */
 		xen_pfn_t mfn;
 		/* INVLPG_LOCAL, INVLPG_ALL, SET_LDT */
 		unsigned long linear_addr;
@@ -198,6 +361,8 @@ struct mmuext_op {
 		unsigned int nr_ents;
 		/* TLB_FLUSH_MULTI, INVLPG_MULTI */
 		void *vcpumask;
+		/* COPY_PAGE */
+		xen_pfn_t src_mfn;
 	} arg2;
 };
 DEFINE_GUEST_HANDLE_STRUCT(mmuext_op);
@@ -225,10 +390,23 @@ DEFINE_GUEST_HANDLE_STRUCT(mmuext_op);
  */
 #define VMASST_CMD_enable                0
 #define VMASST_CMD_disable               1
+
+/* x86/32 guests: simulate full 4GB segment limits. */
 #define VMASST_TYPE_4gb_segments         0
+
+/* x86/32 guests: trap (vector 15) whenever above vmassist is used. */
 #define VMASST_TYPE_4gb_segments_notify  1
+
+/*
+ * x86 guests: support writes to bottom-level PTEs.
+ * NB1. Page-directory entries cannot be written.
+ * NB2. Guest must continue to remove all writable mappings of PTEs.
+ */
 #define VMASST_TYPE_writable_pagetables  2
+
+/* x86/PAE guests: support PDPTs above 4GB. */
 #define VMASST_TYPE_pae_extended_cr3     3
+
 #define MAX_VMASST_TYPE 3
 
 #ifndef __ASSEMBLY__
@@ -260,6 +438,15 @@ typedef uint16_t domid_t;
  */
 #define DOMID_XEN  (0x7FF2U)
 
+/* DOMID_COW is used as the owner of sharable pages */
+#define DOMID_COW  (0x7FF3U)
+
+/* DOMID_INVALID is used to identify pages with unknown owner. */
+#define DOMID_INVALID (0x7FF4U)
+
+/* Idle domain. */
+#define DOMID_IDLE (0x7FFFU)
+
 /*
  * Send an array of these to HYPERVISOR_mmu_update().
  * NB. The fields are natural pointer/address size for this architecture.
@@ -272,7 +459,9 @@ DEFINE_GUEST_HANDLE_STRUCT(mmu_update);
 
 /*
  * Send an array of these to HYPERVISOR_multicall().
- * NB. The fields are natural register size for this architecture.
+ * NB. The fields are logically the natural register size for this
+ * architecture. In cases where xen_ulong_t is larger than this then
+ * any unused bits in the upper portion must be zero.
  */
 struct multicall_entry {
     xen_ulong_t op;
@@ -442,8 +631,48 @@ struct start_info {
 	unsigned long mod_start;    /* VIRTUAL address of pre-loaded module.  */
 	unsigned long mod_len;      /* Size (bytes) of pre-loaded module.     */
 	int8_t cmd_line[MAX_GUEST_CMDLINE];
+	/* The pfn range here covers both page table and p->m table frames.   */
+	unsigned long first_p2m_pfn;/* 1st pfn forming initial P->M table.    */
+	unsigned long nr_p2m_frames;/* # of pfns forming initial P->M table.  */
 };
 
+/* These flags are passed in the 'flags' field of start_info_t. */
+#define SIF_PRIVILEGED    (1<<0)  /* Is the domain privileged? */
+#define SIF_INITDOMAIN    (1<<1)  /* Is this the initial control domain? */
+#define SIF_MULTIBOOT_MOD (1<<2)  /* Is mod_start a multiboot module? */
+#define SIF_MOD_START_PFN (1<<3)  /* Is mod_start a PFN? */
+#define SIF_PM_MASK       (0xFF<<8) /* reserve 1 byte for xen-pm options */
+
+/*
+ * A multiboot module is a package containing modules very similar to a
+ * multiboot module array. The only differences are:
+ * - the array of module descriptors is by convention simply at the beginning
+ *   of the multiboot module,
+ * - addresses in the module descriptors are based on the beginning of the
+ *   multiboot module,
+ * - the number of modules is determined by a termination descriptor that has
+ *   mod_start == 0.
+ *
+ * This permits to both build it statically and reference it in a configuration
+ * file, and let the PV guest easily rebase the addresses to virtual addresses
+ * and at the same time count the number of modules.
+ */
+struct xen_multiboot_mod_list {
+	/* Address of first byte of the module */
+	uint32_t mod_start;
+	/* Address of last byte of the module (inclusive) */
+	uint32_t mod_end;
+	/* Address of zero-terminated command line */
+	uint32_t cmdline;
+	/* Unused, must be zero */
+	uint32_t pad;
+};
+/*
+ * The console structure in start_info.console.dom0
+ *
+ * This structure includes a variety of information required to
+ * have a working VGA/VESA console.
+ */
 struct dom0_vga_console_info {
 	uint8_t video_type;
 #define XEN_VGATYPE_TEXT_MODE_3 0x03
@@ -484,11 +713,6 @@ struct dom0_vga_console_info {
 	} u;
 };
 
-/* These flags are passed in the 'flags' field of start_info_t. */
-#define SIF_PRIVILEGED    (1<<0)  /* Is the domain privileged? */
-#define SIF_INITDOMAIN    (1<<1)  /* Is this the initial control domain? */
-#define SIF_PM_MASK       (0xFF<<8) /* reserve 1 byte for xen-pm options */
-
 typedef uint64_t cpumap_t;
 
 typedef uint8_t xen_domain_handle_t[16];
-- 
1.8.4.5

