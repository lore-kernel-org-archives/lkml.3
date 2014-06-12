Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310AbaFLNTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:19:45 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:59718 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792AbaFLNTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:19:43 -0400
MIME-Version: 1.0
In-Reply-To: <5d5e221e59be20a3a7ceb99452e74e233383e7b4.1402514715.git.luto@amacapital.net>
References: <sam@ravnborg.org>
	<5d5e221e59be20a3a7ceb99452e74e233383e7b4.1402514715.git.luto@amacapital.net>
Date: Thu, 12 Jun 2014 09:19:43 -0400
X-Google-Sender-Auth: 5guF5qehOHntG_DT-6xq9WnT4qM
Message-ID: <CA+5PVA5rP4cF14-ckD4K4MgBNtfHB+xPg3whEL26JkxegE7qpg@mail.gmail.com>
Subject: Re: [PATCH v2] x86,vdso: Fix vdso_install
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 3:25 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> The filenames are different now.  Inspired by a patch from
> Sam Ravnborg.
>
> Reported-by: Josh Boyer <jwboyer@fedoraproject.org>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  arch/x86/vdso/Makefile | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
> index 9769df0..e3683d6 100644
> --- a/arch/x86/vdso/Makefile
> +++ b/arch/x86/vdso/Makefile
> @@ -9,11 +9,6 @@ VDSOX32-$(CONFIG_X86_X32_ABI)  := y
>  VDSO32-$(CONFIG_X86_32)                := y
>  VDSO32-$(CONFIG_COMPAT)                := y
>
> -vdso-install-$(VDSO64-y)       += vdso.so
> -vdso-install-$(VDSOX32-y)      += vdsox32.so
> -vdso-install-$(VDSO32-y)       += $(vdso32-images)
> -
> -
>  # files to link into the vdso
>  vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o
>
> @@ -176,15 +171,20 @@ VDSO_LDFLAGS = -fPIC -shared $(call cc-ldoption, -Wl$(comma)--hash-style=sysv) \
>  GCOV_PROFILE := n
>
>  #
> -# Install the unstripped copy of vdso*.so listed in $(vdso-install-y).
> +# Install the unstripped copies of vdso*.so.
>  #
> -quiet_cmd_vdso_install = INSTALL $@
> -      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
> -$(vdso-install-y): %.so: $(obj)/%.so.dbg FORCE
> +quiet_cmd_vdso_install = INSTALL $(@:install_%=%)
> +      cmd_vdso_install = cp $< $(MODLIB)/vdso/$(@:install_%=%)
> +
> +vdso_img_insttargets := $(vdso_img_sodbg:%=install_%)
> +
> +$(MODLIB)/vdso: FORCE
>         @mkdir -p $(MODLIB)/vdso
> +
> +$(vdso_img_insttargets): install_%: $(obj)/% $(MODLIB)/vdso FORCE
>         $(call cmd,vdso_install)
>
> -PHONY += vdso_install $(vdso-install-y)
> -vdso_install: $(vdso-install-y)
> +PHONY += vdso_install $(vdso_img_insttargets)
> +vdso_install: $(vdso_img_insttargets) FORCE

OK, so I can't tell from the changelog if this is intentional or not,
but now this installs e.g. vdso64.so.dbg instead of vdso64.so.

[jwboyer@sb vdso]$ pwd
/lib/modules/3.16.0-0.rc0.git3.1.fc21.x86_64/vdso
[jwboyer@sb vdso]$ ls
vdso32-int80.so.dbg  vdso32-syscall.so.dbg  vdso32-sysenter.so.dbg
vdso64.so.dbg
[jwboyer@sb vdso]$

If it's intentional, you might want to make the changelog a bit more verbose.

josh
