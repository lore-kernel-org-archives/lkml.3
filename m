Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab3HUKTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 06:19:32 -0400
Received: from iona.labri.fr ([147.210.8.143]:50289 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab3HUKR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 06:17:58 -0400
Message-ID: <521493DC.9000905@labri.fr>
Date: Wed, 21 Aug 2013 12:18:04 +0200
From: Martin Peres <martin.peres@labri.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
CC: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: nouveau: temperature on nv40 is unavailable since ad40d73ef533ab0ad16b4a1ab2f7870c1f8ab954
References: <1836330.fGgIDqPTNA@pali> <201308150924.49518@pali> <520D547F.2060600@labri.fr> <1616575.x8rWiILC8l@pali>
In-Reply-To: <1616575.x8rWiILC8l@pali>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/08/2013 09:14, Pali Rohár wrote:
> On Thursday 15 August 2013 18:21:51 Martin Peres wrote:
>> On 15/08/2013 03:24, Pali Rohár wrote:
>>> On Thursday 15 August 2013 04:07:24 Martin Peres wrote:
>>>> On 14/08/2013 05:02, Pali Rohár wrote:
>>>>> On Tuesday 13 August 2013 15:55:28 Martin Peres wrote:
>>>>>> On 13/08/2013 09:53, Pali Rohár wrote:
>>>>>>> On utorok, 13. augusta 2013 15:32:45 CEST, Martin Peres
>>>>> wrote:
>>>>>>>> On 13/08/2013 09:23, Pali Rohár wrote:
>>>>>>>>> On Tuesday 13 August 2013 09:01:19 Martin Peres wrote:
>>>>>>>>     ...
>>>>>>>>
>>>>>>>> You can check the temperature by running nvidia-settings.
>>>>>>>> If you can't see the temperature in it, then nvidia
>>>>>>>> doesn't support it on your card and
>>>>>>>> I'm not sure we should :s
>>>>>>>>
>>>>>>>> Thanks for the vbios you sent me in private. For the
>>>>>>>> others, the reason why he doesn't have temperature
>>>>>>>> anymore is because his vbios lacks sensor calibration
>>>>>>>> values.
>>>>>>> In nvidia-settings tab "GPU 0 - (GeForce 6600 GT)" -->
>>>>>>> "Thermal Settings" is:
>>>>>>>
>>>>>>> Thermal Sensor Information:
>>>>>>> ID: 0
>>>>>>> Target: GPU
>>>>>>> Provider: GPU Internal
>>>>>>> Temperature: 70 C (now)
>>>>>>>
>>>>>>> I looked in Windows program SpeedFan. It found Nvidia PCI
>>>>>>> card and reported "GPU Temp" about 68-70 C. So it looks
>>>>>>> like both nvidia driver and windows SpeedFan program
>>>>>>> reading same values.
>>>>>> Great, I'll cook you a patch in a bit and you'll see what
>>>>>> the temperature is like. It won't be perfectly accurate
>>>>>> but there is some kind of default for nvidia cards of this
>>>>>> generation.
>>>>> Ok, send me patch and I can try it if it will work and
>>>>> report similar values as windows or nvidia driver.
>>>> Sorry for the late answer.
>>>>
>>>> Please test this patch. Be aware that temperature with nouveau
>>>> will be higher than with the blob.
>>>> I only want to see if nouveau reports a temperature.
>>>>
>>>> The only way to be sure if the values are good-enough would be
>>>> to use the blob and run:
>>>> nvapeek 0x15b0
>>>> Please send me the result along with the temperature reported
>>>> by nvidia at the time of the peek.
>>>>
>>>> Martin
>>>>
>>>> PS: This patch has only be compile-tested, I don't have access
>>>> to an nv4x right now.
>>> Hello,
>>>
>>> now after patch nouveau report temperature:
>>>
>>> $ sensors
>>> ...
>>> nouveau-pci-0500
>>> Adapter: PCI adapter
>>> temp1:        +63.0°C  (high = +95.0°C, hyst =  +3.0°C)
>>>
>>>                          (crit = +145.0°C, hyst =  +2.0°C)
>>>                          (emerg = +135.0°C, hyst =  +5.0°C)
>> Ok, that was expected ;)
>>
>>> ...
>>>
>>> I found that nvidia binary driver has command line utility
>>> nvidia-smi which report same temperature as X utility nvidia-
>>> settings. So I will use nvidia-smi (if it is OK).
>>>
>>> And after reboot nvidia report another temperature value:
>>>
>>> $ nvidia-smi -q -d TEMPERATURE
>>> ...
>>> GPU 0000:05:00.0
>>>
>>>       Temperature
>>>       
>>>           Gpu                     : 70 C
>>>
>>> Immediately I called nvapeek command:
>>>
>>> $ nvapeek 0x15b0
>>> 000015b0: 1000008e
>>>
>>> So value reported by nouveau is lower than value reported by
>>> nvidia binary driver.
>> As you didn't run nvapeek 15b0 when running nouveau it is hard to tell
>> if it is due to
>> calibration values or because the temperature was lower.
>>
> I run it and it always reported value 000000ff (also when temperature changed).

Seems like we may not calibrate the ADC correctly, this is weird.
>
>> Could you please read the temperature + peek 15b0 when running nouveau?
>>
>> Anyway, it is weird because I cannot find 70°C with 0x8e as an input
>> temperature and with
>> the current default values :o
>>
> My idea is that register does not contains temperature. Both nouveau and
> nvidia driver when show different temperature it does not show different output
> from "nvapeek 0x15b0".
>
> Now I started computer with nouveau driver. Temperature is incresing, but
> nvapeek 0x15b0 is still same.
>
> So do you really needs other tests with nvapeek 0x15b0? Is that register
> correct?

I want you to be really sure that 15b0 doesn't change with temperature 
ON THE
PROPRIETARY driver. This is very serious if this is not the case.

If this is not the case, then you must have an i2c device from which the 
blob is
reading temperature and this device isn't detected by Nouveau.

