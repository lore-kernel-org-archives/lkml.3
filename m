Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbaBTQbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:31:04 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27916 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbaBTQbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:31:01 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-68-53062dc30a69
Message-id: <53062DC1.9010504@samsung.com>
Date: Thu, 20 Feb 2014 20:30:57 +0400
From: Alexey Perevalov <a.perevalov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        Anton Vorontsov <anton@enomsg.org>, anton@nomsg.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        akpm@linux-foundation.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH v3 4/6] timerfd: Factor out timer-type unspecific
 timerfd_expire()
References: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com>
 <1392885633-7787-5-git-send-email-a.perevalov@samsung.com>
 <alpine.DEB.2.02.1402201136500.4468@ionos.tec.linutronix.de>
In-reply-to: <alpine.DEB.2.02.1402201136500.4468@ionos.tec.linutronix.de>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t/xK7qHddmCDZ6tlLSYs34Nm8XF1tss
	Fge3alr0/+pktbj+5TmrxZnfuhZnm96wW1zeNYfNYvOmqcwOnB4T+j8xety5tofN4925c+we
	J2b8ZvH4smcvs0ffllWMHp83yQWwR3HZpKTmZJalFunbJXBl/LtSXPBEoGLvjdesDYzLebsY
	OTkkBEwkFhztZoGwxSQu3FvP1sXIxSEksJRR4vyTgywQzmdGicPXD4FV8QpoSbRNOcsMYrMI
	qEq8n/gIyObgYBMwkNh3zxbEFBWIkDi6XBOiWlDix+R7YJ0iAhoSGy/dYgYZySzwjlHi5/wz
	bCAJYaD6Z1u/M0PsOsQo8WPOLSaQBKeAp8SOCbfZQWxmAWuJlZO2MULY8hKb17xlnsAoMAvJ
	kllIymYhKVvAyLyKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIyQSvuxgXHzM6hCjAAejEg9v
	gQRbsBBrYllxZS7QNRzMSiK87ipAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYw6V00zt/s88rNr
	2CfCF2OtfSSiPsn+ygtNNWOlqTZT+LeZeC2OKFG4viaP6WHLWZbsnDM/Ipb+F+WMNbVt/akw
	6ZJT/aqAw/b/Cj7uV7y97/nGf0eV5AO/uLc5v1NirLLL0Kid1Fi6qjfHjvmNS8qZ83fPlcx8
	PFV5I98m/wP90jKfBQUupiqxFGckGmoxFxUnAgA1EGdjYgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 02:52 PM, Thomas Gleixner wrote:
> On Thu, 20 Feb 2014, Alexey Perevalov wrote:
>
>> From: Anton Vorontsov <anton@enomsg.org>
>>
>> There is nothing hrtimer-specific inside the timerfd_tmrproc(), except
>> the function prototype. We're about to add other timer types, so factor
>> out generic timerfd_expire() helper from timerfd_tmrproc().
> This changelog is completely useless. How is timerfd_tmrproc, which is
> not a function but a function pointer, related to the patch?
>
> Moving duplicated code to a common function is nice, but ....
>   
>> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
>> Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
>> ---
>>   fs/timerfd.c |   40 +++++++++++++++++++---------------------
>>   1 file changed, 19 insertions(+), 21 deletions(-)
>>
>> diff --git a/fs/timerfd.c b/fs/timerfd.c
>> index 9293121..3561ce7 100644
>> --- a/fs/timerfd.c
>> +++ b/fs/timerfd.c
>> @@ -229,6 +229,23 @@ static unsigned int timerfd_poll(struct file *file, poll_table *wait)
>>   	return events;
>>   }
>>   
>> +static u64 timerfd_rearm(struct timerfd_ctx *ctx)
>> +{
>> +	u64 orun;
>> +
>> +	if (isalarm(ctx)) {
>> +		orun += alarm_forward_now(
>> +			&ctx->t.alarm, ctx->tintv) - 1;
>> +		alarm_restart(&ctx->t.alarm);
>> +	} else {
>> +		orun += hrtimer_forward_now(&ctx->t.tmr,
>> +		     ctx->tintv) - 1;
>> +		hrtimer_restart(&ctx->t.tmr);
> Warnings are there to be ignored and testing of user space
> interfaces after a change is overrated, right?
>
> Aside of that you just blindly copied the original code w/o fixing up
> the now unnecessary line breaks.
>
> The summary of this patch is:
>
>      1) Breaks existing functionality including user space ABI
>      2) Compiler warnings ignored
>      3) Untested
>      4) Utter lack of programming style
>      5) Useless changelog
>
> Impressive for a trivial thing like this.
>
> Thanks,
>
> 	tglx
>
Compiler warning - if you mean uninitialized orun, I fixed it
ill-timed in the next patch,
yes it should be in original patch.

-- 
Best regards,
Alexey Perevalov
