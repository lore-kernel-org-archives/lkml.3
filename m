Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbaGJO4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:56:06 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59999 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbaGJO4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:56:03 -0400
Message-ID: <53BEB443.9000606@ti.com>
Date: Thu, 10 Jul 2014 18:41:55 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Stephen Boyd <sboyd@codeaurora.org>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: a case for a common efuse API?
References: <53BC4DD7.20906@codeaurora.org> <20140709083509.GQ13423@lukather> <53BDD0F3.7040906@codeaurora.org> <20140710142616.GD27469@lukather>
In-Reply-To: <20140710142616.GD27469@lukather>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 05:26 PM, Maxime Ripard wrote:
> On Wed, Jul 09, 2014 at 04:32:03PM -0700, Stephen Boyd wrote:
>> On 07/09/14 01:35, Maxime Ripard wrote:
>>> Hi Stephen,
>>>
>>> On Tue, Jul 08, 2014 at 01:00:23PM -0700, Stephen Boyd wrote:
>>>> Hi,
>>>>
>>>> On MSM chips we have some efuses (called qfprom) where we store things
>>>> like calibration data, speed bins, etc. We need to read out data from
>>>> the efuses in various drivers like the cpufreq, thermal, etc. This
>>>> essentially boils down to a bunch of readls on the efuse from a handful
>>>> of different drivers. In devicetree this looks a little odd because
>>>> these drivers end up having an extra reg property (or two) that points
>>>> to a register in the efuse and some length, i.e you see this:
>>>>
>>>> 	thermal-sensor@34000 {
>>>> 		compatible = "sensor";
>>>> 		reg = <0x34000 0x1000>, <0x10018 0xc>;
>>>> 		reg-names = "sensor", "efuse_calib";
>>>> 	}
>>>>
>>>>
>>>> I imagine in DT we want something more like this:
>>>>
>>>> 	efuse: efuse@10000 {
>>>> 		compatible = "efuse";
>>>> 		reg = <0x10000 0x1000>;
>>>> 	}
>>>>
>>>> 	thermal-sensor@34000 {
>>>> 		compatible = "sensor";
>>>> 		reg = <0x34000 0x1000>;
>>>> 		efuse = <&efuse 0x18>;
>>>> 	}

Why don't use "syscon" framework for your needs? (mfd/syscon.c)

>>> We have pretty much the same things in the Allwinner SoCs. We have an
>>> efuse directly mapped into memory, with a few informations like a MAC
>>> address, the SoC ID, the serial number, some RSA keys for the device,
>>> etc.
>>>
>>> The thing is, some boards expose these informations in an external
>>> EEPROM as well.
>>>
>>> I started working and went quite far to create an "eeprom" framework
>>> to handle these cases, with a dt representation similar to what you
>>> were exposing.
>>>
>>> https://github.com/mripard/linux/tree/eeprom-framework-at24
>>>
>>> It was working quite well, I was about to send it, but was told that I
>>> should all be moved to MTD, and given up on it.
>>
>> Did anything ever get merged? Or the whole thing was dropped?
>
> Nope, I just never posted it. I could send it as an RFC though, and
> see what are the feedbacks.
>
>> That branch looks like what I want, assuming we could get an agreement
>> on the binding. It looks like pretty much every SoC has this, and there
>> isn't any API or binding for it that I've seen. The only thing I see is
>> Documentation/devicetree/bindings/eeprom.txt and that doesn't cover the
>> client aspect at all.
>>
>> Taking a quick peek at the code, it might be better to change the read
>> API to take a buffer and length, so that the caller doesn't need to free
>> the data allocated by the eeprom layer. It also makes it symmetrical
>> with the write API. We'd probably also need to make it work really early
>> for SoC's like Tegra where we want to read the SoC revision early. So
>> probably split off the device registration part to a later time to allow
>> register() to be called early.
>
> I guess that the kind of things we could discuss after posting these
> patches, but yep, it looks reasonnable.
>
> I'll try to get things a bit cleaner, and post them in the next days.
>

Regards,
-grygorii
