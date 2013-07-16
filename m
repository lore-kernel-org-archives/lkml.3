Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933697Ab3GPSNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:13:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:10806 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933334Ab3GPSNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:13:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,678,1367996400"; 
   d="scan'208";a="346572966"
Message-ID: <51E58ECE.2030405@linux.intel.com>
Date: Tue, 16 Jul 2013 11:19:58 -0700
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Thermal: Fix lockup of cpu_down()
References: <1373997748.6458.26.camel@gandalf.local.home>
In-Reply-To: <1373997748.6458.26.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks. How did you trigger this error condition? Is it a code review or 
you have some way to reproduce?

Regards,
Srinivas

On 07/16/2013 11:02 AM, Steven Rostedt wrote:
> Commit f1a18a105 "Thermal: CPU Package temperature thermal" had code
> that did a get_online_cpus(), run a loop and then do a
> put_online_cpus(). The problem is that the loop had an error exit that
> would skip the put_online_cpus() part.
>
> In the error exit part of the function, it also did a get_online_cpus(),
> run a loop and then put_online_cpus(). The only way to get to the error
> exit part is with get_online_cpus() already performed. If this error
> condition is hit, the system will be prevented from taking CPUs offline.
> The process taking the CPU offline will lock up hard.
>
> Removing the get_online_cpus() removes the lockup as the hotplug CPU
> refcount is back to zero.
>
> This was bisected with ktest.
>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>
> diff --git a/drivers/thermal/x86_pkg_temp_thermal.c b/drivers/thermal/x86_pkg_temp_thermal.c
> index 5de56f6..d47624c 100644
> --- a/drivers/thermal/x86_pkg_temp_thermal.c
> +++ b/drivers/thermal/x86_pkg_temp_thermal.c
> @@ -592,7 +592,6 @@ static int __init pkg_temp_thermal_init(void)
>   	return 0;
>   
>   err_ret:
> -	get_online_cpus();
>   	for_each_online_cpu(i)
>   		put_core_offline(i);
>   	put_online_cpus();
>
>
>

