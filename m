Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbaJTVts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:49:48 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47192 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbaJTVtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:49:46 -0400
From: Pieter Smith <pieter@boesman.nl>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Josh Triplett <josh@joshtriplett.org>, Pieter Smith <pieter@boesman.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, Matt Turner <mattst88@gmail.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Fabian Frederick <fabf@skynet.be>, Tejun Heo <tj@kernel.org>,
        =?UTF-8?q?=E8=94=A1=E6=AD=A3=E9=BE=99?= <zhenglong.cai@cs2c.com.cn>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Peter Foley <pefoley2@pefoley.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Kees Cook <keescook@chromium.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org (open list),
        linux-api@vger.kernel.org (open list:ABI/API)
Subject: [PATCH 2/2] fs: Support compiling out sendfile
Date: Mon, 20 Oct 2014 23:48:37 +0200
Message-Id: <1413841728-1313-2-git-send-email-pieter@boesman.nl>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413841728-1313-1-git-send-email-pieter@boesman.nl>
References: <1413841728-1313-1-git-send-email-pieter@boesman.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many embedded systems will not need this syscall, and omitting it
saves space.  Add a new EXPERT config option CONFIG_SENDFILE_SYSCALL
(default y) to support compiling it out.

bloat-o-meter:
add/remove: 0/4 grow/shrink: 5/0 up/down: 23/-751 (-728)
function                                     old     new   delta
sys_pwritev                                  115     122      +7
sys_preadv                                   115     122      +7
fdput_pos                                     29      36      +7
sys_pwrite64                                 115     116      +1
sys_pread64                                  115     116      +1
fdput                                         11       -     -11
sys_sendfile                                 122       -    -122
sys_sendfile64                               126       -    -126
do_sendfile                                  492       -    -492

Signed-off-by: Pieter Smith <pieter@boesman.nl>
---
 fs/Makefile     |  3 ++-
 init/Kconfig    | 10 ++++++++++
 kernel/sys_ni.c |  4 ++++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/Makefile b/fs/Makefile
index 1e3423f..1bbfea7 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -5,7 +5,7 @@
 # Rewritten to use lists instead of if-statements.
 # 
 
-obj-y :=	open.o read_write.o sendfile.o file_table.o super.o \
+obj-y :=	open.o read_write.o file_table.o super.o \
 		char_dev.o stat.o exec.o pipe.o namei.o fcntl.o \
 		ioctl.o readdir.o select.o dcache.o inode.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o \
@@ -38,6 +38,7 @@ obj-$(CONFIG_COMPAT_BINFMT_ELF)	+= compat_binfmt_elf.o
 obj-$(CONFIG_BINFMT_ELF_FDPIC)	+= binfmt_elf_fdpic.o
 obj-$(CONFIG_BINFMT_SOM)	+= binfmt_som.o
 obj-$(CONFIG_BINFMT_FLAT)	+= binfmt_flat.o
+obj-$(CONFIG_SENDFILE_SYSCALL)	+= sendfile.o
 
 obj-$(CONFIG_FS_MBCACHE)	+= mbcache.o
 obj-$(CONFIG_FS_POSIX_ACL)	+= posix_acl.o
diff --git a/init/Kconfig b/init/Kconfig
index 782a65b..df6785c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1547,6 +1547,16 @@ config ADVISE_SYSCALLS
 	  applications use these syscalls, you can disable this option to save
 	  space.
 
+config SENDFILE_SYSCALL
+	bool "Enable sendfile syscall" if EXPERT
+	default y
+	help
+	  This option enables the sendfile syscall, used by applications to copy
+	  data between file descriptors. Because sendfile performs the copying
+	  within the kernel, it is more efficient than the combination of read
+	  and write.  If building an embedded system where no applications use
+	  the sendfile syscall, you can disable this option to save space.
+
 config PCI_QUIRKS
 	default y
 	bool "Enable PCI quirk workarounds" if EXPERT
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index d4709d4..b068de7 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -159,6 +159,10 @@ cond_syscall(sys_uselib);
 cond_syscall(sys_fadvise64);
 cond_syscall(sys_fadvise64_64);
 cond_syscall(sys_madvise);
+cond_syscall(sys_sendfile);
+cond_syscall(sys_sendfile64);
+cond_syscall(compat_sys_sendfile);
+cond_syscall(compat_sys_sendfile64);
 
 /* arch-specific weak syscall entries */
 cond_syscall(sys_pciconfig_read);
-- 
1.9.1

