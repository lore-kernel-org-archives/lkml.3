Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829Ab3K1OXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:23:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab3K1OXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:23:14 -0500
Date: Thu, 28 Nov 2013 15:23:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <htejun@gmail.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
	userspace child
Message-ID: <20131128142359.GA6420@redhat.com>
References: <20131125121416.GB23829@redhat.com> <OF4CF076F6.04AFF122-ON48257C2F.0009B6E4-48257C2F.000BF905@zte.com.cn> <20131126180420.GA18172@redhat.com> <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn> <20131127183117.GB13098@mtj.dyndns.org> <20131128091358.GH10022@twins.programming.kicks-ass.net> <20131128114542.GA3826@redhat.com> <20131128121748.GN10022@twins.programming.kicks-ass.net> <20131128133152.GA821@redhat.com> <20131128133947.GR10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128133947.GR10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28, Peter Zijlstra wrote:
>
> On Thu, Nov 28, 2013 at 02:31:52PM +0100, Oleg Nesterov wrote:
> > On 11/28, Peter Zijlstra wrote:
> > >
> > > On Thu, Nov 28, 2013 at 12:45:42PM +0100, Oleg Nesterov wrote:
> > > > It has? khelper is a workqueue thread, this flag is set by create_worker().
> > > >
> > > > And it does kernel_thread() (not kthread_create()) so the child gets this
> > > > flag too.
> > >
> > > Urgh, but that's still completely wrong. khelper is a singlethread
> > > workqueue, those should be unbound and therefore should not have this
> > > flag set at all.
> >
> > Well. This is debatable, but I leave this to you and Tejun ;)
>
> How can that be debatable? I don't see a single argument in favour of
> doing that; its plain ridiculous.

Let me repeat, I do not pretend I understand the current implementation
in details.

However, I'd like to say that I do not think think this is ridiculous.
I think this is clever.


> > > In fact, I know people want to set affinity on khelper
> >
> > This is not that simple. Note that khelper itself is the rescuer thread,
> > it doesn't not process the works. There are other kworker/u* threads which
> > run the work queued on khelper_wq. There is a pool of threads.
>
> That's just fucked. WTF does singlethreaded mean then?

Yes, the naming is misleading. But it was always misleading.

"singlethreaded" meant a single thread, yes, but this just reflected the
implementation details. What it actually meant is: not bound to any cpu,
and the works can't race with each other.

create_singlethread_workqueue() still has the same semantics due to
WQ_UNBOUND && max_active == 1. So in this sense (max_active == 1) it
is still single threaded, just (iiuc, Tejun can correct me) it does
not guarantee that the kernel thread which actually runs the work will
be always the same.

> A single parent process for all usermode helpers makes so much sense;

This was never true, at least in UMH_WAIT_PROC case.

> not doing it is just weird.

Why?

Oleg.

