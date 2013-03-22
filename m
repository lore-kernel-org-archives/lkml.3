Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933701Ab3CVPFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:05:40 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43664
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932192Ab3CVPFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:05:37 -0400
Date: Fri, 22 Mar 2013 09:05:19 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org,
        linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 6/7] block: queue work on any cpu
Message-ID: <20130322150519.GJ25978@kernel.dk>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
 <9aa157216e60de7d245128d42fb896918184ae8c.1363617402.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9aa157216e60de7d245128d42fb896918184ae8c.1363617402.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18 2013, Viresh Kumar wrote:
> block layer uses workqueues for multiple purposes. There is no real dependency
> of scheduling these on the cpu which scheduled them.
> 
> On a idle system, it is observed that and idle cpu wakes up many times just to
> service this work. It would be better if we can schedule it on a cpu which isn't
> idle to save on power.
> 
> By idle cpu (from scheduler's perspective) we mean:
> - Current task is idle task
> - nr_running == 0
> - wake_list is empty
> 
> This patch replaces schedule_work() and queue_[delayed_]work() with
> queue_[delayed_]work_on_any_cpu() siblings.
> 
> These routines would look for the closest (via scheduling domains) non-idle cpu
> (non-idle from schedulers perspective). If the current cpu is not idle or all
> cpus are idle, work will be scheduled on local cpu.

What are the performance implications of this? From that perspective,
scheduling on a local core is the better choice. Hopefully it's already
running on the local socket of the device, keeping it on that node would
be preferable.

For the delayed functions, the timer is typically added on the current
CPU. It's hard to know what the state of idleness of CPUs would be when
the delay has expired. How are you handling this?

I can see the win from a power consumption point of view, but it quickly
gets a little more complicated than that.

-- 
Jens Axboe

