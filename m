Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959AbaLINLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:11:40 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54355 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756940AbaLINLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:11:37 -0500
MIME-Version: 1.0
In-Reply-To: <5485DADF.7020109@nvidia.com>
References: <1555621726.710701418024675477.JavaMail.weblogic@epmlwas04c> <5485DADF.7020109@nvidia.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 9 Dec 2014 22:11:16 +0900
Message-ID: <CAAVeFu+ZK_RpHqVQbbqJQV_8NWD3ShHMpNw0RmfFVK0Nykt+oQ@mail.gmail.com>
Subject: Re: [RFC RESEND 0/3] Add watermark support to devfreq
To: Arto Merilainen <amerilainen@nvidia.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        =?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
        "tomeu.vizoso@collabora.com" <tomeu.vizoso@collabora.com>,
        "javier.martinez@collabora.co.uk" <javier.martinez@collabora.co.uk>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "srasal@nvidia.com" <srasal@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 2:07 AM, Arto Merilainen <amerilainen@nvidia.com> wrote:
> Hi MyungJoo,
>
> Thank for your answer, see my answers inline.
>
> On 12/08/2014 09:44 AM, MyungJoo Ham wrote:
>>
>> Please let me start with somewhat naive high-level question:
>>    What do you mean by watermark in this context?
>
>
> Sorry for poor choice of naming. "Load threshold interrupt" might be more
> appropriate. The idea of the series here is to add an ability to program
> hardware to give interrupts when the current load value goes above (or
> below) certain threshold(s). I will revisit the naming.

I personally like the watermark naming and think it is a pretty good
analogy to what this series is doing, but your call.

>
>> Other itching points include:
>> - devfreq_watermark_event() was declared but has never been used.
>>      Who is supposed to call this function?
>
>
> The device profile is responsible to call this function from an interrupt
> handler. I will document this.
>
>> - Is enum watermark_type supposed to be used out of /drivers/devfreq/* ?
>
>
> Yes, the idea is to use the enumerations for informing the type of the
> event. I.e. from interrupt handler we might call:
>   devfreq_watermark_event(devfreq, ACTMON_INTR_BELOW_WMARK);
>
>> - Could you please watermark-specific interfaces (set_high/low_wmark) into
>>      its own public header file? (e.g.,
>> /include/linux/devfreq/governor_wmark.h)
>>    I think we can create another (governor_simpleondemand.h) in there as
>> well
>>      in order to have threshold values configured by device drivers.
>>    Adding governor-specific configurations into devfreq.h seems not
>>      appropriate especially when we expect that we may need many different
>>      governors.

Considering that watermarking is a pretty common technique for the
kind of work that devfreq is attempting to cover (implementing
event-driven frequency scaling vs. polling-driven as current devfreq
does), doesn't it make sense to turn it into a core devfreq feature? I
don't think devfreq can be that easily extended and doing so might
make things messier than they are.

>
>
> I am not convinced that creating two separate interfaces is better than
> extending a single centralised interface. Let us first consider the
> compatibility...:
>
> First, in trivial case the device driver does not implement the threshold
> feature. Obviously we cannot use threshold based governor for scaling but
> all existing polling based governors will work as earlier.
>
> Second, let us assume that we have a device that supports threshold
> interrupts and the driver has implemented the required set_h/l_wmark
> interrupts and calls devfreq_watermark_event() when we get an interrupt.
> This device can therefore use wmark_simple and wmark_active governors. In
> addition to the wmark governors, we may choose to use a polling based
> governor. With current approach the polling governor simply ignores the
> events and leaves the thresholds "as is".
>
> In short, I would not be concerned on compatibility. From governor side it
> should be ok to ignore an event. In addition, it is ok from governor
> initialization to fail in case the device driver does not implement all
> required features.
>
>
> I am also afraid that initialisation makes two-communication-paths approach
> tricky. In code you likely could have..:
>   devfreq_add_device(dev, &pdata->devfreq, "wmark_simple", &extra_fns);
>
> .. but what happens if we wish to change the governor on the fly through
> sysfs? In worst case this is targeting to a governor that requires its own
> data field in initialisation.
>
>>
>>    OR..
>>
>>    This seems that you can keep set_h/l_wmark functions exposed to
>>      drivers/devfreq/* only. Therefore, having
>> /drivers/devfreq/governor_wmark.h
>>      should be sufficient as well, which should be more neat than the
>> above.
>>    The callbacks are to be defined by the devfreq drivers, aren't they?
>
>
> set_h/l_wmark callbacks should be implemented by the device profiles (the
> device drivers themselves) for setting the thresholds on hardware. These are
> not devfreq/governor private functions but something that should be
> implemented inside the device driver.
>
>>
>> - The event name, "DEVFREQ_GOV_WMARK", defined in governor.h, seems to be
>>      more appropriate if it is named "DEVFREQ_GOV_INTERNAL" as we won't
>> need
>>      to define event names for each govornor's internal needs.
>>
>>    OR.. for more generality,
>>      we may define a macro like:
>>
>> #define DEVFREQ_GOV_INTERNAL(value)     ((0x1 << 31) | (value))
>> #define GET_DEVFREQ_GOV_INTERNAL(event) ((event) & ~(0x1 << 31))
>
>
> This should work.
>
>>
>> - In general, I would love to see governors with minimal intervention on
>>      the framework core/main code, especially when it is not beneficial to
>>      other governors. Unlike cpufreq, we may contain many different types
>> of
>>      devices in devfreq, which has the potential to accompany many
>> different
>>      governors.
>>
>
> I would like to see is that we could easily take advantage of hardware
> features and not let framework limit us too much. :-)
>
> For example, Tomeu has been working on ACTMON driver that measures memory
> transfers (please refer to "Add support for Tegra Activity Monitor" series).
> This hardware block is capable of generating interrupts based on activity
> and hence by factoring the series properly, we could use the same governor
> from the series in different places easily. Without proper interfacing
> everyone ends up duplicating the code.

Indeed. Watermarking support would make the ACTMON driver simpler and
easier to integrate with all the governors that devfreq currently has.
Without core support for it, it could only interact properly with its
own, dedicated governor.

MyungJoo, the issue of having this feature in the core vs. having it
as a devfreq "extension" aside, do you agree with the core idea? An
informl ack for the idea would allow us to start leveraging this for
the ACTMON driver. With a concrete user it will make it easier for
everyone to understand how the pieces should fit together.
