Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab3GILvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 07:51:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24291 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab3GILvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 07:51:35 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-b6-51dbf945f8e2
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, Borislav Petkov <bp@alien8.de>,
        Jiri Kosina <jkosina@suse.cz>, Tomasz Figa <t.figa@samsung.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: Re: [v3.10 regression] deadlock on cpu hotplug
Date: Tue, 09 Jul 2013 13:51:19 +0200
Message-id: <1754044.EVIH1UZj6p@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.5.0-rc2+; KDE/4.8.5; i686; ; )
In-reply-to: <51DB724F.9050708@linux.vnet.ibm.com>
References: <1443144.WnBWEpaopK@amdc1032> <51DB724F.9050708@linux.vnet.ibm.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t9jQV3Xn7cDDf6+NLL4vOEfm8XuOYtZ
	LC7vmsNm8bn3CKPF4xVv2S3Wz3jNYrHxq4fFoadzWBw4PL639rF4LN7zksnjzrU9bB4PDm1m
	8ejbsorR48yCI+wenzfJBbBHcdmkpOZklqUW6dslcGU0HNzJUrBPtOL7kyNMDYwHBLoYOTkk
	BEwkTrT0MEPYYhIX7q1n62Lk4hASmM4osaGrCSwhJNDCJDHlijOIzSZgJTGxfRUjiC0ioCux
	6/czsAZmgd+MEievd7KAJIQFrCUWfNnJBGKzCKhKrL2zCGwQr4CmxM31n9lBbFEBe4lt794C
	NXNwcAoYSWyekQSxy19i1qJj7BDlghI/Jt8DG8ksIC+xb/9UVghbR2J/6zS2CYwCs5CUzUJS
	NgtJ2QJG5lWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwRHwTGoH48oGi0OMAhyMSjy8Hy7f
	ChRiTSwrrsw9xCjBwawkwrto5+1AId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHWq0DhQTSE0tS
	s1NTC1KLYLJMHJxSDYxG12a+CA+w3as88abgr4USS21FjKbUzc6f+XfTRWUfX79gA9crT7gm
	H9bVPbdacpeecJfwg7DMA7/lktc4RF9rj5IManGSmq+nWbQk4X2xZuC6HeK6mS1z2DqaHTmU
	HrY5fQ8K43N5IZRXpBBq9/XBj2XuTI/MDkzRkpyzLuVz1YJPh9gYjZRYijMSDbWYi4oTAUHs
	O/98AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday, July 09, 2013 10:15:43 AM Michael Wang wrote:
> Hi, Bartlomiej
> 
> On 07/08/2013 11:26 PM, Bartlomiej Zolnierkiewicz wrote:
> [snip]
> > 
> > # echo 0 > /sys/devices/system/cpu/cpu3/online
> > # echo 0 > /sys/devices/system/cpu/cpu2/online
> > # echo 0 > /sys/devices/system/cpu/cpu1/online
> > # while true;do echo 1 > /sys/devices/system/cpu/cpu1/online;echo 0 > /sys/devices/system/cpu/cpu1/online;done
> > 
> > The commit in question (2f7021a8) was merged in v3.10-rc5 as a fix for
> > commit 031299b ("cpufreq: governors: Avoid unnecessary per cpu timer
> > interrupts") which was causing a kernel warning to show up.
> > 
> > Michael/Viresh: do you have some idea how to fix the issue?
> 
> Thanks for the report :) would you like to take a try
> on below patch and see whether it solve the issue?

It doesn't help and unfortunately it just can't help as it only
addresses lockdep functionality while the issue is not a lockdep
problem but a genuine locking problem. CPU hot-unplug invokes
_cpu_down() which calls cpu_hotplug_begin() which in turn takes
&cpu_hotplug.lock. The lock is then hold during __cpu_notify()
call. Notifier chain goes up to cpufreq_governor_dbs() which for
CPUFREQ_GOV_STOP event does gov_cancel_work(). This function
flushes pending work and waits for it to finish. The all above
happens in one kernel thread. At the same time the other kernel
thread is doing the work we are waiting to complete and it also
happens to do gov_queue_work() which calls get_online_cpus().
Then the code tries to take &cpu_hotplug.lock which is already
held by the first thread and deadlocks.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index 5af40ad..aa05eaa 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -229,6 +229,8 @@ static void set_sampling_rate(struct dbs_data *dbs_data,
>         }
>  }
>  
> +static struct lock_class_key j_cdbs_key;
> +
>  int cpufreq_governor_dbs(struct cpufreq_policy *policy,
>                 struct common_dbs_data *cdata, unsigned int event)
>  {
> @@ -366,6 +368,8 @@ int (struct cpufreq_policy *policy,
>                                         kcpustat_cpu(j).cpustat[CPUTIME_NICE];
>  
>                         mutex_init(&j_cdbs->timer_mutex);
> +                       lockdep_set_class(&j_cdbs->timer_mutex, &j_cdbs_key);
> +
>                         INIT_DEFERRABLE_WORK(&j_cdbs->work,
>                                              dbs_data->cdata->gov_dbs_timer);
>                 }
> 
> Regards,
> Michael Wang

