Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab3K1PjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:39:12 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:43032 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab3K1PjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:39:10 -0500
Date: Thu, 28 Nov 2013 10:39:06 -0500
From: Tejun Heo <htejun@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH]: exec: avoid propagating PF_NO_SETAFFINITY into
 userspace child
Message-ID: <20131128153906.GL3925@htj.dyndns.org>
References: <20131128133152.GA821@redhat.com>
 <20131128133947.GR10022@twins.programming.kicks-ass.net>
 <20131128141329.GB3925@htj.dyndns.org>
 <20131128143145.GT10022@twins.programming.kicks-ass.net>
 <20131128143848.GD3925@htj.dyndns.org>
 <20131128145505.GX10022@twins.programming.kicks-ass.net>
 <20131128145723.GH3925@htj.dyndns.org>
 <20131128145948.GZ10022@twins.programming.kicks-ass.net>
 <20131128150722.GJ3925@htj.dyndns.org>
 <20131128151704.GC10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128151704.GC10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Thu, Nov 28, 2013 at 04:17:04PM +0100, Peter Zijlstra wrote:
> So there's three useful parts to having a single parent task:
> 
>  - its a task so you can change the entire task attribute set; current
>    and future.

Using task as interface could be okay but I'd still go for explicitly
specifying what gets inherited and expand them gradually; otherwise,
we end up exposing broken stuff unintentionally.  cpuset did this with
bound workers and the capability was removed retro-actively, which is
not a happy situation.

>  - new children will automatically get the desired attributes.
> 
>  - all children are easily identified by virtual of being children of
>    said parent process.

That'd mean that we'd have to have a dummy target task for attributes
for each workqueue and hooks for workqueue to get notified of
attribute changes.  Unless we're gonna go back to per-workqueue
workers, we can't have a single parent per workqueue and all its
workers as children of it.  Different workqueue configure different
set of attributes.  Not all !percpu workers are equal and each
workqueue serves as an attribute domain.

We *could* do all that and it proably won't require walking the
children from userland as each attribute change would surmount to
finding or creating a matching worker pool, but it doesn't look
attractive to me.

> Well, mixed attributes is you own responsibility. I'm all for letting
> people shoot themselves in the foot as long we don't crash.

Again, I'm worried about exposing unintended characteristics of
implementation and being locked into it.  Regardless of interface, I
think it's important to control what can be depended upon from
userland if we're gonna keep up "no userland visible behavior will
break" thing.

> The huge disadvantage to creating special interfaces is that you can
> only capture a small part of the task attributes; and worse, you create
> a special limited interface for a special few tasks.

Yeah, that's the disadvantage but I don't think the single parent per
workqueue model is gonna work.  FWIW, workqueue implements
standardized sysfs interface so that each user doesn't end up with
custom interface (writeback was growing one and got switched to the
workqueue standard one).

workqueue is shared pools of workers keyed by specific worker
attributes.  There evidently are restrictions coming from its nature
and no matter what we do workqueue needs to be taught to distinguish
each attribute.  I think workqueue-wide interface is an acceptable
compromise especially considering that there are attributes which
can't be represented by a single task such as max_active and automatic
NUMA binding, which means we need workqueue-specific interface anyway.

Thanks.

-- 
tejun
