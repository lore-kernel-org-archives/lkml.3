Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaESSIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 14:08:42 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:46395 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaESSIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 14:08:40 -0400
MIME-Version: 1.0
In-Reply-To: <537A037E.8000800@ti.com>
References: <1400231366-1221-1-git-send-email-inderpal.s@samsung.com>
	<537A037E.8000800@ti.com>
Date: Mon, 19 May 2014 23:38:40 +0530
X-Google-Sender-Auth: aQys37iB9_KZ6jXlt_U09ic5N-M
Message-ID: <CAOqmu83XqC_B1Abb_+FMc=DywUxL0=_NompWB4ED18UhxxqQNw@mail.gmail.com>
Subject: Re: [PATCH] PM / OPP: Implement free_opp_table function
From: Inderpal Singh <inderpal.s@samsung.com>
To: Nishanth Menon <nm@ti.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nishanth,

Thanks for the review comments.

On Mon, May 19, 2014 at 6:43 PM, Nishanth Menon <nm@ti.com> wrote:
> On 05/16/2014 04:09 AM, Inderpal Singh wrote:
>> At the driver unloading time the associated opp table may need
>> to be deleted. Otherwise it amounts to memory leak. The existing
>> OPP library does not have provison to do so.
>>
>> Hence this patch implements the function to free the opp table.
>>
>> Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
>> ---
>>  drivers/base/power/opp.c | 41 +++++++++++++++++++++++++++++++++++++++++
>>  include/linux/pm_opp.h   |  6 ++++++
>>  2 files changed, 47 insertions(+)
>>
>> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
>> index d9e376a..d45ffd5 100644
>> --- a/drivers/base/power/opp.c
>> +++ b/drivers/base/power/opp.c
>> @@ -654,4 +654,45 @@ int of_init_opp_table(struct device *dev)
>>       return 0;
>>  }
>>  EXPORT_SYMBOL_GPL(of_init_opp_table);
>> +
>> +/**
>> + * dev_pm_opp_free_opp_table() - free the opp table
>> + * @dev:     device for which we do this operation
>> + *
>> + * Free up the allocated opp table
>> + *
>> + * Locking: The internal device_opp and opp structures are RCU protected.
>> + * Hence this function internally uses RCU updater strategy with mutex locks to
>> + * keep the integrity of the internal data structures. Callers should ensure
>> + * that this function is *NOT* called under RCU protection or in contexts where
>> + * mutex locking or synchronize_rcu() blocking calls cannot be used.
>> + */
>> +void dev_pm_opp_free_opp_table(struct device *dev)
>> +{
>> +     struct device_opp *dev_opp = NULL;
>> +     struct dev_pm_opp *opp;
>> +
> if (!dev)
>         return;
>

missed it. Will take care in the next version.

>> +     /* Hold our list modification lock here */
>> +     mutex_lock(&dev_opp_list_lock);
>> +
>> +     /* Check for existing list for 'dev' */
>> +     dev_opp = find_device_opp(dev);
>> +     if (IS_ERR(dev_opp)) {
>> +             mutex_unlock(&dev_opp_list_lock);
>> +             return;
>> +     }
>> +
>> +     while (!list_empty(&dev_opp->opp_list)) {
>> +             opp = list_entry_rcu(dev_opp->opp_list.next,
>> +                                     struct dev_pm_opp, node);
>> +             list_del_rcu(&opp->node);
>> +             kfree_rcu(opp, head);
>> +     }
>
> How about the OPP notifiers? should'nt we add a new event
> OPP_EVENT_REMOVE?
>

As this function is to free the whole opp table. Hence, I think,
notifier may not be needed. It may be required for per opp removal as
is the case with opp addition and enable/disable. But at present there
are no users of these notifiers at all. Let me know your view.

> To maintain non-dt behavior coherency, should'nt we rather add a
> opp_remove or an opp_del function?

Yes we should have opp_remove as well, but what's the use case ?
Should we go ahead and implement it Or, wait for the use-case?

Thanks,
Inder

>
>> +
>> +     list_del_rcu(&dev_opp->node);
>> +     mutex_unlock(&dev_opp_list_lock);
>> +     synchronize_rcu();
>> +     kfree(dev_opp);
>> +}
>> +EXPORT_SYMBOL_GPL(dev_pm_opp_free_opp_table);
>>  #endif
>> diff --git a/include/linux/pm_opp.h b/include/linux/pm_opp.h
>> index 0330217..3c29620 100644
>> --- a/include/linux/pm_opp.h
>> +++ b/include/linux/pm_opp.h
>> @@ -50,6 +50,8 @@ int dev_pm_opp_enable(struct device *dev, unsigned long freq);
>>  int dev_pm_opp_disable(struct device *dev, unsigned long freq);
>>
>>  struct srcu_notifier_head *dev_pm_opp_get_notifier(struct device *dev);
>> +
>> +void dev_pm_opp_free_opp_table(struct device *dev);
>>  #else
>>  static inline unsigned long dev_pm_opp_get_voltage(struct dev_pm_opp *opp)
>>  {
>> @@ -105,6 +107,10 @@ static inline struct srcu_notifier_head *dev_pm_opp_get_notifier(
>>  {
>>       return ERR_PTR(-EINVAL);
>>  }
>> +
>> +void dev_pm_opp_free_opp_table(struct device *dev)
>> +{
>> +}
>>  #endif               /* CONFIG_PM_OPP */
>>
>>  #if defined(CONFIG_PM_OPP) && defined(CONFIG_OF)
>>
>
>
> --
> Regards,
> Nishanth Menon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
