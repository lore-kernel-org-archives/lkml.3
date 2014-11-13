Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548AbaKMKWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:22:34 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:59372 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbaKMKWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:22:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "roland@hack.frob.com" <roland@hack.frob.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ulrich.Weigand@de.ibm.com,
        Andreas Krebbel <Andreas.Krebbel@de.ibm.com>
Subject: Re: [RFC] ptrace: add generic SET_SYSCALL request
Date: Thu, 13 Nov 2014 11:21:28 +0100
Message-ID: <3899236.yrOvvrZHD6@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54645799.5010409@linaro.org>
References: <1415346443-28915-1-git-send-email-takahiro.akashi@linaro.org> <6358312.yt5WU3kBm9@wuerfel> <54645799.5010409@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:WjUIHCcFhLP7+/NOZhFb89jE6OL31crRGsN88A8QkFM
 dcZ2RgF827dao7NPK7OUFY4nqIhvmcszJmludpND9+VK/zLnsV
 nR/1OpoReu0rfJ5YlcQT+JNohMKgy+ufqh62b472Beg4uPK505
 NmkmZtLeG8KAdE6E3cjCqAja4fzCPAzbX3zdOYMC7SLkP6lKHg
 LOrHcYhHOuGXH8Aa4PdDhfpHdpClJTVj+8H5756JULy7P9Vzy8
 fXzWyeVLEbXLZ/lj9/eyOAp6nJ58072t/Lx1ewNqN24PcPNU5h
 lkuUYOmEYBTpmDQJyvuMjKi/GVIzWq3funb51iClu5Hj81jyaV
 uk5HrkXEKCXUPucLz1d8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 November 2014 16:02:49 AKASHI Takahiro wrote:
> On 11/12/2014 08:19 PM, Arnd Bergmann wrote:
> > On Wednesday 12 November 2014 11:13:52 Will Deacon wrote:
> >> On Wed, Nov 12, 2014 at 11:06:59AM +0000, AKASHI Takahiro wrote:
> >>> On 11/12/2014 08:00 PM, Will Deacon wrote:
> >>>> On Wed, Nov 12, 2014 at 10:46:01AM +0000, AKASHI Takahiro wrote:
> >>>>> On 11/07/2014 11:04 PM, Oleg Nesterov wrote:
> >>>>>> To me the fact that PTRACE_SET_SYSCALL can be undefined and syscall_set_nr()
> >>>>>> is very much arch-dependant (but most probably trivial) means that this  code
> >>>>>> should live in arch_ptrace().
> >>>>>
> >>>>> Thinking of Oleg's comment above, it doesn't make sense neither to define generic
> >>>>> NT_SYSTEM_CALL (user_regset) in uapi/linux/elf.h and implement it in ptrace_regset()
> >>>>> in kernel/ptrace.c with arch-defined syscall_(g)set_nr().
> >>>>>
> >>>>> Since we should have the same interface on arm and arm64, we'd better implement
> >>>>> ptrace(PTRACE_SET_SYSCALL) locally on arm64 for now (as I originally submitted).
> >>>>
> >>>> I think the regset approach is cleaner. We already do something similar for
> >>>> TLS. That would be implemented under arch/arm64/ with it's own NT type.
> >>>
> >>> Okey, so arm64 goes its own way
> >>> Or do you want to have a similar regset on arm, too?
> >>> (In this case, NT_ARM_SYSTEM_CALL can be shared in uapi/linux/elf.h)
> >>
> >> Just do arm64. We already have the dedicated request for arch/arm/.
> >
> > I wonder if we should define NT_ARM64_SYSTEM_CALL to the same value
> > as NT_S390_SYSTEM_CALL (0x307), or even define it as an architecture-
> > independent NT_SYSTEM_CALL number with that value, so other architectures
> > don't have to introduce new types when they also want to implement it.
> 
> I digged into gdb code (gdb/bfd/elf.c):
> https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;a=blob;f=bfd/elf.c;h=8b207ad872a3992381e93bdfa0a75ef444651613;hb=HEAD
>    elf_parse_notes()->elfcore_grok_note()->elfcore_grok_s390_system_call()
> 
> It seems to me that NT_S390_SYSTEM_CALL(=0x307) is recognized as a s390 specific
> value (without checking for machine type). So thinking of potential conflict, it might not be
> a good idea to use this value as a common number (of NT_SYSTEM_CALL).
> It's very unlikely that a "note" section for NT_(S390_)SYSTEM_CALL appears in a coredump file, though.
>
> What do you think?

(adding Ulrich and Andreas)

This code was introduced by http://sourceware-org.1504.n7.nabble.com/rfa-s390-bfd-part-Support-extended-register-sets-td50072.html

I have to admit that I don't really understand gdb internals, but from
a first look I get the impression that it will just do the right thing
if you reuse NT_S390_SYSTEM_CALL on ARM64 with the same semantics.

If not, we should indeed have a different number for it and duplicate that
code.

	Arnd
