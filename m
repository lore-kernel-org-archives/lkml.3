Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaGTKCt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 06:02:49 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:32827 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbaGTKCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 06:02:47 -0400
Date: Sun, 20 Jul 2014 12:02:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: =?iso-8859-1?Q?Vin=EDcius?= Tinti <viniciustinti@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Behan Webster <behanw@converseincode.com>
Subject: Re: [PATCH] kbuild: add support to generate LLVM bitcode files
Message-ID: <20140720100239.GA3496@ravnborg.org>
References: <1405733677-16650-1-git-send-email-viniciustinti@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405733677-16650-1-git-send-email-viniciustinti@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 10:34:37PM -0300, Vinícius Tinti wrote:
> Allows kbuild to generate LLVM bitcode files with the .ll extension when
> building with Clang.
> 
>   # c code
>   CC=clang make kernel/pid.ll
> 
>   # asm code
>   CC=clang make arch/arm/kernel/calls.ll
> 
> Signed-off-by: Vinícius Tinti <viniciustinti@gmail.com>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> ---
>  Makefile               |  7 +++++++
>  scripts/Makefile.build | 18 ++++++++++++++++++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index f3c543d..4eb0d14 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1484,6 +1484,13 @@ endif
>  %.symtypes: %.c prepare scripts FORCE
>  	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
>  
> +ifeq ($(COMPILER),clang)
> +%.ll: %.c prepare scripts FORCE
> +	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
> +%.ll: %.S prepare scripts FORCE
> +	$(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
> +endif
Can we drop the test for $(COMPILER) here?
If one try this with gcc then gcc will just fail if it do not support the clang flags supplied.

And help section should be updated to list .ll too.


> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index bf3e677..9ea19d6 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -174,6 +174,14 @@ cmd_cc_symtypes_c =                                                         \
>  $(obj)/%.symtypes : $(src)/%.c FORCE
>  	$(call cmd,cc_symtypes_c)
>  
> +ifeq ($(COMPILER),clang)
> +quiet_cmd_cc_ll_c = CC $(quiet_modtag)  $@
> +cmd_cc_ll_c       = $(CC) $(c_flags) $(DISABLE_LTO) -fverbose-asm -emit-llvm -S -o $@ $<

Can we drop the test for COMPILER here too?
Do -fverbose-asm make sense when generating .ll files?
It looks like a leftover from what you copied.


> +# LLVM bitcode
> +# ---------------------------------------------------------------------------
> +ifeq ($(COMPILER),clang)
> +quiet_cmd_as_ll_S = CPP $(quiet_modtag) $@
> +cmd_as_ll_S       = $(CPP) $(a_flags)   -o $@ $<
> +
> +$(obj)/%.ll: $(src)/%.S FORCE
> +	$(call if_changed_dep,as_ll_S)
> +endif
This chunk belongs together with the other chunk.
There is no reason to separate .S => .ll and .c => .ll rules.

The current rules for .c => .lst etc is a mess and not something to be too
much inspired from.

	Sam
