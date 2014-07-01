Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366AbaGAREu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 13:04:50 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:61779 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334AbaGAREt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 13:04:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "Pinski, Andrew" <Andrew.Pinski@caviumnetworks.com>,
        Andrew Pinski <apinski@cavium.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 22/24] ARM64:ILP32: Use a seperate syscall table as a few syscalls need to be using the compat syscalls.
Date: Tue, 01 Jul 2014 19:04:41 +0200
Message-ID: <4834150.MH2srkQr01@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140701165041.GU18313@arm.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com> <4268617.3t49DXZOBa@wuerfel> <20140701165041.GU18313@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ZjifjfjeWT5bjOm6F1t/EW5t5YGDyq7VaFW7nEFi4r1
 a2S41FzfXha+AaGLj4CZwzDKysSDggWOe64GM+WZfoR1Q6aZjx
 FjlerYY+Jpp0+Y7epGoDiWlKIjU6Ea7Noq0cWf/6sM1FRA8H+O
 8xiPdJbYWeBjXcRXBFsbnVTzey8QNRQBr/Ug7UrbBtW1UEY1Nk
 SHuaZduMwgO8v469DvZh80MhbbaTlPzqoC+br9vf3Wb1AiIRFw
 m/e1LOEdGOcNeqGMsamtO4DYcGkKkeZE/8uq44B7yZPyFQPySx
 0AjFQECAiKlDwhIiRp5OC1Dv9jvusHX0tLW1UV/9OXRFbPgWPi
 J04zZkHpffrbFiy1VhnQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 July 2014 17:50:41 Catalin Marinas wrote:
> On Tue, Jul 01, 2014 at 05:38:12PM +0100, Arnd Bergmann wrote:
> > On Tuesday 01 July 2014 15:30:51 Pinski, Andrew wrote:
> > > > On Jul 1, 2014, at 8:07 AM, "Catalin Marinas" <catalin.marinas@arm.com> wrote:
> > > >> On Sat, May 24, 2014 at 12:02:17AM -0700, Andrew Pinski wrote:
> > > >> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> > > >> index 1e1ebfc..8241ffe 100644
> > > >> --- a/arch/arm64/kernel/entry.S
> > > >> +++ b/arch/arm64/kernel/entry.S
> > > >> @@ -620,9 +620,14 @@ ENDPROC(ret_from_fork)
> > > >>  */
> > > >>    .align    6
> > > >> el0_svc:
> > > >> -    adrp    stbl, sys_call_table        // load syscall table pointer
> > > >>    uxtw    scno, w8            // syscall number in w8
> > > >>    mov    sc_nr, #__NR_syscalls
> > > >> +#ifdef CONFIG_ARM64_ILP32
> > > >> +    get_thread_info tsk
> > > >> +    ldr    x16, [tsk, #TI_FLAGS]
> > > >> +    tbnz    x16, #TIF_32BIT_AARCH64, el0_ilp32_svc // We are using ILP32
> > > >> +#endif
> > > >> +    adrp    stbl, sys_call_table        // load syscall table pointer
> > > > 
> > > > This adds a slight penalty on the AArch64 SVC entry path. I can't tell
> > > > whether that's visible or not but I think the x86 guys decided to set an
> > > > extra bit to the syscall number to distinguish it from native calls.
> > 
> > IIRC the intention on x86 was that you should always be able to call
> > any of the three syscall ABIs (x86-32, x86-64, x32) from any process
> > by passing the right number, for flexibility.
> 
> I don't see how this is useful though. Do you happen to have more
> information?

It's been a decade since this code was merged, so my memory isn't very
good here. I believe one of the main reasons was being able to run
emulation layers in user space that make use of the kernel helpers.

Another use case might be an application that wants to use the native
ioctl interface for a driver that does not have a (efficient) compat
ioctl handler.

	Arnd
