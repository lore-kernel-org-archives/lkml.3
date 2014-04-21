Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaDUOEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 10:04:46 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:49709 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaDUOEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 10:04:42 -0400
From: Fengwei Yin <yfw.kernel@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix seq_read dead loop and trigger memory allocation failure.
Date: Mon, 21 Apr 2014 22:12:42 +0800
Message-Id: <1398089562-5925-1-git-send-email-yfw.kernel@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dump /proc/xxx/maps, if d_path return error in seq_path, the
buffer will be exhaust and trigger dead loop in seq_read. Till
kmalloc fails with -ENOMEM.

Saving and restoring the m->count to avoid the dead loop in seq_read
if d_path return error.

Signed-off-by: Fengwei Yin <yfw.kernel@gmail.com>
---
 fs/proc/task_mmu.c   | 10 +++++++++-
 fs/proc/task_nommu.c | 10 +++++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 442177b..a080531 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -295,8 +295,16 @@ show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
 	 * special [heap] marker for the heap:
 	 */
 	if (file) {
+		size_t sz;
 		seq_pad(m, ' ');
-		seq_path(m, &file->f_path, "\n");
+		/* Save current count. Once seq_path return negtive value,
+		 * we need to restore saved count. Otherwise, seq_path will
+		 * exhaust the buffer and make seq_read dead loop till
+		 * m->buff allocation failure.
+		 */
+		sz = m->count;
+		if (seq_path(m, &file->f_path, "\n") < 0)
+			m->count = sz;
 		goto done;
 	}
 
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 678455d..0d4d6e0 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -160,8 +160,16 @@ static int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma,
 		   MAJOR(dev), MINOR(dev), ino);
 
 	if (file) {
+		size_t sz;
 		seq_pad(m, ' ');
-		seq_path(m, &file->f_path, "");
+		/* Save current count. Once seq_path return negtive value,
+		 * we need to restore saved count. Otherwise, seq_path will
+		 * exhaust the buffer and make seq_read dead loop till
+		 * m->buff allocation failure.
+		 */
+		sz = m->count;
+		if (seq_path(m, &file->f_path, "\n") < 0)
+			m->count = sz;
 	} else if (mm) {
 		pid_t tid = vm_is_stack(priv->task, vma, is_pid);
 
-- 
1.8.3.2

