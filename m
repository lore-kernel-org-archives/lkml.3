Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab3IJVqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:46:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab3IJVpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:45:15 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org
Cc: akpm@linux-foundation.org, zohar@linux.vnet.ibm.com,
        d.kasatkin@samsung.com, ebiederm@xmission.com, hpa@zytor.com,
        matthew.garrett@nebula.com, vgoyal@redhat.com
Subject: [PATCH 16/16] mount: Add a flag to not follow symlink at the end of mount point
Date: Tue, 10 Sep 2013 17:44:31 -0400
Message-Id: <1378849471-10521-17-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a requirement where I want to make sure that mount() fails if
mount point is a symlink. Hence introducing a new mount flag MS_NOSYMLINK.

Following is little more info on what I am trying to do. I am trying
to write patches for signed /sbin/kexec. That is /sbin/kexec binary will
be signed and in secureboot environment kernel will verify signature
of /sbin/kexec and upon successful verfication, /sbin/kexec will be
trusted and allowed to load new kernel.

/sbin/kexec gathers bunch of data from /sys and /proc. Given the fact that
only /sbin/kexec is trusted and not other root processes, one need to make
sure that a root process can not alter /sys or /proc to fool /sbin/kexec.

So requirement is that /sbin/kexec needs to make sure that it is
looking at /proc and /sys as exported by kernel (and not an artificial
view possibly created by a root process).

Eric Biederman suggested that use per process mount name space functionality.
/sbin/kexec runs as root. So create separate mount namespace. Make it
recursively private to disable any event propogation. Unmount existing
/proc and /sys and remount them.

Actual code of what I am trying to do in kexec-tools is posted here.

https://lists.fedoraproject.org/pipermail/kernel/2013-September/004463.html

Al Viro mentioned that one needs to make sure /proc and /sys are not symlinks.
Otherwise after remounting, root could remove symlinks and create /proc and
/sys with its own files.

And there comes the need to make sure mount point is not a symlink
and hence this patch.

I did basic testing by doing following and it seems to work.

syscall(__NR_mount, "none", <mount-point>, "proc", 1<<25,"");

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/namespace.c          | 6 +++++-
 include/uapi/linux/fs.h | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 7b1ca9b..d19627e 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2278,7 +2278,11 @@ long do_mount(const char *dev_name, const char *dir_name,
 		((char *)data_page)[PAGE_SIZE - 1] = 0;
 
 	/* ... and get the mountpoint */
-	retval = kern_path(dir_name, LOOKUP_FOLLOW, &path);
+	if (flags & MS_NOSYMLINK)
+		retval = kern_path(dir_name, 0, &path);
+	else
+		retval = kern_path(dir_name, LOOKUP_FOLLOW, &path);
+
 	if (retval)
 		return retval;
 
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index a4ed56c..584f083 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -86,6 +86,7 @@ struct inodes_stat_t {
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
+#define MS_NOSYMLINK	(1<<25) /* Do not follow symlink at the end */
 
 /* These sb flags are internal to the kernel */
 #define MS_NOSEC	(1<<28)
-- 
1.8.3.1

