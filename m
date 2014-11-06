Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbaKFDxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 22:53:20 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57144 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999AbaKFDxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 22:53:17 -0500
Message-ID: <1415245982.3398.53.camel@decadent.org.uk>
Subject: [RFC][PATCH] x86: Make x32 syscall support conditional on a kernel
 parameter
From: Ben Hutchings <ben@decadent.org.uk>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Thu, 06 Nov 2014 03:53:02 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-xD4f/5InkdRmdHInBkuZ"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xD4f/5InkdRmdHInBkuZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Enabling x32 in a distribution default kernel increases its attack
surface while providing no benefit to the vast majority of its users.
No-one seems interested in regularly checking for vulnerabilities
specific to x32 (at least no-one with a white hat).

Still, requiring a separate or custom configuration just to turn on
x32 seems wasteful.  And the only differences on syscall entry are
two instructions (mask out the x32 flag and compare the syscall
number).

So pad the standard comparison with a nop and add a kernel parameter
"syscall.x32" which controls whether this is replaced with the x32
version at boot time.  Add a Kconfig parameter to set the default.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
This is currently used in Debian, where x32 is an unofficial port that
can be installed in parallel with amd64 (multiarch).  I acknowledge the
patch is a bit hacky, e.g. it has several magic numbers.  I'm sending
this to find out whether anything like this would be acceptable
upstream.

Ben.

 Documentation/kernel-parameters.txt |  4 ++++
 arch/x86/Kconfig                    |  8 +++++++
 arch/x86/include/asm/elf.h          |  8 ++++++-
 arch/x86/kernel/entry_64.S          | 26 ++++++++++++++++++----
 arch/x86/kernel/syscall_64.c        | 43 +++++++++++++++++++++++++++++++++=
++++
 5 files changed, 84 insertions(+), 5 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-par=
ameters.txt
index 4c81a86..1e161b0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3397,6 +3397,10 @@ bytes respectively. Such letter suffixes can also be=
 entirely omitted.
=20
 	switches=3D	[HW,M68k]
=20
+	syscall.x32=3D	[KNL,x86_64] Enable/disable use of x32 syscalls on
+			an x86_64 kernel where CONFIG_X86_X32 is enabled.
+			Default depends on CONFIG_X86_X32_DISABLED.
+
 	sysfs.deprecated=3D0|1 [KNL]
 			Enable/disable old style sysfs layout for old udev
 			on older distributions. When this option is enabled
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ded8a67..9627922 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2455,6 +2455,14 @@ config X86_X32
 	  elf32_x86_64 support enabled to compile a kernel with this
 	  option set.
=20
+config X86_X32_DISABLED
+	bool "x32 ABI disabled by default"
+	depends on X86_X32
+	default n
+	help
+	  Disable the x32 ABI unless explicitly enabled using the
+	  kernel paramter "syscall.x32=3Dy".
+
 config COMPAT
 	def_bool y
 	depends on IA32_EMULATION || X86_X32
diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index ca3347a..2a8b89a 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -154,6 +154,12 @@ do {						\
=20
 #else /* CONFIG_X86_32 */
=20
+#ifdef CONFIG_X86_X32_ABI
+extern bool x32_enabled;
+#else
+#define x32_enabled 0
+#endif
+
 /*
  * This is used to ensure we don't load something for the wrong architectu=
re.
  */
@@ -162,7 +168,7 @@ do {						\
=20
 #define compat_elf_check_arch(x)					\
 	(elf_check_arch_ia32(x) ||					\
-	 (IS_ENABLED(CONFIG_X86_X32_ABI) && (x)->e_machine =3D=3D EM_X86_64))
+	 (x32_enabled && (x)->e_machine =3D=3D EM_X86_64))
=20
 #if __USER32_DS !=3D __USER_DS
 # error "The following code assumes __USER32_DS =3D=3D __USER_DS"
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index df088bb..50b265a 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -414,8 +414,12 @@ system_call_fastpath:
 #if __SYSCALL_MASK =3D=3D ~0
 	cmpq $__NR_syscall_max,%rax
 #else
-	andl $__SYSCALL_MASK,%eax
-	cmpl $__NR_syscall_max,%eax
+	.globl system_call_fast_compare
+	.globl system_call_fast_compare_end
+system_call_fast_compare:
+	cmpq $511,%rax			/* x32 syscalls start at 512 */
+	.byte P6_NOP4
+system_call_fast_compare_end:
 #endif
 	ja ret_from_sys_call  /* and return regs->ax */
 	movq %r10,%rcx
@@ -520,8 +524,12 @@ tracesys_phase2:
 #if __SYSCALL_MASK =3D=3D ~0
 	cmpq $__NR_syscall_max,%rax
 #else
-	andl $__SYSCALL_MASK,%eax
-	cmpl $__NR_syscall_max,%eax
+	.globl system_call_trace_compare
+	.globl system_call_trace_compare_end
+system_call_trace_compare:
+	cmpq $511,%rax			/* x32 syscalls start at 512 */
+	.byte P6_NOP4
+system_call_trace_compare_end:
 #endif
 	ja   int_ret_from_sys_call	/* RAX(%rsp) is already set */
 	movq %r10,%rcx	/* fixup for C */
@@ -593,6 +601,16 @@ int_restore_rest:
 	CFI_ENDPROC
 END(system_call)
=20
+#if __SYSCALL_MASK !=3D ~0
+	/* This replaces the usual comparisons if syscall.x32 is set */
+	.globl system_call_mask_compare
+	.globl system_call_mask_compare_end
+system_call_mask_compare:
+	andl $__SYSCALL_MASK,%eax
+	cmpl $__NR_syscall_max,%eax
+system_call_mask_compare_end:
+#endif
+
 	.macro FORK_LIKE func
 ENTRY(stub_\func)
 	CFI_STARTPROC
diff --git a/arch/x86/kernel/syscall_64.c b/arch/x86/kernel/syscall_64.c
index 4ac730b..7a6e66f 100644
--- a/arch/x86/kernel/syscall_64.c
+++ b/arch/x86/kernel/syscall_64.c
@@ -3,8 +3,14 @@
 #include <linux/linkage.h>
 #include <linux/sys.h>
 #include <linux/cache.h>
+#include <linux/moduleparam.h>
+#undef MODULE_PARAM_PREFIX
+#define MODULE_PARAM_PREFIX "syscall."
+#include <linux/bug.h>
+#include <linux/init.h>
 #include <asm/asm-offsets.h>
 #include <asm/syscall.h>
+#include <asm/alternative.h>
=20
 #define __SYSCALL_COMMON(nr, sym, compat) __SYSCALL_64(nr, sym, compat)
=20
@@ -30,3 +36,40 @@ asmlinkage const sys_call_ptr_t sys_call_table[__NR_sysc=
all_max+1] =3D {
 	[0 ... __NR_syscall_max] =3D &sys_ni_syscall,
 #include <asm/syscalls_64.h>
 };
+
+#ifdef CONFIG_X86_X32_ABI
+
+/* Maybe enable x32 syscalls */
+
+bool x32_enabled =3D !IS_ENABLED(CONFIG_X86_X32_DISABLED);
+module_param_named(x32, x32_enabled, bool, 0444);
+
+extern char system_call_fast_compare_end[], system_call_fast_compare[],
+	system_call_trace_compare_end[], system_call_trace_compare[],
+	system_call_mask_compare_end[], system_call_mask_compare[];
+
+static int __init x32_enable(void)
+{
+	BUG_ON(system_call_fast_compare_end - system_call_fast_compare !=3D 10);
+	BUG_ON(system_call_trace_compare_end - system_call_trace_compare !=3D 10)=
;
+	BUG_ON(system_call_mask_compare_end - system_call_mask_compare !=3D 10);
+
+	if (x32_enabled) {
+		text_poke_early(system_call_fast_compare,
+				system_call_mask_compare, 10);
+		text_poke_early(system_call_trace_compare,
+				system_call_mask_compare, 10);
+#ifdef CONFIG_X86_X32_DISABLED
+		pr_info("Enabled x32 syscalls\n");
+#endif
+	}
+#ifndef CONFIG_X86_X32_DISABLED
+	else
+		pr_info("Disabled x32 syscalls\n");
+#endif
+
+	return 0;
+}
+late_initcall(x32_enable);
+
+#endif

--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-xD4f/5InkdRmdHInBkuZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVFrwpee/yOyVhhEJAQr75A//eh403XkrauFWBTOqt9zHQQB4eHaGmXr3
jfNxFPD2krxbnWROw+5IdWjWbsAfPTHz2UukXyUDWhI+Q6E5Mpy1n5bpqo18imtI
uKUVJNqMZv8VZb6XOcayWaVPdQMIzQsfh+LRAuaEkcKHtrL5bvgWunBum1LoB+Dq
auBxwIdti2M6sRh7T5Di6GKvYUptQ6VhAnC7dNB6WwjlZrdrXW2dnOBijnvUPHoG
wdbs1Y0QlhVK/cVMjcy8qo2ICuMt1q/frnLf1O0zlmjaiRmop/wnxSvKineEQvoo
qshPudGRriH8vO5oMs3Umgnr0wCSBJctD7uzTqdesXJA6B2bmS2c8dTS3qzbpRVg
tzO3GMxF5BP6UANG5M4HBikq7Ch9PNXPxss5UxwgB+mm899JfGBuncuBke8lW2/Y
ko08qv+QETFulVdCBMMeP0PFKG8a9tIimb/3sqin8QS7yqKM0kPsq7OBrbaqK/Ob
LAiMqeGhJf+XJUUZdOQbpuoBp/mZUUIbapkQmQq94U7j5Ol/XFLjtue9+GRSSMNs
7y9/rCKdBvATx96VGa0W1AGtSqcLVtzVs/sPvxdSi0o74I5z7hxR9BBb4YnJYMjK
S2IvmbvjemHcnskolXphWSXPWwEeQZ5SwrREnm+TU4fxZaf5oRbgqYFdU6xxGCLd
eWHFXg0ES8M=
=iwN+
-----END PGP SIGNATURE-----

--=-xD4f/5InkdRmdHInBkuZ--
