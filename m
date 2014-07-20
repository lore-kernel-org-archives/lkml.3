Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbaGTTEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 15:04:43 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:42947 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbaGTTEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 15:04:41 -0400
Date: Sun, 20 Jul 2014 21:04:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Dirk Gouders <dirk@gouders.net>,
        mmarek@suse.cz
Subject: Re: [PATCH 1/2] kbuild: Support split debug info v3
Message-ID: <20140720190420.GA4630@ravnborg.org>
References: <1405466172-17055-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405466172-17055-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi.

On Wed, Jul 16, 2014 at 01:16:11AM +0200, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> This is an alternative approach to lower the overhead of debug info
> (as we discussed a few days ago)
> 
> gcc 4.7+ and newer binutils have a new "split debug info" debug info
> model where the debug info is only written once into central ".dwo" files.
> 
> This avoids having to copy it around multiple times, from the object
> files to the final executable. It also lowers the disk space
> requirements. In addition it defaults to compressed debug data.
> 
> More details here: http://gcc.gnu.org/wiki/DebugFission
> 
> This patch adds a new option to enable it. It has to be an option,
> because it'll undoubtedly break everyone's debuginfo packaging scheme.
> gdb/objdump/etc. all still work, if you have new enough versions.
> 
> I don't see big compile wins (maybe a second or two faster or so), but the
> object dirs with debuginfo get significantly smaller. My standard kernel
> config (slightly bigger than defconfig) shrinks from 2.9G disk space
> to 1.1G objdir (with non reduced debuginfo). I presume if you are IO limited
> the compile time difference will be larger.
> 
> Only problem I've seen so far is that it doesn't play well with older
> versions of ccache (apparently fixed, see
> https://bugzilla.samba.org/show_bug.cgi?id=10005)
> 
> v2: various fixes from Dirk Gouders. Improve commit message slightly.
> v3: Fix clean rules and improve Kconfig slightly
> Cc: Dirk Gouders <dirk@gouders.net>
> Cc: mmarek@suse.cz
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  .gitignore        |  1 +
>  Makefile          |  5 +++++
>  lib/Kconfig.debug | 13 +++++++++++++
>  3 files changed, 19 insertions(+)
> 
> diff --git a/.gitignore b/.gitignore
> index f4c0b09..e213b27 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -34,6 +34,7 @@
>  *.gcno
>  modules.builtin
>  Module.symvers
> +*.dwo
>  
>  #
>  # Top-level generic files
> diff --git a/Makefile b/Makefile
> index 1317563..953659e 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -683,9 +683,13 @@ endif
>  endif
>  
>  ifdef CONFIG_DEBUG_INFO
> +ifdef CONFIG_DEBUG_INFO_SPLIT
> +KBUILD_CFLAGS   += $(call cc-option, -gsplit-dwarf, -g)
> +else
>  KBUILD_CFLAGS	+= -g
>  KBUILD_AFLAGS	+= -Wa,-gdwarf-2
>  endif
> +endif

Why are as only called with -Wa,-gdwarf-2 in the non-split case?
Is this a bug or intentional?
If it is intentional then it is not explained.


>  
>  ifdef CONFIG_DEBUG_INFO_REDUCED
>  KBUILD_CFLAGS 	+= $(call cc-option, -femit-struct-debug-baseonly) \
> @@ -1371,6 +1375,7 @@ clean: $(clean-dirs)
>  	@find $(if $(KBUILD_EXTMOD), $(KBUILD_EXTMOD), .) $(RCS_FIND_IGNORE) \
>  		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
>  		-o -name '*.ko.*' \
> +		-o -name '*.dwo'  \
>  		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
>  		-o -name '*.symtypes' -o -name 'modules.order' \
>  		-o -name modules.builtin -o -name '.tmp_*.o.*' \
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 7a638aa..fb07c33 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -143,6 +143,19 @@ config DEBUG_INFO_REDUCED
>  	  DEBUG_INFO build and compile times are reduced too.
>  	  Only works with newer gcc versions.
>  
> +config DEBUG_INFO_SPLIT
> +	bool "Produce split debuginfo in .dwo files"

Jut nitpicking here - but please be consistent with debuginfo.
If it is one or two words.

> +	depends on DEBUG_INFO
> +	help
> +	  Generate debug info into separate .dwo files. This can be
> +	  faster for building than including the debug information directly
Here the "faster" part is promoted.
But in your cover letter you actually highlight the "smaller" case
as more significant.
Maybe include info on both positive items.

> +	  in the object files and the vmlinux, as it only needs to
> +	  be stored once to disk, not multiple times in object files.
> +	  Requires recent gcc (4.7+) and recent gdb/binutils.
> +	  Any tool that packages or reads debug information would need
> +	  to know about the .dwo files and include them.
> +	  Incompatible with older versions of ccache.


	Sam
