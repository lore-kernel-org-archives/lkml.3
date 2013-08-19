Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751162Ab3HSSOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 14:14:34 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:40954 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750864Ab3HSSOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 14:14:33 -0400
X-Greylist: delayed 519 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Aug 2013 14:14:32 EDT
Message-ID: <52125E79.8070009@semaphore.gr>
Date: Mon, 19 Aug 2013 21:05:45 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 1/4] nohz: Only update sleeptime stats locally
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com> <1376667753-29014-2-git-send-email-fweisbec@gmail.com> <20130818170408.GA22417@redhat.com>
In-Reply-To: <20130818170408.GA22417@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2013 08:04 PM, Oleg Nesterov wrote:
> Sorry for double post. forgot to cc cpufreq maintainers.
> 
> On 08/16, Frederic Weisbecker wrote:
>>
>> To fix this, lets only update the sleeptime stats locally when the CPU
>> exits from idle.
> 
> I am in no position to ack the changes in this area, but I like this
> change very much. Because, as a code reader, I was totally confused by
> 
> 	if (last_update_time)
> 		update_ts_time_stats()
> 
> code and it looks "obviously wrong".
> 
> I added more cc's. It seems to me that 9366d840 "cpufreq: governors:
> Calculate iowait time only when necessary" doesn't realize what
> 
> 	-       u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
> 	+       u64 idle_time = get_cpu_idle_time_us(cpu, io_busy ? wall : NULL);
> 
> actually means. OTOH, get_cpu_iowait_time_us() was called with
> last_update_time != NULL even before this patch...

To be honest, I am unfamiliar with tick-sched code.
With patch 9366d840, I was trying to avoid duplicate calls to
get_cpu_iowait_time_us function. I just saw that the original
code was calling update_ts_time_stats within get_cpu_idle_time_us
and get_cpu_iowait_time_us and I thought that I should keep calling
these functions with non NULL parameter to update the time stats.

In fact the original patch submission was without this:
-       u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
+       u64 idle_time = get_cpu_idle_time_us(cpu, io_busy ? wall : NULL);
and the idle time calculation was wrong (ondemand couldn't increase to max freq)


For your convenience the call paths before and after this patch:

Before patch

get_cpu_idle_time(j, &cur_wall_time);
	u64 idle_time = get_cpu_idle_time_us(cpu, NULL);
	idle_time += get_cpu_iowait_time_us(cpu, wall);
		update_ts_time_stats(cpu, ts, now, last_update_time);
... 
get_cpu_iowait_time_us(j, &cur_wall_time);
	update_ts_time_stats(cpu, ts, now, last_update_time);


After patch (io_busy = 1)

cur_idle_time = get_cpu_idle_time(j, &cur_wall_time, io_busy);
	u64 idle_time = get_cpu_idle_time_us(cpu, io_busy ? wall : NULL);
		update_ts_time_stats(cpu, ts, now, last_update_time);


After patch (io_busy = 0)

cur_idle_time = get_cpu_idle_time(j, &cur_wall_time, io_busy);
	u64 idle_time = get_cpu_idle_time_us(cpu, io_busy ? wall : NULL);

	idle_time += get_cpu_iowait_time_us(cpu, wall);
		update_ts_time_stats(cpu, ts, now, last_update_time);


Regards,
Stratos
