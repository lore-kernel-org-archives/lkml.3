Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbaIQO2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 10:28:30 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:36969 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061AbaIQO23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 10:28:29 -0400
MIME-Version: 1.0
In-Reply-To: <54194A4A.7030104@zytor.com>
References: <1410912351-31273-1-git-send-email-rlarocque@google.com>
 <CALCETrXtYV5xKkTxothuqNb7ra80Be7ZXJ-hDnC6p-bfEPZ=Lw@mail.gmail.com>
 <CABgu+=NC1ZMQkV0J2c9-MD1+TAmTjDm4ACZASPnfX2Fwiu5rMQ@mail.gmail.com>
 <CALCETrWj8Pj8d8YjybvOKG-=xmy-XGFo9cGQ9qn0V4t9Oj+dOw@mail.gmail.com>
 <CADU+-uCguxhkw259MefABuzOxvyK_F6bhwza0YhveCCJxEV8wQ@mail.gmail.com> <54194A4A.7030104@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 17 Sep 2014 07:28:07 -0700
Message-ID: <CALCETrXsx2-1yf6q4OLzBdisr8P1086rNrsAt=WbyJaiT-cMpw@mail.gmail.com>
Subject: Re: [PATCH] x86/vdso: Add prctl to set per-process VDSO load
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Thelen <gthelen@google.com>, X86 ML <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Michael Davidson <md@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Richard Larocque <rlarocque@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Filipe Brandenburger <filbranden@google.com>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 17, 2014 1:46 AM, "H. Peter Anvin" <hpa@zytor.com> wrote:
>
> On 09/16/2014 11:21 PM, Filipe Brandenburger wrote:
> > Hi Andy,
> >
> > On Tue, Sep 16, 2014 at 10:00 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> >> I think that the patch should instead tweak the vvar mapping to tell
> >> the vdso not to use rdtsc.  It should be based on this:
> >
> > I've been working on this approach which extends the vvar from 2 to 3
> > pages. The third page would initially be mapped to a zero page but
> > then through a prctl a task could replace it with a real page that
> > could then be inherited through fork and exec.
> >
> > That would make it possible to have per-task vvar contents.
> >
> > We could use some of those values as flags to indicate whether vdso
> > routines may use RDTSC or not.
> >
> > In the future, we're planning to also use that to store clock offsets
> > so that we can ensure CLOCK_MONOTONIC works after CRIU migration
> > without having to turn off the VDSO or have to always fallback to full
> > syscalls on every case.
> >
> > Do you think that would be a reasonable way to accomplish that?
> >
>
> Why would we need/want per process vvar contents?  It seems better to
> have the code swapped out.

That seems messier from a build perspective.  Also, if we ever want to
switch this dynamically, swapping out data is much easier than
swapping out code.  I think we should be able to replace the vvar page
with the zero page, though.

One tricky bit: currently we can only easily do this on exec, but we
should be able to do it immediately if we start tracking mremap of the
vdso.  Should we make that a prerequisite?  I don't really want this
to end up being permanently weird.

As for an actual post-migration offset, I'd rather add support for
per-mm forced syscall fallback and then get something into the code
timing code before even thinking about an x86 vdso fast path.  I don't
think that a feature like per-mm timing offsets should happen as an
arch-specific thing first.

--Andy

>
>         -hpa
>
>
