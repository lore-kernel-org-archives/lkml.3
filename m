Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaFKTDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 15:03:39 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:44167 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbaFKTDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 15:03:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140611185119.GA13412@ravnborg.org>
References: <5398749B.4090209@zytor.com> <cover.1402503408.git.luto@amacapital.net>
 <fe51e9f5c338d33b1a8b20813441538df5e17add.1402503408.git.luto@amacapital.net>
 <CA+5PVA5uPj0JiTLXJAtBt9b9e6aEcJh7ApFRbaCAP0=se89GKA@mail.gmail.com> <20140611185119.GA13412@ravnborg.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 11 Jun 2014 12:03:16 -0700
Message-ID: <CALCETrXnGqrPh94zL91um+xC3Hdy1SQmBc6_pOkNBGEmX_2rVw@mail.gmail.com>
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

On Wed, Jun 11, 2014 at 11:51 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Wed, Jun 11, 2014 at 01:23:59PM -0400, Josh Boyer wrote:
>> On Wed, Jun 11, 2014 at 12:20 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> > Rather than monkeying with barely-comprehensible static pattern
>> > rules, just use an explicit loop.
>> >
>> > Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> > ---
>> >  arch/x86/vdso/Makefile | 20 +++++++-------------
>> >  1 file changed, 7 insertions(+), 13 deletions(-)
>> >
>> > diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
>> > index 9769df0..b1c70cc 100644
>> > --- a/arch/x86/vdso/Makefile
>> > +++ b/arch/x86/vdso/Makefile
>> > @@ -9,11 +9,6 @@ VDSOX32-$(CONFIG_X86_X32_ABI)  := y
>> >  VDSO32-$(CONFIG_X86_32)                := y
>> >  VDSO32-$(CONFIG_COMPAT)                := y
>> >
>> > -vdso-install-$(VDSO64-y)       += vdso.so
>> > -vdso-install-$(VDSOX32-y)      += vdsox32.so
>> > -vdso-install-$(VDSO32-y)       += $(vdso32-images)
>> > -
>> > -
>> >  # files to link into the vdso
>> >  vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o
>> >
>> > @@ -176,15 +171,14 @@ VDSO_LDFLAGS = -fPIC -shared $(call cc-ldoption, -Wl$(comma)--hash-style=sysv) \
>> >  GCOV_PROFILE := n
>> >
>> >  #
>> > -# Install the unstripped copy of vdso*.so listed in $(vdso-install-y).
>> > +# Install the unstripped copies of vdso*.so listed in $(vdso-install-y).
>> >  #
>> > -quiet_cmd_vdso_install = INSTALL $@
>> > -      cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
>> > -$(vdso-install-y): %.so: $(obj)/%.so.dbg FORCE
>> > -       @mkdir -p $(MODLIB)/vdso
>> > -       $(call cmd,vdso_install)
>> > +quiet_cmd_vdso_install = INSTALL $(sofile)
>> > +      cmd_vdso_install = cp $(obj)/$(sofile).dbg $(MODLIB)/vdso/$(sofile)
>> >
>> > -PHONY += vdso_install $(vdso-install-y)
>> > -vdso_install: $(vdso-install-y)
>> > +PHONY += vdso_install
>> > +vdso_install: $(vdso_img_sodbg:%=$(obj)/%) FORCE
>> > +       @mkdir -p $(MODLIB)/vdso
>> > +       @$(foreach sofile,$(vdso_img_sodbg:%.dbg=%),$(call recipe-cmd,vdso_install);)
>
> Can we please fix this in a way where we do not need to add stuff to core kbuild.
> If the original approach was used then make took care of the looping
> and the foreach part was not needed.

Would expanding out the cmd macro here be okay?  Or is that too
dependent on kbuild internals?

I can fiddle with static patterns again (ugh).

--Andy
