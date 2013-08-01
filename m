Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab3HAH57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:57:59 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:53748 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab3HAH55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:57:57 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, dholsgrove@xilinx.com,
        Rich Felker <dalias@aerifal.cx>, akpm@linux-foundation.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        James Hogan <james.hogan@imgtec.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH v4] microblaze: Fix clone syscall
Date: Thu,  1 Aug 2013 09:57:36 +0200
Message-Id: <0468c5ac37aff05db2915c9b4bef8332ef059cbb.1375343841.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-26179-1375343856-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-26179-1375343856-0001

Fix inadvertent breakage in the clone syscall ABI for Microblaze
that was introduced in this patch:
"microblaze: switch to generic fork/vfork/clone"
(sha1: f3268edbe6fe0ce56e62c6d6b14640aeb04864b7)

The Microblaze syscall ABI for clone takes the parent tid address in
the 4th argument; the third argument slot is used for the stack size.
The incorrectly-used CLONE_BACKWARDS type assigned parent tid to the
3rd slot.

This commit restores the original ABI so that existing userspace libc
code will work correctly.

All kernel versions from v3.8-rc1 were affected.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>

---
Changes in v4:
 - use ifdef in syscalls.h instead of simple if (it is breaking  make ARCH=x86_64 allnoconfig)
 - Compilation passed by kbuild robot

Changes in v3:
 - Change patch description based on Rich comments.

Changes in v2:
 - Add information about the first broken patch - Suggested by Andrew

 arch/Kconfig             | 6 ++++++
 arch/microblaze/Kconfig  | 2 +-
 include/linux/syscalls.h | 5 +++++
 kernel/fork.c            | 6 ++++++
 4 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 8d2ae24..1feb169 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -407,6 +407,12 @@ config CLONE_BACKWARDS2
 	help
 	  Architecture has the first two arguments of clone(2) swapped.

+config CLONE_BACKWARDS3
+	bool
+	help
+	  Architecture has tls passed as the 3rd argument of clone(2),
+	  not the 5th one.
+
 config ODD_RT_SIGACTION
 	bool
 	help
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index d22a4ec..4fab522 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -28,7 +28,7 @@ config MICROBLAZE
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_IDLE_POLL_SETUP
 	select MODULES_USE_ELF_RELA
-	select CLONE_BACKWARDS
+	select CLONE_BACKWARDS3

 config SWAP
 	def_bool n
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 4147d70..84662ec 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -802,9 +802,14 @@ asmlinkage long sys_vfork(void);
 asmlinkage long sys_clone(unsigned long, unsigned long, int __user *, int,
 	       int __user *);
 #else
+#ifdef CONFIG_CLONE_BACKWARDS3
+asmlinkage long sys_clone(unsigned long, unsigned long, int, int __user *,
+			  int __user *, int);
+#else
 asmlinkage long sys_clone(unsigned long, unsigned long, int __user *,
 	       int __user *, int);
 #endif
+#endif

 asmlinkage long sys_execve(const char __user *filename,
 		const char __user *const __user *argv,
diff --git a/kernel/fork.c b/kernel/fork.c
index 403d2bb..e23bb19 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1679,6 +1679,12 @@ SYSCALL_DEFINE5(clone, unsigned long, newsp, unsigned long, clone_flags,
 		 int __user *, parent_tidptr,
 		 int __user *, child_tidptr,
 		 int, tls_val)
+#elif defined(CONFIG_CLONE_BACKWARDS3)
+SYSCALL_DEFINE6(clone, unsigned long, clone_flags, unsigned long, newsp,
+		int, stack_size,
+		int __user *, parent_tidptr,
+		int __user *, child_tidptr,
+		int, tls_val)
 #else
 SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
 		 int __user *, parent_tidptr,
--
1.8.2.3


--=_mimegpg-monstr-desktop-26179-1375343856-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlH6FPAACgkQykllyylKDCHrWgCfWihy/FG7BZoAv5hmgtksdm+u
ihgAnjssJi01rXKALFYiA98x2FNpp4I9
=ZEpi
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-26179-1375343856-0001--
