Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbaENJHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:07:24 -0400
Received: from mail-bl2on0136.outbound.protection.outlook.com ([65.55.169.136]:4855
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751055AbaENJHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:07:21 -0400
From: Richard Lee <superlibj8301@gmail.com>
To: <linux-mm@kvack.org>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <arnd@arndb.de>,
        <robherring2@gmail.com>
CC: <lauraa@codeaurora.org>, <akpm@linux-foundation.org>,
        <d.hatayama@jp.fujitsu.com>, <zhangyanfei@cn.fujitsu.com>,
        <liwanp@linux.vnet.ibm.com>, <iamjoonsoo.kim@lge.com>,
        <hannes@cmpxchg.org>, <linux-kernel@vger.kernel.org>,
        Richard Lee <superlibj8301@gmail.com>
Subject: [PATCHv2 1/2] mm/vmalloc: Add IO mapping space reused interface support.
Date: Wed, 14 May 2014 16:18:51 +0800
Message-ID: <1400055532-13134-2-git-send-email-superlibj8301@gmail.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1400055532-13134-1-git-send-email-superlibj8301@gmail.com>
References: <1400055532-13134-1-git-send-email-superlibj8301@gmail.com>
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130445320277238280;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(189002)(199002)(36756003)(44976005)(74502001)(19580395003)(19580405001)(81542001)(31966008)(6806004)(102836001)(84676001)(55446002)(87286001)(4396001)(77156001)(81342001)(82202001)(50226001)(81156002)(99396002)(86362001)(46102001)(62966002)(68736004)(2009001)(64706001)(93916002)(69596002)(61266001)(81442001)(77982001)(85852003)(21056001)(92566001)(92726001)(2201001)(89996001)(50466002)(73972005)(48376002)(87792001)(87572001)(87936001)(20776003)(76176999)(79102001)(74662001)(50986999)(97736001)(77096999)(73392001)(83072002)(88136002)(80022001)(33646001)(47776003)(57042002)(46252002)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB481;H:az84smr01.freescale.net;FPR:;MLV:nov;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0211965D06
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
 smtp.mailfrom=superlibj8301@gmail.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the IO mapping, the same physical address space maybe
mapped more than one time, for example, in some SoCs:
  - 0x20001000 ~ 0x20001400 --> 1KB for Dev1
  - 0x20001400 ~ 0x20001800 --> 1KB for Dev2
  and the page size is 4KB.

Then both Dev1 and Dev2 will do ioremap operations, and the IO
vmalloc area's virtual address will be aligned down to 4KB, and
the size will be aligned up to 4KB. That's to say, only one
4KB size's vmalloc area could contain Dev1 and Dev2 IO mapping area
at the same time.

For this case, we can ioremap only one time, and the later ioremap
operation will just return the exist vmalloc area.

Signed-off-by: Richard Lee <superlibj8301@gmail.com>
---
 include/linux/vmalloc.h |  5 +++
 mm/vmalloc.c            | 82 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 87 insertions(+)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 4b8a891..a53b70f 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_VMALLOC_H
 #define _LINUX_VMALLOC_H
 
+#include <linux/atomic.h>
 #include <linux/spinlock.h>
 #include <linux/init.h>
 #include <linux/list.h>
@@ -34,6 +35,7 @@ struct vm_struct {
 	struct page		**pages;
 	unsigned int		nr_pages;
 	phys_addr_t		phys_addr;
+	atomic_t		used;
 	const void		*caller;
 };
 
@@ -100,6 +102,9 @@ static inline size_t get_vm_area_size(const struct vm_struct *area)
 	return area->size - PAGE_SIZE;
 }
 
+extern struct vm_struct *find_vm_area_paddr(phys_addr_t paddr, size_t size,
+				     unsigned long *offset,
+				     unsigned long flags);
 extern struct vm_struct *get_vm_area(unsigned long size, unsigned long flags);
 extern struct vm_struct *get_vm_area_caller(unsigned long size,
 					unsigned long flags, const void *caller);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bf233b2..cf0093c 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1293,6 +1293,7 @@ static void setup_vmalloc_vm(struct vm_struct *vm, struct vmap_area *va,
 	vm->addr = (void *)va->va_start;
 	vm->size = va->va_end - va->va_start;
 	vm->caller = caller;
+	atomic_set(&vm->used, 1);
 	va->vm = vm;
 	va->flags |= VM_VM_AREA;
 	spin_unlock(&vmap_area_lock);
@@ -1383,6 +1384,84 @@ struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
 				  NUMA_NO_NODE, GFP_KERNEL, caller);
 }
 
+static int vm_area_used_inc(struct vm_struct *area)
+{
+	if (!(area->flags & VM_IOREMAP))
+		return -EINVAL;
+
+	atomic_add(1, &area->used);
+
+	return atomic_read(&va->vm->used);
+}
+
+static int vm_area_used_dec(const void *addr)
+{
+	struct vmap_area *va;
+
+	va = find_vmap_area((unsigned long)addr);
+	if (!va || !(va->flags & VM_VM_AREA))
+		return 0;
+
+	if (!(va->vm->flags & VM_IOREMAP))
+		return 0;
+
+	atomic_sub(1, &va->vm->used);
+
+	return atomic_read(&va->vm->used);
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
+ *	Search for the kernel VM area, whoes physical address starting at
+ *	@paddr, and if the exsit VM area's size is large enough, then return
+ *	it with increasing the 'used' counter, or return NULL.
+ */
+struct vm_struct *find_vm_area_paddr(phys_addr_t paddr, size_t size,
+				     unsigned long *offset,
+				     unsigned long flags)
+{
+	struct vmap_area *va;
+	int off;
+
+	if (!(flags & VM_IOREMAP))
+		return NULL;
+
+	size = PAGE_ALIGN((paddr & ~PAGE_MASK) + size);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(va, &vmap_area_list, list) {
+		phys_addr_t phys_addr;
+
+		if (!va || !(va->flags & VM_VM_AREA) || !va->vm)
+			continue;
+
+		if (!(va->vm->flags & VM_IOREMAP))
+			continue;
+
+		phys_addr = va->vm->phys_addr;
+
+		off = (paddr & PAGE_MASK) - (phys_addr & PAGE_MASK);
+		if (off < 0)
+			continue;
+
+		if (off + size <= va->vm->size - PAGE_SIZE) {
+			*offset = off + (paddr & ~PAGE_MASK);
+			vm_area_used_inc(va->vm);
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
@@ -1443,6 +1522,9 @@ static void __vunmap(const void *addr, int deallocate_pages)
 			addr))
 		return;
 
+	if (vm_area_used_dec(addr))
+		return;
+
 	area = remove_vm_area(addr);
 	if (unlikely(!area)) {
 		WARN(1, KERN_ERR "Trying to vfree() nonexistent vm area (%p)\n",
-- 
1.8.4

