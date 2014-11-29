Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbaK2Pco (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 10:32:44 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:43009 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaK2Pcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 10:32:42 -0500
MIME-Version: 1.0
In-Reply-To: <87mw7aof2m.fsf@x220.int.ebiederm.org>
References: <b0f6c4df0e8ef8afcc7b786edecb4be8c752941e.1417215468.git.luto@amacapital.net>
 <87mw7aof2m.fsf@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 29 Nov 2014 07:32:20 -0800
Message-ID: <CALCETrVaeVcho=Sk_Tt6W4SKoK=WtOFZwRFAucFmi8Wi1XKGQA@mail.gmail.com>
Subject: Re: [RFC PATCH] proc, pidns: Add highpid
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Herrmann <dh.herrmann@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        criu@openvz.org, Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 7:34 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>
>> Pid reuse is common, which means that it's difficult or impossible
>> to read information about a pid from /proc without races.
>
> Sigh.
>
> What we need are not race free pids, but a file descriptor based process
> management api.  Possibly one that starts by handing you a proc
> directory.

I agree completely, and the Capsicum stuff from FreeBSD would probably
be a very good start here.

>
> Which probably means that we need a proc file we can write to and send
> signals to a process, and another proc file we can select on and wait
> for the process to exit.

That too.  In fact, I have an old patch that went nowhere that makes
the proc directory fd itself pollable.

>
> Making pids bigger just looks like bandaid.
>
> Remember evovle things in the direction of an object capability system
> things wind up being more maintainable.

Yes, but this really is intended to be a much better bandaid than what
people currently use.

I'm aiming this at two main use cases that aren't going to switch to
using fds any time soon.  One is shell stuff and PID files.  If we can
put something like "12345@81726162" in /run/lock/foo.pid and safely
kill `cat /run/lock/foo.pid`, that would be nice (even though sensible
users don't use pid files any more, there are *tons* of things that
still use them).  This could also be used for diagnostics.  Suppose
the kernel log indicates a misbehaving pid.  There's currently no
race-free way to poke at those pids.

The much more pressing issue is that there are apparently programs
that think that checking the process's starttime is a good idea for
avoiding PID reuse races.  Both kdbus v1 and v2 do this, hopefully
only for diagnostics.  This is, IMO, completely unacceptable, but I
really don't expect kdbus to start passing even more fds around when
they'll be ignored most of the time.  So, if kdbus is going to be
merged at some point, I'd like to give it the opportunity to name the
sender of a message in a way that is only mildly dangerous (in non
race-related ways) as opposed to being totally broken.

Now if someone wants to implement real light-weight capability-ish fds
in Linux, that would be neat.  IIRC someone tried several years ago
using fds with some high bits set, but it never went anywhere.

FWIW, given that I seem to be the most vocal reviewer of the kdbus
patches, I feel like it's nice to offer some assistance in a piece of
the kdbus stuff that I think really would benefit from a new kernel
feature.

--Andy
