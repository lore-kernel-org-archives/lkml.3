Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab3G2GXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 02:23:09 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:44528 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab3G2GXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 02:23:07 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, dholsgrove@xilinx.com,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        James Hogan <james.hogan@imgtec.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        microblaze-uclinux@itee.uq.edu.au
Subject: [RESEND PATCH v2] microblaze: Fix clone syscall
Date: Mon, 29 Jul 2013 08:22:56 +0200
Message-Id: <3fe61cc5f884f9367214b045da6b83f15c4101ec.1375078947.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-17425-1375078976-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-17425-1375078976-0001

Microblaze was assign to CLONE_BACKWARDS type where
parent tid was passed via 3rd argument.
Microblaze glibc is using 4th argument for it.

Create new CLONE_BACKWARDS3 type where stack_size is passed
via 3rd argument, parent thread id pointer via 4th,
child thread id pointer via 5th and tls value as 6th
argument

Inconsistency was introduced by this patch:
"microblaze: switch to generic fork/vfork/clone"
(sha1: f3268edbe6fe0ce56e62c6d6b14640aeb04864b7)

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
Changes in v2:
 - Add information about the first broken patch - Suggested by Andrew

Hi Al,

We have found this problem based on debugging timer_create()
reported by customer which wasn't cover by LTP testing.
What tool do you use for syscall testing?

IRC there was any discussion about adding syscall tests
directly to the kernel.

I am not sure if there is more elegant way how to fix this
in syscalls.h.

Thanks,
Michal

---
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
index 4147d70..71d8931 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -802,9 +802,14 @@ asmlinkage long sys_vfork(void);
 asmlinkage long sys_clone(unsigned long, unsigned long, int __user *, int,
 	       int __user *);
 #else
+#if CONFIG_CLONE_BACKWARDS3
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


--=_mimegpg-monstr-desktop-17425-1375078976-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlH2CkAACgkQykllyylKDCEwlQCePxDE3LH+AzVZwIVv61bmHBEd
p8sAn0AGaMtA6RdIdT5mi2c03LgeMwF6
=Vm8g
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-17425-1375078976-0001--
