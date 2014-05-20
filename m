Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750987AbaETFgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 01:36:32 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:50086 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbaETFgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 01:36:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAGo_u6p+XWfQU64Uvbd2-5u5DumoSo1XsDt_s48MF5yXYZDBxA@mail.gmail.com>
References: <1400231366-1221-1-git-send-email-inderpal.s@samsung.com>
	<537A037E.8000800@ti.com>
	<CAOqmu83XqC_B1Abb_+FMc=DywUxL0=_NompWB4ED18UhxxqQNw@mail.gmail.com>
	<CAGo_u6p+XWfQU64Uvbd2-5u5DumoSo1XsDt_s48MF5yXYZDBxA@mail.gmail.com>
Date: Tue, 20 May 2014 11:06:30 +0530
X-Google-Sender-Auth: OTOQkjxU7T03DPL-jDgpyuNG_lw
Message-ID: <CAOqmu80avjT8cjKPLL-JFbP4w8dWqbfSTJQW9XDd16UviSSRDQ@mail.gmail.com>
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

On Tue, May 20, 2014 at 12:04 AM, Nishanth Menon <nm@ti.com> wrote:
> On Mon, May 19, 2014 at 1:08 PM, Inderpal Singh <inderpal.s@samsung.com> wrote:
>> Hi Nishanth,
>>
>> Thanks for the review comments.
>>
>> On Mon, May 19, 2014 at 6:43 PM, Nishanth Menon <nm@ti.com> wrote:
>>> On 05/16/2014 04:09 AM, Inderpal Singh wrote:
>>>> At the driver unloading time the associated opp table may need
>>>> to be deleted. Otherwise it amounts to memory leak. The existing
>>>> OPP library does not have provison to do so.
>>>>
>>>> Hence this patch implements the function to free the opp table.
>>>>
>>>> Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
>>>> ---
>>>>  drivers/base/power/opp.c | 41 +++++++++++++++++++++++++++++++++++++++++
>>>>  include/linux/pm_opp.h   |  6 ++++++
>>>>  2 files changed, 47 insertions(+)
>>>>
>>>> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
>>>> index d9e376a..d45ffd5 100644
>>>> --- a/drivers/base/power/opp.c
>>>> +++ b/drivers/base/power/opp.c
>>>> @@ -654,4 +654,45 @@ int of_init_opp_table(struct device *dev)
>>>>       return 0;
>>>>  }
>>>>  EXPORT_SYMBOL_GPL(of_init_opp_table);
>>>> +
>>>> +/**
>>>> + * dev_pm_opp_free_opp_table() - free the opp table
>>>> + * @dev:     device for which we do this operation
>>>> + *
>>>> + * Free up the allocated opp table
>>>> + *
>>>> + * Locking: The internal device_opp and opp structures are RCU protected.
>>>> + * Hence this function internally uses RCU updater strategy with mutex locks to
>>>> + * keep the integrity of the internal data structures. Callers should ensure
>>>> + * that this function is *NOT* called under RCU protection or in contexts where
>>>> + * mutex locking or synchronize_rcu() blocking calls cannot be used.
>>>> + */
>>>> +void dev_pm_opp_free_opp_table(struct device *dev)
>>>> +{
>>>> +     struct device_opp *dev_opp = NULL;
>>>> +     struct dev_pm_opp *opp;
>>>> +
>>> if (!dev)
>>>         return;
>>>
>>
>> missed it. Will take care in the next version.
>>
>>>> +     /* Hold our list modification lock here */
>>>> +     mutex_lock(&dev_opp_list_lock);
>>>> +
>>>> +     /* Check for existing list for 'dev' */
>>>> +     dev_opp = find_device_opp(dev);
>>>> +     if (IS_ERR(dev_opp)) {
>>>> +             mutex_unlock(&dev_opp_list_lock);
>>>> +             return;
>>>> +     }
>>>> +
>>>> +     while (!list_empty(&dev_opp->opp_list)) {
>>>> +             opp = list_entry_rcu(dev_opp->opp_list.next,
>>>> +                                     struct dev_pm_opp, node);
>>>> +             list_del_rcu(&opp->node);
>>>> +             kfree_rcu(opp, head);
>>>> +     }
>>>
>>> How about the OPP notifiers? should'nt we add a new event
>>> OPP_EVENT_REMOVE?
>>>
>>
>> As this function is to free the whole opp table. Hence, I think,
>> notifier may not be needed. It may be required for per opp removal as
>> is the case with opp addition and enable/disable. But at present there
>> are no users of these notifiers at all. Let me know your view.
>
> umm.. we do have devfreq which depends on OPPs :).

Yes, devfreq does depend on OPPs, but no devfreq driver is registering
its notifier_block to handle OPP notifications.

>
>>> To maintain non-dt behavior coherency, should'nt we rather add a
>>> opp_remove or an opp_del function?
>>
>> Yes we should have opp_remove as well, but what's the use case ?
>> Should we go ahead and implement it Or, wait for the use-case?
>
> IMHO, if we are doing it properly, we should add the requisite
> function as well. we dont want to have differing behavior device tree
> Vs non-DT.

So we will have 2 functions then. One to remove the whole opp table
and the the other to remove the individual OPPs.
I will cover this in v2. Will also take care of the OPP_EVENT_REMOVE
notification part.


Regards,
Inder

>
> Regards,
> Nishanth Menon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
