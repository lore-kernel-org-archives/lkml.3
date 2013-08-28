Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab3H1VII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 17:08:08 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:45111 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab3H1VIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 17:08:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130828195934.GA13318@ZenIV.linux.org.uk>
References: <CA+55aFw20W9L8HV+VbTRNeQQM-_+aeUhvT9AAod5LGfb-7hE9g@mail.gmail.com>
 <7d1419dda1da70a8ad915f85b093a58b86bcaf3b.1377630856.git.luto@amacapital.net>
 <CA+55aFwtVH+MoG7Emt5V5wy2eDbYOBHBgOywRHFQ+Vm2XZn-Ag@mail.gmail.com>
 <CALCETrVerk6evSngbf1fiD=k6E557KgKNCBF4qYQSCXYrOx0ag@mail.gmail.com>
 <20130828061623.GJ27005@ZenIV.linux.org.uk> <CALCETrUemSDkci_Z=MaZtU9x8ns-4UFwOSn_HNy_2hpQAOf+-Q@mail.gmail.com>
 <20130828195934.GA13318@ZenIV.linux.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 28 Aug 2013 14:07:44 -0700
Message-ID: <CALCETrU99=Ur_noMrtfgpSN-rGdYMSkp6fGPL8Oi+nOe1=AmjA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: Add user_file_or_path_at and use it for truncate
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
        Ingo Molnar <mingo@kernel.org>,
        "security@kernel.org" <security@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 12:59 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Aug 28, 2013 at 12:04:43PM -0700, Andy Lutomirski wrote:
>> On Tue, Aug 27, 2013 at 11:16 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> > On Tue, Aug 27, 2013 at 01:28:27PM -0700, Andy Lutomirski wrote:
>> >> There are also O_PATH fds, and I'm not sure what the semantics of
>> >> O_PATH fds are or should be when they refer to something other than a
>> >> directory.
>> >
>> > O_PATH file just points to specific location in the tree, no more and
>> > no less.
>>
>> I don't know whether ftruncate(some O_PATH fd) should work.  But this
>> probably barely matters.
>
> It shouldn't.  No IO on these guys at all.
>
>> > AFAICS, the *only* cases when we might possibly care are linkat() target,
>> > truncate() and open().  Note, BTW, that right now we *do* allow an attempt
>> > to reopen a file via procfs symlink r/w, even when file had been r/o.
>> > It's subject to permissions on the object being opened, but that's it.
>> >
>> > I'm not sure we can change that - again, it's a user-visible API, and
>> > the change is very likely to break some scripts.  In fact, it's about
>> > as dangerous as a full-blown switch to dup-style semantics for procfs
>> > opens, and it's a lot less attractive.
>> >
>> > For truncate() we would only need to have FMODE_WRITE reported, more or
>> > less the same way as FMODE_FLINK.  And without open() changes it doesn't
>> > buy us anything at all...
>> >
>> > I've no problem with unrolling the user_path_at() in do_sys_truncate()
>> > into an explicit loop by trailing symlinks and checking for indication
>> > left by proc_pid_follow_link(), more or less the same way as with
>> > LOOKUP_LINK in lookup_last().  It's _far_ less invasive than playing
>> > with "oh, here we fill a struct path or maybe a struct file" horrors,
>> > pinning struct file for no reason, etc.
>> >
>> > AFAICS, the real question is whether we dare to change open() behaviour on
>> > /proc/*/fd/*.  I've played with that a bit and I believe that I can do
>> > the switch to dup-style with very localized changes in fs/namei.c and
>> > fs/proc/{base,fd}.c.  Will be even binary compatible kernel-side -
>> > ->atomic_open() returns NULL/ERR_PTR where it used to return 0/-error,
>> > not that we had many instances to convert.  *IF* that variant is not
>> > out of consideration for userland API stability reasons, I would certainly
>> > prefer to go that way; turns out that these days we can pull it off without
>> > black magic in descriptor handling, etc.  Linus?
>>
>> I personally find the check-mode-but-get-a-new-struct-file version to
>> be less weird that the dup approach.  Either approach will break
>> scripts that try to write to /dev/stdin (which is the whole point).
>
> What, breaking existing userland?  IMO that's a thing to avoid, unless we
> have really, really strong reasons not to.  And yes, it goes for both
> variants...  FWIW, I'm not convinced that the reasons you are giving for
> it are strong enough - passing somebody a read-only file descriptor to
> a file they could open for write and relying on their inability to truncate
> the fscker just because it's not reachable via any path they've got search
> permissions to looks like a Bloody Bad Idea(tm), and not only because it won't
> do what you hope it'll do on existing kernels.  It's very easy to fuck up
> and end up with a searchable path to the damn thing; e.g. /proc/<pid>/cwd/foo
> will bypass the grandparent of foo not being searchable for you, etc.
>

This affects O_TMPFILE, for example -- create a file with O_TMPFILE |
O_RDWR and mode 0666 (by accident), write something, then
open("/proc/self/fd/N", O_RDONLY) and send the resulting fd to
someone.  They can't directly write it, but they can reopen it O_RDWR.

I agree that flink is the main issue here, FWIW.  I think that the
current semantics are just too screwed up to make it really safe to
pass around fds with reduced access modes and expect those modes to
stick.

--Andy
