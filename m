Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbaENJbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:31:17 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:47372 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbaENJbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:31:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAGo_u6qTZ-yq26+K5nHut92d=-9nrCHKDNK9EMLK5kGMQc+dOw@mail.gmail.com>
References: <1399966890-22926-1-git-send-email-k.chander@samsung.com>
	<CAGo_u6qTZ-yq26+K5nHut92d=-9nrCHKDNK9EMLK5kGMQc+dOw@mail.gmail.com>
Date: Wed, 14 May 2014 15:01:11 +0530
Message-ID: <CANuQgHGehqDD8-SKTfEKMEZmT5KwofFL8bhYqge0uNm6kpPgUQ@mail.gmail.com>
Subject: Re: [PATCH] PM / OPP: discard duplicate OPP additions
From: Chander Kashyap <chander.kashyap@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nishant,

On 13 May 2014 18:53, Nishanth Menon <nm@ti.com> wrote:
> On Tue, May 13, 2014 at 2:41 AM, [Chander Kashyap
> <chander.kashyap@linaro.org> wrote:
>> From: Chander Kashyap <k.chander@samsung.com>
>>
>> It may be possible to unregister and re-register the cpufreq driver.
>> One such example is arm big-little IKS cpufreq driver. While
>> re-registering the driver, same OPPs may get added again.
>>
>> This patch detects the duplicacy and discards them.
>
> Nice catch. Thanks for the same.
>
> That said, instead of ignoring it (skipping addition), should we do
> the following:
> a) if we find the same OPP being added, return error
> b) add a cleanup routine dev_pm_opp_remove ?
>
> Original design required OPP entries added by platform code and used
> by driver code, but things have changed over time.
>
>>
>> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
>> Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
>> ---
>>  drivers/base/power/opp.c |   28 +++++++++++++++++++---------
>>  1 file changed, 19 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
>> index 2553867..2e803a9 100644
>> --- a/drivers/base/power/opp.c
>> +++ b/drivers/base/power/opp.c
>> @@ -443,23 +443,33 @@ int dev_pm_opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
>>         new_opp->u_volt = u_volt;
>>         new_opp->available = true;
>>
>> -       /* Insert new OPP in order of increasing frequency */
>> +       /*
>> +        * Insert new OPP in order of increasing frequency
>> +        * and discard if already present
>> +        */
>>         head = &dev_opp->opp_list;
>>         list_for_each_entry_rcu(opp, &dev_opp->opp_list, node) {
>> -               if (new_opp->rate < opp->rate)
>> +               if (new_opp->rate <= opp->rate)
>>                         break;
>>                 else
>>                         head = &opp->node;
>>         }
>>
>
> say we do at this point:
> if (new_opp->rate == opp->rate) {
>   dev_err(dev, "%s: attempt to add duplicate OPP entry (rate=%ld)\n",
> __func__, new_opp->rate)
>    kfree(new_opp);
>     return -EINVAL;
> }

Yes this is more cleaner.
But instead of dev_err,  we should use dev_warn and secondly
return 0 rather than EINVAL, as there are independent users for this function

> we could avoid the change below, right?
>
>> -       list_add_rcu(&new_opp->node, head);
>> -       mutex_unlock(&dev_opp_list_lock);
>> +       if (new_opp->rate != opp->rate) {
>> +               list_add_rcu(&new_opp->node, head);
>> +               mutex_unlock(&dev_opp_list_lock);
>> +
>> +               /*
>> +                * Notify the changes in the availability of the operable
>> +                * frequency/voltage list.
>> +                */
>> +               srcu_notifier_call_chain(&dev_opp->head,
>> +                                               OPP_EVENT_ADD, new_opp);
>> +       } else {
>> +               mutex_unlock(&dev_opp_list_lock);
>> +               kfree(new_opp);
>> +       }
>>
>> -       /*
>> -        * Notify the changes in the availability of the operable
>> -        * frequency/voltage list.
>> -        */
>> -       srcu_notifier_call_chain(&dev_opp->head, OPP_EVENT_ADD, new_opp);
>>         return 0;
>>  }
>>  EXPORT_SYMBOL_GPL(dev_pm_opp_add);
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
with warm regards,
Chander Kashyap
