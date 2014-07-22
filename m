Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbaGVNpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:45:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403AbaGVNpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:45:05 -0400
From: "Jerome Marchand" <jmarchan@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-doc@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux390@de.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 3/5] mm, shmem: Add shmem_vma() helper
Date: Tue, 22 Jul 2014 15:43:50 +0200
Message-Id: <1406036632-26552-4-git-send-email-jmarchan@redhat.com>
In-Reply-To: <1406036632-26552-1-git-send-email-jmarchan@redhat.com>
References: <1406036632-26552-1-git-send-email-jmarchan@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a simple helper to check if a vm area belongs to shmem.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 include/linux/mm.h | 6 ++++++
 mm/shmem.c         | 8 ++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 34099fa..04a58d1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1074,11 +1074,17 @@ int shmem_zero_setup(struct vm_area_struct *);
 
 extern int shmem_locate(struct vm_area_struct *vma, pgoff_t pgoff, int *count);
 bool shmem_mapping(struct address_space *mapping);
+bool shmem_vma(struct vm_area_struct *vma);
+
 #else
 static inline bool shmem_mapping(struct address_space *mapping)
 {
 	return false;
 }
+static inline bool shmem_vma(struct vm_area_struct *vma)
+{
+	return false;
+}
 #endif
 
 extern int can_do_mlock(void);
diff --git a/mm/shmem.c b/mm/shmem.c
index 8aa4892..7d16227 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1483,6 +1483,14 @@ bool shmem_mapping(struct address_space *mapping)
 	return mapping->backing_dev_info == &shmem_backing_dev_info;
 }
 
+bool shmem_vma(struct vm_area_struct *vma)
+{
+	return (vma->vm_file &&
+		vma->vm_file->f_dentry->d_inode->i_mapping->backing_dev_info
+		== &shmem_backing_dev_info);
+
+}
+
 #ifdef CONFIG_TMPFS
 static const struct inode_operations shmem_symlink_inode_operations;
 static const struct inode_operations shmem_short_symlink_operations;
-- 
1.9.3

