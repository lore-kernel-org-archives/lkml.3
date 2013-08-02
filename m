Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab3HBG5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 02:57:44 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:35341 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab3HBG5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 02:57:42 -0400
Message-ID: <51FB5789.6030401@linux.vnet.ibm.com>
Date: Fri, 02 Aug 2013 12:24:01 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM list <linux-pm@vger.kernel.org>, cpufreq@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] cpufreq: Avoid double kobject_put() for the same kobject
 in error code path
References: <2204970.DYsqYi7YjZ@vostro.rjw.lan>
In-Reply-To: <2204970.DYsqYi7YjZ@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080206-2674-0000-0000-00000A110DD9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 03:01 AM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The only case triggering a jump to the err_out_unregister label in
> __cpufreq_add_dev() is when cpufreq_add_dev_interface() fails.
> However, if cpufreq_add_dev_interface() fails, it calls kobject_put()
> for the policy kobject in its error code path and since that causes
> the kobject's refcount to become 0, the additional kobject_put() for
> the same kobject under err_out_unregister and the
> wait_for_completion() following it are pointless, so drop them.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> ---
>  drivers/cpufreq/cpufreq.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> Index: linux-pm/drivers/cpufreq/cpufreq.c
> ===================================================================
> --- linux-pm.orig/drivers/cpufreq/cpufreq.c
> +++ linux-pm/drivers/cpufreq/cpufreq.c
> @@ -1109,9 +1109,6 @@ err_out_unregister:
>  	}
>  	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> 
> -	kobject_put(&policy->kobj);
> -	wait_for_completion(&policy->kobj_unregister);
> -
>  err_set_policy_cpu:
>  	per_cpu(cpufreq_policy_cpu, cpu) = -1;
>  	cpufreq_policy_free(policy);
> 

