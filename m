Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaEUIGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:06:36 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:36659 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaEUIGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:06:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=UgVoBL2xNBwe_AoqtCOYj4Rcc=vHh2kb=64UHLjjiAw@mail.gmail.com>
References: <1400231366-1221-1-git-send-email-inderpal.s@samsung.com>
	<1400651502-23703-1-git-send-email-inderpal.s@samsung.com>
	<CAKohpo=UgVoBL2xNBwe_AoqtCOYj4Rcc=vHh2kb=64UHLjjiAw@mail.gmail.com>
Date: Wed, 21 May 2014 13:36:31 +0530
X-Google-Sender-Auth: C3BYCBdgKdC2ZwzZojSdVRQfrMM
Message-ID: <CAOqmu80zZ3u+XUUaDedpNoziaSVZ_Qbc38yhy4aYVSF1riSfHQ@mail.gmail.com>
Subject: Re: [PATCH v2] PM / OPP: Implement opp_remove and free_opp_table functions
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

On Wed, May 21, 2014 at 1:25 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 21 May 2014 11:21, Inderpal Singh <inderpal.s@samsung.com> wrote:
>> At the driver unloading time the associated opps and its table may need
>> to be deleted. Otherwise it amounts to memory leak. The existing
>> OPP library does not have provision to do so.
>>
>> Hence this patch implements the required functions to free the same.
>>
>> Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
>> ---
>> Changes in v2:
>>         - As suggested by Nishanth, added support to remove a single OPP
>>           for non-DT users
>>         - Added an internal helper function to avoid the code duplication
>>           between opp_remove and free_opp_table functions
>>
>>  drivers/base/power/opp.c | 122 ++++++++++++++++++++++++++++++++++++++++++++++-
>>  include/linux/pm_opp.h   |  14 +++++-
>>  2 files changed, 134 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
>> index faae9cf..22adef3 100644
>> --- a/drivers/base/power/opp.c
>> +++ b/drivers/base/power/opp.c
>> @@ -89,6 +89,7 @@ struct device_opp {
>>         struct device *dev;
>>         struct srcu_notifier_head head;
>>         struct list_head opp_list;
>> +       struct rcu_head head_rcu;
>
> This isn't used ...

Its being used in opp_remove_and_free function to free dev_opp with kfree_rcu.

>
>>  };
>>
>>  /*
>> @@ -427,7 +428,6 @@ int dev_pm_opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
>>                                 __func__);
>>                         return -ENOMEM;
>>                 }
>> -
>
> Unrelated change.

Ahhh, missed it. Thanks for pointing.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
