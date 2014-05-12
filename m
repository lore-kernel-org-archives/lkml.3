Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbaELDGS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 23:06:18 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:13075
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751197AbaELDGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 23:06:15 -0400
From: Richard Lee <superlibj8301@gmail.com>
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
CC: Richard Lee <superlibj8301@gmail.com>, Richard Lee <superlibj@gmail.com>
Subject: [RFC][PATCH 1/2] mm/vmalloc: Add IO mapping space reused interface.
Date: Mon, 12 May 2014 10:19:54 +0800
Message-ID: <1399861195-21087-2-git-send-email-superlibj8301@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1399861195-21087-1-git-send-email-superlibj8301@gmail.com>
References: <1399861195-21087-1-git-send-email-superlibj8301@gmail.com>
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130443375729325423;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(189002)(199002)(21056001)(77156001)(44976005)(81156002)(87936001)(19580395003)(88136002)(62966002)(19580405001)(2201001)(48376002)(50466002)(68736004)(74502001)(69596002)(73972005)(93916002)(92566001)(86362001)(92726001)(83072002)(82202001)(97736001)(85852003)(46102001)(31966008)(77096999)(36756003)(76176999)(4396001)(50226001)(55446002)(77982001)(61266001)(20776003)(47776003)(64706001)(79102001)(87286001)(87572001)(99396002)(80022001)(33646001)(74662001)(50986999)(81442001)(81542001)(84676001)(2009001)(81342001)(6806004)(57042002)(46252002)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB410;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0209425D0A
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
 smtp.mailfrom=superlibj8301@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the IO mapping, for the same physical address space maybe
mapped more than one time, for example, in some SoCs:
0x20000000 ~ 0x20001000: are global control IO physical map,
and this range space will be used by many drivers.
And then if each driver will do the same ioremap operation, we
will waste to much malloc virtual spaces.

This patch add the IO mapping space reusing interface:
- find_vm_area_paddr: used to find the exsit vmalloc area using
  the IO physical address.
- vm_area_is_aready_to_free: before vfree the IO mapped areas
  using this to do the check that if this area is used by more
  than one consumer.

Signed-off-by: Richard Lee <superlibj@gmail.com>
---
 include/linux/vmalloc.h |  5 ++++
 mm/vmalloc.c            | 63 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 4b8a891..2b811f6 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -34,6 +34,7 @@ struct vm_struct {
 	struct page		**pages;
 	unsigned int		nr_pages;
 	phys_addr_t		phys_addr;
+	unsigned int		used;
 	const void		*caller;
 };
 
@@ -100,6 +101,10 @@ static inline size_t get_vm_area_size(const struct vm_struct *area)
 	return area->size - PAGE_SIZE;
 }
 
+extern int vm_area_is_aready_to_free(phys_addr_t addr);
+struct vm_struct *find_vm_area_paddr(phys_addr_t paddr, size_t size,
+				     unsigned long *offset,
+				     unsigned long flags);
 extern struct vm_struct *get_vm_area(unsigned long size, unsigned long flags);
 extern struct vm_struct *get_vm_area_caller(unsigned long size,
 					unsigned long flags, const void *caller);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bf233b2..f75b7b3 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1293,6 +1293,7 @@ static void setup_vmalloc_vm(struct vm_struct *vm, struct vmap_area *va,
 	vm->addr = (void *)va->va_start;
 	vm->size = va->va_end - va->va_start;
 	vm->caller = caller;
+	vm->used = 1;
 	va->vm = vm;
 	va->flags |= VM_VM_AREA;
 	spin_unlock(&vmap_area_lock);
@@ -1383,6 +1384,68 @@ struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
 				  NUMA_NO_NODE, GFP_KERNEL, caller);
 }
 
+int vm_area_is_aready_to_free(phys_addr_t addr)
+{
+	struct vmap_area *va;
+
+	va = find_vmap_area((unsigned long)addr);
+	if (!va || !(va->flags & VM_VM_AREA) || !va->vm)
+		return 1;
+
+	if (va->vm->used <= 1)
+		return 1;
+
+	--va->vm->used;
+
+	return 0;
+}
+
+/**
+ *	find_vm_area_paddr  -  find a continuous kernel virtual area using the
+ *			physical addreess.
+ *	@paddr:		base physical address
+ *	@size:		size of the physical area range
+ *	@offset:	the start offset of the vm area
+ *	@flags:		%VM_IOREMAP for I/O mappings
+ *
+ *	Search for the kernel VM area, whoes physical address starting at @paddr,
+ *	and if the exsit VM area's size is large enough, then just return it, or
+ *	return NULL.
+ */
+struct vm_struct *find_vm_area_paddr(phys_addr_t paddr, size_t size,
+				     unsigned long *offset,
+				     unsigned long flags)
+{
+	struct vmap_area *va;
+
+	if (!(flags & VM_IOREMAP))
+		return NULL;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(va, &vmap_area_list, list) {
+		phys_addr_t phys_addr;
+
+		if (!va || !(va->flags & VM_VM_AREA) || !va->vm)
+			continue;
+
+		phys_addr = va->vm->phys_addr;
+
+		if (paddr < phys_addr || paddr + size > phys_addr + va->vm->size)
+			continue;
+
+		*offset = paddr - phys_addr;
+
+		if (va->vm->flags & VM_IOREMAP && va->vm->size >= size) {
+			va->vm->used++;
+			rcu_read_unlock();
+			return va->vm;
+		}
+	}
+	rcu_read_unlock();
+
+	return NULL;
+}
+
 /**
  *	find_vm_area  -  find a continuous kernel virtual area
  *	@addr:		base address
-- 
1.8.4

