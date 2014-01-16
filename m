Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaAPBDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:03:17 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:39756 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbaAPBDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:03:12 -0500
Message-ID: <52D72FCD.1030005@gmail.com>
Date: Wed, 15 Jan 2014 17:03:09 -0800
From: Marc C <marc.ceeeee@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Christian Daudt <bcm@fixthebug.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 7/7] ARM: brcmstb: dts: add a reference DTS for Broadcom
 7445
References: <1389743333-16741-1-git-send-email-marc.ceeeee@gmail.com> <1389743333-16741-8-git-send-email-marc.ceeeee@gmail.com> <201401151410.39112.arnd@arndb.de> <61E0E2A7-F7FC-4397-8E92-06CC409912B9@gmail.com>
In-Reply-To: <61E0E2A7-F7FC-4397-8E92-06CC409912B9@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd,

> And then you can add a regular device driver to drivers/reset that provides a
> device_reset() API to other drivers, or a system-reset function to be registered as
> arm_pm_restart. This driver would use syscon_regmap_lookup_by_phandle() to get access
> to a regmap pointer, and then use either hardcoded offsets into the regmap, or get
> those offsets from numbers in the devicetree, as provided in the example above.

I was able to port a standalone "reboot" driver using syscon + regmap. However, for the
SMP initialization case, it turns out that syscon is configured *after* SMP init. Do you
have any advice for this type of situation?

I'd hate to go around in circles, but without resorting to hard-coded offsets, perhaps I
can just add the remaining "non-regmap" register offsets in the DT?

Thanks,
Marc

On 01/15/2014 10:22 AM, Marc wrote:
> Hi Arnd,
> 
> Thank you for the suggestion - it's exactly what we were looking for!
> 
> Regards,
> Marc
> 
> Sent from my phone
> 
>> On Jan 15, 2014, at 5:10 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>>
>>> On Wednesday 15 January 2014, Marc Carino wrote:
>>> +       gen-ctrl {
>>> +               compatible = "brcm,brcmstb-gen-ctrl-v1";
>>> +               reg = <0xf0404304 0x4
>>> +                      0xf0404308 0x4
>>> +                      0xf03e2578 0x4
>>> +                      0xf03e2488 0x10
>>> +                      0xf0452000 0x20>;
>>> +       };
>>
>> Sorry I didn't get back to you on this when we discussed the previous
>> version. I'm actually less happy with this DT representation than the
>> original. What I take from your description is that you have multiple
>> register ranges that basically combine more-or-less random registers
>> that belong into different Linux subsystems.
>>
>> I think the best way to deal with this is to have the "syscon" driver
>> handle the multiplexing between the various drivers that need access
>> to the registers. It would look something like (taking the numbers
>> from your previous patch):
>>
>>    ahb {
>>        ranges = <0 0xf0000000 0x1000000>; /* 16 MB remapped registers */
>>
>>        hif-cpubuictrl: syscon@3e2400 {
>>            compatible = "brcm,7445-cpubioctrl", "syscon";
>>            reg = <0x3e2000, 0x1000>;
>>        };
>>
>>        hif-continuation: syscon@45200 {
>>            compatible = "brcm,7445-hif-continuation", "syscon";
>>            reg = <0x452000, 0x1000>;
>>        };
>>
>>        sun-top-ctrl: ...
>>    };
>>
>> This lets the syscon driver find and map the three register areas.
>> Drivers that need access to the registers then do 
>>
>>    reset {
>>        compatible = "brcm,7445-reset-ctrl";
>>        syscon = <&sun-top-ctrl 0x300 0x100>;
>>        #reset-cells = <1>;
>>    };
>>
>> And then you can add a regular device driver to drivers/reset that provides
>> a device_reset() API to other drivers, or a system-reset function to be
>> registered as arm_pm_restart. This driver would use
>> syscon_regmap_lookup_by_phandle() to get access to a regmap pointer,
>> and then use either hardcoded offsets into the regmap, or get those
>> offsets from numbers in the devicetree, as provided in the example
>> above.
>>
>>    Arnd

