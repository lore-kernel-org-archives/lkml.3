Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbbANS2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 13:28:10 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:49542 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbbANS2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 13:28:09 -0500
MIME-Version: 1.0
In-Reply-To: <20150114165151.GA3479@codeblueprint.co.uk>
References: <5491B4A8.905@amacapital.net> <CALCETrUyw5_E+FN8o8ZsOxN5XG81-Q8MVzeUHPZ_XBM+ifi6_w@mail.gmail.com>
 <20141231183739.GA28946@console-pimps.org> <20150114165151.GA3479@codeblueprint.co.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 14 Jan 2015 10:27:47 -0800
Message-ID: <CALCETrWOxPwoL0zo0UZMk=05uAEqgY-Xovk1=JHwbVtinx3u3w@mail.gmail.com>
Subject: Re: EFI mixed mode + perf = rampant triple faults
To: Matt Fleming <matt@console-pimps.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 8:51 AM, Matt Fleming <matt@console-pimps.org> wrote:
> On Wed, 31 Dec, at 06:37:39PM, Matt Fleming wrote:
>> On Wed, 17 Dec, at 08:54:56AM, Andy Lutomirski wrote:
>> > > As far as I know, the only way to have continuously functional interrupt
>> > > handling across a long mode transition is to install an interrupt vector
>> > > table and hope that CPUs actually do something intelligent when
>> > > receiving an interrupt with LME=1, LMA=1, and PG=0.  Yuck.
>> > >
>> > > Could we get away with issuing 32-bit EFI calls in compat mode, i.e.
>> > > with a 32-bit CPL0 CS but while still in long mode?  I think that
>> > > delivery of an IST interrupt (which includes both NMI and MCE) will
>> > > correctly switch to a fully valid 64-bit state and would correctly
>> > > switch back when we execute IRET at the end.  (Am I missing some reason
>> > > that switching bitness without a privilege level change doesn't work
>> > > well?  I haven't thought of anything, other than the lack of SS/SP controls
>> > > on intra-ring interrupts, but that shouldn't be an issue here.)
>> > >
>> > > As an added benefit, this would considerably simplify the code.
>>
>> I can't immediately think of a reason that this wouldn't work, but I've
>> Cc'd more x86 folks for additional insight.
>>
>> I will schedule some time to look into this issue in the new year.
>> Thanks Andy.
>
> I finally got some time to look into this, and running with
> __KERNEL32_CS seems to work fine at runtime both with Qemu + 32-bit OVMF
> and on my ASUS T100. Manually triggering an MCE exception immediately
> before invoking the firmware service recovers gracefully.

How are you manually triggering an MCE?  I've been playing with some
MCE stuff recently, but the only reasonably reliable way I know of to
trigger an MCE is using WHEA, and I don't have a box with WHEA, and I
assume your ASUS T100 doesn't either.

>
> Where this won't work so well is at boot time before we jump to the
> kernel proper. There, we still need to restore the firmware's GDT so
> that interrupts are serviced correctly before ExitBootServices() (in
> particular, ia32 Tianocore assumes __KERNEL_CS is a 32-bit CS).

Tianocore makes assumptions about the kernel's GDT layout?  Yuck.

--Andy
