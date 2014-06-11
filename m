Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaFKTTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:19:00 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:56645 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaFKTS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:18:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140611191609.GA16069@ravnborg.org>
References: <5398749B.4090209@zytor.com> <cover.1402503408.git.luto@amacapital.net>
 <fe51e9f5c338d33b1a8b20813441538df5e17add.1402503408.git.luto@amacapital.net>
 <CA+5PVA5uPj0JiTLXJAtBt9b9e6aEcJh7ApFRbaCAP0=se89GKA@mail.gmail.com>
 <20140611185119.GA13412@ravnborg.org> <CALCETrXnGqrPh94zL91um+xC3Hdy1SQmBc6_pOkNBGEmX_2rVw@mail.gmail.com>
 <20140611191609.GA16069@ravnborg.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 11 Jun 2014 12:18:36 -0700
Message-ID: <CALCETrVoB12wCssGPQhW60T4NHAin4jC_A=yt0sSWY9zaUbW9g@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86,vdso: Fix vdso_install
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Michal Marek <mmarek@suse.cz>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 12:16 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>> >
>> > Can we please fix this in a way where we do not need to add stuff to core kbuild.
>> > If the original approach was used then make took care of the looping
>> > and the foreach part was not needed.
> Following is my first quick approach.
> It reuses the old - a little complex logic to do the looping and copying.
> Thsi is only tested on my i386 box / build.
>
>         Sam
>
>
> diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
> index 9769df0..39fb152 100644
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
> @@ -179,12 +174,12 @@ GCOV_PROFILE := n
>  # Install the unstripped copy of vdso*.so listed in $(vdso-install-y).
>  #
>  quiet_cmd_vdso_install = INSTALL $@
> -      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
> -$(vdso-install-y): %.so: $(obj)/%.so.dbg FORCE
> +      cmd_vdso_install = cp $(obj)/$@ $(MODLIB)/vdso/$(@:.dbg=)


> +$(vdso_img_sodbg): %.so.dbg: $(obj)/%.so.dbg FORCE
>         @mkdir -p $(MODLIB)/vdso
>         $(call cmd,vdso_install)

The part that scares me is that this rule defines targets with names
like vdso64.so.dbg, which are the names of actual files (admittedly,
they're missing the path, but still).  This seems fragile.

>
> -PHONY += vdso_install $(vdso-install-y)
> -vdso_install: $(vdso-install-y)
> +PHONY += vdso_install $(vdso_img_sodbg)
> +vdso_install: $(vdso_img_sodbg)
>
>  clean-files := vdso32-syscall* vdso32-sysenter* vdso32-int80*
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
