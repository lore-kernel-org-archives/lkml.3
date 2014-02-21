Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbaBUVAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:00:49 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:40253 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbaBUVAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:00:48 -0500
X-Originating-IP: 173.246.103.110
Date: Fri, 21 Feb 2014 13:00:36 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>, Jiri Slaby <jslaby@suse.cz>,
        Eric Paris <eparis@redhat.com>, Dwight Engen <dwight.engen@oracle.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2] fs, kernel: Support disabling the uselib syscall
Message-ID: <20140221210036.GA6096@jtriplet-mobl1>
References: <20140221181103.GA5773@jtriplet-mobl1>
 <20140221121627.19e5d04dbba25984d4be8a15@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221121627.19e5d04dbba25984d4be8a15@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uselib hasn't been used since libc5; glibc does not use it.  Support
turning it off.

When disabled, also omit the load_elf_library implementation as part of
the binfmt, which only uselib invokes.

bloat-o-meter:
add/remove: 0/4 grow/shrink: 0/1 up/down: 0/-785 (-785)
function                                     old     new   delta
padzero                                       39      36      -3
uselib_flags                                  20       -     -20
sys_uselib                                   168       -    -168
SyS_uselib                                   168       -    -168
load_elf_library                             426       -    -426

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
v2: Add "default y", unintentionally omitted from the first patch.

Andrew, can you please replace the patch in -mm with this one?

 fs/binfmt_elf.c |  9 ++++++++-
 fs/exec.c       |  2 ++
 init/Kconfig    | 10 ++++++++++
 kernel/sys_ni.c |  1 +
 4 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 67be295..0f59799 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -46,10 +46,15 @@
 #endif
 
 static int load_elf_binary(struct linux_binprm *bprm);
-static int load_elf_library(struct file *);
 static unsigned long elf_map(struct file *, unsigned long, struct elf_phdr *,
 				int, int, unsigned long);
 
+#ifdef CONFIG_USELIB
+static int load_elf_library(struct file *);
+#else
+#define load_elf_library NULL
+#endif
+
 /*
  * If we don't support core dumping, then supply a NULL so we
  * don't even try.
@@ -1005,6 +1010,7 @@ out_free_ph:
 	goto out;
 }
 
+#ifdef CONFIG_USELIB
 /* This is really simpleminded and specialized - we are loading an
    a.out library that is given an ELF header. */
 static int load_elf_library(struct file *file)
@@ -1083,6 +1089,7 @@ out_free_ph:
 out:
 	return error;
 }
+#endif /* #ifdef CONFIG_USELIB */
 
 #ifdef CONFIG_ELF_CORE
 /*
diff --git a/fs/exec.c b/fs/exec.c
index 3d78fcc..48eb039 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -97,6 +97,7 @@ static inline void put_binfmt(struct linux_binfmt * fmt)
 	module_put(fmt->module);
 }
 
+#ifdef CONFIG_USELIB
 /*
  * Note that a shared library must be both readable and executable due to
  * security reasons.
@@ -156,6 +157,7 @@ exit:
 out:
   	return error;
 }
+#endif /* #ifdef CONFIG_USELIB */
 
 #ifdef CONFIG_MMU
 /*
diff --git a/init/Kconfig b/init/Kconfig
index 009a797..7f295a3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -273,6 +273,16 @@ config FHANDLE
 	  get renamed. Enables open_by_handle_at(2) and name_to_handle_at(2)
 	  syscalls.
 
+config USELIB
+	bool "uselib syscall"
+	default y
+	help
+	  This option enables the uselib syscall, a system call used in the
+	  dynamic linker from libc5 and earlier.  glibc does not use this
+	  system call.  If you intend to run programs built on libc5 or
+	  earlier, you may need to enable this syscall.  Current systems
+	  running glibc can safely disable this.
+
 config AUDIT
 	bool "Auditing support"
 	depends on NET
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 7078052..4177e3e 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -151,6 +151,7 @@ cond_syscall(sys_process_vm_readv);
 cond_syscall(sys_process_vm_writev);
 cond_syscall(compat_sys_process_vm_readv);
 cond_syscall(compat_sys_process_vm_writev);
+cond_syscall(sys_uselib);
 
 /* arch-specific weak syscall entries */
 cond_syscall(sys_pciconfig_read);
-- 
1.9.0

