Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaBIPtZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 10:49:25 -0500
Received: from services.gouders.net ([141.101.32.176]:35523 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaBIPtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 10:49:23 -0500
X-Greylist: delayed 891 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Feb 2014 10:49:22 EST
From: Dirk Gouders <dirk@gouders.net>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] kbuild: Support split debug info
In-Reply-To: <1391900703-18163-1-git-send-email-ak@linux.intel.com> (Andi
	Kleen's message of "Sun, 9 Feb 2014 00:05:03 +0100")
References: <1391900703-18163-1-git-send-email-ak@linux.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Sun, 09 Feb 2014 16:34:09 +0100
Message-ID: <ghbnyg47wu.fsf@lena.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@linux.intel.com> writes:

> This is an alternative approach to lower the overhead of debug info
> (as we discussed a few days ago)
>
> gcc 4.7+ and newer binutils have a new "split debug info" debug info
> model where the debug info is only written once into central ".dwo" files.
>
> This avoids having to copy it around multiple times, from the object
> files to the final executable. It also lowers the disk space
> requirement. In addition it defaults to compressed debug data.
>
> More details here: http://gcc.gnu.org/wiki/DebugFission
>
> This patch adds a new option to enable it. It has to be an option,
> because it'll undoubtedly break everyone's debuginfo packaging scheme.
> gdb/objdump/etc. all still work, if you have new enough versions.
>
> I don't see big compile wins (maybe a second or two faster or so), but the
> object dirs with debuginfo get significantly smaller. My standard kernel
> config (slightly bigger than defconfig) goes from 2.9G disk space
> to 1.1G objdir (without debuginfo reduced). I presume if you are IO limited
> it will also compile faster.
>
> Only problem I've seen so far is that it doesn't play well with ccache.

Hi Andi,

there are some rather superficial things I noticed with this patch.

First, I was wondering if it would probably be a good idea to add the
More-Details-Link to the Kconfig helpt text.  I also noticed
that the commit message references gcc 4.7+ whereas in the help text it
is gcc 4.8+.

Then, I tested the patch and got a trailing whitespace warning when
applying the patch:

"Applying: kbuild: Support split debug info
/usr/src/torvalds/.git/rebase-apply/patch:45: trailing whitespace.
          in the object files and the vmlinux, as it only needs to 
warning: 1 line adds whitespace errors."

I also noticed that `make clean' does not remove all .dwo files.
Probably there are more elegant ways to do that, but this at least works
here (I also tried to use globstar patterns in scripts/Makefile.clean
but felt that wasn't a good idea):

diff --git a/Makefile b/Makefile
index 2f3d9d1..3a41147 100644
--- a/Makefile
+++ b/Makefile
@@ -1076,8 +1076,6 @@ MRPROPER_FILES += .config .config.old .version .old_version $(version_h) \
                  extra_certificates signing_key.x509.keyid             \
                  signing_key.x509.signer
 
-CLEAN_FILES += .*.dwo
-
 # clean - Delete most, but leave enough to build external modules
 #
 clean: rm-dirs  := $(CLEAN_DIRS)
@@ -1324,6 +1322,7 @@ clean: $(clean-dirs)
        @find $(if $(KBUILD_EXTMOD), $(KBUILD_EXTMOD), .) $(RCS_FIND_IGNORE) \
                \( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
                -o -name '*.ko.*' \
+               -o -name '*.dwo' \
                -o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
                -o -name '*.symtypes' -o -name 'modules.order' \
                -o -name modules.builtin -o -name '.tmp_*.o.*' \

Finally, git doesn't know about the .dwo files, so I am wondering if
.gitignore should be updated, too:

diff --git a/.gitignore b/.gitignore
index 7e9932e..cb43ed9 100644
--- a/.gitignore
+++ b/.gitignore
@@ -17,6 +17,7 @@
 *.ko
 *.so
 *.so.dbg
+*.dwo
 *.mod.c
 *.i
 *.lst

Dirk

> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  Makefile          |  6 ++++++
>  lib/Kconfig.debug | 13 +++++++++++++
>  2 files changed, 19 insertions(+)
>
> diff --git a/Makefile b/Makefile
> index 606ef7c..2f3d9d1 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -638,7 +638,11 @@ endif
>  endif
>  
>  ifdef CONFIG_DEBUG_INFO
> +ifdef CONFIG_DEBUG_INFO_SPLIT
> +KBUILD_CFLAGS   += $(call cc-option, -gsplit-dwarf, -g)
> +else
>  KBUILD_CFLAGS	+= -g
> +endif
>  KBUILD_AFLAGS	+= -Wa,--gdwarf-2
>  endif
>  
> @@ -1072,6 +1076,8 @@ MRPROPER_FILES += .config .config.old .version .old_version $(version_h) \
>  		  extra_certificates signing_key.x509.keyid		\
>  		  signing_key.x509.signer
>  
> +CLEAN_FILES += .*.dwo
> +
>  # clean - Delete most, but leave enough to build external modules
>  #
>  clean: rm-dirs  := $(CLEAN_DIRS)
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index a48abea..367a6ba 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -143,6 +143,19 @@ config DEBUG_INFO_REDUCED
>  	  DEBUG_INFO build and compile times are reduced too.
>  	  Only works with newer gcc versions.
>  
> +config DEBUG_INFO_SPLIT
> +	bool "Produce split debuginfo in .dwo files"
> +	depends on DEBUG_INFO
> +	help
> +	  Generate debug info into separate .dwo files. This can be
> +	  faster for building than including the debug information directly
> +	  in the object files and the vmlinux, as it only needs to 
> +	  be stored once to disk, not multiple times in object files.
> +	  Requires recent gcc (4.8+) and recent gdb/binutils.
> +	  Any tool that packages or reads debug information would need
> +	  to know about the .dwo files and include them.
> +	  Currently incompatible with ccache.
> +
>  config ENABLE_WARN_DEPRECATED
>  	bool "Enable __deprecated logic"
>  	default y
