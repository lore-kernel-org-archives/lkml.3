Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbaEVJtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:49:05 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:44463 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaEVJtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:49:03 -0400
Message-ID: <537DC6D2.8040305@linux.vnet.ibm.com>
Date: Thu, 22 May 2014 15:13:46 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] intel_rapl: Correct hotplug correction
References: <1400750624-19238-1-git-send-email-bp@alien8.de>
In-Reply-To: <1400750624-19238-1-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052209-0260-0000-0000-000004FDE0D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 02:53 PM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> So 009f225ef050 ("powercap, intel-rapl: Fix CPU hotplug callback
> registration") says how get_/put_online_cpus() should be replaced with
> this cpu_notifier_register_begin/_done().
> 
> But they're still there so what's up?
> 

Ok, so I retained that because the comments in the code said that
the caller of rapl_cleanup_data() should hold the hotplug lock.

Here is the snippet from the patch's changelog:

    ...
    Fix the intel-rapl code in the powercap driver by using this latter form
    of callback registration. But retain the calls to get/put_online_cpus(),
    since they also protect the function rapl_cleanup_data(). By nesting
    get/put_online_cpus() *inside* cpu_notifier_register_begin/done(), we avoid
    the ABBA deadlock possibility mentioned above.

But looking closer at the code, I think the only requirement is that
rapl_cleanup_data() should be protected against CPU hotplug, and we
don't actually need to hold the cpu_hotplug.lock per-se.

cpu_notifier_register_begin()/end() also provide equivalent protection
against CPU hotplug. So we should be able to remove the get/put_online_cpus()
from intel-rapl driver.

Jacob/Srinivas, is the above assumption correct for rapl?

Regards,
Srivatsa S. Bhat

> Let me do what was supposed to be done.
> 
> Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  drivers/powercap/intel_rapl.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/powercap/intel_rapl.c b/drivers/powercap/intel_rapl.c
> index d9a0770b6c73..9055f3df1f64 100644
> --- a/drivers/powercap/intel_rapl.c
> +++ b/drivers/powercap/intel_rapl.c
> @@ -1377,8 +1377,6 @@ static int __init rapl_init(void)
> 
>  	cpu_notifier_register_begin();
> 
> -	/* prevent CPU hotplug during detection */
> -	get_online_cpus();
>  	ret = rapl_detect_topology();
>  	if (ret)
>  		goto done;
> @@ -1390,7 +1388,6 @@ static int __init rapl_init(void)
>  	}
>  	__register_hotcpu_notifier(&rapl_cpu_notifier);
>  done:
> -	put_online_cpus();
>  	cpu_notifier_register_done();
> 
>  	return ret;
> 

