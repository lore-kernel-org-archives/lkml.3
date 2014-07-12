Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbaGLUFR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 16:05:17 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:62938 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaGLUFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 16:05:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140712200136.15788.17192.stgit@zurg>
References: <20140712200136.15788.17192.stgit@zurg>
Date: Sun, 13 Jul 2014 00:05:11 +0400
Message-ID: <CALYGNiPrbknJEVkdvAGZj3rFH=HDbO82kagsdxLW7b=ac=VCyw@mail.gmail.com>
Subject: Re: [PATCH] lib/Kconfig.debug: introduce CONFIG_CC_STACK_USAGE
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damn, I forget to add them to the .gitignore

On Sun, Jul 13, 2014 at 12:01 AM, Konstantin Khlebnikov
<koct9i@gmail.com> wrote:
> This patch adds option for collecting stack usage statistics
> via gcc option '-fstack-usage' (needs gcc 4.6 or newer).
> For each .o file gcc dumps stack-frame sizes into .su file.
>
> File format:
> <file>:<line>:<column>:<function>       <size>  <qualifiers>
>
> select.c:870:5:do_sys_poll      1040    static
> rtnetlink.c:1880:12:rtnl_newlink        552     dynamic
> random.c:1334:1:random_read     664     dynamic,bounded
>
> Quote from the gcc manpage about qualifiers:
>
>     The qualifier "static" means that the function
>     manipulates the stack statically: a fixed number of bytes
>     are allocated for the frame on function entry and
>     released on function exit; no stack adjustments are
>     otherwise made in the function.  The second field is this
>     fixed number of bytes.
>
>     The qualifier "dynamic" means that the function
>     manipulates the stack dynamically: in addition to the
>     static allocation described above, stack adjustments are
>     made in the body of the function, for example to push/pop
>     arguments around function calls.  If the qualifier
>     "bounded" is also present, the amount of these
>     adjustments is bounded at compile time and the second
>     field is an upper bound of the total amount of stack used
>     by the function.  If it is not present, the amount of
>     these adjustments is not bounded at compile time and the
>     second field only represents the bounded part.
>
> In comparison to the scripts/checkstack.pl this method is more accurate.
> It takes into account function arguments, push/pop pairs, frame
> pointers and saved return address. It gives information about all
> functions except purely assember (for example sha1_transform_avx2).
>
> Also this patch adds make target 'stack-usage' which combines all .su
> files into one sorted 'stack-usage'. Also prints top 100 and all unbounded
> dynamic stack frames.
>
> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
> ---
>  Makefile          |   22 +++++++++++++++++++++-
>  lib/Kconfig.debug |    9 +++++++++
>  2 files changed, 30 insertions(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index 2167084..9ba61ee 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -635,6 +635,10 @@ ifneq ($(CONFIG_FRAME_WARN),0)
>  KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
>  endif
>
> +ifdef CONFIG_CC_STACK_USAGE
> +KBUILD_CFLAGS += $(call cc-option,-fstack-usage)
> +endif
> +
>  # Handle stack protector mode.
>  ifdef CONFIG_CC_STACKPROTECTOR_REGULAR
>    stackp-flag := -fstack-protector
> @@ -1228,6 +1232,7 @@ help:
>          echo  ''
>         @echo  'Static analysers'
>         @echo  '  checkstack      - Generate a list of stack hogs'
> +       @echo  '  stack-usage     - Alternative list of stack hogs'
>         @echo  '  namespacecheck  - Name space analysis on compiled kernel'
>         @echo  '  versioncheck    - Sanity check on version.h usage'
>         @echo  '  includecheck    - Check for duplicate included header files'
> @@ -1376,7 +1381,7 @@ clean: $(clean-dirs)
>         $(call cmd,rmfiles)
>         @find $(if $(KBUILD_EXTMOD), $(KBUILD_EXTMOD), .) $(RCS_FIND_IGNORE) \
>                 \( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
> -               -o -name '*.ko.*' \
> +               -o -name '*.ko.*' -o -name '*.su' \
>                 -o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
>                 -o -name '*.symtypes' -o -name 'modules.order' \
>                 -o -name modules.builtin -o -name '.tmp_*.o.*' \
> @@ -1432,6 +1437,21 @@ checkstack:
>         $(OBJDUMP) -d vmlinux $$(find . -name '*.ko') | \
>         $(PERL) $(src)/scripts/checkstack.pl $(CHECKSTACK_ARCH)
>
> +quiet_cmd_cc_stack_usage = SORTING $@
> +cmd_cc_stack_usage = find -name '*.su' | xargs cat | sort -k 2 -n -r > $@
> +
> +stack-usage: FORCE
> +ifndef CONFIG_CC_STACK_USAGE
> +       $(Q)echo >&2 'Please rebuild with CONFIG_CC_STACK_USAGE=y' && false
> +endif
> +       $(call cmd,cc_stack_usage)
> +       $(Q)echo ''
> +       $(Q)echo 'Unbounded dynamic stack frames:'
> +       $(Q)grep '\bdynamic$$' $@
> +       $(Q)echo ''
> +       $(Q)echo 'Top 100 stack frames:'
> +       $(Q)head -100 < $@
> +
>  kernelrelease:
>         @echo "$(KERNELVERSION)$$($(CONFIG_SHELL) $(srctree)/scripts/setlocalversion $(srctree))"
>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 7a638aa..3b30853 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -170,6 +170,15 @@ config FRAME_WARN
>           Setting it to 0 disables the warning.
>           Requires gcc 4.4
>
> +config CC_STACK_USAGE
> +       bool "Collect statistics about stack usage (needs gcc 4.6)"
> +       help
> +         This enables gcc option -fstack-usage which saves information
> +         about stack frames in per-function basis into '.su' files.
> +
> +         Run 'make stack-usage' after building kernel and modules to
> +         combine all information in one file.
> +
>  config STRIP_ASM_SYMS
>         bool "Strip assembler-generated symbols during link"
>         default n
>
