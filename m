Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab3IIVfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 17:35:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603Ab3IIVfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 17:35:30 -0400
Date: Mon, 9 Sep 2013 17:35:26 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-fsdevel@vger.kernel.org,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, viro@ZenIV.linux.org.uk,
        matthew.garrett@nebula.com
Subject: [RFC PATCH] mount: Add a flag to not follow symlink at the end of
 mount point
Message-ID: <20130909213526.GB2799@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
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
 fs/namespace.c          |    6 +++++-
 include/uapi/linux/fs.h |    1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/include/uapi/linux/fs.h
===================================================================
--- linux-2.6.orig/include/uapi/linux/fs.h	2013-05-03 22:05:19.000000000 -0400
+++ linux-2.6/include/uapi/linux/fs.h	2013-09-10 04:42:08.372708254 -0400
@@ -86,6 +86,7 @@ struct inodes_stat_t {
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
+#define MS_NOSYMLINK	(1<<25) /* Do not follow symlink at the end */
 
 /* These sb flags are internal to the kernel */
 #define MS_NOSEC	(1<<28)
Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2013-09-09 21:50:45.000000000 -0400
+++ linux-2.6/fs/namespace.c	2013-09-10 04:40:26.477709733 -0400
@@ -2323,7 +2323,11 @@ long do_mount(const char *dev_name, cons
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
 
