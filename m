Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaHWIug (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 04:50:36 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51545 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaHWIuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 04:50:10 -0400
Message-Id: <20140823085007.310194940@openvz.org>
User-Agent: quilt/0.60-1
Date: Sat, 23 Aug 2014 12:46:12 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, keescook@chromium.org, oleg@redhat.com,
        tj@kernel.org, avagin@openvz.org, ebiederm@xmission.com, hpa@zytor.com,
        serge.hallyn@canonical.com, xemul@parallels.com, segoon@openwall.com,
        kamezawa.hiroyu@jp.fujitsu.com, mtk.manpages@gmail.com, jln@google.com,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 1/2 -mm] prctl: PR_SET_MM_MAP -- Copy @auxv from userspace early
References: <20140823084611.939722362@openvz.org>
Content-Disposition: inline; filename=prctl-rework-new-mm-map-auxv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg noticed that I'm doing a strange games with mm::mmap_sem
member -- I take it and keep busy whie validating data which
comes from user space but then I release it and copy auxv
data itself.

This means we've a small window where previously found VMAs might
be no longer valid thus move @auxv validation and copying at the
beginning of prctl_set_mm_map before we take the lock.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Julien Tinnes <jln@google.com>
---
 kernel/sys.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

Index: linux-2.6.git/kernel/sys.c
===================================================================
--- linux-2.6.git.orig/kernel/sys.c
+++ linux-2.6.git/kernel/sys.c
@@ -1838,22 +1838,28 @@ static int prctl_set_mm_map(int opt, con
 	if (copy_from_user(&prctl_map, addr, sizeof(prctl_map)))
 		return -EFAULT;
 
-	down_read(&mm->mmap_sem);
-
-	if (validate_prctl_map_locked(&prctl_map))
-		goto out;
-
+	/*
+	 * Validate and copy auxv early to be able to keep
+	 * @mmap_sem taken until this function ends.
+	 */
 	if (prctl_map.auxv_size) {
-		up_read(&mm->mmap_sem);
+		if (!prctl_map.auxv ||
+		    prctl_map.auxv_size > sizeof(mm->saved_auxv))
+			return -EINVAL;
+
 		memset(user_auxv, 0, sizeof(user_auxv));
 		error = copy_from_user(user_auxv,
 				       (const void __user *)prctl_map.auxv,
 				       prctl_map.auxv_size);
-		down_read(&mm->mmap_sem);
 		if (error)
 			goto out;
 	}
 
+	down_read(&mm->mmap_sem);
+
+	if (validate_prctl_map_locked(&prctl_map))
+		goto out;
+
 	if (prctl_map.exe_fd != (u32)-1) {
 		error = prctl_set_mm_exe_file_locked(mm, prctl_map.exe_fd);
 		if (error)

