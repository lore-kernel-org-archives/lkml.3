Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbaBGNTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:19:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41518 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343AbaBGLsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 031/233] vfs: In d_path don't call d_dname on a mount point
Date: Fri,  7 Feb 2014 11:44:10 +0000
Message-Id: <1391773652-25214-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit f48cfddc6729ef133933062320039808bafa6f45 upstream.

Aditya Kali (adityakali@google.com) wrote:
> Commit bf056bfa80596a5d14b26b17276a56a0dcb080e5:
> "proc: Fix the namespace inode permission checks." converted
> the namespace files into symlinks. The same commit changed
> the way namespace bind mounts appear in /proc/mounts:
>   $ mount --bind /proc/self/ns/ipc /mnt/ipc
> Originally:
>   $ cat /proc/mounts | grep ipc
>   proc /mnt/ipc proc rw,nosuid,nodev,noexec 0 0
>
> After commit bf056bfa80596a5d14b26b17276a56a0dcb080e5:
>   $ cat /proc/mounts | grep ipc
>   proc ipc:[4026531839] proc rw,nosuid,nodev,noexec 0 0
>
> This breaks userspace which expects the 2nd field in
> /proc/mounts to be a valid path.

The symlink /proc/<pid>/ns/{ipc,mnt,net,pid,user,uts} point to
dentries allocated with d_alloc_pseudo that we can mount, and
that have interesting names printed out with d_dname.

When these files are bind mounted /proc/mounts is not currently
displaying the mount point correctly because d_dname is called instead
of just displaying the path where the file is mounted.

Solve this by adding an explicit check to distinguish mounted pseudo
inodes and unmounted pseudo inodes.  Unmounted pseudo inodes always
use mount of their filesstem as the mnt_root  in their path making
these two cases easy to distinguish.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Reported-by: Aditya Kali <adityakali@google.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/dcache.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index b949af8..2d1a5ea 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2675,8 +2675,13 @@ char *d_path(const struct path *path, char *buf, int buflen)
 	 * thus don't need to be hashed.  They also don't need a name until a
 	 * user wants to identify the object in /proc/pid/fd/.  The little hack
 	 * below allows us to generate a name for these objects on demand:
+	 *
+	 * Some pseudo inodes are mountable.  When they are mounted
+	 * path->dentry == path->mnt->mnt_root.  In that case don't call d_dname
+	 * and instead have d_path return the mounted path.
 	 */
-	if (path->dentry->d_op && path->dentry->d_op->d_dname)
+	if (path->dentry->d_op && path->dentry->d_op->d_dname &&
+	    (!IS_ROOT(path->dentry) || path->dentry != path->mnt->mnt_root))
 		return path->dentry->d_op->d_dname(path->dentry, buf, buflen);
 
 	get_fs_root(current->fs, &root);
-- 
1.8.3.2

