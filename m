Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbaISV0L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 17:26:11 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:37418 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234AbaISV0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 17:26:06 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXpB4qOS+JUBqJnTY8JUfQ=A6DaebU6e=32sSv=0c0QCg@mail.gmail.com>
References: <1410912351-31273-1-git-send-email-rlarocque@google.com>
	<CALCETrXtYV5xKkTxothuqNb7ra80Be7ZXJ-hDnC6p-bfEPZ=Lw@mail.gmail.com>
	<CABgu+=NC1ZMQkV0J2c9-MD1+TAmTjDm4ACZASPnfX2Fwiu5rMQ@mail.gmail.com>
	<CALCETrWj8Pj8d8YjybvOKG-=xmy-XGFo9cGQ9qn0V4t9Oj+dOw@mail.gmail.com>
	<CADU+-uCguxhkw259MefABuzOxvyK_F6bhwza0YhveCCJxEV8wQ@mail.gmail.com>
	<54194A4A.7030104@zytor.com>
	<CALCETrXsx2-1yf6q4OLzBdisr8P1086rNrsAt=WbyJaiT-cMpw@mail.gmail.com>
	<CALCETrXpB4qOS+JUBqJnTY8JUfQ=A6DaebU6e=32sSv=0c0QCg@mail.gmail.com>
Date: Fri, 19 Sep 2014 14:26:05 -0700
Message-ID: <CABgu+=O6y+ELX=dxpFPkGhLjFpuAoY4+z6A9425889vFyfTmuw@mail.gmail.com>
Subject: Re: [PATCH] x86/vdso: Add prctl to set per-process VDSO load
From: Richard Larocque <rlarocque@google.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Greg Thelen <gthelen@google.com>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Michael Davidson <md@google.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Filipe Brandenburger <filbranden@google.com>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 12:27 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Wed, Sep 17, 2014 at 7:28 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Sep 17, 2014 1:46 AM, "H. Peter Anvin" <hpa@zytor.com> wrote:
>>>
>>> On 09/16/2014 11:21 PM, Filipe Brandenburger wrote:
>>> > Hi Andy,
>>> >
>>> > On Tue, Sep 16, 2014 at 10:00 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> >> I think that the patch should instead tweak the vvar mapping to tell
>>> >> the vdso not to use rdtsc.  It should be based on this:
>>> >
>>> > I've been working on this approach which extends the vvar from 2 to 3
>>> > pages. The third page would initially be mapped to a zero page but
>>> > then through a prctl a task could replace it with a real page that
>>> > could then be inherited through fork and exec.
>>> >
>>> > That would make it possible to have per-task vvar contents.
>>> >
>>> > We could use some of those values as flags to indicate whether vdso
>>> > routines may use RDTSC or not.
>>> >
>>> > In the future, we're planning to also use that to store clock offsets
>>> > so that we can ensure CLOCK_MONOTONIC works after CRIU migration
>>> > without having to turn off the VDSO or have to always fallback to full
>>> > syscalls on every case.
>>> >
>>> > Do you think that would be a reasonable way to accomplish that?
>>> >
>>>
>>> Why would we need/want per process vvar contents?  It seems better to
>>> have the code swapped out.
>>
>> That seems messier from a build perspective.  Also, if we ever want to
>> switch this dynamically, swapping out data is much easier than
>> swapping out code.  I think we should be able to replace the vvar page
>> with the zero page, though.
>>
>> One tricky bit: currently we can only easily do this on exec, but we
>> should be able to do it immediately if we start tracking mremap of the
>> vdso.  Should we make that a prerequisite?  I don't really want this
>> to end up being permanently weird.
>
> I have this (special mapping tracking) 3/4 implemented.  I'm planning
> on making it fully functional for 64-bit programs and almost correct
> for 32-bit.  (You'll still crash if you have multiple threads, you use
> sysenter, and you remap the vdso, but I think that this is essentially
> unavoidable until someone lets mremap work on multiple vmas at once.)
>

Thanks!  I look forward to seeing the result.

I have some per-process clock offset patches that currently work only
when the vDSO is disabled.  It sounds like your patches will provide a
clean solution to deal with that issue.  I'll try to rebase my work on
top of your changes when they're ready.

We've also got some patches to apply an offset to the TSC that could
benefit from your changes, but I guess there's not much appetite for
merging them.  That's fine with me.  I don't see any need for that
feature until we have a few examples of applications that could be
broken by TSC changes during migration.
