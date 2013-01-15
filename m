Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab3AOVIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 16:08:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4503 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab3AOVIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 16:08:04 -0500
X-Authority-Analysis: v=2.0 cv=T70Ovo2Q c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=79wlbEtt-9EA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=pX4miy-IAAsA:10 a=V_axDqPMZ-kZQ1pBRDUA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358284082.4068.22.camel@gandalf.local.home>
Subject: Re: [PATCH] mips: function tracer: Fix broken function tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: Alan Cooper <alcooperx@gmail.com>
Cc: David Daney <ddaney.cavm@gmail.com>, ralf@linux-mips.org,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Tue, 15 Jan 2013 16:08:02 -0500
In-Reply-To: <CAOGqxeUSAikiRpVY=Lsu71DzBU6Mmt7C319NqLOv1WscESq=tw@mail.gmail.com>
References: <1357914810-20656-1-git-send-email-alcooperx@gmail.com>
	 <50F0454D.5060109@gmail.com> <20130115034006.GA3854@home.goodmis.org>
	 <CAOGqxeUSAikiRpVY=Lsu71DzBU6Mmt7C319NqLOv1WscESq=tw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-15 at 12:53 -0500, Alan Cooper wrote:
> On Mon, Jan 14, 2013 at 10:40 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Fri, Jan 11, 2013 at 09:01:01AM -0800, David Daney wrote:
> >>
> >> I thought all CPUs were in stop_machine() when the modifications
> >> were done, so that there is no issue with multi-word instruction
> >> patching.
> >>
> >> Am I wrong about this?
> >>
> >> So really I think you can do two NOP just as easily.
> >
> > The problem with double NOPs is that it can only work if there's no
> > problem executing one nop and a non NOP. Which I think is an issue here.
> >
> >
> > If you have something like:
> >
> >         bl      _mcount
> >         addiu   sp,sp,-8
> >
> > And you convert that to:
> >
> >         nop
> >         nop
> >
> > Now if you convert that back to:
> >
> >         bl      ftrace_caller
> >         addiu   sp,sp,-8
> >
> > then you can have an issue if the task was preempted after that first
> > nop. Because stop_machine() doesn't wait for tasks to exit kernel space.
> > If you have a CONFIG_PREEMPT kernel, a task can be sleeping anywhere.
> > Thus you have a task execute the first nop, get preempted. You update
> > the code to be:
> >
> >         bl      ftrace_caller
> >         addiu   sp,sp,-8
> >
> > When that task gets scheduled back in, it will act like it just
> > executed:
> >
> >         nop
> >         addiu   sp,sp,-8
> >
> > Which is the problem you're trying to solve in the first place.
> >
> > Now that said, There's no reason we need that addiu sp,sp,-8 there.
> > That's just what the mips defined mcount requires. But as you can see
> > above, with dynamic ftrace, the defined mcount is only called at boot
> > up, and never again. That means at boot up you can convert to:
> >
> >         nop
> >         nop
> >
> > and then when you enable tracing just convert it to:
> >
> >         bl      ftrace_caller
> >         nop
> >
> > There's nothing that states what the ftrace caller must be. We can have
> > it do a proper stack update. That is, only at boot up do we need to
> > handle the defined mcount. After that, those instructions are just place
> > holders for our own algorithms. If the addiu was needed for the defined
> > mcount, there's no reason to keep it for our own ftrace_caller.
> >
> > Would that work?
> >
> > -- Steve
> >

Lost for words? :-)

-- Steve


