Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab3KNRI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 12:08:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:53478 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567Ab3KNRIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 12:08:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,700,1378882800"; 
   d="scan'208";a="433538008"
Message-ID: <52850320.1050101@intel.com>
Date: Thu, 14 Nov 2013 18:06:40 +0100
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Yong Wang <yong.y.wang@linux.intel.com>, rui.zhang@intel.com,
        len.brown@intel.com
CC: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM: remove device suspend and resume from "freeze" flow
References: <20131111051859.GA18150@yong.y.wang@linux.intel.com>
In-Reply-To: <20131111051859.GA18150@yong.y.wang@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 6:18 AM, Yong Wang wrote:
> "freeze" was originally designed to be equal to
> frozen processes + suspended devices + idle processors.
> Frankly speaking, "freeze" has not been widely adopted so far
> since it was introduced. Following might be some reasons of
> why that is the case.
>
> 1. As traditional s3 is going away, there will be more devices
> supporting connected standby instead. Unlike traditional s3, connected
> standby is a power state that devices enter and exit more frequently.
> Therefore, the entry and exit latency of connected standby state must
> be as short as possible in order to minimize the impact on average
> power and to achieve a decent battery life. With the current design
> of "freeze", device suspend and resume contribute to the overall
> entry and exit latency of "freeze" state significantly. Therefore
> removing device suspend and resume could cut the latency dramatically.

Yes, it could.

> 2. With the interaction between runtime PM and system PM, devices
> that have been runtime suspended before system enters "freeze" state
> will first be runtime resumed and then suspended again by their suspend
> callback. When system exits "freeze" state, all devices will be resumed
> despite the fact that only some devices need to participate in handling
> the wakeup event. Then devices that were previously runtime suspended
> will be runtime suspended again. Wouldn't it be better if we could
> leave those devices runtime suspended during "freeze" and only have
> necessary devices runtime resumed to handle wakeup event when system
> exits "freeze" state.

That only is correct for PCI devices at the moment, if I remember 
correctly.  Moreover, it doesn't have to be this way and we may just 
remove that thing.

> 3. In practice, we have found many device drivers that will not
> put their devices into proper low power states because traditional
> s3 will yank the platform power as a whole as the final step of s3.
> Because many driver developers are still holding that assumption and
> assume that someone else will help do all the power setting correctly
> as the final step of s3, they simply leave their devices in a high
> power state. In contract, many driver developers are able to do the
> right thing with their runtime PM code because they know they are on
> their own and no one else is going to help them put their devices
> into a proper low power state.
>
> Due to the reasons listed above, I propose to remove device suspend
> and rsume from "freeze" flow and and make it equal to
> frozen processes + idle processors which I belive will make "freeze"
> more useful.

I'm generally fine with this change, but your point 2 above is quite 
arguable.

Thanks,
Rafael

> Signed-off-by: Yong Wang <yong.y.wang@intel.com>
> ---
>   kernel/power/suspend.c |   44 ++++++++++++++++++++++++++------------------
>   1 files changed, 26 insertions(+), 18 deletions(-)
>
> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> index 62ee437..4501cb9 100644
> --- a/kernel/power/suspend.c
> +++ b/kernel/power/suspend.c
> @@ -184,10 +184,12 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
>   			goto Platform_finish;
>   	}
>   
> -	error = dpm_suspend_end(PMSG_SUSPEND);
> -	if (error) {
> -		printk(KERN_ERR "PM: Some devices failed to power down\n");
> -		goto Platform_finish;
> +	if (need_suspend_ops(state)) {
> +		error = dpm_suspend_end(PMSG_SUSPEND);
> +		if (error) {
> +			printk(KERN_ERR "PM: Some devices failed to power down\n");
> +			goto Platform_finish;
> +		}
>   	}
>   
>   	if (need_suspend_ops(state) && suspend_ops->prepare_late) {
> @@ -239,7 +241,8 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
>   	if (need_suspend_ops(state) && suspend_ops->wake)
>   		suspend_ops->wake();
>   
> -	dpm_resume_start(PMSG_RESUME);
> +	if (need_suspend_ops(state))
> +		dpm_resume_start(PMSG_RESUME);
>   
>    Platform_finish:
>   	if (need_suspend_ops(state) && suspend_ops->finish)
> @@ -266,16 +269,19 @@ int suspend_devices_and_enter(suspend_state_t state)
>   		if (error)
>   			goto Close;
>   	}
> -	suspend_console();
> -	suspend_test_start();
> -	error = dpm_suspend_start(PMSG_SUSPEND);
> -	if (error) {
> -		pr_err("PM: Some devices failed to suspend, or early wake event detected\n");
> -		goto Recover_platform;
> +
> +	if (need_suspend_ops(state)) {
> +		suspend_console();
> +		suspend_test_start();
> +		error = dpm_suspend_start(PMSG_SUSPEND);
> +		if (error) {
> +			pr_err("PM: Some devices failed to suspend, or early wake event detected\n");
> +			goto Recover_platform;
> +		}
> +		suspend_test_finish("suspend devices");
> +		if (suspend_test(TEST_DEVICES))
> +			goto Recover_platform;
>   	}
> -	suspend_test_finish("suspend devices");
> -	if (suspend_test(TEST_DEVICES))
> -		goto Recover_platform;
>   
>   	do {
>   		error = suspend_enter(state, &wakeup);
> @@ -283,10 +289,12 @@ int suspend_devices_and_enter(suspend_state_t state)
>   		&& suspend_ops->suspend_again && suspend_ops->suspend_again());
>   
>    Resume_devices:
> -	suspend_test_start();
> -	dpm_resume_end(PMSG_RESUME);
> -	suspend_test_finish("resume devices");
> -	resume_console();
> +	if (need_suspend_ops(state)) {
> +		suspend_test_start();
> +		dpm_resume_end(PMSG_RESUME);
> +		suspend_test_finish("resume devices");
> +		resume_console();
> +	}
>    Close:
>   	if (need_suspend_ops(state) && suspend_ops->end)
>   		suspend_ops->end();

