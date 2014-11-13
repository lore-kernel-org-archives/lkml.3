Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934117AbaKMV23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:28:29 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:52249 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbaKMV21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:28:27 -0500
From: Pieter Smith <pieter@boesman.nl>
To: pieter@boesman.nl
Cc: Josh Triplett <josh@joshtriplett.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Turner <mattst88@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Fabian Frederick <fabf@skynet.be>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tejun Heo <tj@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Peter Foley <pefoley2@pefoley.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>, Vivek Goyal <vgoyal@redhat.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-api@vger.kernel.org (open list:ABI/API)
Subject: [PATCH 03/56] fs: Support compiling out splice-family syscalls
Date: Thu, 13 Nov 2014 22:22:40 +0100
Message-Id: <1415913813-362-4-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415913813-362-1-git-send-email-pieter@boesman.nl>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many embedded systems will not need the splice-family syscalls (splice,
vmsplice, tee and sendfile). Omitting them saves space.  This adds a new EXPERT
config option CONFIG_SYSCALL_SPLICE (default y) to support compiling them out.

This patch removes almost all callers of .splice_read() and .splice_write()
in the file_operations struct. This paves the way to eventually compile out the
.splice_read and .splice_write members of the file_operations struct as well as
the remaining splice-related infrastructure.

add/remove: 0/16 grow/shrink: 2/5 up/down: 114/-3693 (-3579)
function                                     old     new   delta
splice_direct_to_actor                       348     416     +68
splice_to_pipe                               371     417     +46
splice_from_pipe_next                        107     106      -1
fdput                                         11       -     -11
signal_pending                                39      26     -13
fdget                                         56      42     -14
user_page_pipe_buf_ops                        20       -     -20
user_page_pipe_buf_steal                      25       -     -25
file_end_write                                58      29     -29
file_start_write                              68      34     -34
pipe_to_user                                  43       -     -43
wakeup_pipe_readers                           54       -     -54
do_splice_to                                  87       -     -87
ipipe_prep.part                               92       -     -92
opipe_prep.part                              119       -    -119
sys_sendfile                                 122       -    -122
sys_sendfile64                               126       -    -126
sys_vmsplice                                 137       -    -137
vmsplice_to_user                             205       -    -205
sys_tee                                      491       -    -491
do_sendfile                                  492       -    -492
vmsplice_to_pipe                             558       -    -558
sys_splice                                  1020       -   -1020

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/splice.c     |  2 ++
 init/Kconfig    | 10 ++++++++++
 kernel/sys_ni.c |  8 ++++++++
 3 files changed, 20 insertions(+)

diff --git a/fs/splice.c b/fs/splice.c
index 44b201b..7c4c695 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1316,6 +1316,7 @@ long do_splice_direct(struct file *in, loff_t *ppos, struct file *out,
 	return ret;
 }
 
+#ifdef CONFIG_SYSCALL_SPLICE
 static int splice_pipe_to_pipe(struct pipe_inode_info *ipipe,
 			       struct pipe_inode_info *opipe,
 			       size_t len, unsigned int flags);
@@ -2200,4 +2201,5 @@ COMPAT_SYSCALL_DEFINE4(sendfile64, int, out_fd, int, in_fd,
 	return do_sendfile(out_fd, in_fd, NULL, count, 0);
 }
 #endif
+#endif
 
diff --git a/init/Kconfig b/init/Kconfig
index 782a65b..25ee289 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1547,6 +1547,16 @@ config ADVISE_SYSCALLS
 	  applications use these syscalls, you can disable this option to save
 	  space.
 
+config SYSCALL_SPLICE
+	bool "Enable splice/vmsplice/tee/sendfile syscalls" if EXPERT
+	default y
+	help
+	  This option enables the splice, vmsplice, tee and sendfile syscalls. These
+	  are used by applications to: move data between buffers and arbitrary file
+	  descriptors; "copy" data between buffers; or copy data from userspace into
+	  buffers. If building an embedded system where no applications use these
+	  syscalls, you can disable this option to save space.
+
 config PCI_QUIRKS
 	default y
 	bool "Enable PCI quirk workarounds" if EXPERT
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index d4709d4..2913337 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -159,6 +159,14 @@ cond_syscall(sys_uselib);
 cond_syscall(sys_fadvise64);
 cond_syscall(sys_fadvise64_64);
 cond_syscall(sys_madvise);
+cond_syscall(sys_vmsplice);
+cond_syscall(sys_splice);
+cond_syscall(sys_tee);
+cond_syscall(sys_sendfile);
+cond_syscall(sys_sendfile64);
+cond_syscall(compat_sys_vmsplice);
+cond_syscall(compat_sys_sendfile);
+cond_syscall(compat_sys_sendfile64);
 
 /* arch-specific weak syscall entries */
 cond_syscall(sys_pciconfig_read);
-- 
1.9.1

