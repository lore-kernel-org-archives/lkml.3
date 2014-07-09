Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbaGIXcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:32:09 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36162 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbaGIXcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:32:06 -0400
Message-ID: <53BDD0F3.7040906@codeaurora.org>
Date: Wed, 09 Jul 2014 16:32:03 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Stephen Warren <swarren@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: a case for a common efuse API?
References: <53BC4DD7.20906@codeaurora.org> <20140709083509.GQ13423@lukather>
In-Reply-To: <20140709083509.GQ13423@lukather>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/14 01:35, Maxime Ripard wrote:
> Hi Stephen,
>
> On Tue, Jul 08, 2014 at 01:00:23PM -0700, Stephen Boyd wrote:
>> Hi,
>>
>> On MSM chips we have some efuses (called qfprom) where we store things
>> like calibration data, speed bins, etc. We need to read out data from
>> the efuses in various drivers like the cpufreq, thermal, etc. This
>> essentially boils down to a bunch of readls on the efuse from a handful
>> of different drivers. In devicetree this looks a little odd because
>> these drivers end up having an extra reg property (or two) that points
>> to a register in the efuse and some length, i.e you see this:
>>
>> 	thermal-sensor@34000 {
>> 		compatible = "sensor";
>> 		reg = <0x34000 0x1000>, <0x10018 0xc>;
>> 		reg-names = "sensor", "efuse_calib";
>> 	}
>>
>>
>> I imagine in DT we want something more like this:
>>
>> 	efuse: efuse@10000 {
>> 		compatible = "efuse";
>> 		reg = <0x10000 0x1000>;
>> 	}
>>
>> 	thermal-sensor@34000 {
>> 		compatible = "sensor";
>> 		reg = <0x34000 0x1000>;
>> 		efuse = <&efuse 0x18>;
>> 	}
> We have pretty much the same things in the Allwinner SoCs. We have an
> efuse directly mapped into memory, with a few informations like a MAC
> address, the SoC ID, the serial number, some RSA keys for the device,
> etc.
>
> The thing is, some boards expose these informations in an external
> EEPROM as well.
>
> I started working and went quite far to create an "eeprom" framework
> to handle these cases, with a dt representation similar to what you
> were exposing.
>
> https://github.com/mripard/linux/tree/eeprom-framework-at24
>
> It was working quite well, I was about to send it, but was told that I
> should all be moved to MTD, and given up on it.

Did anything ever get merged? Or the whole thing was dropped?

That branch looks like what I want, assuming we could get an agreement
on the binding. It looks like pretty much every SoC has this, and there
isn't any API or binding for it that I've seen. The only thing I see is
Documentation/devicetree/bindings/eeprom.txt and that doesn't cover the
client aspect at all.

Taking a quick peek at the code, it might be better to change the read
API to take a buffer and length, so that the caller doesn't need to free
the data allocated by the eeprom layer. It also makes it symmetrical
with the write API. We'd probably also need to make it work really early
for SoC's like Tegra where we want to read the SoC revision early. So
probably split off the device registration part to a later time to allow
register() to be called early.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

