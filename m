Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab3JKMpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:45:10 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:10918 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755585Ab3JKMpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:45:09 -0400
Date: Fri, 11 Oct 2013 08:45:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "George Spelvin" <linux@horizon.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Message-ID: <20131011084507.1d691504@gandalf.local.home>
In-Reply-To: <20131011121457.25042.qmail@science.horizon.com>
References: <20131011121457.25042.qmail@science.horizon.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 Oct 2013 08:14:57 -0400
"George Spelvin" <linux@horizon.com> wrote:

> > There's places in the kernel that does for_each_cpu() that I'm sure you
> > don't want to disable preemption for. Especially when you start having
> > 4096 CPU machines!
> 
> Er... why not?
> 
> Seriously.  If I have 4096 processors, and preemption is disabled on
> *one* of them for a long time, can't an urgent task just find a different
> processor to preempt?

The problem is that the scheduler doesn't see that the current task has
preemption disabled. It only looks at the priorities of the current
task, and if it can preempt it, it will. It sets the NEED_RESCHED to the
current task and waits for the preemption to schedule it out.

If an RT task is woken on a CPU that's running a SCHED_OTHER task
that's doing this loop. It will have to wait for the loop to finish
before it can schedule in. After doing the wake up, the scheduling
algorithm is happy that it got an RT task on a CPU quickly, when in
reality it has to wait a long time till preemption is enabled again.

-- Steve



> 
> This seems like a non-problem.  Or am I misunderstanding something about
> processor affinity?

