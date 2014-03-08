Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaCGOhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 09:37:54 -0500
Received: from owamsq.epam.com ([217.21.63.36]:55854 "EHLO
	EVBYMINSA0101.epam.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbaCGOhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 09:37:52 -0500
X-Greylist: delayed 925 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Mar 2014 09:37:52 EST
Date: Sat, 8 Mar 2014 05:20:33 +0300
From: Artem Fetishev <artem_fetishev@epam.com>
To: <akpm@linux-foundation.org>
CC: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <wiebittewas@googlemail.com>, <xemul@parallels.com>,
        <alexandr_terekhov@epam.com>
Subject: [PATCH] proc: #68991 Fix GPF in /proc/$PID/map_files
Message-ID: <20140308022033.GC5690@owamsq.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [10.6.165.158]
X-ClientProxiedBy: EVBYMINSA0101.epam.com (10.6.110.10) To
 EVBYMINSA0074.epam.com (10.6.110.12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=68991

The expected logic of proc_map_files_get_link() is either to return 0 and
initialize 'path' or return an error and leave 'path' uninitialized. By the time
dname_to_vma_addr() returns 0 the corresponding vma may have already be gone. In
this case the path is not initialized but the return value is still 0. This
results in 'general protection fault' inside d_path().

Steps to reproduce:
CONFIG_CHECKPOINT_RESTORE=y

fd = open(...);
while (1) {
	mmap(fd, ...);
	munmap(fd, ...);
}

ls -la /proc/$PID/map_files

Signed-off-by: Artem Fetishev <artem_fetishev@epam.com>
Signed-off-by: Aleksandr Terekhov <aleksandr_terekhov@epam.com>
---
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 5150706..b976062 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1824,6 +1824,7 @@ static int proc_map_files_get_link(struct dentry *dentry, struct path *path)
 	if (rc)
 		goto out_mmput;
 
+	rc = -ENOENT;
 	down_read(&mm->mmap_sem);
 	vma = find_exact_vma(mm, vm_start, vm_end);
 	if (vma && vma->vm_file) {
