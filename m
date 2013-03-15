Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab3COLSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 07:18:07 -0400
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:45882 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab3COLSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 07:18:05 -0400
Date: Fri, 15 Mar 2013 20:04:11 +0900
From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
To: iamjoonsoo.kim@lge.com, ebiederm@xmission.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, anderson@redhat.com, vgoyal@redhat.com,
        lliubbo@gmail.com, penberg@kernel.org, kexec@lists.infradead.org,
        js1304@gmail.com
Subject: Re: [PATCH v2 7/8] mm, vmalloc: export vmap_area_list, instead of
 vmlist
Message-Id: <20130315200411.59edc3c7af0ffafdef2a9d4b@mxc.nes.nec.co.jp>
In-Reply-To: <87k3pbsst7.fsf@xmission.com>
References: <1363156381-2881-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1363156381-2881-8-git-send-email-iamjoonsoo.kim@lge.com>
	<87k3pbsst7.fsf@xmission.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, 12 Mar 2013 23:43:48 -0700
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:
> 
> > From: Joonsoo Kim <js1304@gmail.com>
> >
> > Although our intention is to unexport internal structure entirely,
> > but there is one exception for kexec. kexec dumps address of vmlist
> > and makedumpfile uses this information.
> >
> > We are about to remove vmlist, then another way to retrieve information
> > of vmalloc layer is needed for makedumpfile. For this purpose,
> > we export vmap_area_list, instead of vmlist.
> 
> That seems entirely reasonable to me.  Usage by kexec should not limit
> the evoluion of the kernel especially usage by makedumpfile.
> 
> Atsushi Kumagai can you make makedumpfile work with this change?

Sure! I'm going to work with this change in the next version.
But, I noticed that necessary information is missed in this patch,
and sorry for too late reply.

Both OFFSET(vmap_area.va_start) and OFFSET(vmap_area.list) are
necessary to get vmalloc_start value from vmap_area_list, but
they aren't exported in this patch.
I understand that the policy of this patch series "to unexport
internal structure entirely", although the information is necessary
for makedumpfile.

Additionally, OFFSET(vm_struct.addr) is no longer used, should be
removed. It was added for the same purpose as vmlist in the commit
below. 

  commit acd99dbf54020f5c80b9aa2f2ea86f43cb285b02
  Author: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
  Date:   Sat Oct 18 20:28:30 2008 -0700

      kdump: add vmlist.addr to vmcoreinfo for x86 vmalloc translation.

To sum it up, I would like to push the patch below.

Thanks
Atsushi Kumagai

--
From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Date: Fri, 15 Mar 2013 14:19:28 +0900
Subject: [PATCH] kexec, vmalloc: Export additional information of
 vmalloc layer.

Now, vmap_area_list is exported as VMCOREINFO for makedumpfile
to get the start address of vmalloc region (vmalloc_start).
The address which contains vmalloc_start value is represented as
below:

  vmap_area_list.next - OFFSET(vmap_area.list) + OFFSET(vmap_area.va_start)

However, both OFFSET(vmap_area.va_start) and OFFSET(vmap_area.list)
aren't exported as VMCOREINFO.

So, this patch exports them externally with small cleanup.

Signed-off-by: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
---
 include/linux/vmalloc.h | 12 ++++++++++++
 kernel/kexec.c          |  3 ++-
 mm/vmalloc.c            | 11 -----------
 3 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 8a25f90..62e0354 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -4,6 +4,7 @@
 #include <linux/spinlock.h>
 #include <linux/init.h>
 #include <asm/page.h>		/* pgprot_t */
+#include <linux/rbtree.h>
 
 struct vm_area_struct;		/* vma defining user mapping in mm_types.h */
 
@@ -35,6 +36,17 @@ struct vm_struct {
 	const void		*caller;
 };
 
+struct vmap_area {
+	unsigned long va_start;
+	unsigned long va_end;
+	unsigned long flags;
+	struct rb_node rb_node;         /* address sorted rbtree */
+	struct list_head list;          /* address sorted list */
+	struct list_head purge_list;    /* "lazy purge" list */
+	struct vm_struct *vm;
+	struct rcu_head rcu_head;
+};
+
 /*
  *	Highlevel APIs for driver use
  */
diff --git a/kernel/kexec.c b/kernel/kexec.c
index d9bfc6c..5db0148 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1527,7 +1527,8 @@ static int __init crash_save_vmcoreinfo_init(void)
 	VMCOREINFO_OFFSET(free_area, free_list);
 	VMCOREINFO_OFFSET(list_head, next);
 	VMCOREINFO_OFFSET(list_head, prev);
-	VMCOREINFO_OFFSET(vm_struct, addr);
+	VMCOREINFO_OFFSET(vmap_area, va_start);
+	VMCOREINFO_OFFSET(vmap_area, list);
 	VMCOREINFO_LENGTH(zone.free_area, MAX_ORDER);
 	log_buf_kexec_setup();
 	VMCOREINFO_LENGTH(free_area.free_list, MIGRATE_TYPES);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 151da8a..72043d6 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -249,17 +249,6 @@ EXPORT_SYMBOL(vmalloc_to_pfn);
 #define VM_LAZY_FREEING	0x02
 #define VM_VM_AREA	0x04
 
-struct vmap_area {
-	unsigned long va_start;
-	unsigned long va_end;
-	unsigned long flags;
-	struct rb_node rb_node;		/* address sorted rbtree */
-	struct list_head list;		/* address sorted list */
-	struct list_head purge_list;	/* "lazy purge" list */
-	struct vm_struct *vm;
-	struct rcu_head rcu_head;
-};
-
 static DEFINE_SPINLOCK(vmap_area_lock);
 /* Export for kexec only */
 LIST_HEAD(vmap_area_list);
-- 
1.8.0.2
