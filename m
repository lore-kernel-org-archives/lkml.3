Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab3IRW5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 18:57:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:33454 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3IRW5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 18:57:43 -0400
Date: Thu, 19 Sep 2013 00:57:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <cl@linux.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
        Tejun Heo <tj@kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux-MM <linux-mm@kvack.org>
Subject: Re: RFC vmstat: On demand vmstat threads
In-Reply-To: <20130918150659.5091a2c3ca94b99304427ec5@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1309190033440.4089@ionos.tec.linutronix.de>
References: <00000140e9dfd6bd-40db3d4f-c1be-434f-8132-7820f81bb586-000000@email.amazonses.com> <CAOtvUMdfqyg80_9J8AnOaAdahuRYGC-bpemdo_oucDBPguXbVA@mail.gmail.com> <0000014109b8e5db-4b0f577e-c3b4-47fe-b7f2-0e5febbcc948-000000@email.amazonses.com>
 <20130918150659.5091a2c3ca94b99304427ec5@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Sep 2013, Andrew Morton wrote:
> On Tue, 10 Sep 2013 21:13:34 +0000 Christoph Lameter <cl@linux.com> wrote:
> > +	cpumask_copy(monitored_cpus, cpu_online_mask);
> > +	cpumask_clear_cpu(tick_do_timer_cpu, monitored_cpus);
> 
> What on earth are we using tick_do_timer_cpu for anyway? 
> tick_do_timer_cpu is cheerfully undocumented, as is this code's use of
> it.

tick_do_timer_cpu is a timer core internal variable, which holds the
CPU NR which is responsible for calling do_timer(), i.e. the
timekeeping stuff. This variable has two functions:

1) Prevent a thundering herd issue of a gazillion of CPUs trying to
   grab the timekeeping lock all at once. Only the CPU which is
   assigned to do the update is handling it.

2) Hand off the duty in the NOHZ idle case by setting the value to
   TICK_DO_TIMER_NONE, i.e. a non existing CPU. So the next cpu which
   looks at it will take over and keep the time keeping alive.
   The hand over procedure also covers cpu hotplug.

(Ab)Using it for anything else outside the timers core code is just
broken.

It's working for Christophs use case as his setup will not change the
assignment away from the boot cpu, but that's really not a brilliant
design to start with.

The vmstat accounting is not the only thing which we want to delegate
to dedicated core(s) for the full NOHZ mode.

So instead of playing broken games with explicitly not exposed core
code variables, we should implement a core code facility which is
aware of the NOHZ details and provides a sane way to delegate stuff to
a certain subset of CPUs.

Thanks,

	tglx
