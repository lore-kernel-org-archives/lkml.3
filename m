Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933584AbaCRV2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:28:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54452 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779AbaCRV2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:28:44 -0400
Date: Tue, 18 Mar 2014 14:28:02 -0700
From: tip-bot for Stefani Seibold <tipbot@zytor.com>
Message-ID: <tip-3935ed6a3a533c1736e3ca65bff72afd1773be27@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1395094933-14252-3-git-send-email-stefani@seibold.net>
References: <1395094933-14252-3-git-send-email-stefani@seibold.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] mm: Add new func _install_special_mapping()
  to mmap.c
Git-Commit-ID: 3935ed6a3a533c1736e3ca65bff72afd1773be27
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3935ed6a3a533c1736e3ca65bff72afd1773be27
Gitweb:     http://git.kernel.org/tip/3935ed6a3a533c1736e3ca65bff72afd1773be27
Author:     Stefani Seibold <stefani@seibold.net>
AuthorDate: Mon, 17 Mar 2014 23:22:02 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 18 Mar 2014 12:51:56 -0700

mm: Add new func _install_special_mapping() to mmap.c

The _install_special_mapping() is the new base function for
install_special_mapping(). This function will return a pointer of the
created VMA or a error code in an ERR_PTR()

This new function will be needed by the for the vdso 32 bit support to map the
additonal vvar and hpet pages into the 32 bit address space. This will be done
with io_remap_pfn_range() and remap_pfn_range, which requieres a vm_area_struct.

Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Stefani Seibold <stefani@seibold.net>
Link: http://lkml.kernel.org/r/1395094933-14252-3-git-send-email-stefani@seibold.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 include/linux/mm.h |  3 +++
 mm/mmap.c          | 20 ++++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c1b7414..6c7fedf 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1750,6 +1750,9 @@ extern void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
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
