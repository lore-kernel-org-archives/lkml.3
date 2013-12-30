Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754Ab3L3I5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 03:57:08 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:47029 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab3L3I5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 03:57:05 -0500
Date: Mon, 30 Dec 2013 09:56:56 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Question about /proc/uptime
Message-ID: <20131230095656.4c78dd98@mschwide>
In-Reply-To: <20131227144504.GA17192@redhat.com>
References: <1388025009.1176.17@driftwood>
 <20131227144504.GA17192@redhat.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13123008-8372-0000-0000-000008357EEF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Dec 2013 15:45:04 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> Add Frederic, I am not sure I understand this correctly.
> 
> On 12/25, Rob Landley wrote:
> >
> > There are two values here, the first is seconds since boot time (which
> > is just elapsed time; at one point it was ajusted for suspend and that
> > was revered as confusing).
> 
> Hmm, uptime_proc_show() still uses get_monotonic_boottime(), this should
> include suspend time?

The first value of /proc/uptime is the amount of time the system has been
running, the sum of the suspend time is not included. timekeeping_resume()
is supposed to take care of that.
 
> > The second value isn't documented but looking at fs/proc/uptime.c I
> > think it's idle time?
> 
> And this cpustat[CPUTIME_IDLE] doesn't match get_idle_time(), I guess
> it only counts ticks.

The second value of /proc/uptime is the sum of the idle time of all cpus. 
The value should roughly match the sum over get_idle_time() for all cpus.
The difference is that get_idle_time() uses arch_idle_time to add the
time for the currently running idle period as well (at least for s390).
That does make a difference if the cpus stay idle for long periods of
time.

> > Except, if yo uadd up the idle time from all
> > processors wouldn't you get 4x the uptime on a 4-way SMP system that's
> > been idle since boot?
> 
> Yes, looks strange.

Minus some cpu time for the boot and an occasional timer interrupt. And
if cpus are offline for any period of time this is not added to the idle
time as well. For a system that never disables cpus and stays idle for
99.9% of the time the idle time from /proc/uptime should be close to
#cpus * uptime.

> > Also, is this actual "cpu was on but not doing anything" time, so
> > doesn't count suspend as idle?
> 
> I think suspend is not counted as idle.

For suspend all cpus but one are set offline. These cpus will not generate
any cputime while offline, so no idle time nor steal time nor system time.
The suspend cpu will store the TOD clock before switching off, on resume
a new TOD time stamp is created and things are restarted from this new
time. The time spent while in idle is ignored, it is not included in any
cputime bucket. 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

