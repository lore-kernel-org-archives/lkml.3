Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935452Ab3DJH1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 03:27:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47962 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab3DJH1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 03:27:07 -0400
Message-ID: <1365578814.30071.19.camel@laptop>
Subject: Re: [PATCH v4] sched: fix wrong rq's runnable_avg update with rt
 tasks
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>
Date: Wed, 10 Apr 2013 09:26:54 +0200
In-Reply-To: <CAKfTPtDJa5Am+jEHSzy+hhh+9=GcR9YXzKV-DAH3D3Hq6uMHog@mail.gmail.com>
References: <1365084959-28374-1-git-send-email-vincent.guittot@linaro.org>
	 <1365497406.2609.162.camel@laptop>
	 <CAKfTPtDJa5Am+jEHSzy+hhh+9=GcR9YXzKV-DAH3D3Hq6uMHog@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 11:06 +0200, Vincent Guittot wrote:
> >> +void idle_enter(struct rq *this_rq)
> >> +{
> >> +       update_rq_runnable_avg(this_rq, 1);
> >> +}

> >> +void idle_exit(struct rq *this_rq)
> >> +{
> >> +       update_rq_runnable_avg(this_rq, 0);
> >> +}
> >
> > These seem like fairly unfortunate names to expose to the global
> > namespace, why not expose update_rq_runnable_avg() instead?
> 
> Just to gather in one place all cfs actions that should be done when
> exiting idle even if we only have update_rq_runnable_avg right now. I
> have distinguished that from idle_balance because this sequence can't
> generate extra context switch like idle_balance and they would finally
> not be called in the same time

OK, but could we then please give then more scheduler specific names?
It just seems to me that idle_enter/idle_exit() are very obvious
function names for unrelated things.

How about calling it idle_{enter,exit}_fair; so that once other classes
grow hooks we can do something like:

static void pre_schedule_idle(struct rq *rq, struct task_struct *p)
{
	struct sched_class *class;

	for_each_class(class) {
		if (class->idle_enter)
			class->idle_enter(rq);
	}	
}

or whatnot..

