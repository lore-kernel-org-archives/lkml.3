Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572AbaFKR01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:26:27 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:42455 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933286AbaFKRYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:24:00 -0400
MIME-Version: 1.0
In-Reply-To: <fe51e9f5c338d33b1a8b20813441538df5e17add.1402503408.git.luto@amacapital.net>
References: <5398749B.4090209@zytor.com>
	<cover.1402503408.git.luto@amacapital.net>
	<fe51e9f5c338d33b1a8b20813441538df5e17add.1402503408.git.luto@amacapital.net>
Date: Wed, 11 Jun 2014 13:23:59 -0400
X-Google-Sender-Auth: Is7wkvmBlun6vp9EmSvk0behV1Q
Message-ID: <CA+5PVA5uPj0JiTLXJAtBt9b9e6aEcJh7ApFRbaCAP0=se89GKA@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86,vdso: Fix vdso_install
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 12:20 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> Rather than monkeying with barely-comprehensible static pattern
> rules, just use an explicit loop.
>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  arch/x86/vdso/Makefile | 20 +++++++-------------
>  1 file changed, 7 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
> index 9769df0..b1c70cc 100644
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
> @@ -176,15 +171,14 @@ VDSO_LDFLAGS = -fPIC -shared $(call cc-ldoption, -Wl$(comma)--hash-style=sysv) \
>  GCOV_PROFILE := n
>
>  #
> -# Install the unstripped copy of vdso*.so listed in $(vdso-install-y).
> +# Install the unstripped copies of vdso*.so listed in $(vdso-install-y).
>  #
> -quiet_cmd_vdso_install = INSTALL $@
> -      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
> -$(vdso-install-y): %.so: $(obj)/%.so.dbg FORCE
> -       @mkdir -p $(MODLIB)/vdso
> -       $(call cmd,vdso_install)
> +quiet_cmd_vdso_install = INSTALL $(sofile)
> +      cmd_vdso_install = cp $(obj)/$(sofile).dbg $(MODLIB)/vdso/$(sofile)
>
> -PHONY += vdso_install $(vdso-install-y)
> -vdso_install: $(vdso-install-y)
> +PHONY += vdso_install
> +vdso_install: $(vdso_img_sodbg:%=$(obj)/%) FORCE
> +       @mkdir -p $(MODLIB)/vdso
> +       @$(foreach sofile,$(vdso_img_sodbg:%.dbg=%),$(call recipe-cmd,vdso_install);)

So this does fix the invocation of 'make vdso_install' and the
resulting files look to be accurate to me, with the glaring exception
that now we get e.g. vdso64.so on x86_64 as the installed file instead
of vdso.so.  How much that actually matters, I have no idea.
Plausibly fixed with a symlink if we really need to perhaps.

josh
