Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362AbaHHUuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:50:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40755 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758282AbaHHUtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:49:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 053/259] nick kvfree() from apparmor
Date: Fri,  8 Aug 2014 13:37:56 -0700
Message-Id: <1407530482-4483-54-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 39f1f78d53b9bcbca91967380c5f0f2305a5c55f upstream.

too many places open-code it

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
[ kamal: picked for 3.13-stable for backport convenience ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/mm.h                   |  2 ++
 mm/util.c                            | 10 ++++++++++
 security/apparmor/include/apparmor.h |  1 -
 security/apparmor/lib.c              | 14 --------------
 4 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5360b82..4506b84 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -352,6 +352,8 @@ static inline int is_vmalloc_or_module_addr(const void *x)
 }
 #endif
 
+extern void kvfree(const void *addr);
+
 static inline void compound_lock(struct page *page)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff --git a/mm/util.c b/mm/util.c
index 808f375..8636d3d 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -9,6 +9,7 @@
 #include <linux/swapops.h>
 #include <linux/mman.h>
 #include <linux/hugetlb.h>
+#include <linux/vmalloc.h>
 
 #include <asm/uaccess.h>
 
@@ -386,6 +387,15 @@ unsigned long vm_mmap(struct file *file, unsigned long addr,
 }
 EXPORT_SYMBOL(vm_mmap);
 
+void kvfree(const void *addr)
+{
+	if (is_vmalloc_addr(addr))
+		vfree(addr);
+	else
+		kfree(addr);
+}
+EXPORT_SYMBOL(kvfree);
+
 struct address_space *page_mapping(struct page *page)
 {
 	struct address_space *mapping = page->mapping;
diff --git a/security/apparmor/include/apparmor.h b/security/apparmor/include/apparmor.h
index 8fb1488..97130f8 100644
--- a/security/apparmor/include/apparmor.h
+++ b/security/apparmor/include/apparmor.h
@@ -66,7 +66,6 @@ extern int apparmor_initialized __initdata;
 char *aa_split_fqname(char *args, char **ns_name);
 void aa_info_message(const char *str);
 void *__aa_kvmalloc(size_t size, gfp_t flags);
-void kvfree(void *buffer);
 
 static inline void *kvmalloc(size_t size)
 {
diff --git a/security/apparmor/lib.c b/security/apparmor/lib.c
index 6968992..c1827e0 100644
--- a/security/apparmor/lib.c
+++ b/security/apparmor/lib.c
@@ -104,17 +104,3 @@ void *__aa_kvmalloc(size_t size, gfp_t flags)
 	}
 	return buffer;
 }
-
-/**
- * kvfree - free an allocation do by kvmalloc
- * @buffer: buffer to free (MAYBE_NULL)
- *
- * Free a buffer allocated by kvmalloc
- */
-void kvfree(void *buffer)
-{
-	if (is_vmalloc_addr(buffer))
-		vfree(buffer);
-	else
-		kfree(buffer);
-}
-- 
1.9.1

