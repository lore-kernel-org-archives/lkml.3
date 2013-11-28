Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759178Ab3K1PHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:07:30 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:56252 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758993Ab3K1PH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:07:26 -0500
Date: Thu, 28 Nov 2013 10:07:22 -0500
From: Tejun Heo <htejun@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131128150722.GJ3925@htj.dyndns.org>
References: <20131128114542.GA3826@redhat.com>
 <20131128121748.GN10022@twins.programming.kicks-ass.net>
 <20131128133152.GA821@redhat.com>
 <20131128133947.GR10022@twins.programming.kicks-ass.net>
 <20131128141329.GB3925@htj.dyndns.org>
 <20131128143145.GT10022@twins.programming.kicks-ass.net>
 <20131128143848.GD3925@htj.dyndns.org>
 <20131128145505.GX10022@twins.programming.kicks-ass.net>
 <20131128145723.GH3925@htj.dyndns.org>
 <20131128145948.GZ10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128145948.GZ10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 03:59:48PM +0100, Peter Zijlstra wrote:
> On Thu, Nov 28, 2013 at 09:57:23AM -0500, Tejun Heo wrote:
> > On Thu, Nov 28, 2013 at 03:55:05PM +0100, Peter Zijlstra wrote:
> > > Because that is exactly what some users desire? Some RT and HPC people
> > > want all those crypt jobs to run on a few designated cpus and not wreck
> > > their compute jobs.
> > 
> > And you can't do that reliably from userland.  Those things are
> > created dynamically.  workqueue provides per-workqueue attributes to
> > enable those use cases.  It doesn't have system-wide default
> > attributes right now but adding that shouldn't be too difficult.
> 
> Like a parent process, right? So people can use the existing task
> interfaces.
>
> Or are we going to tell people; here, there's cgroups for managing your
> tasks. Oh and here is this crippled interface X for if you want to
> manage these few tasks, and interface Y for managing these other few
> tasks.

Changing attributes on the parent doesn't get propagated to its
children, so I don't think that'd be a terribly good interface for
workqueue.  You'll end up with workers with mixed attributes and
regardless, workqueue management logic needs to know which workqueue
has which set of attributes to decide how the workers are shared.
Overrloading all that over task mgmt interface would be horrible.

For transient processes like usermode helpers, single parent could
work.  I don't necessarily think exposing that is a good idea but if
that's gonna happen, that's not gonna be part of workqueue.  Just
create a dedicated kthread for it.

-- 
tejun
