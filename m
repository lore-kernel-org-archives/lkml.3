Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbaGWMAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:00:51 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:34660 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208AbaGWMAt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:00:49 -0400
MIME-Version: 1.0
In-Reply-To: <1406116613-4514-1-git-send-email-viniciustinti@gmail.com>
References: <CALD9WKxTzPYeaAZRrYYuLjNK4VvF1pDxzeDPDvWLuSOpw7_1Tw@mail.gmail.com>
	<1406116613-4514-1-git-send-email-viniciustinti@gmail.com>
Date: Wed, 23 Jul 2014 09:00:49 -0300
Message-ID: <CALD9WKzGmCeCPdwO4hCMtAjEjFoB8=oiQjUktT4PN4ewtDY7XA@mail.gmail.com>
Subject: Re: [PATCH v2] kbuild: add support to generate LLVM bitcode files
From: Tinti <viniciustinti@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, Renato Golin <renato.golin@linaro.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Behan Webster <behanw@converseincode.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 8:56 AM, Vinícius Tinti <viniciustinti@gmail.com> wrote:
> Allows kbuild to generate LLVM bitcode files with the .ll extension.
>
>   # from c code
>   CC=clang make kernel/pid.ll
>
>   # from asm code
>   CC=clang make arch/x86/kernel/preempt.ll
>
> Signed-off-by: Vinícius Tinti <viniciustinti@gmail.com>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> ---
>  .gitignore             |  1 +
>  Makefile               |  6 ++++++
>  scripts/Makefile.build | 14 ++++++++++++++
>  3 files changed, 21 insertions(+)
>
> diff --git a/.gitignore b/.gitignore
> index f4c0b09..c5a7656 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -32,6 +32,7 @@
>  *.lzo
>  *.patch
>  *.gcno
> +*.ll
>  modules.builtin
>  Module.symvers
>
> diff --git a/Makefile b/Makefile
> index 6b27741..7826c33 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1213,6 +1213,8 @@ help:
>         @echo  '                    (default: $$(INSTALL_MOD_PATH)/lib/firmware)'
>         @echo  '  dir/            - Build all files in dir and below'
>         @echo  '  dir/file.[oisS] - Build specified target only'
> +       @echo  '  dir/file.ll     - Build the LLVM bitcode file'
> +       @echo  '                    (requires a compiler support for LLVM bitcode generation)'
>         @echo  '  dir/file.lst    - Build specified mixed source/assembly target only'
>         @echo  '                    (requires a recent binutils and recent build (System.map))'
>         @echo  '  dir/file.ko     - Build module including final link'
> @@ -1483,6 +1485,10 @@ endif
>         $(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
>  %.symtypes: %.c prepare scripts FORCE
>         $(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
> +%.ll: %.c prepare scripts FORCE
> +       $(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
> +%.ll: %.S prepare scripts FORCE
> +       $(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
>
>  # Modules
>  /: prepare scripts FORCE
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index bf3e677..4d97e4f 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -174,6 +174,20 @@ cmd_cc_symtypes_c =                                                         \
>  $(obj)/%.symtypes : $(src)/%.c FORCE
>         $(call cmd,cc_symtypes_c)
>
> +# LLVM bitcode
> +# Generate .ll files from .s and .c
> +quiet_cmd_cc_ll_c = CC $(quiet_modtag)  $@
> +      cmd_cc_ll_c = $(CC) $(c_flags) -emit-llvm -S -o $@ $<
> +
> +$(obj)/%.ll: $(src)/%.c FORCE
> +       $(call if_changed_dep,cc_ll_c)
> +
> +quiet_cmd_as_ll_S = CPP $(quiet_modtag) $@
> +      cmd_as_ll_S = $(CPP) $(a_flags)   -o $@ $<
> +
> +$(obj)/%.ll: $(src)/%.S FORCE
> +       $(call if_changed_dep,as_ll_S)
> +
>  # C (.c) files
>  # The C file is compiled and updated dependency information is generated.
>  # (See cmd_cc_o_c + relevant part of rule_cc_o_c)
> --
> 2.0.1
>

The preempt.s works for me as well the preempt.ll.

The make help now displays about the .ll files but I have not found
other section in Documentation about it. If there is please let me know.
I have also added the *.ll in .gitignore.

Regards

-- 
Simplicity is the ultimate sophistication
