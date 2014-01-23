Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbaAWSqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:46:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbaAWSjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:39:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Aditya Kali <adityakali@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 3.10 08/23] vfs: In d_path dont call d_dname on a mount point
Date: Thu, 23 Jan 2014 10:39:41 -0800
Message-Id: <20140123183900.982451631@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140123183859.635713053@linuxfoundation.org>
References: <20140123183859.635713053@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/dcache.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2686,8 +2686,13 @@ char *d_path(const struct path *path, ch
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


