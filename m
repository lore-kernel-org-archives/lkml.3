Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab3DEFF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 01:05:57 -0400
Received: from ozlabs.org ([203.10.76.45]:57810 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab3DEFF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 01:05:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sebastian Wankerl <sisewank@cip.cs.fau.de>
Cc: Sebastian Wankerl <sisewank@cip.cs.fau.de>, linux-kernel@vger.kernel.org,
        Philip Kranz <philip.kranz@googlemail.com>,
        i4passt@lists.informatik.uni-erlangen.de, linux-parisc@vger.kernel.org
Subject: Re: [PATCH] Add non-zero module sections to sysfs
In-Reply-To: <515D4A7F.5070102@cip.cs.fau.de>
References: <1364994499-23708-1-git-send-email-sisewank@cip.cs.fau.de> <87mwtf3ya1.fsf@rustcorp.com.au> <515D4A7F.5070102@cip.cs.fau.de>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 05 Apr 2013 14:30:50 +1030
Message-ID: <87vc81lj7x.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Wankerl <sisewank@cip.cs.fau.de> writes:
> On 04/04/13 03:00, Rusty Russell wrote:
>> Sebastian Wankerl <sisewank@cip.cs.fau.de> writes:
>>> Add non-zero module sections to sysfs on architectures unequal to PARISC.
>>> KGDB needs all module sections for proper module debugging. Therefore, commit 
>>> 35dead4235e2b67da7275b4122fed37099c2f462 is revoked except for PARISC
>>> architecture.
>> #ifdef CONFIG_PARISC in the middle of kernel/module.c is super-ugly, and
>> wrong.
>
> I don't see why this is wrong. It used to load all sections to sysfs
> until the patch mentioned. Actually, it is the PARISC build chain which
> is broken.

Exactly.  Don't workaround it here, revert it and put the
duplicate-section-name fixup in parisc where it belongs.

Assuming parisc still produces these dup sections: that patch is 4 years
old now.

Untested:

diff --git a/arch/parisc/kernel/module.c b/arch/parisc/kernel/module.c
index 2a625fb..28d32a2 100644
--- a/arch/parisc/kernel/module.c
+++ b/arch/parisc/kernel/module.c
@@ -341,6 +341,11 @@ int module_frob_arch_sections(CONST Elf_Ehdr *hdr,
 			    ".PARISC.unwind", 14) == 0)
 			me->arch.unwind_section = i;
 
+		/* we produce multiple, empty .text sections, and kallsyms
+		 * gets upset.  make non-alloc so it doesn't see them. */
+		if (sechdrs[i].sh_size == 0)
+			sechdrs[i].sh_flags &= ~SHF_ALLOC;
+
 		if (sechdrs[i].sh_type != SHT_RELA)
 			continue;
 
>> My preference would be to fix kgdb.  If the section is empty, what need
>> does it have to examine it?
>
> GDB needs to know all sections of the binary and its addresses.

Why?  Does something refer to this empty section?  Why has noone noticed
this since 2009?

> It is generally useful to be able to check up all sections of the binary
> regardless if they are empty or not so one can see the binary's
> structure.

A zero-length section doesn't change the binary's structure.  You don't
see non-SHF_ALLOC sections either.

Cheers,
Rusty.
