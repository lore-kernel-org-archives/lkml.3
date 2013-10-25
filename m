Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab3JYKxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:53:53 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:26713 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab3JYKxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:53:08 -0400
X-IronPort-AV: E=Sophos;i="4.93,569,1378857600"; 
   d="scan'208";a="64684015"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v9 03/18] arm/xen,arm64/xen: introduce p2m
Date: Fri, 25 Oct 2013 11:51:38 +0100
Message-ID: <1382698313-13161-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310251144020.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce physical to machine and machine to physical tracking
mechanisms based on rbtrees for arm/xen and arm64/xen.

We need it because any guests on ARM are an autotranslate guests,
therefore a physical address is potentially different from a machine
address. When programming a device to do DMA, we need to be
extra-careful to use machine addresses rather than physical addresses to
program the device. Therefore we need to know the physical to machine
mappings.

For the moment we assume that dom0 starts with a 1:1 physical to machine
mapping, in other words physical addresses correspond to machine
addresses. However when mapping a foreign grant reference, obviously the
1:1 model doesn't work anymore. So at the very least we need to be able
to track grant mappings.

We need locking to protect accesses to the two trees.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Changes in v8:
- move pfn_to_mfn and mfn_to_pfn to page.h as static inline functions;
- no need to walk the tree if phys_to_mach.rb_node is NULL;
- correctly handle multipage p2m entries;
- substitute the spin_lock with a rwlock.
---
 arch/arm/include/asm/xen/page.h |   49 ++++++++--
 arch/arm/xen/Makefile           |    2 +-
 arch/arm/xen/p2m.c              |  208 +++++++++++++++++++++++++++++++++++++++
 arch/arm64/xen/Makefile         |    2 +-
 4 files changed, 252 insertions(+), 9 deletions(-)
 create mode 100644 arch/arm/xen/p2m.c

diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
index 359a7b5..d1b5dd5 100644
--- a/arch/arm/include/asm/xen/page.h
+++ b/arch/arm/include/asm/xen/page.h
@@ -7,11 +7,10 @@
 #include <linux/pfn.h>
 #include <linux/types.h>
 
+#include <xen/xen.h>
 #include <xen/interface/grant_table.h>
 
-#define pfn_to_mfn(pfn)			(pfn)
 #define phys_to_machine_mapping_valid(pfn) (1)
-#define mfn_to_pfn(mfn)			(mfn)
 #define mfn_to_virt(m)			(__va(mfn_to_pfn(m) << PAGE_SHIFT))
 
 #define pte_mfn	    pte_pfn
@@ -32,6 +31,44 @@ typedef struct xpaddr {
 
 #define INVALID_P2M_ENTRY      (~0UL)
 
+unsigned long __pfn_to_mfn(unsigned long pfn);
+unsigned long __mfn_to_pfn(unsigned long mfn);
+extern struct rb_root phys_to_mach;
+
+static inline unsigned long pfn_to_mfn(unsigned long pfn)
+{
+	unsigned long mfn;
+	
+	if (phys_to_mach.rb_node != NULL) {
+		mfn = __pfn_to_mfn(pfn);
+		if (mfn != INVALID_P2M_ENTRY)
+			return mfn;
+	}
+
+	if (xen_initial_domain())
+		return pfn;
+	else
+		return INVALID_P2M_ENTRY;
+}
+
+static inline unsigned long mfn_to_pfn(unsigned long mfn)
+{
+	unsigned long pfn;
+
+	if (phys_to_mach.rb_node != NULL) {
+		pfn = __mfn_to_pfn(mfn);
+		if (pfn != INVALID_P2M_ENTRY)
+			return pfn;
+	}
+
+	if (xen_initial_domain())
+		return mfn;
+	else
+		return INVALID_P2M_ENTRY;
+}
+
+#define mfn_to_local_pfn(mfn) mfn_to_pfn(mfn)
+
 static inline xmaddr_t phys_to_machine(xpaddr_t phys)
 {
 	unsigned offset = phys.paddr & ~PAGE_MASK;
@@ -76,11 +113,9 @@ static inline int m2p_remove_override(struct page *page, bool clear_pte)
 	return 0;
 }
 
-static inline bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
-{
-	BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
-	return true;
-}
+bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn);
+bool __set_phys_to_machine_multi(unsigned long pfn, unsigned long mfn,
+		unsigned long nr_pages);
 
 static inline bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 {
diff --git a/arch/arm/xen/Makefile b/arch/arm/xen/Makefile
index 4384103..21e6ff5 100644
--- a/arch/arm/xen/Makefile
+++ b/arch/arm/xen/Makefile
@@ -1 +1 @@
-obj-y		:= enlighten.o hypercall.o grant-table.o
+obj-y		:= enlighten.o hypercall.o grant-table.o p2m.o
diff --git a/arch/arm/xen/p2m.c b/arch/arm/xen/p2m.c
new file mode 100644
index 0000000..5df4a9a
--- /dev/null
+++ b/arch/arm/xen/p2m.c
@@ -0,0 +1,208 @@
+#include <linux/bootmem.h>
+#include <linux/gfp.h>
+#include <linux/export.h>
+#include <linux/rwlock.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/dma-mapping.h>
+#include <linux/vmalloc.h>
+#include <linux/swiotlb.h>
+
+#include <xen/xen.h>
+#include <xen/interface/memory.h>
+#include <xen/swiotlb-xen.h>
+
+#include <asm/cacheflush.h>
+#include <asm/xen/page.h>
+#include <asm/xen/hypercall.h>
+#include <asm/xen/interface.h>
+
+struct xen_p2m_entry {
+	unsigned long pfn;
+	unsigned long mfn;
+	unsigned long nr_pages;
+	struct rb_node rbnode_mach;
+	struct rb_node rbnode_phys;
+};
+
+rwlock_t p2m_lock;
+struct rb_root phys_to_mach = RB_ROOT;
+static struct rb_root mach_to_phys = RB_ROOT;
+
+static int xen_add_phys_to_mach_entry(struct xen_p2m_entry *new)
+{
+	struct rb_node **link = &phys_to_mach.rb_node;
+	struct rb_node *parent = NULL;
+	struct xen_p2m_entry *entry;
+	int rc = 0;
+
+	while (*link) {
+		parent = *link;
+		entry = rb_entry(parent, struct xen_p2m_entry, rbnode_phys);
+
+		if (new->mfn == entry->mfn)
+			goto err_out;
+		if (new->pfn == entry->pfn)
+			goto err_out;
+
+		if (new->pfn < entry->pfn)
+			link = &(*link)->rb_left;
+		else
+			link = &(*link)->rb_right;
+	}
+	rb_link_node(&new->rbnode_phys, parent, link);
+	rb_insert_color(&new->rbnode_phys, &phys_to_mach);
+	goto out;
+
+err_out:
+	rc = -EINVAL;
+	pr_warn("%s: cannot add pfn=%pa -> mfn=%pa: pfn=%pa -> mfn=%pa already exists\n",
+			__func__, &new->pfn, &new->mfn, &entry->pfn, &entry->mfn);
+out:
+	return rc;
+}
+
+unsigned long __pfn_to_mfn(unsigned long pfn)
+{
+	struct rb_node *n = phys_to_mach.rb_node;
+	struct xen_p2m_entry *entry;
+	unsigned long irqflags;
+
+	read_lock_irqsave(&p2m_lock, irqflags);
+	while (n) {
+		entry = rb_entry(n, struct xen_p2m_entry, rbnode_phys);
+		if (entry->pfn <= pfn &&
+				entry->pfn + entry->nr_pages > pfn) {
+			read_unlock_irqrestore(&p2m_lock, irqflags);
+			return entry->mfn + (pfn - entry->pfn);
+		}
+		if (pfn < entry->pfn)
+			n = n->rb_left;
+		else
+			n = n->rb_right;
+	}
+	read_unlock_irqrestore(&p2m_lock, irqflags);
+
+	return INVALID_P2M_ENTRY;
+}
+EXPORT_SYMBOL_GPL(__pfn_to_mfn);
+
+static int xen_add_mach_to_phys_entry(struct xen_p2m_entry *new)
+{
+	struct rb_node **link = &mach_to_phys.rb_node;
+	struct rb_node *parent = NULL;
+	struct xen_p2m_entry *entry;
+	int rc = 0;
+
+	while (*link) {
+		parent = *link;
+		entry = rb_entry(parent, struct xen_p2m_entry, rbnode_mach);
+
+		if (new->mfn == entry->mfn)
+			goto err_out;
+		if (new->pfn == entry->pfn)
+			goto err_out;
+
+		if (new->mfn < entry->mfn)
+			link = &(*link)->rb_left;
+		else
+			link = &(*link)->rb_right;
+	}
+	rb_link_node(&new->rbnode_mach, parent, link);
+	rb_insert_color(&new->rbnode_mach, &mach_to_phys);
+	goto out;
+
+err_out:
+	rc = -EINVAL;
+	pr_warn("%s: cannot add pfn=%pa -> mfn=%pa: pfn=%pa -> mfn=%pa already exists\n",
+			__func__, &new->pfn, &new->mfn, &entry->pfn, &entry->mfn);
+out:
+	return rc;
+}
+
+unsigned long __mfn_to_pfn(unsigned long mfn)
+{
+	struct rb_node *n = mach_to_phys.rb_node;
+	struct xen_p2m_entry *entry;
+	unsigned long irqflags;
+
+	read_lock_irqsave(&p2m_lock, irqflags);
+	while (n) {
+		entry = rb_entry(n, struct xen_p2m_entry, rbnode_mach);
+		if (entry->mfn <= mfn &&
+				entry->mfn + entry->nr_pages > mfn) {
+			read_unlock_irqrestore(&p2m_lock, irqflags);
+			return entry->pfn + (mfn - entry->mfn);
+		}
+		if (mfn < entry->mfn)
+			n = n->rb_left;
+		else
+			n = n->rb_right;
+	}
+	read_unlock_irqrestore(&p2m_lock, irqflags);
+
+	return INVALID_P2M_ENTRY;
+}
+EXPORT_SYMBOL_GPL(__mfn_to_pfn);
+
+bool __set_phys_to_machine_multi(unsigned long pfn,
+		unsigned long mfn, unsigned long nr_pages)
+{
+	int rc;
+	unsigned long irqflags;
+	struct xen_p2m_entry *p2m_entry;
+	struct rb_node *n = phys_to_mach.rb_node;
+
+	if (mfn == INVALID_P2M_ENTRY) {
+		write_lock_irqsave(&p2m_lock, irqflags);
+		while (n) {
+			p2m_entry = rb_entry(n, struct xen_p2m_entry, rbnode_phys);
+			if (p2m_entry->pfn <= pfn &&
+					p2m_entry->pfn + p2m_entry->nr_pages > pfn) {
+				rb_erase(&p2m_entry->rbnode_mach, &mach_to_phys);
+				rb_erase(&p2m_entry->rbnode_phys, &phys_to_mach);
+				write_unlock_irqrestore(&p2m_lock, irqflags);
+				kfree(p2m_entry);	
+				return true;
+			}
+			if (pfn < p2m_entry->pfn)
+				n = n->rb_left;
+			else
+				n = n->rb_right;
+		}
+		write_unlock_irqrestore(&p2m_lock, irqflags);
+		return true;
+	}
+
+	p2m_entry = kzalloc(sizeof(struct xen_p2m_entry), GFP_NOWAIT);
+	if (!p2m_entry) {
+		pr_warn("cannot allocate xen_p2m_entry\n");
+		return false;
+	}
+	p2m_entry->pfn = pfn;
+	p2m_entry->nr_pages = nr_pages;
+	p2m_entry->mfn = mfn;
+
+	write_lock_irqsave(&p2m_lock, irqflags);
+	if ((rc = xen_add_phys_to_mach_entry(p2m_entry) < 0) ||
+		(rc = xen_add_mach_to_phys_entry(p2m_entry) < 0)) {
+		write_unlock_irqrestore(&p2m_lock, irqflags);
+		return false;
+	}
+	write_unlock_irqrestore(&p2m_lock, irqflags);
+	return true;
+}
+EXPORT_SYMBOL_GPL(__set_phys_to_machine_multi);
+
+bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
+{
+	return __set_phys_to_machine_multi(pfn, mfn, 1);
+}
+EXPORT_SYMBOL_GPL(__set_phys_to_machine);
+
+int p2m_init(void)
+{
+	rwlock_init(&p2m_lock);
+	return 0;
+}
+arch_initcall(p2m_init);
diff --git a/arch/arm64/xen/Makefile b/arch/arm64/xen/Makefile
index be24040..cd866b0 100644
--- a/arch/arm64/xen/Makefile
+++ b/arch/arm64/xen/Makefile
@@ -1,2 +1,2 @@
-xen-arm-y	+= $(addprefix ../../arm/xen/, enlighten.o grant-table.o)
+xen-arm-y	+= $(addprefix ../../arm/xen/, enlighten.o grant-table.o p2m.o)
 obj-y		:= xen-arm.o hypercall.o
-- 
1.7.2.5

