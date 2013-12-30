Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab3L3PKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 10:10:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756116Ab3L3PKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 10:10:32 -0500
Date: Mon, 30 Dec 2013 16:11:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Question about /proc/uptime
Message-ID: <20131230151110.GA29636@redhat.com>
References: <1388025009.1176.17@driftwood> <20131227144504.GA17192@redhat.com> <20131230095656.4c78dd98@mschwide>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131230095656.4c78dd98@mschwide>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30, Martin Schwidefsky wrote:
<
> On Fri, 27 Dec 2013 15:45:04 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Add Frederic, I am not sure I understand this correctly.
> >
> > On 12/25, Rob Landley wrote:
> > >
> > > There are two values here, the first is seconds since boot time (which
> > > is just elapsed time; at one point it was ajusted for suspend and that
> > > was revered as confusing).
> >
> > Hmm, uptime_proc_show() still uses get_monotonic_boottime(), this should
> > include suspend time?
>
> The first value of /proc/uptime is the amount of time the system has been
> running, the sum of the suspend time is not included.

Hmm. It uses get_monotonic_boottime() and this helper adds
timekeeper->total_sleep_time to the returned value? Even the comment says

	* This is similar to CLOCK_MONTONIC/ktime_get_ts, but also
	* includes the time spent in suspend.

> timekeeping_resume()
> is supposed to take care of that.

Not sure I understand... except that timekeeping_resume() does
__timekeeping_inject_sleeptime().

> > > The second value isn't documented but looking at fs/proc/uptime.c I
> > > think it's idle time?
> >
> > And this cpustat[CPUTIME_IDLE] doesn't match get_idle_time(), I guess
> > it only counts ticks.
>
> The second value of /proc/uptime is the sum of the idle time of all cpus.
> The value should roughly match the sum over get_idle_time() for all cpus.
> The difference is that get_idle_time() uses arch_idle_time to add the
> time for the currently running idle period as well (at least for s390).

Only if defined(arch_idle_time) ?

Otherwise get_idle_time() uses get_cpu_idle_time_us() and
CONFIG_NO_HZ_COMMON makes a difference.

> That does make a difference if the cpus stay idle for long periods of
> time.

Yes.

Oleg.

