Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312Ab3HTJy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:54:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:25556 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab3HTJy1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:54:27 -0400
X-IronPort-AV: E=Sophos;i="4.89,919,1367942400"; 
   d="scan'208";a="8250223"
Message-ID: <52133DD0.8030804@cn.fujitsu.com>
Date: Tue, 20 Aug 2013 17:58:40 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Borislav Petkov <bp@alien8.de>,
        Borislav Petkov <bp@suse.de>,
        =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
Subject: Re: [PATCH tip/core/rcu 1/9] rcu: Expedite grace periods during suspend/resume
References: <20130820024148.GA30283@linux.vnet.ibm.com> <1376966534-30775-1-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1376966534-30775-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/20 17:52:31,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/20 17:52:42
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 10:42 AM, Paul E. McKenney wrote:
> From: Borislav Petkov <bp@alien8.de>
> 
> CONFIG_RCU_FAST_NO_HZ can increase grace-period durations by up to
> a factor of four, which can result in long suspend and resume times.
> Thus, this commit temporarily switches to expedited grace periods when
> suspending the box and return to normal settings when resuming.  Similar
> logic is applied to hibernation.
> 
> Because expedited grace periods are of dubious benefit on very large
> systems, so this commit restricts their automated use during suspend
> and resume to systems of 256 or fewer CPUs.  (Some day a number of
> Linux-kernel facilities, including RCU's expedited grace periods,
> will be more scalable, but I need to see bug reports first.)
> 
> [ paulmck: This also papers over an audio/irq bug, but hopefully that will
>   be fixed soon. ]
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Bjørn Mork <bjorn@mork.no>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  kernel/rcutree.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 338f1d1..a7bf517 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -54,6 +54,7 @@
>  #include <linux/stop_machine.h>
>  #include <linux/random.h>
>  #include <linux/ftrace_event.h>
> +#include <linux/suspend.h>
>  
>  #include "rcutree.h"
>  #include <trace/events/rcu.h>
> @@ -3032,6 +3033,25 @@ static int rcu_cpu_notify(struct notifier_block *self,
>  	return NOTIFY_OK;
>  }
>  
> +static int rcu_pm_notify(struct notifier_block *self,
> +			 unsigned long action, void *hcpu)
> +{
> +	switch (action) {
> +	case PM_HIBERNATION_PREPARE:
> +	case PM_SUSPEND_PREPARE:
> +		if (nr_cpu_ids <= 256) /* Expediting bad for large systems. */
> +			rcu_expedited = 1;
> +		break;
> +	case PM_POST_HIBERNATION:
> +	case PM_POST_SUSPEND:
> +		rcu_expedited = 0;

Users can set it via sysfs, this notify will changes it.
I think we can introduce an rcu_expedited_syfs_saved;
thus we can change this line to:
-		rcu_expedited = 0;
+		rcu_expedited = rcu_expedited_syfs_saved;


rcu_init() {
	...
+	rcu_expedited_syfs_saved = rcu_expedited;
}

static ssize_t rcu_expedited_store(struct kobject *kobj,
				   struct kobj_attribute *attr,
				   const char *buf, size_t count)
{
	if (kstrtoint(buf, 0, &rcu_expedited))
		return -EINVAL;

+	rcu_expedited_syfs_saved = rcu_expedited;
	return count;
}

> +		break;
> +	default:
> +		break;
> +	}
> +	return NOTIFY_OK;
> +}
> +
>  /*
>   * Spawn the kthread that handles this RCU flavor's grace periods.
>   */
> @@ -3273,6 +3293,7 @@ void __init rcu_init(void)
>  	 * or the scheduler are operational.
>  	 */
>  	cpu_notifier(rcu_cpu_notify, 0);
> +	pm_notifier(rcu_pm_notify, 0);
>  	for_each_online_cpu(cpu)
>  		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
>  }

