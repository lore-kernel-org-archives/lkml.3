Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab3GONf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 09:35:57 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:37232 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482Ab3GONfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 09:35:54 -0400
Message-ID: <51E3F9D9.8060403@linux.vnet.ibm.com>
Date: Mon, 15 Jul 2013 19:02:09 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Michael Wang <wangyun@linux.vnet.ibm.com>, Jiri Kosina <jkosina@suse.cz>,
        Borislav Petkov <bp@alien8.de>, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [LOCKDEP] cpufreq: possible circular locking dependency detected
References: <20130625211544.GA2270@swordfish> <51D10899.1080501@linux.vnet.ibm.com> <20130710231305.GA4046@swordfish> <51DE1BE1.3090707@linux.vnet.ibm.com> <20130714114721.GB2178@swordfish> <20130714120629.GA4067@swordfish> <51E37194.1080103@linux.vnet.ibm.com> <51E3AA3B.9090003@linux.vnet.ibm.com> <20130715082918.GA2435@swordfish> <51E3F6EB.2050807@linux.vnet.ibm.com>
In-Reply-To: <51E3F6EB.2050807@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071513-5490-0000-0000-000003D20757
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 06:49 PM, Srivatsa S. Bhat wrote:
[...] 
> The intent of this commit was to avoid warnings during CPU hotplug, which
> indicated that offline CPUs were getting IPIs from the cpufreq governor's
> work items. But the real root-cause of that problem was commit a66b2e5
> (cpufreq: Preserve sysfs files across suspend/resume) because it totally
> skipped all the cpufreq callbacks during CPU hotplug in the suspend/resume
> path, and hence it never actually shut down the cpufreq governor's worker
> threads during CPU offline in the suspend/resume path.
> 
> Reflecting back, the reason why we never suspected that commit as the
> root-cause earlier, was that the original issue was reported with just the
> halt command and nobody had brought in suspend/resume to the equation.
> 
> The reason for _that_ in turn, it turns out is that, earlier halt/shutdown
> was being done by disabling non-boot CPUs while tasks were frozen, just like
> suspend/resume....  but commit cf7df378a (reboot: rigrate shutdown/reboot to
> boot cpu) which came somewhere along that very same time changed that logic:
> shutdown/halt no longer takes CPUs offline.
> Thus, the test-cases for reproducing the bug were vastly different and thus
> we went totally off the trail.
> 
> Overall, it was one hell of a confusion with so many commits affecting
> each other and also affecting the symptoms of the problems in subtle
> ways. Finally, now since the original problematic commit (a66b2e5) has been
> completely reverted, revert this intermediate fix too (2f7021a), to fix the
> CPU hotplug deadlock. Phew!
> 
> Reported-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Reported-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Forgot to add: If this solves the issues people are facing, IMHO this should
also be CC'ed to stable just like the full-revert of a66b2e5, .

Regards,
Srivatsa S. Bhat

> ---
> 
>  drivers/cpufreq/cpufreq_governor.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index 4645876..7b839a8 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -25,7 +25,6 @@
>  #include <linux/slab.h>
>  #include <linux/types.h>
>  #include <linux/workqueue.h>
> -#include <linux/cpu.h>
>  
>  #include "cpufreq_governor.h"
>  
> @@ -137,10 +136,8 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
>  	if (!all_cpus) {
>  		__gov_queue_work(smp_processor_id(), dbs_data, delay);
>  	} else {
> -		get_online_cpus();
>  		for_each_cpu(i, policy->cpus)
>  			__gov_queue_work(i, dbs_data, delay);
> -		put_online_cpus();
>  	}
>  }
>  EXPORT_SYMBOL_GPL(gov_queue_work);
> 

