Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492Ab3KMP5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:57:40 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:49059 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757002Ab3KMP5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:57:38 -0500
Date: Wed, 13 Nov 2013 10:57:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Matthew Whitehead <tedheadster@gmail.com>, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, mwhitehe@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: nohz problem with idle time on old hardware
Message-ID: <20131113105737.3f7a0b1b@gandalf.local.home>
In-Reply-To: <20131113103134.5b8cf02f@gandalf.local.home>
References: <20131113113927.GA13875@mwhitehe.csb>
	<alpine.DEB.2.02.1311131453500.30673@ionos.tec.linutronix.de>
	<20131113102153.5f10e6b5@gandalf.local.home>
	<20131113103134.5b8cf02f@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Nov 2013 10:31:34 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:
 
> The trace does indeed show that a tick is happening, as the config has
> HZ=250 (4ms) and we see a tick happen every 4ms. But for some reason,
> we don't update the the idle time correctly when nohz is enabled.
> 
> When I say nohz is enabled, I mean that we don't have nohz=off in the
> command line. There seems to be some difference between having nohz=off
> and having nohz disabled at runtime.


Looking at the differences between nohz=off from the command line, and
disabled at run time seems to be the variable "tick_nohz_enabled". I
don't see where it gets set to zero except for nohz=off.

$ git grep tick_nohz_enabled
kernel/rcutree.h:       int tick_nohz_enabled_snap; /* Previously seen
value from sysfs. */ kernel/rcutree_plugin.h:extern int
tick_nohz_enabled; kernel/rcutree_plugin.h:        tne =
ACCESS_ONCE(tick_nohz_enabled); kernel/rcutree_plugin.h:        if
(tne != rdtp->tick_nohz_enabled_snap)
{ kernel/rcutree_plugin.h:                rdtp->tick_nohz_enabled_snap
= tne; kernel/rcutree_plugin.h:
rdtp->tick_nohz_enabled_snap ? '.' : 'D'); kernel/time/tick-sched.c:int
tick_nohz_enabled __read_mostly  = 1;
kernel/time/tick-sched.c:               tick_nohz_enabled = 0;
kernel/time/tick-sched.c:               tick_nohz_enabled = 1;
kernel/time/tick-sched.c:       if (!tick_nohz_enabled)
kernel/time/tick-sched.c:       if (!tick_nohz_enabled)
kernel/time/tick-sched.c:       if (!tick_nohz_enabled)
kernel/time/tick-sched.c:       if (tick_nohz_enabled)


What's even stranger is that the RCU code in rcutree_plugin.h does an
ACCESS_ONCE(tick_nohz_enabled) as if it can change.

That said, looking at the fs/proc/stat.c get_idle_time() it does an
idle_time = get_cpu_idle_time_us(cpu, NULL) which has:

u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
{
	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
	ktime_t now, idle;

	if (!tick_nohz_enabled)
		return -1;

	now = ktime_get();
	if (last_update_time) {
		update_ts_time_stats(cpu, ts, now, last_update_time);
		idle = ts->idle_sleeptime;
	} else {
		if (ts->idle_active && !nr_iowait_cpu(cpu)) {
			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
			idle = ktime_add(ts->idle_sleeptime, delta);
		} else {
			idle = ts->idle_sleeptime;
		}
	}

	return ktime_to_us(idle);

}

This is one of the differences between nohz=off and nohz=on with jiffy
accounting. When we have nohz=off, this returns -1 and the calling
function calculates the idle time differently.

-- Steve
