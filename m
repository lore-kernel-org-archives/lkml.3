Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbaBSVSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:18:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171AbaBSVSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:18:38 -0500
Message-ID: <1392844700.2165.70.camel@flatline.rdu.redhat.com>
Subject: Re: [ARCH question] Do syscall_get_nr and syscall_get_arguments
 always work?
From: Eric Paris <eparis@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jonas Bonn <jonas.bonn@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-arch <linux-arch@vger.kernel.org>, linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Steve Grubb <sgrubb@redhat.com>
Date: Wed, 19 Feb 2014 16:18:20 -0500
In-Reply-To: <CALCETrXnLfqo=VyaM7TyDAmjXyZDoztzmaNxkLudoSN7OZBd4Q@mail.gmail.com>
References: <CALCETrU6M=Abo1z2cRoZy07-=3bwKiK84gCSMcBPLA1TkXPb8A@mail.gmail.com>
	 <CACM3HyHwrKQAWZRhE2N1VtGKu1xSvcGeuMG1Ag+vzP2BA111cQ@mail.gmail.com>
	 <CALCETrXXnSdyc5VpT8f6uu6kbO1cq4QwdKqr9z8AOhY_wsoBLA@mail.gmail.com>
	 <1392752362.2165.31.camel@flatline.rdu.redhat.com>
	 <CALCETrXnLfqo=VyaM7TyDAmjXyZDoztzmaNxkLudoSN7OZBd4Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-18 at 19:09 -0800, Andy Lutomirski wrote:
> On Tue, Feb 18, 2014 at 11:39 AM, Eric Paris <eparis@redhat.com> wrote:

> > Al just indicated to me that on at least ia64, syscall_get_arguments()
> > is really expensive.  So maybe not a deal breaker, but sounds like we'd
> > lose a lot of performance trying to get them at syscall exit...
> >
> 
> I wonder how slow syscall_get_arguments has to be before it's a real
> problem.  Remember that we only need to call it when we already know
> that an audit record needs to be written (or if a syscall argument is
> used in a filter rule, I suppose -- I'm sure sure whether that's
> possible).

It's possible to include a0-a3 in syscall filter rules.  (Al wasn't
supportive of killing __audit_syscall_entry().  He mentioned in
particular difficulties around audit_get_stamp().  Won't pretend to have
my head wrapped around what he was referring to...

> But I think this is still a bit of a lost cause.  Currently, if I'm
> reading the code correctly, signal delivery to a non-auditd process
> can result in writing an audit event.

So?  The info we collect about the target of the signal is not related
to the changes you are discussing.  The work/collection is done as the
task 'sending' the signal (and will only be emitted on syscall exit)

> If the signal is delivered
> during a syscall, then current code will write an audit record for
> that syscall on syscall exit.

Right, so we only care about if the sender has its audit_context all set
up.  We'll only send a record on syscall exit...

> If we want to preserve that behavior without a syscall audit hook,
> then the signal delivery code needs to know whether it's in the middle
> of a syscall.  AFAIK this is not possible.

Clearly we need a syscall exit hook, I agree with that...

> On the other hand, most interesting signals are probably *not* the
> result of a syscall anyway, so it may make sense to just remove that
> code entirely.
> 
> TBH, as long as something happens to get rid of audit overhead when
> there are no rules, my interest in personally writing something fancy
> to make the nonzero-number-of-rules case have less overhead is rather
> low.

That's fair   :)

> 
> --Andy


