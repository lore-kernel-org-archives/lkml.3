Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab3K1PRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:17:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52107 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3K1PRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:17:14 -0500
Date: Thu, 28 Nov 2013 16:17:04 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131128151704.GC10022@twins.programming.kicks-ass.net>
References: <20131128121748.GN10022@twins.programming.kicks-ass.net>
 <20131128133152.GA821@redhat.com>
 <20131128133947.GR10022@twins.programming.kicks-ass.net>
 <20131128141329.GB3925@htj.dyndns.org>
 <20131128143145.GT10022@twins.programming.kicks-ass.net>
 <20131128143848.GD3925@htj.dyndns.org>
 <20131128145505.GX10022@twins.programming.kicks-ass.net>
 <20131128145723.GH3925@htj.dyndns.org>
 <20131128145948.GZ10022@twins.programming.kicks-ass.net>
 <20131128150722.GJ3925@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128150722.GJ3925@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 10:07:22AM -0500, Tejun Heo wrote:
> Changing attributes on the parent doesn't get propagated to its
> children, so I don't think that'd be a terribly good interface for
> workqueue. 

The idea was that if there's a single parent, its easy to find all the
children using the task hierarchy. So flip the parent to the new
attributes, then iterate the children and flip them.

That's a single pass race-free approach. New children will already have
the desired attributes, dead children we don't care about.

So there's three useful parts to having a single parent task:

 - its a task so you can change the entire task attribute set; current
   and future.

 - new children will automatically get the desired attributes.

 - all children are easily identified by virtual of being children of
   said parent process.

Currently its hard to find all usermode helpers or all workqueue tasks.

I know people who are poking at /proc/$pid/stat to inspect
task_struct::flags while gleaning the PF_ flags from sched.h and run
this in a polling loop to catch new entries.

Surely that's a bad idea ;-)

> You'll end up with workers with mixed attributes and
> regardless, workqueue management logic needs to know which workqueue
> has which set of attributes to decide how the workers are shared.
> Overrloading all that over task mgmt interface would be horrible.

Well, mixed attributes is you own responsibility. I'm all for letting
people shoot themselves in the foot as long we don't crash.

The huge disadvantage to creating special interfaces is that you can
only capture a small part of the task attributes; and worse, you create
a special limited interface for a special few tasks.


