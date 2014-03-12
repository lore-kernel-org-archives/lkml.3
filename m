Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaCLKlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:41:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:40149 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbaCLKlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:41:21 -0400
Date: Wed, 12 Mar 2014 11:41:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Juri Lelli <juri.lelli@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v3] sched: Fix broken setscheduler()
In-Reply-To: <20140311192420.39395358@gandalf.local.home>
Message-ID: <alpine.DEB.2.02.1403121138480.18573@ionos.tec.linutronix.de>
References: <20140305232931.449eef8c@gandalf.local.home> <20140306115825.GS27965@twins.programming.kicks-ass.net> <20140306132040.781dbf18c9385a6112fbab2b@gmail.com> <20140306120438.638bfe94@gandalf.local.home> <alpine.DEB.2.02.1403062143360.18573@ionos.tec.linutronix.de>
 <20140310132940.78e556c7@gandalf.local.home> <alpine.DEB.2.02.1403102206520.18573@ionos.tec.linutronix.de> <20140310173731.06d41157@gandalf.local.home> <20140311103545.fc7f0f6b1bf0eb1d3391c85c@gmail.com> <alpine.DEB.2.02.1403111147540.18573@ionos.tec.linutronix.de>
 <20140311192420.39395358@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2014, Steven Rostedt wrote:

> 
> I decided to run my tests on linux-next, and my wakeup_rt tracer was
> broken. After running a bisect, I found that the problem commit was:
> 
>    linux-next commit c365c292d059
>    "sched: Consider pi boosting in setscheduler()"
> 
> And the reason the wake_rt tracer test was failing, was because it had
> no RT task to trace. I first noticed this when running with
> sched_switch event and saw that my RT task still had normal SCHED_OTHER
> priority. Looking at the problem commit, I found:
> 
>  -       p->normal_prio = normal_prio(p);
>  -       p->prio = rt_mutex_getprio(p);
> 
> With no
> 
>  +       p->normal_prio = normal_prio(p);
>  +       p->prio = rt_mutex_getprio(p);
> 
> Reading what the commit is suppose to do, I realize that the p->prio
> can't be set if the task is boosted with a higher prio, but the
> p->normal_prio still needs to be set regardless, otherwise, when the
> task is deboosted, it wont get the new priority.
> 
> The p->prio has to be set before "check_class_changed()" is called,
> otherwise the class wont be changed.
> 
> Also added fix to newprio to include a check for deadline policy that
> was missing. This change was suggested by Juri Lelli.
> 
> Link: http://lkml.kernel.org/r/20140306120438.638bfe94@gandalf.local.home
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

