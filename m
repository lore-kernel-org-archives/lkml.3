Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaCBJUy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 04:20:54 -0500
Received: from www84.your-server.de ([213.133.104.84]:48022 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbaCBJUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 04:20:51 -0500
From: Stefani Seibold <stefani@seibold.net>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH v21 02/12] Add new func _install_special_mapping() to mmap.c
Date: Sun,  2 Mar 2014 10:20:10 +0100
Message-Id: <1393752020-6740-3-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393752020-6740-1-git-send-email-stefani@seibold.net>
References: <1393752020-6740-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The _install_special_mapping() is the new base function for
install_special_mapping(). This function will return a pointer of the
created VMA or a error code in an ERR_PTR()

This new function will be needed by the for the vdso 32 bit support to map the
additonal vvar and hpet pages into the 32 bit address space. This will be done
with io_remap_pfn_range() and remap_pfn_range, which requieres a vm_area_struct.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 include/linux/mm.h |  3 +++
 mm/mmap.c          | 20 ++++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f28f46e..55342aa 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1740,6 +1740,9 @@ extern void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
 extern struct file *get_mm_exe_file(struct mm_struct *mm);
 
 extern int may_expand_vm(struct mm_struct *mm, unsigned long npages);
+extern struct vm_area_struct *_install_special_mapping(struct mm_struct *mm,
+				   unsigned long addr, unsigned long len,
+				   unsigned long flags, struct page **pages);
 extern int install_special_mapping(struct mm_struct *mm,
 				   unsigned long addr, unsigned long len,
 				   unsigned long flags, struct page **pages);
diff --git a/mm/mmap.c b/mm/mmap.c
index 20ff0c3..81ba54f 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2918,7 +2918,7 @@ static const struct vm_operations_struct special_mapping_vmops = {
  * The array pointer and the pages it points to are assumed to stay alive
  * for as long as this mapping might exist.
  */
-int install_special_mapping(struct mm_struct *mm,
+struct vm_area_struct *_install_special_mapping(struct mm_struct *mm,
 			    unsigned long addr, unsigned long len,
 			    unsigned long vm_flags, struct page **pages)
 {
@@ -2927,7 +2927,7 @@ int install_special_mapping(struct mm_struct *mm,
 
 	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (unlikely(vma == NULL))
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&vma->anon_vma_chain);
 	vma->vm_mm = mm;
@@ -2948,11 +2948,23 @@ int install_special_mapping(struct mm_struct *mm,
 
 	perf_event_mmap(vma);
 
-	return 0;
+	return vma;
 
 out:
 	kmem_cache_free(vm_area_cachep, vma);
-	return ret;
+	return ERR_PTR(ret);
+}
+
+int install_special_mapping(struct mm_struct *mm,
+			    unsigned long addr, unsigned long len,
+			    unsigned long vm_flags, struct page **pages)
+{
+	struct vm_area_struct *vma = _install_special_mapping(mm,
+			    addr, len, vm_flags, pages);
+
+	if (IS_ERR(vma))
+		return PTR_ERR(vma);
+	return 0;
 }
 
 static DEFINE_MUTEX(mm_all_locks_mutex);
-- 
1.9.0

