Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab3LCTmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 14:42:52 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:38353 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab3LCTmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 14:42:45 -0500
From: Bill Sumner <bill.sumner@hp.com>
To: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com
Cc: iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, bill.sumner@hp.com,
        doug.hatch@hp.com
Subject: [PATCH 2/6] Crashdump-Accepting-Active-IOMMU-Utility-functions
Date: Tue,  3 Dec 2013 12:41:30 -0700
Message-Id: <1386099694-4190-3-git-send-email-bill.sumner@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1386099694-4190-1-git-send-email-bill.sumner@hp.com>
References: <Crashdump-Accepting-Active-IOMMU>
 <1386099694-4190-1-git-send-email-bill.sumner@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bill Sumner <bill.sumner@hp.com>
---
 drivers/iommu/intel-iommu.c | 74 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index a0e8a76..b68b962 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4453,3 +4453,77 @@ static void __init check_tylersburg_isoch(void)
 	printk(KERN_WARNING "DMAR: Recommended TLB entries for ISOCH unit is 16; your BIOS set %d\n",
 	       vtisochctrl);
 }
+#ifdef CONFIG_CRASH_DUMP
+
+/* ========================================================================
+ * Utility functions for accessing the iommu Translation Tables
+ * ------------------------------------------------------------------------
+ */
+static inline struct context_entry *
+get_context_phys_from_root(struct root_entry *root)
+{
+	return (struct context_entry *)
+		(root_present(root) ? (void *) (root->val & VTD_PAGE_MASK)
+				    : NULL);
+}
+
+static int
+context_get_p(struct context_entry *c)    {return((c->lo >> 0) & 0x1); }
+
+static int
+context_get_fpdi(struct context_entry *c) {return((c->lo >> 1) & 0x1); }
+
+static int
+context_get_t(struct context_entry *c)    {return((c->lo >> 2) & 0x3); }
+
+static u64
+context_get_asr(struct context_entry *c)  {return((c->lo >> 12));      }
+
+static int
+context_get_aw(struct context_entry *c)   {return((c->hi >> 0) & 0x7); }
+
+static int
+context_get_aval(struct context_entry *c) {return((c->hi >> 3) & 0xf); }
+
+static int
+context_get_did(struct context_entry *c)  {return((c->hi >> 8) & 0xffff); }
+
+static void context_put_asr(struct context_entry *c, unsigned long asr)
+{
+	c->lo &= (~VTD_PAGE_MASK);
+	c->lo |= (asr << VTD_PAGE_SHIFT);
+}
+
+
+/*
+ * Copy memory from a physically-addressed area into a virtually-addressed area
+ */
+static int oldcopy(void *to, void *from, int size)
+{
+	size_t ret = 0;			/* Length copied */
+	unsigned long pfn;		/* Page Frame Number */
+	char *buf = to;			/* Adr(Output buffer) */
+	size_t csize = (size_t)size;	/* Num(bytes to copy) */
+	unsigned long offset;		/* Lower 12 bits of from */
+	int userbuf = 0;		/* to is in kernel space */
+
+	if (pr_dbg.enter_oldcopy)
+		pr_debug("ENTER %s to=%16.16llx, from = %16.16llx, size = %d\n",
+			__func__,
+			(unsigned long long) to,
+			(unsigned long long) from, size);
+
+	if (intel_iommu_translation_tables_are_mapped)
+		memcpy(to, phys_to_virt((phys_addr_t)from), csize);
+	else {
+		pfn = ((unsigned long) from) >> VTD_PAGE_SHIFT;
+		offset = ((unsigned long) from) & (~VTD_PAGE_MASK);
+		ret = copy_oldmem_page(pfn, buf, csize, offset, userbuf);
+	}
+
+	if (pr_dbg.leave_oldcopy)
+		pr_debug("LEAVE %s ret=%d\n", __func__, (int) ret);
+
+	return (int) ret;
+}
+#endif /* CONFIG_CRASH_DUMP */
-- 
Bill Sumner <bill.sumner@hp.com>

