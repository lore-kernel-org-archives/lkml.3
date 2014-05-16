Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbaEPRIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:08:53 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:46336 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbaEPRIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:08:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohponY6Nn5kYGyps2SLm5uBbH1JWuJBpzzVD=QOc=oM7crAg@mail.gmail.com>
References: <1400231366-1221-1-git-send-email-inderpal.s@samsung.com>
	<CAKohponY6Nn5kYGyps2SLm5uBbH1JWuJBpzzVD=QOc=oM7crAg@mail.gmail.com>
Date: Fri, 16 May 2014 22:38:50 +0530
X-Google-Sender-Auth: RozTqom6zU6LHFmox8Dr-ykzw6E
Message-ID: <CAOqmu82GQ2qsm0c7fq8n5ovR7+4j5t_Y3=03S=nWtR+bH3yhdg@mail.gmail.com>
Subject: Re: [PATCH] PM / OPP: Implement free_opp_table function
From: Inderpal Singh <inderpal.s@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

Thanks for the review.

On Fri, May 16, 2014 at 3:36 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 16 May 2014 14:39, Inderpal Singh <inderpal.s@samsung.com> wrote:
>> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
>> +void dev_pm_opp_free_opp_table(struct device *dev)
>> +{
>> +       struct device_opp *dev_opp = NULL;
>> +       struct dev_pm_opp *opp;
>> +
>> +       /* Hold our list modification lock here */
>> +       mutex_lock(&dev_opp_list_lock);
>> +
>> +       /* Check for existing list for 'dev' */
>> +       dev_opp = find_device_opp(dev);
>> +       if (IS_ERR(dev_opp)) {
>> +               mutex_unlock(&dev_opp_list_lock);
>> +               return;
>> +       }
>> +
>> +       while (!list_empty(&dev_opp->opp_list)) {
>> +               opp = list_entry_rcu(dev_opp->opp_list.next,
>> +                                       struct dev_pm_opp, node);
>
> list_for_each_entry_rcu ?
>

list_for_each_entry_rcu can not be used as opp is being deleted in the loop.

Thanks,
Inder

>> +               list_del_rcu(&opp->node);
>> +               kfree_rcu(opp, head);
>> +       }
>> +
>> +       list_del_rcu(&dev_opp->node);
>> +       mutex_unlock(&dev_opp_list_lock);
>> +       synchronize_rcu();
>> +       kfree(dev_opp);
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
>>         return ERR_PTR(-EINVAL);
>>  }
>> +
>> +void dev_pm_opp_free_opp_table(struct device *dev)
>> +{
>> +}
>>  #endif         /* CONFIG_PM_OPP */
>>
>>  #if defined(CONFIG_PM_OPP) && defined(CONFIG_OF)
>
> Otherwise looks fine.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
