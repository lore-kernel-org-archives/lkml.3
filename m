Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbaGaFhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 01:37:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37756 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaGaFhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 01:37:50 -0400
Message-ID: <53D9D628.5050800@codeaurora.org>
Date: Thu, 31 Jul 2014 11:07:44 +0530
From: Chintan Pandya <cpandya@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: tglx@linutronix.de, john.stultz@linaro.org, peterz@infradead.org,
        mingo@redhat.com, hughd@google.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 2/2] ksm: Provide support to use deferrable timers
 for scanner thread
References: <1406299698-6357-1-git-send-email-cpandya@codeaurora.org>	<1406299698-6357-2-git-send-email-cpandya@codeaurora.org> <20140730144752.8c931d9ed997324632d5f2fd@linux-foundation.org>
In-Reply-To: <20140730144752.8c931d9ed997324632d5f2fd@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 03:17 AM, Andrew Morton wrote:
> On Fri, 25 Jul 2014 20:18:18 +0530 Chintan Pandya<cpandya@codeaurora.org>  wrote:
>
>> KSM thread to scan pages is scheduled on definite timeout. That wakes
>> up CPU from idle state and hence may affect the power consumption.
>> Provide an optional support to use deferrable timer which suites
>> low-power use-cases.
>>
>> Typically, on our setup we observed, 10% less power consumption with
>> some use-cases in which CPU goes to power collapse frequently. For
>> example, playing audio while typically CPU remains idle.
>>
>> To enable deferrable timers,
>> $ echo 1>  /sys/kernel/mm/ksm/deferrable_timer
>
> This could not have been the version which you tested.  What's up?

My bad :( I will be careful next time
>
> --- a/mm/ksm.c~ksm-provide-support-to-use-deferrable-timers-for-scanner-thread-fix-fix-2
> +++ a/mm/ksm.c
> @@ -1720,8 +1720,6 @@ static int ksmd_should_run(void)
>
>   static int ksm_scan_thread(void *nothing)
>   {
> -	signed long to;
> -
>   	set_freezable();
>   	set_user_nice(current, 5);
>
> @@ -1735,7 +1733,9 @@ static int ksm_scan_thread(void *nothing
>   		try_to_freeze();
>
>   		if (ksmd_should_run()) {
> -			timeout = msecs_to_jiffies(ksm_thread_sleep_millisecs);
> +			signed long to;
> +
> +			to = msecs_to_jiffies(ksm_thread_sleep_millisecs);
>   			if (use_deferrable_timer)
>   				schedule_timeout_deferrable_interruptible(to);
>   			else
> _
>


-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation
