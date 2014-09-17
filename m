Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbaIQBSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 21:18:05 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:43105 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbaIQBSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 21:18:02 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXtYV5xKkTxothuqNb7ra80Be7ZXJ-hDnC6p-bfEPZ=Lw@mail.gmail.com>
References: <1410912351-31273-1-git-send-email-rlarocque@google.com>
	<CALCETrXtYV5xKkTxothuqNb7ra80Be7ZXJ-hDnC6p-bfEPZ=Lw@mail.gmail.com>
Date: Tue, 16 Sep 2014 18:18:00 -0700
Message-ID: <CABgu+=NC1ZMQkV0J2c9-MD1+TAmTjDm4ACZASPnfX2Fwiu5rMQ@mail.gmail.com>
Subject: Re: [PATCH] x86/vdso: Add prctl to set per-process VDSO load
From: Richard Larocque <rlarocque@google.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Filipe Brandenburger <filbranden@google.com>,
        Michael Davidson <md@google.com>, Greg Thelen <gthelen@google.com>,
        X86 ML <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 5:27 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Tue, Sep 16, 2014 at 5:05 PM, Richard Larocque <rlarocque@google.com> wrote:
>> Adds new prctl calls to enable or disable VDSO loading for a process
>> and its children.
>>
>> The PR_SET_DISABLE_VDSO call takes one argument, which is interpreted as
>> a boolean value.  If true, it disables the loading of the VDSO on exec()
>> for this process and any children created after this call.  A false
>> value unsets the flag.
>>
>> The PR_GET_DISABLE_VDSO option returns a non-negative true value if VDSO
>> loading has been disabled for this process, zero if it has not been
>> disabled, and a negative value in case of error.
>>
>> These prctl calls are hidden behind a new Kconfig,
>> CONFIG_VDSO_DISABLE_PRCTL.  This feature is available only on x86.
>>
>> The command line option vdso=0 overrides the behavior of
>> PR_SET_DISABLE_VDSO, however, PR_GET_DISABLE_VDSO will coninue to return
>> whetever setting was last set with PR_SET_DISABLE_VDSO.
>>
>> Signed-off-by: Richard Larocque <rlarocque@google.com>
>> ---
>> This patch is part of some work to better handle times and CRIU migration.
>> I suspect that there are other use cases out there, so I'm offering this
>> patch separately.
>>
>> When considering CRIU migration and times, we put some thought into how
>> to handle the rdtsc instruction.  If we migrate between machines or across
>> reboots, the migrated process will see values that could break its assumptions
>> about how rdtsc is supposed to work.
>
> I don't get it.
>
> If __vdso_clock_gettime returns the wrong value in any scenario, we
> should fix that.  Simiarly, CRIU *already works*, unless there's
> something I don't know of.

Right.  As far as I know, there's nothing wrong with the use of RDTSC
in the vDSO following a migration.  The problem is that some
applications might use RDTSC outside of the vDSO.  If they save the
returned values, then compare pre- and post- migration values, bad
things could happen (in theory).

Anything we do to try to trap and handle the use of RDTSC in wider
userspace will affect its use in the vDSO, too.  In some situations,
it might be nice to run applications with no vDSO and PR_TSC_SIGSEGV,
just to make sure they don't have any heavy reliance on the TSC.  It
would be nice if those applications didn't crash when they called
clock_gettime().

Another alternative is to trap and adjust the RDTSC.  That might be a
viable option for applications that care about reliable RDTSC behavior
and migration, but don't care about performance.  I think it makes
sense to disable the vDSO in that case, rather than trap on every call
that it makes.

> That being said, I would like an option to gate off RDTSC for a
> process and its children in order to make PR_TSC_SIGSEGV more useful.
> All the prerequisites are there now.

Agreed.  That's what this patch is attempting to do, and that's the
main reason why I figured it was worth submitting independent of any
other time-related work.

> What problem are you trying to solve exactly?

Eventually, we'd like to make it so that neither RDTSC nor
CLOCK_MONOTONIC can go backwards following a migration.

The fix for RDTSC starts here.  Building on this patch as a base, we
can either ban it from being used entirely, or write some code to
adjust its value as necessary.

The CLOCK_MONOTONIC fix will be a different patch stack.  We're
currently hoping to do that without disable the vDSO, but that's
another discussion.
