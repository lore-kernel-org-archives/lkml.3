Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbaKKIlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:41:14 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:50488 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbaKKIlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:41:10 -0500
MIME-Version: 1.0
In-Reply-To: <546190BA.7050502@nvidia.com>
References: <1414594232-15684-1-git-send-email-tomeu.vizoso@collabora.com>
 <545C8BCC.3090908@nvidia.com> <545CBC87.7050404@collabora.com> <546190BA.7050502@nvidia.com>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Tue, 11 Nov 2014 09:40:49 +0100
X-Google-Sender-Auth: vXxNMhqGic10dND8im7MhhZvRJg
Message-ID: <CAAObsKB9xxS5C7VsP9cBGYDB5ArhbLM0nKEPk8yqWX=iwqcj7A@mail.gmail.com>
Subject: Re: [PATCH 0/3] Add support for Tegra Activity Monitor
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 November 2014 05:29, Alexandre Courbot <acourbot@nvidia.com> wrote:
> On 11/07/2014 09:35 PM, Tomeu Vizoso wrote:
>>
>> On 11/07/2014 10:07 AM, Alexandre Courbot wrote:
>>>
>>> On 10/29/2014 11:50 PM, Tomeu Vizoso wrote:
>>>>
>>>> Hello,
>>>>
>>>> these patches implement support for setting the rate of the EMC clock
>>>> based on
>>>> stats collected from the ACTMON, a piece of hw in the Tegra124 that
>>>> counts
>>>> memory accesses (among others).
>>>>
>>>> It depends on the following in-flight patches:
>>>>
>>>> * MC driver: http://thread.gmane.org/gmane.linux.ports.tegra/19623
>>>> * EMC driver:
>>>> http://thread.gmane.org/gmane.linux.ports.arm.kernel/365125
>>>> * CPUFreq driver: http://thread.gmane.org/gmane.linux.kernel/1812962
>>>>
>>>> I have pushed a branch here for testing:
>>>
>>>
>>> I am not too familiar with DVFS, but after going through this series it
>>> really seems to me that this could use devfreq. In its current form this
>>> driver mixes control and policy and lacks flexibility, preventing e.g.
>>> to switch to a performance or power-saving profile. Could you study the
>>> feasibility of using devfreq for this?
>>
>>
>> Yeah, I started writing a devfreq driver, but then I looked in more
>> detail to the downstream driver and realized that most of the
>> functionality that devfreq provides overlaps with the hw.
>>
>> The ACTMON can be configured to fire an interrupt when a set of
>> thresholds are crossed, similar to the simple-ondemand governor but a
>> bit more sophisticated.
>
>
> I think (after a quick look at devfreq's source) that you can avoid polling
> altogether if you set polling_ms to 0 in your devfreq_dev_profile instance.
> Then it is up to you to call update_devfreq() from your custom governor
> whenever it sees fit.
>
> ACTMON support seems to overlap between being a governor (which reacts to
> ACTMON interrupts and calls update_devfreq() when needed) and part of a
> devfreq_dev_profile (get_dev_status() needs to use the actmon counters). If
> we keep your current design where the driver simply controls a clock, you
> could have the ACTMON driver obtain that clock, register its governor,
> create a non-polling devfreq_dev_profile that controls that clock, and just
> call devfreq_add_device() with both. Then we will have the benefit of being
> able to use ACTMON as well as the performance and powersave governors on
> EMC, and switch policies dynamically.
>
> Another benefit is that you will have a placeholder in the governor to
> implement suspend/resume for the ACTMON IP, in case this becomes necessary
> in the future.
>
> Do you think that would work? Apart from the polling which doesn't seem to
> be an issue, have you seen any other redundancy between devfreq and ACTMON?

I don't think there's any obstacle to having this as a devfreq driver,
it's just that it won't use much/any functionality of it so I don't
really see the point.

I think it will be better if I send a version of the driver that uses
the devfreq framework, so we can better compare (and maybe I will
change my opinion).

Regards,

Tomeu
