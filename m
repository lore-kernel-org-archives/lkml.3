Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab3K1NbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 08:31:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab3K1NbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 08:31:04 -0500
Date: Thu, 28 Nov 2013 14:31:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <htejun@gmail.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
	userspace child
Message-ID: <20131128133152.GA821@redhat.com>
References: <CAOS58YO_pZzBB+T6FEzNqfZv4_UUQ_QF1n1zxy4u+H_KhW-vJQ@mail.gmail.com> <OF36E72FA9.51146BE3-ON48257C2E.0008BC6D-48257C2E.0008FF9C@zte.com.cn> <20131125121416.GB23829@redhat.com> <OF4CF076F6.04AFF122-ON48257C2F.0009B6E4-48257C2F.000BF905@zte.com.cn> <20131126180420.GA18172@redhat.com> <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn> <20131127183117.GB13098@mtj.dyndns.org> <20131128091358.GH10022@twins.programming.kicks-ass.net> <20131128114542.GA3826@redhat.com> <20131128121748.GN10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128121748.GN10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28, Peter Zijlstra wrote:
>
> On Thu, Nov 28, 2013 at 12:45:42PM +0100, Oleg Nesterov wrote:
> > It has? khelper is a workqueue thread, this flag is set by create_worker().
> >
> > And it does kernel_thread() (not kthread_create()) so the child gets this
> > flag too.
>
> Urgh, but that's still completely wrong. khelper is a singlethread
> workqueue, those should be unbound and therefore should not have this
> flag set at all.

Well. This is debatable, but I leave this to you and Tejun ;)

But:

> In fact, I know people want to set affinity on khelper

This is not that simple. Note that khelper itself is the rescuer thread,
it doesn't not process the works. There are other kworker/u* threads which
run the work queued on khelper_wq. There is a pool of threads.

> to ensure all the
> usermode helper tasks get spawned on the specific system-cpus and leave
> the rest of the system unperturbed.

I _guess_ usermodehelper_init() should use WQ_SYSFS then, and in this case
the user can write to wq_cpumask_store somewhere in /sys/.

Not sure I read this code correctly though, I didn't check.

But PF_NO_SETAFFINITY should be cleared on exec anyway, so I still think
the patch does the right thing.

Oleg.

