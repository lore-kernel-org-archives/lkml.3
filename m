Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab3BEG3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 01:29:31 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:38340 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab3BEG33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 01:29:29 -0500
MIME-Version: 1.0
In-Reply-To: <CA+Z25wXWUxDBpsZHDoZwoLHVYHb=qN6D7yyLkGDdXMybv+8W8Q@mail.gmail.com>
References: <1357624239-13938-1-git-send-email-rajagopal.venkat@linaro.org>
	<1357624239-13938-3-git-send-email-rajagopal.venkat@linaro.org>
	<CAJ0PZbSowAauHJgRS6eLHA3Tsy-fCJ4KBEBMo=c0QpqLZjjXrw@mail.gmail.com>
	<CA+Z25wXWUxDBpsZHDoZwoLHVYHb=qN6D7yyLkGDdXMybv+8W8Q@mail.gmail.com>
Date: Tue, 5 Feb 2013 15:29:27 +0900
Message-ID: <CAJ0PZbRuc4o4+-c9uaQL4QO-Urwm_kd_me_uXsAUWz6Lw2WMLw@mail.gmail.com>
Subject: Re: [PATCH 3/3] PM / devfreq: account suspend/resume for stats
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: Rajagopal Venkat <rajagopal.venkat@linaro.org>
Cc: jonghwa3.lee@samsung.com, kyungmin.park@samsung.com, mturquette@linaro.org,
        rjw@sisk.pl, patches@linaro.org, linaro-dev@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 8:46 PM, Rajagopal Venkat
<rajagopal.venkat@linaro.org> wrote:
> On 14 January 2013 20:18, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
>> On Tue, Jan 8, 2013 at 2:50 PM, Rajagopal Venkat
>> <rajagopal.venkat@linaro.org> wrote:
>>> devfreq stats is not taking device suspend and resume into
>>> account. Fix it.
>>>
>>> Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
>>
>> With monitor_suspend(), we are suspending the DVFS mechanism of a
>> device, not the device itself.
>>
>> Thus, the device may keep its frequency running and we may assume that
>> the frequency is constant as the DVFS mechanism is in suspend.
>>
>> Why do you want to stop the statistics as well?
>>
>
> There seems to be misunderstanding of devfreq_monitor_suspend() and
> devfreq_monitor_resume() apis usage.
>
> Typically devfreq_monitor_suspend() would be called to suspend the device
> devfreq when device is entering idle state by powering off(clocks and voltage).
> When device itself is off, it's incorrect to allow stats to continue.

Ah.. yes... you're right. It is meant to be called by suspend of
pm-sleep or pm-suspend.
This will be applied soon.


Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

>
>>
>>
>> Again, as in the other patch, this is about the semantics of the
>> "devfreq statistics".
>>
>> It does not seem to be a problem of which is correct and which is not,
>> but it seems to be a problem of which is more convenient.
>>
>> Could you please give me some cases where your semantics is more helpful?
>
> When gpu is powered off, gpu devfreq should be suspended and hence the stats.



>
>>
>>
>>
>> I've been using the stat feature like this:
>>
>> # cat stat; run benchmark; cat stat
>> and look at the differences with any ops done during "run benchmark".
>>
>>
>>
>> Cheers,
>> MyungJoo.
>>
>>> ---
>>>  drivers/devfreq/devfreq.c |   15 ++++++++++++---
>>>  1 file changed, 12 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
>>> index 2843a22..4c50235 100644
>>> --- a/drivers/devfreq/devfreq.c
>>> +++ b/drivers/devfreq/devfreq.c
>>> @@ -297,6 +297,7 @@ void devfreq_monitor_suspend(struct devfreq *devfreq)
>>>                 return;
>>>         }
>>>
>>> +       devfreq_update_status(devfreq, devfreq->previous_freq);
>>>         devfreq->stop_polling = true;
>>>         mutex_unlock(&devfreq->lock);
>>>         cancel_delayed_work_sync(&devfreq->work);
>>> @@ -313,6 +314,8 @@ EXPORT_SYMBOL(devfreq_monitor_suspend);
>>>   */
>>>  void devfreq_monitor_resume(struct devfreq *devfreq)
>>>  {
>>> +       unsigned long freq;
>>> +
>>>         mutex_lock(&devfreq->lock);
>>>         if (!devfreq->stop_polling)
>>>                 goto out;
>>> @@ -321,8 +324,14 @@ void devfreq_monitor_resume(struct devfreq *devfreq)
>>>                         devfreq->profile->polling_ms)
>>>                 queue_delayed_work(devfreq_wq, &devfreq->work,
>>>                         msecs_to_jiffies(devfreq->profile->polling_ms));
>>> +
>>> +       devfreq->last_stat_updated = jiffies;
>>>         devfreq->stop_polling = false;
>>>
>>> +       if (devfreq->profile->get_cur_freq &&
>>> +               !devfreq->profile->get_cur_freq(devfreq->dev.parent, &freq))
>>> +               devfreq->previous_freq = freq;
>>> +
>>>  out:
>>>         mutex_unlock(&devfreq->lock);
>>>  }
>>> @@ -931,11 +940,11 @@ static ssize_t show_trans_table(struct device *dev, struct device_attribute *att
>>>  {
>>>         struct devfreq *devfreq = to_devfreq(dev);
>>>         ssize_t len;
>>> -       int i, j, err;
>>> +       int i, j;
>>>         unsigned int max_state = devfreq->profile->max_state;
>>>
>>> -       err = devfreq_update_status(devfreq, devfreq->previous_freq);
>>> -       if (err)
>>> +       if (!devfreq->stop_polling &&
>>> +                       devfreq_update_status(devfreq, devfreq->previous_freq))
>>>                 return 0;
>>>
>>>         len = sprintf(buf, "   From  :   To\n");
>>> --
>>> 1.7.10.4
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> MyungJoo Ham, Ph.D.
>> Mobile Software Platform Lab, DMC Business, Samsung Electronics
>
>
>
> --
> Regards,
> Rajagopal



-- 
MyungJoo Ham, Ph.D.
System S/W Lab, S/W Center, Samsung Electronics
