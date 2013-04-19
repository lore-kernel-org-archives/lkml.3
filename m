Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609Ab3DSEan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 00:30:43 -0400
Received: from mout.gmx.net ([212.227.15.15]:62711 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772Ab3DSEal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 00:30:41 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+oMLVSpaWo7Jqsvgwg7/KQpC+0iWm8pl5GbShkoG
	P/TgSnEn5XtKJC
Message-ID: <1366345833.4708.17.camel@marge.simpson.net>
Subject: Re: [PATCH Resend v6] sched: fix wrong rq's runnable_avg update
 with rt tasks
From: Mike Galbraith <efault@gmx.de>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, pjt@google.com,
        rostedt@goodmis.org, fweisbec@gmail.com
Date: Fri, 19 Apr 2013 06:30:33 +0200
In-Reply-To: <1366302867-5055-1-git-send-email-vincent.guittot@linaro.org>
References: <1366302867-5055-1-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-18 at 18:34 +0200, Vincent Guittot wrote: 
> The current update of the rq's load can be erroneous when RT tasks are
> involved
> 
> The update of the load of a rq that becomes idle, is done only if the avg_idle
> is less than sysctl_sched_migration_cost. If RT tasks and short idle duration
> alternate, the runnable_avg will not be updated correctly and the time will be
> accounted as idle time when a CFS task wakes up.
> 
> A new idle_enter function is called when the next task is the idle function
> so the elapsed time will be accounted as run time in the load of the rq,
> whatever the average idle time is. The function update_rq_runnable_avg is
> removed from idle_balance.
> 
> When a RT task is scheduled on an idle CPU, the update of the rq's load is
> not done when the rq exit idle state because CFS's functions are not
> called. Then, the idle_balance, which is called just before entering the
> idle function, updates the rq's load and makes the assumption that the
> elapsed time since the last update, was only running time.
> 
> As a consequence, the rq's load of a CPU that only runs a periodic RT task,
> is close to LOAD_AVG_MAX whatever the running duration of the RT task is.

Why do we care what rq's load says, if the only thing running is a
periodic RT task?  I _think_ I recall that stuff being put under the
throttle specifically to not waste cycles doing that on every
microscopic idle.

Seems to me when scheduling an rt task, you want to do as little other
than switching to/from the rt task as possible.  I don't let rt tasks do
idle balancing either, their job isn't to balance fair class on the way
out the door, it's to get off/onto the cpu ASAP, and do rt work.

-Mike

