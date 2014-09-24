Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbaIXCIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 22:08:17 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:48959 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754804AbaIXCIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 22:08:15 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
Message-ID: <54222785.5030605@smartplayin.com>
Date: Wed, 24 Sep 2014 07:38:05 +0530
From: Pramod Gurav <pramod.gurav@smartplayin.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Josh Cartwright <joshc@codeaurora.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-pm@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v3] power: reset: use restart_notifier mechanism for msm-poweroff
References: <1411452520-29589-1-git-send-email-pramod.gurav@smartplayin.com> <542112FD.7080302@smartplayin.com> <2C40727B-BF1E-46AC-9189-6B35E358220E@codeaurora.org>
In-Reply-To: <2C40727B-BF1E-46AC-9189-6B35E358220E@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar,

On 23-09-2014 11:18 PM, Kumar Gala wrote:
> 
> On Sep 23, 2014, at 1:28 AM, Pramod Gurav <pramod.gurav@smartplayin.com> wrote:
> 
>> +linux-arm-msm
>> On Tuesday 23 September 2014 11:38 AM, Pramod Gurav wrote:
>>> This change replaces use of arm_pm_restart with recently introduced
>>> reset mechanism in Linux kernel called restart_notifier.
> 
> Can you update the commit message to include details about the priority level we are setting it to.
> 
> Probably something like Josh had:
> 
> Choose priority 128, as according to documentation, this mechanism "is
> sufficient to restart the entire system”.
Will update the commit message.
> 
> Hmm, what happens if we have ps_hold restart and msm-poweroff enabled.  Which one should have priority?
In case of A-family/apq8064, the ps_hold register region is owned by
pinctrl hence the reset is implemented in pinctrl driver as the region
is already mapped there.
I have had a discussion with Stephen Boyd and was informed that ps_hold
register region in apq8074/B-family are moved to its own region and we
need to reset it through pinctrl.

So, for b family there is no need for ps_hold to be configured/muxed in
pinctrl and Josh's changes wont execute. Hence msm-poweroff wil be the
default reset as 128 in the default priority.

Hope I was able to put it well to answer your comment.
> 
>>>
>>> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>>> Cc: Guenter Roeck <linux@roeck-us.net>
>>> Cc: Josh Cartwright <joshc@codeaurora.org>
>>> Cc: Sebastian Reichel <sre@kernel.org>
>>> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>>> Cc: David Woodhouse <dwmw2@infradead.org>
>>> Cc: Stephen Boyd <sboyd@codeaurora.org>
>>> Cc: linux-pm@vger.kernel.org
>>>
>>> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
>>> ---
>>> Tested on Dragonboard APQ8074
>>>
>>> Changes since v2:
>>> - Removed unwanted header file and added linux/pm.h
>>>
>>> Changes since v1:
>>> - Initialized restart_nb with its declaration
>>> - Removed return check for register_restart_handler as it always
>>>  returns 0 as per Guenter's suggestion to Josh's similar patch.
>>>  This takes care of Guenter's comments on error logs and NULL
>>>  initialization of restart_nb.notifier_call.
>>> ---
>>> drivers/power/reset/msm-poweroff.c |   20 ++++++++++++++------
>>> 1 file changed, 14 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/power/reset/msm-poweroff.c b/drivers/power/reset/msm-poweroff.c
>>> index 774f9a3..4702efd 100644
>>> --- a/drivers/power/reset/msm-poweroff.c
>>> +++ b/drivers/power/reset/msm-poweroff.c
>>> @@ -20,21 +20,27 @@
>>> #include <linux/platform_device.h>
>>> #include <linux/module.h>
>>> #include <linux/reboot.h>
>>> -
>>> -#include <asm/system_misc.h>
>>> +#include <linux/pm.h>
>>>
>>> static void __iomem *msm_ps_hold;
>>> -
>>> -static void do_msm_restart(enum reboot_mode reboot_mode, const char *cmd)
>>> +static int do_msm_restart(struct notifier_block *nb, unsigned long action,
>>> +			   void *data)
>>> {
>>> 	writel(0, msm_ps_hold);
>>> 	mdelay(10000);
>>> +
>>> +	return NOTIFY_DONE;
>>> }
>>>
>>> +static struct notifier_block restart_nb = {
>>> +	.notifier_call = do_msm_restart,
>>> +	.priority = 128,
>>> +};
>>> +
>>> static void do_msm_poweroff(void)
>>> {
>>> 	/* TODO: Add poweroff capability */
>>> -	do_msm_restart(REBOOT_HARD, NULL);
>>> +	do_msm_restart(&restart_nb, 0, NULL);
>>> }
>>>
>>> static int msm_restart_probe(struct platform_device *pdev)
>>> @@ -47,8 +53,10 @@ static int msm_restart_probe(struct platform_device *pdev)
>>> 	if (IS_ERR(msm_ps_hold))
>>> 		return PTR_ERR(msm_ps_hold);
>>>
>>> +	register_restart_handler(&restart_nb);
>>> +
>>> 	pm_power_off = do_msm_poweroff;
>>> -	arm_pm_restart = do_msm_restart;
>>> +
>>> 	return 0;
>>> }
>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
