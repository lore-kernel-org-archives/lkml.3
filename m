Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625Ab3K1OcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:32:03 -0500
Received: from mail-qe0-f45.google.com ([209.85.128.45]:53294 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757926Ab3K1Ob6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:31:58 -0500
Date: Thu, 28 Nov 2013 09:31:55 -0500
From: Tejun Heo <htejun@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131128143155.GC3925@htj.dyndns.org>
References: <OF4CF076F6.04AFF122-ON48257C2F.0009B6E4-48257C2F.000BF905@zte.com.cn>
 <20131126180420.GA18172@redhat.com>
 <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn>
 <20131127183117.GB13098@mtj.dyndns.org>
 <20131128091358.GH10022@twins.programming.kicks-ass.net>
 <20131128114542.GA3826@redhat.com>
 <20131128121748.GN10022@twins.programming.kicks-ass.net>
 <20131128133152.GA821@redhat.com>
 <20131128133947.GR10022@twins.programming.kicks-ass.net>
 <20131128142359.GA6420@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128142359.GA6420@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 28, 2013 at 03:23:59PM +0100, Oleg Nesterov wrote:
> Yes, the naming is misleading. But it was always misleading.
> "singlethreaded" meant a single thread, yes, but this just reflected the
> implementation details. What it actually meant is: not bound to any cpu,
> and the works can't race with each other.

Way back when it was actually a singlethread, the naming was kinda
okay.  Now it's a deprecated interface.  I just didn't finish
convering the existing ones to alloc_ordered_workqueue().

> create_singlethread_workqueue() still has the same semantics due to
> WQ_UNBOUND && max_active == 1. So in this sense (max_active == 1) it
> is still single threaded, just (iiuc, Tejun can correct me) it does
> not guarantee that the kernel thread which actually runs the work will
> be always the same.

So, the thing with create_singlethread_workqueue() is that the
original implementation guaranteed dedicated execution resource, which
means that it requires WQ_RESCUER in the new (well, newer)
implementation.  Also, singlethread workqueue used to be used not
because singlethreadedness was necessary but just to avoid creating
all the per-cpu workers, which is no longer necessary and actually is
less efficient.  So, converting create_singlethread_workqueue()
instances to the new interface usually involves making the two
determinations.

* Is WQ_RESCUER actually necessary?  If not, WQ_RESCUER will be
  dropped and the task bearing the name of the workqueue will no
  longer exist.

* Is ordered execution necessary?  If not, it can be converted to
  alloc_workqueue() or just to use system_wq.

khelper is special as its attributes get inherited to its children,
so, yeah, we probably wanna keep that one's cpumask set to all.
Hmmm... I think it's already broken.  So, on NUMA machines, unbound
workqueues will be segmented to each NUMA node by default.  If khelper
is gonna keep using workqueue, it should set turn on no_numa attribute
explicitly.  I'll prep a patch.

Thanks.

-- 
tejun
