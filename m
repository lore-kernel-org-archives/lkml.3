Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbaDAQjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:39:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44414 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbaDAQJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:09:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Artem Fetishev <artem_fetishev@epam.com>,
        Aleksandr Terekhov <aleksandr_terekhov@epam.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 67/86] fs/proc/base.c: fix GPF in /proc/$PID/map_files
Date: Tue,  1 Apr 2014 09:08:20 -0700
Message-Id: <1396368519-12728-68-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Fetishev <artem_fetishev@epam.com>

commit 70335abb2689c8cd5df91bf2d95a65649addf50b upstream.

The expected logic of proc_map_files_get_link() is either to return 0
and initialize 'path' or return an error and leave 'path' uninitialized.

By the time dname_to_vma_addr() returns 0 the corresponding vma may have
already be gone.  In this case the path is not initialized but the
return value is still 0.  This results in 'general protection fault'
inside d_path().

Steps to reproduce:

  CONFIG_CHECKPOINT_RESTORE=y

    fd = open(...);
    while (1) {
        mmap(fd, ...);
        munmap(fd, ...);
    }

  ls -la /proc/$PID/map_files

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=68991

Signed-off-by: Artem Fetishev <artem_fetishev@epam.com>
Signed-off-by: Aleksandr Terekhov <aleksandr_terekhov@epam.com>
Reported-by: <wiebittewas@gmail.com>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/proc/base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9b43ff77..78150a0 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1784,6 +1784,7 @@ static int proc_map_files_get_link(struct dentry *dentry, struct path *path)
 	if (rc)
 		goto out_mmput;
 
+	rc = -ENOENT;
 	down_read(&mm->mmap_sem);
 	vma = find_exact_vma(mm, vm_start, vm_end);
 	if (vma && vma->vm_file) {
-- 
1.8.3.2

