Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab3CLMhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 08:37:04 -0400
Received: from multi.imgtec.com ([194.200.65.239]:59717 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab3CLMhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 08:37:01 -0400
Message-ID: <513F2165.6050800@imgtec.com>
Date: Tue, 12 Mar 2013 12:36:53 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Al Viro <viro@zeniv.linux.org.uk>,
        Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        <linux-next@vger.kernel.org>
Subject: Re: [RFC -next] linux/linkage.h: fix symbol prefix handling
References: <1362656642-2693-1-git-send-email-james.hogan@imgtec.com> <87sj46wyf2.fsf@rustcorp.com.au> <5139AC39.90805@imgtec.com> <874ngiwije.fsf@rustcorp.com.au> <20130311230731.0c610d86569d09f6e23b8e61@canb.auug.org.au> <87ppz5usts.fsf@rustcorp.com.au>
In-Reply-To: <87ppz5usts.fsf@rustcorp.com.au>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_03_12_12_36_54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On 12/03/13 04:48, Rusty Russell wrote:
> v2: Rename CONFIG_SYMBOL_PREFIX_UNDERSCORE to CONFIG_HAVE_UNDERSCORE_SYMBOL_PREFIX,
>     which is defined in arch/Kconfig and selected by the 3 archs which need it.

Sorry I didn't get a chance to try your patch yesterday.

> Subject: CONFIG_SYMBOL_PREFIX: cleanup.
> 
> We have CONFIG_SYMBOL_PREFIX, which three archs define to the string
> "_".  But Al Viro broke this in "consolidate cond_syscall and
> SYSCALL_ALIAS declarations", and he's not the first to do so.
> 
> Using CONFIG_SYMBOL_PREFIX is awkward, since we usually just want to
> prefix it so something.  So various places define helpers which are
> defined to nothing if CONFIG_SYMBOL_PREFIX isn't set:
> 
> 1) include/asm-generic/unistd.h defines __SYMBOL_PREFIX.
> 2) include/asm-generic/vmlinux.lds.h defines VMLINUX_SYMBOL(sym)
> 3) include/linux/export.h defines MODULE_SYMBOL_PREFIX.
> 4) include/linux/kernel.h defines SYMBOL_PREFIX (which differs from #7)
> 5) kernel/modsign_certificate.S defines ASM_SYMBOL(sym)
> 6) scripts/modpost.c defines MODULE_SYMBOL_PREFIX
> 7) scripts/Makefile.lib defines SYMBOL_PREFIX on the commandline if
>    CONFIG_SYMBOL_PREFIX is set, so that we have a non-string version
>    for pasting.
> 
> (arch/h8300/include/asm/linkage.h defines SYMBOL_NAME(), too).
> 
> Let's solve this properly:
> 1) No more generic prefix, just CONFIG_HAVE_UNDERSCORE_SYMBOL_PREFIX.
> 2) Make linux/export.h usable from asm.
> 3) Define VMLINUX_SYMBOL, VMLINUX_SYMBOL_NAME and VMLINUX_SYMBOL_PREFIX_STR.

You don't seem to define VMLINUX_SYMBOL_NAME

> 4) Make everyone use them.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

After a few modifications detailed below (with a fixup patch at the
end for convenience) it seems to work no worse than before for metag
(module symbol versioning was apparently already broken, I need to
look into that).

Reviewed-by: James Hogan <james.hogan@imgtec.com>
Tested-by: James Hogan <james.hogan@imgtec.com> (on metag)

Cheers
James

> 
> diff --git a/Makefile b/Makefile
> index a05ea42..9dc948d 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1398,7 +1398,7 @@ quiet_cmd_rmfiles = $(if $(wildcard $(rm-files)),CLEAN   $(wildcard $(rm-files))
>  # Run depmod only if we have System.map and depmod is executable
>  quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
>        cmd_depmod = $(CONFIG_SHELL) $(srctree)/scripts/depmod.sh $(DEPMOD) \
> -                   $(KERNELRELEASE) "$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))"
> +                   $(KERNELRELEASE) "$(patsubst y,_,$(CONFIG_SYMBOL_PREFIX_UNDERSCORE))"

should this be CONFIG_HAVE_UNDERSCORE_SYMBOL_PREFIX now?


> diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
> index ae8551e..ba043e3 100644
> --- a/arch/h8300/Kconfig
> +++ b/arch/h8300/Kconfig
> @@ -12,10 +12,10 @@ config H8300
>  	select MODULES_USE_ELF_RELA
>  	select OLD_SIGSUSPEND3
>  	select OLD_SIGACTION
> +	select HAVE_UNDERSCORE_SYMBOL_PREFIX
>  
> -config SYMBOL_PREFIX
> -	string
> -	default "_"
> +config SYMBOL_PREFIX_UNDERSCORE
> +	def_bool y

Not needed anymore I think


> diff --git a/arch/metag/Kconfig b/arch/metag/Kconfig
> index afc8973..88272ce 100644
> --- a/arch/metag/Kconfig
> +++ b/arch/metag/Kconfig
> @@ -1,6 +1,5 @@
> -config SYMBOL_PREFIX
> -	string
> -	default "_"
> +config SYMBOL_PREFIX_UNDERSCORE
> +	def_bool y

Same again.


> diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
> index 4077b5d..80122d4 100644
> --- a/include/asm-generic/unistd.h
> +++ b/include/asm-generic/unistd.h
> @@ -1,4 +1,5 @@
>  #include <uapi/asm-generic/unistd.h>
> +#include <linux/export.h>
>  
>  /*
>   * These are required system calls, we should
> @@ -17,12 +18,7 @@
>   * but it doesn't work on all toolchains, so we just do it by hand
>   */
>  #ifndef cond_syscall
> -#ifdef CONFIG_SYMBOL_PREFIX
> -#define __SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
> -#else
> -#define __SYMBOL_PREFIX
> -#endif
> -#define cond_syscall(x) asm(".weak\t" __SYMBOL_PREFIX #x "\n\t" \
> -			    ".set\t" __SYMBOL_PREFIX #x "," \
> -			    __SYMBOL_PREFIX "sys_ni_syscall")
> +#define cond_syscall(x) asm(".weak\t" SYMBOL_NAME_STR(x) "\n\t"	\
> +			    ".set\t" SYMBOL_NAME_STR(x) ","	\
> +			    SYMBOL_NAME_STR(sys_ni_syscall))

s/SYMBOL_NAME_STR/VMLINUX_SYMBOL_STR/



> diff --git a/include/linux/export.h b/include/linux/export.h
> index 696c0f4..0080e93 100644
> --- a/include/linux/export.h
> +++ b/include/linux/export.h
> @@ -7,15 +7,27 @@
>   *
>   * If you feel the need to add #include <linux/foo.h> to this file
>   * then you are doing something wrong and should go away silently.
> + *
> + * If you think the above arrogance just encourages more people to add
> + * random crap to this file, you're not alone.

:-)

>   */
>  
>  /* Some toolchains use a `_' prefix for all user symbols. */
> -#ifdef CONFIG_SYMBOL_PREFIX
> -#define MODULE_SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
> +#ifdef CONFIG_SYMBOL_PREFIX_UNDERSCORE

CONFIG_HAVE_UNDERSCORE_SYMBOL_PREFIX


> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index 3d569d6..d767681 100644
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -74,9 +74,8 @@ kallsyms()
>  	info KSYM ${2}
>  	local kallsymopt;
>  
> -	if [ -n "${CONFIG_SYMBOL_PREFIX}" ]; then
> -		kallsymopt="${kallsymopt} \
> -			    --symbol-prefix=${CONFIG_SYMBOL_PREFIX}"
> +	if [ -n "${CONFIG_SYMBOL_PREFIX_UNDERSCORE}" ]; then

CONFIG_HAVE_UNDERSCORE_SYMBOL_PREFIX




diff --git a/Makefile b/Makefile
index 9dc948d..0b09ba5 100644
--- a/Makefile
+++ b/Makefile
@@ -1398,7 +1398,7 @@ quiet_cmd_rmfiles = $(if $(wildcard $(rm-files)),CLEAN   $(wildcard $(rm-files))
 # Run depmod only if we have System.map and depmod is executable
 quiet_cmd_depmod = DEPMOD  $(KERNELRELEASE)
       cmd_depmod = $(CONFIG_SHELL) $(srctree)/scripts/depmod.sh $(DEPMOD) \
-                   $(KERNELRELEASE) "$(patsubst y,_,$(CONFIG_SYMBOL_PREFIX_UNDERSCORE))"
+                   $(KERNELRELEASE) "$(patsubst y,_,$(CONFIG_HAVE_UNDERSCORE_SYMBOL_PREFIX))"
 
 # Create temporary dir for module support files
 # clean it up only when building all modules
diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index ba043e3..2333cf6 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -14,9 +14,6 @@ config H8300
 	select OLD_SIGACTION
 	select HAVE_UNDERSCORE_SYMBOL_PREFIX
 
-config SYMBOL_PREFIX_UNDERSCORE
-	def_bool y
-
 config MMU
 	bool
 	default n
diff --git a/arch/metag/Kconfig b/arch/metag/Kconfig
index 88272ce..2099617 100644
--- a/arch/metag/Kconfig
+++ b/arch/metag/Kconfig
@@ -1,6 +1,3 @@
-config SYMBOL_PREFIX_UNDERSCORE
-	def_bool y
-
 config METAG
 	def_bool y
 	select EMBEDDED
diff --git a/include/asm-generic/unistd.h b/include/asm-generic/unistd.h
index 80122d4..15c0598 100644
--- a/include/asm-generic/unistd.h
+++ b/include/asm-generic/unistd.h
@@ -18,7 +18,7 @@
  * but it doesn't work on all toolchains, so we just do it by hand
  */
 #ifndef cond_syscall
-#define cond_syscall(x) asm(".weak\t" SYMBOL_NAME_STR(x) "\n\t"	\
-			    ".set\t" SYMBOL_NAME_STR(x) ","	\
-			    SYMBOL_NAME_STR(sys_ni_syscall))
+#define cond_syscall(x) asm(".weak\t" VMLINUX_SYMBOL_STR(x) "\n\t"	\
+			    ".set\t" VMLINUX_SYMBOL_STR(x) ","	\
+			    VMLINUX_SYMBOL_STR(sys_ni_syscall))
 #endif
diff --git a/include/linux/export.h b/include/linux/export.h
index 0080e93..fc83b2a 100644
--- a/include/linux/export.h
+++ b/include/linux/export.h
@@ -13,7 +13,7 @@
  */
 
 /* Some toolchains use a `_' prefix for all user symbols. */
-#ifdef CONFIG_SYMBOL_PREFIX_UNDERSCORE
+#ifdef CONFIG_HAVE_UNDERSCORE_SYMBOL_PREFIX
 #define __VMLINUX_SYMBOL(x) _##x
 #define __VMLINUX_SYMBOL_STR(x) "_" #x
 #define VMLINUX_SYMBOL_PREFIX_STR "_"
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index d767681..0149949 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -74,7 +74,7 @@ kallsyms()
 	info KSYM ${2}
 	local kallsymopt;
 
-	if [ -n "${CONFIG_SYMBOL_PREFIX_UNDERSCORE}" ]; then
+	if [ -n "${CONFIG_HAVE_UNDERSCORE_SYMBOL_PREFIX}" ]; then
 		kallsymopt="${kallsymopt} --symbol-prefix=_"
 	fi
 

