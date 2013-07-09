Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab3GICP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 22:15:56 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:46816 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab3GICPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 22:15:53 -0400
Message-ID: <51DB724F.9050708@linux.vnet.ibm.com>
Date: Tue, 09 Jul 2013 10:15:43 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, Borislav Petkov <bp@alien8.de>,
        Jiri Kosina <jkosina@suse.cz>, Tomasz Figa <t.figa@samsung.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [v3.10 regression] deadlock on cpu hotplug
References: <1443144.WnBWEpaopK@amdc1032>
In-Reply-To: <1443144.WnBWEpaopK@amdc1032>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070902-4790-0000-0000-0000092C922B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Bartlomiej

On 07/08/2013 11:26 PM, Bartlomiej Zolnierkiewicz wrote:
[snip]
> 
> # echo 0 > /sys/devices/system/cpu/cpu3/online
> # echo 0 > /sys/devices/system/cpu/cpu2/online
> # echo 0 > /sys/devices/system/cpu/cpu1/online
> # while true;do echo 1 > /sys/devices/system/cpu/cpu1/online;echo 0 > /sys/devices/system/cpu/cpu1/online;done
> 
> The commit in question (2f7021a8) was merged in v3.10-rc5 as a fix for
> commit 031299b ("cpufreq: governors: Avoid unnecessary per cpu timer
> interrupts") which was causing a kernel warning to show up.
> 
> Michael/Viresh: do you have some idea how to fix the issue?

Thanks for the report :) would you like to take a try
on below patch and see whether it solve the issue?

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 5af40ad..aa05eaa 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -229,6 +229,8 @@ static void set_sampling_rate(struct dbs_data *dbs_data,
        }
 }
 
+static struct lock_class_key j_cdbs_key;
+
 int cpufreq_governor_dbs(struct cpufreq_policy *policy,
                struct common_dbs_data *cdata, unsigned int event)
 {
@@ -366,6 +368,8 @@ int (struct cpufreq_policy *policy,
                                        kcpustat_cpu(j).cpustat[CPUTIME_NICE];
 
                        mutex_init(&j_cdbs->timer_mutex);
+                       lockdep_set_class(&j_cdbs->timer_mutex, &j_cdbs_key);
+
                        INIT_DEFERRABLE_WORK(&j_cdbs->work,
                                             dbs_data->cdata->gov_dbs_timer);
                }

Regards,
Michael Wang

> 
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

