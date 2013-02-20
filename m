Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934418Ab3BTJez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:34:55 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:65402 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932912Ab3BTJew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:34:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAPDyKFpEUO+tJs+2esDkOT9eZuwgj6qScSrMEoG1G3mct-J6sw@mail.gmail.com>
References: <87bobqrcb4.fsf@octavius.laptop.org>
	<1360656096-1671-1-git-send-email-m.szyprowski@samsung.com>
	<Pine.LNX.4.64.1302122309470.14434@axis700.grange>
	<511B41B8.3060506@samsung.com>
	<Pine.LNX.4.64.1302130844530.18535@axis700.grange>
	<20130213113525.GB5062@opensource.wolfsonmicro.com>
	<511C9AD7.6000904@samsung.com>
	<CAPDyKFpEUO+tJs+2esDkOT9eZuwgj6qScSrMEoG1G3mct-J6sw@mail.gmail.com>
Date: Wed, 20 Feb 2013 17:34:51 +0800
Message-ID: <CADz5_g+gh33k9hKi9=1wd=qc-QoOGyGVnkfkT2QoE6cYnHjLKw@mail.gmail.com>
Subject: Re: [PATCH 3/3 RESEND] mmc: sdhci: check voltage range only on
 regulators aware of voltage value
From: Kevin Liu <keyuan.liu@gmail.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/14 Ulf Hansson <ulf.hansson@linaro.org>:
> On 14 February 2013 09:05, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
>>
>> On 2/13/2013 12:35 PM, Mark Brown wrote:
>>>
>>> On Wed, Feb 13, 2013 at 08:45:56AM +0100, Guennadi Liakhovetski wrote:
>>> > On Wed, 13 Feb 2013, Marek Szyprowski wrote:
>>>
>>> > > BTW, mmc_regulator_get_ocrmask() won't work with continuous range
>>> > > regulators.
>>>
>>> > This seems like a problem, that has to be fixed...
>>>
>>> Indeed, what's the issue?
>>
>>
>> There are probably 2 issues:
>>
>> 1. mmc_regulator_get_ocrmask() works only with regulators which support
>> regulator_count_voltages() and regulator_list_voltage(). Recently support
>> for
>> continuous regulators have been merged. Such regulators doesn't provide
>> regulator_list_voltage() method, but are able to change/set voltage to the
>> given value. I agree that they are not very common, so right now we can
>> probably ignore them until the first board, which uses them arrives.
>>
>> 2. The second issue might be related to the testing of precise voltage
>> values
>> in the ocr mask, not the whole allowed ranges. Such issues in sdhci.c driver
>> has been recently fixed by commit cec2e216f72c6b5ccdadb60aadbe99821d744503
>> ("mmc: sdhci: Use regulator min/max voltage range according to spec"), but I
>> don't know MMC core code to judge if ocr mask is used for exact voltage
>> checking or only for checking the voltage ranges. However someone with good
>> mmc subsystem knowledge should check it.
>>
>
> Not 100% sure what your problem relates too here, but I am aware of an
> issue for how the mmc protocol layer are handling ocr_masks. Let me
> try to describe it here:
>
> 1. During "card init" mmc_power_up will be called for telling the host
> driver to provide power to the card. The level of voltage will be set
> to "ocr_avail" which means the highest supported voltage by the host.
> 2. At the protocol layer the card init sequence tries to negotiate to
> lowest possible ocr value from what the card and the host together
> supports. Once done, the ocr mask value will be cached into the host
> struct.
> 3. The host will informed about the new ocr mask from the protocol
> layer with mmc_select_voltage and it somewhere here the problems
> starts. No host are actually changing the voltage level at this state
> (MMC_POWER_ON) which is correct since it would likely mean violation
> of the spec. At the same time the protocol layer still believes the
> host has switched to operate at the new voltage level.

According to the spec, only during the initialization procedure, the
host is not allowed to change the operating voltage range.
In fact, mmc_select_voltage is called before init start in
mmc_attach_sd/mmc_attach_mmc/mmc_attach_sdio.
So voltage level should can be changed during MMC_POWER_ON.
sdhci.c did this way and worked well. But I noticed some other hosts
didn't change voltage for MMC_POWER_ON.
I think it should be changed.

> 4. So the host and the protocol layer are out of sync with regards to
> the ocr mask, which is why the cached ocr_mask in the host struct is
> reset when doing mmc_power_off. Otherwise the suspend/resume sequence
> would have been broken.
>

But there indeed exist issues that the host->ocr doesn't restore after
resume back and operation voltage use the highest voltage.
Just submitted below patch to fix this. Please help to review.
"[PATCH] mmc: core: restore ocr and operation voltage in resume"

Thanks
Kevin
