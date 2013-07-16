Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab3GPKj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 06:39:58 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:45991 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab3GPKjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 06:39:55 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>
Subject: [PATCH] microblaze: Fix clone syscall
Date: Tue, 16 Jul 2013 12:39:46 +0200
Message-Id: <2dd2f768912e04aa378d358c9a4e20eccbf848d2.1373971170.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-14755-1373971186-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-14755-1373971186-0001

Microblaze was assign to CLONE_BACKWARDS type where
parent tid was passed via 3rd argument.
Microblaze glibc is using 4th argument for it.

Create new CLONE_BACKWARDS3 type where stack_size is passed
via 3rd argument, parent thread id pointer via 4th,
child thread id pointer via 5th and tls value as 6th
argument

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
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
index 66635c8..da6b699 100644
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


--=_mimegpg-monstr-desktop-14755-1373971186-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlHlIvIACgkQykllyylKDCFJ9wCdFXb7bJaCwiwTE8wg0dxf/2Bd
05QAnjhFVi/VMwuqA2LUU1phOLoYn9AI
=IPZI
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-14755-1373971186-0001--
