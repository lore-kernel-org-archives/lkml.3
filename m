Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab3K1OFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:05:51 -0500
Received: from mail-qe0-f51.google.com ([209.85.128.51]:37248 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757926Ab3K1OFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:05:50 -0500
Date: Thu, 28 Nov 2013 09:05:46 -0500
From: Tejun Heo <htejun@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131128140546.GA3925@htj.dyndns.org>
References: <20131125121416.GB23829@redhat.com>
 <OF4CF076F6.04AFF122-ON48257C2F.0009B6E4-48257C2F.000BF905@zte.com.cn>
 <20131126180420.GA18172@redhat.com>
 <OF99742718.77495161-ON48257C30.000A8334-48257C30.000BA983@zte.com.cn>
 <20131127183117.GB13098@mtj.dyndns.org>
 <20131128091358.GH10022@twins.programming.kicks-ass.net>
 <20131128114542.GA3826@redhat.com>
 <20131128121748.GN10022@twins.programming.kicks-ass.net>
 <20131128133152.GA821@redhat.com>
 <20131128134124.GS10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128134124.GS10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Thu, Nov 28, 2013 at 02:41:24PM +0100, Peter Zijlstra wrote:
> On Thu, Nov 28, 2013 at 02:31:52PM +0100, Oleg Nesterov wrote:
> > I _guess_ usermodehelper_init() should use WQ_SYSFS then, and in this case
> > the user can write to wq_cpumask_store somewhere in /sys/.
> 
> WTF is that and why are we creating alternative affinity interfaces when
> sched_setaffinity() is a prefectly fine one?

Hmmm?  Because workqueue is a shared worker pool implementation.  The
attributes are per-workqueue and if two workqueues have a single set
of attributes, they share the same execution resources.  There's no
one-to-one relationship between a worker thread and a workqueue;
otherwise, we end up with a ton of tasks sitting around doing nothing,
so you can't individually do sched_setaffinity() on a task and expect
it to work.

The singlethread name just exists for compatibility and there's new
interface named alloc_ordered_workqueue() and it creates a workqueue
which execute work items one-by-one in issue order.  For singlethread
/ ordered workqueues with rescuer, it could work to always execute
that work item on the rescuer as we're reserving an execution resource
anyway, but that'd unnecessarily increase cache footprint from
actively using more tasks than necessary and also increase code
complexity.

Thanks.

-- 
tejun
