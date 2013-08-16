Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab3HPOw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 10:52:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab3HPOwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 10:52:54 -0400
Date: Fri, 16 Aug 2013 16:47:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jaromir Capik <jcapik@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Ania Honess <ahoness@redhat.com>, atomlin@redhat.com, asolanas@redhat.com,
        linux-kernel@vger.kernel.org
Subject: proc/stat: idle goes backward
Message-ID: <20130816144704.GA25904@redhat.com>
References: <v5wUE000000000000000000000000000000000000000000000MRITO500uRRuI-89T-iqXCkOVGWF4w@sfdc.net> <1904614521.2884383.1376487067689.JavaMail.root@redhat.com> <1277145964.2082352.1376490809716.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277145964.2082352.1376490809716.JavaMail.root@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Out customer reports that "idle" field is not monotonic. So far this
is all I know. I do not know how to reproduce, etc.

But when I look at this code, this looks really possible even
ignoring drivers/cpuidle/ which plays with update_ts_time_stats().

So, get_cpu_idle_time_us(last_update_time => NULL) does:

	if (ts->idle_active && !nr_iowait_cpu(cpu)) {
		ktime_t delta = ktime_sub(now, ts->idle_entrytime);

		idle = ktime_add(ts->idle_sleeptime, delta);
	} else {
		idle = ts->idle_sleeptime;
	}


Suppose that ts->idle_active == T. By the time we calculate

	idle = ktime_add(ts->idle_sleeptime, delta);

this cpu can be already non-idle and ->idle_sleeptime can be already
updated by tick_nohz_stop_idle(), we return the wrong value.

If user-space reads /proc/stat again after that, "idle" can obviously
go back.

get_cpu_iowait_time_us() has the same problem.

Plus nr_iowait_cpu() can change in between even if cpu stays idle,
io_schedule() can return on another CPU.

Questions:

	- Any other reason why it can be non-monotonic?

	- Should we fix this or should we document that userspace
	  should handle this itself?

	  IOW, is this is bug or not?

Oleg.

