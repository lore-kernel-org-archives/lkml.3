Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab3HPPB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:01:29 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:64805 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab3HPPB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:01:27 -0400
Date: Fri, 16 Aug 2013 17:01:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jaromir Capik <jcapik@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ania Honess <ahoness@redhat.com>, atomlin@redhat.com,
        asolanas@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: proc/stat: idle goes backward
Message-ID: <20130816150122.GB24210@somewhere>
References: <v5wUE000000000000000000000000000000000000000000000MRITO500uRRuI-89T-iqXCkOVGWF4w@sfdc.net>
 <1904614521.2884383.1376487067689.JavaMail.root@redhat.com>
 <1277145964.2082352.1376490809716.JavaMail.root@redhat.com>
 <20130816144704.GA25904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816144704.GA25904@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 04:47:04PM +0200, Oleg Nesterov wrote:
> Hello.
> 
> Out customer reports that "idle" field is not monotonic. So far this
> is all I know. I do not know how to reproduce, etc.
> 
> But when I look at this code, this looks really possible even
> ignoring drivers/cpuidle/ which plays with update_ts_time_stats().
> 
> So, get_cpu_idle_time_us(last_update_time => NULL) does:
> 
> 	if (ts->idle_active && !nr_iowait_cpu(cpu)) {
> 		ktime_t delta = ktime_sub(now, ts->idle_entrytime);
> 
> 		idle = ktime_add(ts->idle_sleeptime, delta);
> 	} else {
> 		idle = ts->idle_sleeptime;
> 	}
> 
> 
> Suppose that ts->idle_active == T. By the time we calculate
> 
> 	idle = ktime_add(ts->idle_sleeptime, delta);
> 
> this cpu can be already non-idle and ->idle_sleeptime can be already
> updated by tick_nohz_stop_idle(), we return the wrong value.
> 
> If user-space reads /proc/stat again after that, "idle" can obviously
> go back.
> 
> get_cpu_iowait_time_us() has the same problem.
> 
> Plus nr_iowait_cpu() can change in between even if cpu stays idle,
> io_schedule() can return on another CPU.
> 
> Questions:
> 
> 	- Any other reason why it can be non-monotonic?
> 
> 	- Should we fix this or should we document that userspace
> 	  should handle this itself?
> 
> 	  IOW, is this is bug or not?

I don't know if we want to fix it (I personally think we should because it is not the
first time I hear complains about this) but if we do, here is a possible fix:

https://lkml.org/lkml/2013/8/8/638

Thanks.
