Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab3GPIhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 04:37:32 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:55663 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab3GPIh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 04:37:27 -0400
Message-ID: <51E50570.8080704@linux.vnet.ibm.com>
Date: Tue, 16 Jul 2013 14:03:52 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Michael Wang <wangyun@linux.vnet.ibm.com>, Jiri Kosina <jkosina@suse.cz>,
        Borislav Petkov <bp@alien8.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [LOCKDEP] cpufreq: possible circular locking dependency detected
References: <20130625211544.GA2270@swordfish> <51D10899.1080501@linux.vnet.ibm.com> <20130710231305.GA4046@swordfish> <51DE1BE1.3090707@linux.vnet.ibm.com> <20130714114721.GB2178@swordfish> <20130714120629.GA4067@swordfish> <51E37194.1080103@linux.vnet.ibm.com> <51E3AA3B.9090003@linux.vnet.ibm.com> <20130715082918.GA2435@swordfish> <51E3F6EB.2050807@linux.vnet.ibm.com> <20130715232057.GA2486@swordfish>
In-Reply-To: <20130715232057.GA2486@swordfish>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071608-0260-0000-0000-00000350FBD4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 04:50 AM, Sergey Senozhatsky wrote:
> On (07/15/13 18:49), Srivatsa S. Bhat wrote:
> [..]
>> So here is the solution:
>>
>> On 3.11-rc1, apply these patches in the order mentioned below, and check
>> whether it fixes _all_ problems (both the warnings about IPI as well as the
>> lockdep splat).
>>
>> 1. Patch given in:  https://lkml.org/lkml/2013/7/11/661
>>    (Just apply patch 1, not the entire patchset).
>>
>> 2. Apply the patch shown below, on top of the above patch:
>>
>> ---------------------------------------------------------------------------
>>
> 
> Hello Srivatsa,
> Thanks, I'll test a bit later -- in the morning. (laptop stopped resuming from
> suspend, probably radeon dmp).
> 
> 

Sure, thanks!

> 
> Shouldn't we also kick the console lock?
> 
> 
>  kernel/printk.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index d37d45c..3e20233 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -1926,8 +1926,11 @@ static int __cpuinit console_cpu_notify(struct notifier_block *self,
>  {
>  	switch (action) {
>  	case CPU_ONLINE:
> +	case CPU_ONLINE_FROZEN:
>  	case CPU_DEAD:
> +	case CPU_DEAD_FROZEN:
>  	case CPU_DOWN_FAILED:
> +	case CPU_DOWN_FAILED_FROZEN:
>  	case CPU_UP_CANCELED:
>  		console_lock();
>  		console_unlock();
> 
> 

No need. suspend_console() and resume_console() already handle it
properly in the suspend/resume case, from what I can see.

Regards,
Srivatsa S. Bhat

