Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab3DKL3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 07:29:00 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:27126 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab3DKL26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 07:28:58 -0400
Message-ID: <51669E73.2000301@parallels.com>
Date: Thu, 11 Apr 2013 15:28:51 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] clear_refs: Sanitize accepted commands declaration
References: <51669E5F.4000801@parallels.com>
In-Reply-To: <51669E5F.4000801@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new clear-refs type will be added in the next patch, so prepare
code for that.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
---
 fs/proc/task_mmu.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 3e636d8..67c2586 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -688,6 +688,13 @@ const struct file_operations proc_tid_smaps_operations = {
 	.release	= seq_release_private,
 };
 
+enum clear_refs_types {
+	CLEAR_REFS_ALL = 1,
+	CLEAR_REFS_ANON,
+	CLEAR_REFS_MAPPED,
+	CLEAR_REFS_LAST,
+};
+
 static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 				unsigned long end, struct mm_walk *walk)
 {
@@ -719,10 +726,6 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 	return 0;
 }
 
-#define CLEAR_REFS_ALL 1
-#define CLEAR_REFS_ANON 2
-#define CLEAR_REFS_MAPPED 3
-
 static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
@@ -730,7 +733,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 	char buffer[PROC_NUMBUF];
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
-	int type;
+	enum clear_refs_types type;
 	int rv;
 
 	memset(buffer, 0, sizeof(buffer));
@@ -738,10 +741,10 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
-	rv = kstrtoint(strstrip(buffer), 10, &type);
+	rv = kstrtoint(strstrip(buffer), 10, (int *)&type);
 	if (rv < 0)
 		return rv;
-	if (type < CLEAR_REFS_ALL || type > CLEAR_REFS_MAPPED)
+	if (type < CLEAR_REFS_ALL || type >= CLEAR_REFS_LAST)
 		return -EINVAL;
 	task = get_proc_task(file_inode(file));
 	if (!task)
-- 
1.7.6.5
