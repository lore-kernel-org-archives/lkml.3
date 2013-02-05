Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3BEKnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:43:04 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:51773 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab3BEKm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:42:59 -0500
X-Greylist: delayed 94105 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2013 05:42:59 EST
MIME-Version: 1.0
In-Reply-To: <CAJ0PZbT9SEphLvnguhjho=OuoEE4KkQZfz2s4YrsoKwv=VbvEg@mail.gmail.com>
References: <1357624239-13938-1-git-send-email-rajagopal.venkat@linaro.org>
	<CAJ0PZbTAOdQrUjefOpc2MDam1hHLjSEDLHw3VrP+9=OAbgQ8ug@mail.gmail.com>
	<CA+Z25wVnFMkXvSOvetipBEFkZgSKe2Qjn1wYf-x5i7skGQ-XSA@mail.gmail.com>
	<CAJ0PZbT9SEphLvnguhjho=OuoEE4KkQZfz2s4YrsoKwv=VbvEg@mail.gmail.com>
Date: Tue, 5 Feb 2013 16:12:58 +0530
Message-ID: <CA+Z25wW8ZRCsrXbiLLiJPgtgWVWcXgXarHRQo_NCHyJ8fvx8ww@mail.gmail.com>
Subject: Re: [PATCH 1/3] PM / devfreq: set min/max freq limit from freq table
From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
To: MyungJoo Ham <myungjoo.ham@gmail.com>
Cc: kyungmin.park@samsung.com, mturquette@linaro.org, rjw@sisk.pl,
        patches@linaro.org, linaro-dev@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 February 2013 12:21, MyungJoo Ham <myungjoo.ham@gmail.com> wrote:
> On Tue, Jan 15, 2013 at 8:21 PM, Rajagopal Venkat
> <rajagopal.venkat@linaro.org> wrote:
>> On 14 January 2013 20:06, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
>>> On Tue, Jan 8, 2013 at 2:50 PM, Rajagopal Venkat
>>> <rajagopal.venkat@linaro.org> wrote:
>>>> Set devfreq device min and max frequency limits when device
>>>> is added to devfreq, provided frequency table is supplied.
>>>> This helps governors to suggest target frequency with in
>>>> limits.
>>>>
>>>> Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
>>>
>>> Could you please elaborate the benefit of the patch?
>>>
>>
>> When freq table is supplied, it's unreasonable to suggest the target frequency
>> which is - target_freq < min_freq and target_freq > max_freq. It avoids
>> unnecessary checks at devfreq drivers.
>
> Is it a safety barrier against userspace processes or devfreq governors?
> Users are allowed to enter min_freq and max_freq via sysfs interfaces anyway.
> Also, as mentioned earlier, users are allowed to enter 0 in order to
> "disengage" the min/max_freq.

It doesn't interfere with userspace updates to min_freq/max_freq. The
min/max limits from freq table are assigned only during the device
devfreq init, which can be overwritten by userspace.

> If we need "hardware-specific" min/max value, we'd need another sysfs
> interfaces and values (i.e., scaling_min/max_freq vs
> cpuinfo_min/max_freq).

In my opinion, min_freq and max_freq itself represents the devfreq
device freq limits. Additional sysfs interfaces may not be required.

>
> Besides, if you are able to provide "freq_table", it means that you
> are able to provide OPP for the device.
> Then, you can use OPP APIs to avoid unnecessary checks at devfreq
> driver (even you can use the devfreq helper functions)

That's my intention as well. If driver is able to provide freq_table,
based on the load, let devfreq core suggest only the supported opps
(not just the limits, but for all intermediate opps). In which case,
devfreq core must mandate drivers to add OPP table(instead of passing
freq array) before registering with devfreq.

>
>>
>>> The devfreq device drivers are required to choose proper frequencies
>>> anyway regardless which values the governors may give (hopefully by
>>> choosing the closest value that can support the required performance).
>>>
>>
>> Yes. but then each driver needs to have conditional checks for choosing
>> closet value even though freq table is provided.
>
> Even with this min/max-freq, when governors suggests some values
> between min/max, each driver needs to have checks unless it uses OPP.

With above proposal, devfreq should suggest only supported opps.

>
>>
>>> Besides, the min/max values are to be set by userspace. Users may
>>> enter 0 in order to express that they do not want to limit the
>>> behaviors of governors.
>
> Because of this, this patch will create discrepency from/to userspace
> interfaces.

As said above, there is no conflict of interest between userspace and
this patch.

In summary, I propose making OPP table mandatory for all devfreq
drivers, to enable devfreq core to suggest only supported opps. Any
thoughts?

>
>
>
>
> Cheers,
> MyungJoo.
>
>>>
>>>
>>> Cheers,
>>> MyungJoo.
>>>
>>>> ---
>>>>  drivers/devfreq/devfreq.c |   24 ++++++++++++++++++++++++
>>>>  1 file changed, 24 insertions(+)
>>>>
>>>> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
>>>> index a8f0173..5782c9b 100644
>>>> --- a/drivers/devfreq/devfreq.c
>>>> +++ b/drivers/devfreq/devfreq.c
>>>> @@ -69,6 +69,29 @@ static struct devfreq *find_device_devfreq(struct device *dev)
>>>>  }
>>>>
>>>>  /**
>>>> + * devfreq_set_freq_limits() - Set min and max frequency from freq_table
>>>> + * @devfreq:   the devfreq instance
>>>> + */
>>>> +static void devfreq_set_freq_limits(struct devfreq *devfreq)
>>>> +{
>>>> +       int idx;
>>>> +       unsigned long min = ~0, max = 0;
>>>> +
>>>> +       if (!devfreq->profile->freq_table)
>>>> +               return;
>>>> +
>>>> +       for (idx = 0; idx < devfreq->profile->max_state; idx++) {
>>>> +               if (min > devfreq->profile->freq_table[idx])
>>>> +                       min = devfreq->profile->freq_table[idx];
>>>> +               if (max < devfreq->profile->freq_table[idx])
>>>> +                       max = devfreq->profile->freq_table[idx];
>>>> +       }
>>>> +
>>>> +       devfreq->min_freq = min;
>>>> +       devfreq->max_freq = max;
>>>> +}
>>>> +
>>>> +/**
>>>>   * devfreq_get_freq_level() - Lookup freq_table for the frequency
>>>>   * @devfreq:   the devfreq instance
>>>>   * @freq:      the target frequency
>>>> @@ -476,6 +499,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
>>>>                                                 devfreq->profile->max_state,
>>>>                                                 GFP_KERNEL);
>>>>         devfreq->last_stat_updated = jiffies;
>>>> +       devfreq_set_freq_limits(devfreq);
>>>>
>>>>         dev_set_name(&devfreq->dev, dev_name(dev));
>>>>         err = device_register(&devfreq->dev);
>>>> --
>>>> 1.7.10.4
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>
>>> --
>>> MyungJoo Ham, Ph.D.
>>> Mobile Software Platform Lab, DMC Business, Samsung Electronics
>>
>>
>>
>> --
>> Regards,
>> Rajagopal
>
>
>
> --
> MyungJoo Ham, Ph.D.
> System S/W Lab, S/W Center, Samsung Electronics



-- 
Regards,
Rajagopal
