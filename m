Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab3CRTGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 15:06:23 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:61025 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab3CRTGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 15:06:20 -0400
Date: Mon, 18 Mar 2013 12:06:16 -0700
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Clark Williams <clark@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: workqueue code needing preemption disabled
Message-ID: <20130318190616.GC3042@htj.dyndns.org>
References: <1363617383.25967.152.camel@gandalf.local.home>
 <20130318160652.GA20133@mtj.dyndns.org>
 <1363623799.25967.172.camel@gandalf.local.home>
 <1363624020.25967.175.camel@gandalf.local.home>
 <1363624243.25967.178.camel@gandalf.local.home>
 <20130318164351.GA21516@mtj.dyndns.org>
 <1363626487.25967.186.camel@gandalf.local.home>
 <20130318182130.GA3042@htj.dyndns.org>
 <1363633050.25967.210.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363633050.25967.210.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 02:57:30PM -0400, Steven Rostedt wrote:
> I like the theory, but it has one flaw. I agree that the update should
> be wrapped in preempt_disable() but since this bug happens on the same
> CPU, the state of the list will be the same when it was preempted to
> when it bugged. That said:
> 
> static inline int list_empty(const struct list_head *head)
> {
> 	return head->next == head;
> }

Dang... right.  For some reason, I was thinking it was doing
head->next == head->prev.

> That means when the task was preempted, head->next will either be
> pointing to the next element or back to the list head. Which means if we
> get preempted while updating the list, it will either see the head->next
> == head or head->next == the next element.
> 
> first_worker() returns list_first_entry() which returns head->next. I
> can't see how it would see the list_head and have list_empty() return
> false.

Me neither.  Unfortunately, I'm out of ideas at the moment.
Hmm... last year, there was a similar issue, I think it was in AMD
cpufreq, which was caused by work function doing
set_cpus_allowed_ptr(), so the idle worker was on the correct CPU but
the one issuing local wake up was on the wrong one.  It could be that
there's another such usage in kernle which doesn't trigger easily w/o
RT.  As preemption doesn't trigger concurrency management wakeup, as
long as such user doesn't do something explicitly blocking, upstream
would be fine as long as it restores affinity before finishing but in
RT spinlocks become mutexes and can trigger local wakeups, so...

Anyways, having a crashdump would go a long way towards identifying
what's going on.  All we need to know are the work function which was
being executed, whether the worker was on the right CPU and which
worker it was trying to wake up.

-- 
tejun
