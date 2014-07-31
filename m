Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbaGaID7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 04:03:59 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:61996 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932185AbaGaIDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 04:03:55 -0400
X-IronPort-AV: E=Sophos;i="5.00,1001,1396972800"; 
   d="scan'208";a="34007139"
Message-ID: <53D9F8BD.8010205@cn.fujitsu.com>
Date: Thu, 31 Jul 2014 16:05:17 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Christoph Lameter <cl@gentwo.org>
CC: Fengguang Wu <fengguang.wu@intel.com>, Tejun Heo <tj@kernel.org>,
        Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [scheduler] BUG: unable to handle kernel paging request at 000000000000ce50
References: <20140730135616.GK16537@localhost> <alpine.DEB.2.11.1407300954420.4608@gentwo.org>
In-Reply-To: <alpine.DEB.2.11.1407300954420.4608@gentwo.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 10:55 PM, Christoph Lameter wrote:
> On Wed, 30 Jul 2014, Fengguang Wu wrote:
> 
>> FYI, this commit seems to convert some kernel boot hang bug into
>> different BUG messages.
> 
> Hmmm. Still a bit confused as to why these messages occur.. Does this
> patch do any good?

The vmstat bug can't propagate to scheduler.

I also hope the following patch to be tested earlier for the vmstat bug.

> 
> 
> Subject: vmstat ondemand: Fix online/offline races
> 
> Do not allow onlining/offlining while the shepherd task is checking
> for vmstat threads.
> 
> On offlining a processor do the right thing cancelling the vmstat
> worker thread if it exista and also exclude it from the shepherd
> process checks.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Index: linux/mm/vmstat.c
> ===================================================================
> --- linux.orig/mm/vmstat.c	2014-07-30 09:35:54.602662306 -0500
> +++ linux/mm/vmstat.c	2014-07-30 09:43:07.109037043 -0500
> @@ -1317,6 +1317,7 @@ static void vmstat_shepherd(struct work_
>  {
>  	int cpu;
> 
> +	get_online_cpus();
>  	/* Check processors whose vmstat worker threads have been disabled */
>  	for_each_cpu(cpu, cpu_stat_off)
>  		if (need_update(cpu) &&
> @@ -1325,6 +1326,7 @@ static void vmstat_shepherd(struct work_
>  			schedule_delayed_work_on(cpu, &per_cpu(vmstat_work, cpu),
>  				__round_jiffies_relative(sysctl_stat_interval, cpu));
> 
> +	put_online_cpus();
> 
>  	schedule_delayed_work(&shepherd,
>  		round_jiffies_relative(sysctl_stat_interval));
> @@ -1380,8 +1382,8 @@ static int vmstat_cpuup_callback(struct
>  		break;
>  	case CPU_DOWN_PREPARE:
>  	case CPU_DOWN_PREPARE_FROZEN:
> -		if (!cpumask_test_and_set_cpu(cpu, cpu_stat_off))
> -			cancel_delayed_work_sync(&per_cpu(vmstat_work, cpu));
> +		cancel_delayed_work_sync(&per_cpu(vmstat_work, cpu));
> +		cpumask_clear_cpu(cpu, cpu_stat_off);
>  		break;
>  	case CPU_DOWN_FAILED:
>  	case CPU_DOWN_FAILED_FROZEN:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

