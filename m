Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaBSDJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 22:09:47 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:36578 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbaBSDJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 22:09:45 -0500
MIME-Version: 1.0
In-Reply-To: <1392752362.2165.31.camel@flatline.rdu.redhat.com>
References: <CALCETrU6M=Abo1z2cRoZy07-=3bwKiK84gCSMcBPLA1TkXPb8A@mail.gmail.com>
 <CACM3HyHwrKQAWZRhE2N1VtGKu1xSvcGeuMG1Ag+vzP2BA111cQ@mail.gmail.com>
 <CALCETrXXnSdyc5VpT8f6uu6kbO1cq4QwdKqr9z8AOhY_wsoBLA@mail.gmail.com> <1392752362.2165.31.camel@flatline.rdu.redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 18 Feb 2014 19:09:24 -0800
Message-ID: <CALCETrXnLfqo=VyaM7TyDAmjXyZDoztzmaNxkLudoSN7OZBd4Q@mail.gmail.com>
Subject: Re: [ARCH question] Do syscall_get_nr and syscall_get_arguments
 always work?
To: Eric Paris <eparis@redhat.com>
Cc: Jonas Bonn <jonas.bonn@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-arch <linux-arch@vger.kernel.org>, linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Steve Grubb <sgrubb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 11:39 AM, Eric Paris <eparis@redhat.com> wrote:
> On Fri, 2014-02-07 at 08:40 -0800, Andy Lutomirski wrote:
>> On Fri, Feb 7, 2014 at 4:58 AM, Jonas Bonn <jonas.bonn@gmail.com> wrote:
>> > Hi Andy,
>> >
>> > On 5 February 2014 00:50, Andy Lutomirski <luto@amacapital.net> wrote:
>> >>
>> >> I can't even find the system call entry point on mips.
>> >>
>> >>
>> >> Is there a semi-official answer here?
>> >
>> > I don't have an official answer for you, but when I wanted to do
>> > something with these entry points a couple of years back I discovered
>> > that they aren't very thoroughly implemented across the various
>> > architectures.  I started cleaning this up and can probably dig up
>> > some of this for you if you need it.
>>
>> The syscall_get_xyz functions are certainly implemented and functional
>> in all relevant architectures -- the audit code is already using them.
>>  The thing I'm uncertain about is whether they are usable with no
>> syscall slow path bits set.
>>
>> I guess that, if the syscall restart logic needs to read the argument
>> registers, then they're probably reliably saved...
>
> Al just indicated to me that on at least ia64, syscall_get_arguments()
> is really expensive.  So maybe not a deal breaker, but sounds like we'd
> lose a lot of performance trying to get them at syscall exit...
>

I wonder how slow syscall_get_arguments has to be before it's a real
problem.  Remember that we only need to call it when we already know
that an audit record needs to be written (or if a syscall argument is
used in a filter rule, I suppose -- I'm sure sure whether that's
possible).  As long as syscall_get_nr is fast, which I think it is on
ia64, then the tradeoff might still be a win.

But I think this is still a bit of a lost cause.  Currently, if I'm
reading the code correctly, signal delivery to a non-auditd process
can result in writing an audit event.  If the signal is delivered
during a syscall, then current code will write an audit record for
that syscall on syscall exit.

If we want to preserve that behavior without a syscall audit hook,
then the signal delivery code needs to know whether it's in the middle
of a syscall.  AFAIK this is not possible.

On the other hand, most interesting signals are probably *not* the
result of a syscall anyway, so it may make sense to just remove that
code entirely.

TBH, as long as something happens to get rid of audit overhead when
there are no rules, my interest in personally writing something fancy
to make the nonzero-number-of-rules case have less overhead is rather
low.

--Andy
