Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161788Ab3BONhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:37:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28763 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161381Ab3BONhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 08:37:05 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=amwdYq58fXoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Z7SmUxEbSGQA:10 a=FZUIdQeRwsdU0p4JlRYA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360935422.23152.105.camel@gandalf.local.home>
Subject: Re: [PATCH 2/3] sched: Move idle_balance() to post_schedule
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>
Date: Fri, 15 Feb 2013 08:37:02 -0500
In-Reply-To: <1360929080.27535.9.camel@laptop>
References: <20130212225412.781044738@goodmis.org>
	 <20130212230017.625583020@goodmis.org> <1360780981.8957.3.camel@laptop>
	 <1360782338.23152.22.camel@gandalf.local.home>
	 <1360929080.27535.9.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-15 at 12:51 +0100, Peter Zijlstra wrote:
> On Wed, 2013-02-13 at 14:05 -0500, Steven Rostedt wrote:

> Ah, so that's push_rt_task() which wants to move extra rt tasks to other
> cpus. Doing that from where we have idle_balance() won't actually work I
> think since we might need to move current, which we cannot at that point
> -- I'm thinking a higher prio task (than current) waking to this cpu and
> then cascading current to another cpu, can that happen?

Yep, that's exactly why we do the push after the switch. It also catches
a bunch of races that can happen if in the middle of the switch another
CPU drops in priority. A drop in priority can cause that CPU to search
for pending rt tasks on other CPUs, but because current hasn't been
taken off the queue yet, it can miss trying to pull it, and current
could get stuck on its CPU even though there's another CPU it could run
on. Having the higher priority task do the check solves that race.

> 
> If we never need to migrate current because we don't do the cascade by
> ensuring we wake the higher prio task to the approriate cpu we might
> just get away with it.

I'm not exactly sure what you mean by this? Migrate the higher task? But
what if it's pinned. And we use to do that, until we found out that
higher priority tasks were ping-ponging around like crazy.

-- Steve


