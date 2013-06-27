Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab3F0PZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:25:53 -0400
Received: from 3.mo1.mail-out.ovh.net ([46.105.60.232]:51790 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751273Ab3F0PZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 11:25:52 -0400
Message-ID: <51CC3750.7070803@overkiz.com>
Date: Thu, 27 Jun 2013 15:00:00 +0200
From: =?ISO-8859-1?Q?Ga=EBl_PORTAY?= <g.portay@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Bryan Wu <cooloney@gmail.com>
CC: Joe Perches <joe@perches.com>, Rob Landley <rob@landley.net>,
        Richard Purdie <rpurdie@rpsys.net>,
        "Milo(Woogyom) Kim" <milo.kim@ti.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        b.brezillon@overkiz.com
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [RFC PATCH] led: add Cycle LED trigger.
References: <1371572663-10846-1-git-send-email-g.portay@overkiz.com> <1371593140.2038.8.camel@joe-AO722> <51C2CF0B.1010007@overkiz.com> <CAK5ve-+QSNX82Tr3fqXH-_+7TvkLiR1pvStAh5iCR8shAs1M4w@mail.gmail.com>
In-Reply-To: <CAK5ve-+QSNX82Tr3fqXH-_+7TvkLiR1pvStAh5iCR8shAs1M4w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 4012988744742726592
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrkeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrkeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 20, 2013, at 7:58 PM, Bryan Wu <cooloney@gmail.com> wrote:

> On Thu, Jun 20, 2013 at 2:44 AM, Gaël PORTAY <g.portay@overkiz.com> wrote:
>> On 19/06/2013 00:05, Joe Perches wrote:
>>>
>>> On Tue, 2013-06-18 at 18:24 +0200, Gaël PORTAY wrote:
>>>>
>>>> Currently, none of available triggers supports playing with the LED
>>>> brightness
>>>> level.  The cycle trigger provides a way to define custom brightness
>>>> cycle.
>>>> For example, it is easy to customize the cycle to mock up the rhythm of
>>>> human
>>>> breathing which is a nice cycle to tell the user the system is doing
>>>> something.
>>>
>>> I think maybe this is a userspace thing, but here's a
>>> trivial comment or two
>>>
>>>
>>>> +static int cycle_start(struct cycle_trig_data *data)
>>>> +{
>>>> +       unsigned long flags;
>>>> +
>>>> +       if (hrtimer_active(&data->timer))
>>>> +               return -EINVAL;
>>>> +
>>>> +       spin_lock_irqsave(&data->lock, flags);
>>>> +       data->plot_index = 0;
>>>> +       data->cycle_count = 0;
>>>> +       hrtimer_start(&data->timer, ktime_get(), HRTIMER_MODE_ABS);
>>>> +       spin_unlock_irqrestore(&data->lock, flags);
>>>> +
>>>> +       return 1;
>>>
>>> Maybe return 0 on success
>>>
>>>> +static ssize_t cycle_control_store(struct device *dev,
>>>> +                                   struct device_attribute *attr,
>>>> +                                   const char *buf, size_t size)
>>>> +{
>>>> +       struct led_classdev *led_cdev = dev_get_drvdata(dev);
>>>> +       struct cycle_trig_data *data = led_cdev->trigger_data;
>>>> +
>>>> +       if (strncmp(buf, "start", sizeof("start") - 1) == 0)
>>>> +               cycle_start(data);
>>>> +       else if (strncmp(buf, "stop", sizeof("stop") - 1) == 0)
>>>> +               cycle_stop(data);
>>>> +       else if (strncmp(buf, "reset", sizeof("reset") - 1) == 0)
>>>> +               cycle_reset(data);
>>>> +       else if (strncmp(buf, "pause", sizeof("stop") - 1) == 0)
>>>> +               cycle_pause(data);
>>>> +       else if (strncmp(buf, "resume", sizeof("resume") - 1) == 0)
>>>> +               cycle_resume(data);
>>>> +       else
>>>> +               return -EINVAL;
>>>
>>> I think strcasecmp better than strncmp
>>>
>>>> +static ssize_t cycle_rawplot_store(struct device *dev,
>>>> +                                  struct device_attribute *attr,
>>>> +                                  const char *buf, size_t size)
>>>> +{
>>>
>>> []
>>> +       plot = kzalloc(size, GFP_KERNEL);
>>> +       if (plot) {
>>> +               hrtimer_cancel(&data->timer);
>>>
>>> Ick.
>>>
>>>        if (!plot)
>>>                return -ENOMEM;
>>>
>>>        etc...
>>>
>> Hello,
>>
>> Thanks a lot for your review. I took your remarks into consideration and
>> fixed the mistakes.
>>
>> About the kernel/user space discussion, I'd rather keep the cycle trigger
>> implementation in the kernel space,
>> because it implies brightness change every 10-100ms or less. This 
>> leads to
>> lots of context switches, and I'm not
>> even sure the user space can handle such timings accurately.
>>
>> Could you detail your concerns about adding this driver in the kernel?
>>
>> Best Regards,
>> Gaël
>
> Hi Gaël,
>
> Is that possible to extend an existing leds trigger like ledtrig-timer
> or other triggers instead of creating a new one?
>
> Thanks,
> -Bryan

Hi Bryan,

I'm sorry but the cycle trigger interface is too much different from 
already defined triggers. That's why I have decided to create a new one.

The cycle trigger purposes are:
  - to control a cycle (start/stop pause/resume reset), and
  - to play with the brightness level

But it's possible to implement the timer and heartbeat triggers using 
the interface of the cycle trigger.

Yours sincerely,
Gaël


