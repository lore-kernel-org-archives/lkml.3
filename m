Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934590Ab3DKOJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:09:38 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:54798 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3DKOJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:09:36 -0400
Date: Thu, 11 Apr 2013 16:11:55 +0200
From: Philip Kranz <philip.kranz@googlemail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Philip Kranz <philip.kranz@googlemail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sebastian Wankerl <sisewank@cip.cs.fau.de>,
        linux-kernel@vger.kernel.org, i4passt@lists.informatik.uni-erlangen.de,
        linux-parisc@vger.kernel.org
Subject: Re: [PATCH] Add non-zero module sections to sysfs
Message-ID: <20130411141155.GA21480@yoda.lan>
References: <1364994499-23708-1-git-send-email-sisewank@cip.cs.fau.de> <87mwtf3ya1.fsf@rustcorp.com.au> <515D4A7F.5070102@cip.cs.fau.de> <87vc81lj7x.fsf@rustcorp.com.au> <1365156435.1970.31.camel@dabdike> <20130406104053.GA24710@yoda.lan> <878v4tbqve.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878v4tbqve.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.14 (2007-03-31)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 01:44:45PM +0930, Rusty Russell wrote:
> Philip Kranz <philip.kranz@googlemail.com> writes:
> > Hello.
> >
> > On Fri, Apr 05, 2013 at 12:07:15PM +0200, James Bottomley wrote:
> >> Just so you know: this isn't a parisc specific problem.  Gcc produces
> >> duplicate section names under various circumstances, but the one that
> >> bites us is -ffunction-sections.  Note that there are proposals to use
> >> -ffunction-sections on all architectures (so we can garbage collect
> >> unused functions) in which case you'll induce the bug identified in
> >> 35dead4235e2b67da7275b4122fed37099c2f462 on every architecture
> >
> > I am not able to produce an object file with duplicate section names
> > using gcc on x86. Even with -ffunction-sections, every section gets a
> > unique name. Is this architecture-specific behaviour of gcc?
> 
> Good point.  ld -r will collapse them into the same section (since gcc
> produces them they have to have the same section attributes).
> 
> You can do it with --unique, but no arch uses that.  PARISC has a
> platform-specific toolchain hack which does that for .text sections.
> (Thanks to Alan Modra for that clue...)

Just for clarification, as we are currently preparing a patch set that
depends on this: Would the patch below be an acceptable solution for
this?

Thanks,
Philip



diff --git a/arch/parisc/kernel/module.c b/arch/parisc/kernel/module.c
index 2a625fb..1fd4411 100644
--- a/arch/parisc/kernel/module.c
+++ b/arch/parisc/kernel/module.c
@@ -341,6 +341,11 @@ int module_frob_arch_sections(CONST Elf_Ehdr *hdr,
                ".PARISC.unwind", 14) == 0)
            me->arch.unwind_section = i;
 
+       /* we produce multiple, empty .text sections, and kallsyms
+       * gets upset.  make non-alloc so it doesn't see them. */
+       if (sechdrs[i].sh_size == 0)
+           sechdrs[i].sh_flags &= ~SHF_ALLOC;
+
        if (sechdrs[i].sh_type != SHT_RELA)
            continue;
 
diff --git a/kernel/module.c b/kernel/module.c
index 3c2c72d..42e0d5a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1316,7 +1316,7 @@ resolve_symbol_wait(struct module *mod,
 #ifdef CONFIG_KALLSYMS
 static inline bool sect_empty(const Elf_Shdr *sect)
 {
-   return !(sect->sh_flags & SHF_ALLOC) || sect->sh_size == 0;
+   return !(sect->sh_flags & SHF_ALLOC);
 }
 
 struct module_sect_attr

