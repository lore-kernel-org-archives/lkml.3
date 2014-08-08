Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbaHHQaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:30:15 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64589 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517AbaHHQaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:30:11 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E4FB0D.7010500@roeck-us.net>
Date: Fri, 08 Aug 2014 09:30:05 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: kreijack@inwind.it, Matt Helsley <matt.helsley@gmail.com>
CC: Jean Delvare <jdelvare@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] Export the temperatures via hwmon
References: <1407359103-6012-1-git-send-email-kreijack@inwind.it> <1407359103-6012-6-git-send-email-kreijack@inwind.it> <20140806231803.GA5643@roeck-us.net> <53E31694.8050107@gmail.com> <53E31AB0.6070604@roeck-us.net> <20140807085235.2c0e63dd@endymion.delvare> <53E32C77.5000804@roeck-us.net> <53E3BC48.4020304@inwind.it> <20140807211941.GA2756@eieio> <53E4E4B8.4060900@inwind.it>
In-Reply-To: <53E4E4B8.4060900@inwind.it>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 07:54 AM, Goffredo Baroncelli wrote:
> On 08/07/2014 11:19 PM, Matt Helsley wrote:
>> On Thu, Aug 07, 2014 at 07:50:00PM +0200, Goffredo Baroncelli wrote:
>>> On 08/07/2014 09:36 AM, Guenter Roeck wrote:
>>>> On 08/06/2014 11:52 PM, Jean Delvare wrote:
>>>>> Hi Guenter,
>>>>>
>>>>> On Wed, 06 Aug 2014 23:20:32 -0700, Guenter Roeck wrote:
>>>>>> Patch 4/5 is "Return the fan speed via sysfs: /sys/devices/temperature/fan_level".
>>>>>>
>>>>>> So you are saying that returning the fan speed with a non-hwmon attribute works,
>>>>>> but returning it with a hwmon attribute doesn't ? Not really sure if I understand
>>>>>> your logic. Either fan_level doesn't return the fan speed (or an abstraction of it),
>>>>>> or something in your line of argument is inconsistent.
>>>>>
>>>>> fan_level is a fan speed _control_ value, like pwm1. It is not a fan
>>>>> speed monitoring value.
>>>>>
>>>> Ah, ok. The patch description doesn't seem to match, though.
>>>> And why not export it as pwm1, if that is what it is ?
>>>>
>>>> Guenter
>>>>
>>>>
>>>
>>> the exported fan_level value is a coefficient near proportional to the speed [*];
>>> so it is not the speed nor the pwm.
>>
>>> I tried to read the pwm/speed value, but when I did it, every 5/6 seconds the
>>> fan seemed to stop for 1s, then the speed raised.... So I stopped the test.
>>>
>>> These patches (the first two) solved a real issue: with the last kernels this
>>> driver doesn't work at all, and the fan go to maximum speed (very loud !)
>>> The other three are an improvement.
>>>
>>> When (if) these patches will be accepted I want to write another solution,
>>> but definitely not now. And even if it would work for me, it is very likely
>>> that will  be accepted because nobody is able to test it on all hardware.
>>>
>>> BR
>>> G.Baroncelli
>>>
>>> [*] It is a bit more complicated: basically the adm1030 controls the fan speed
>>> on the basis of an external temperature sensor (the "case" sensor).
>>> Higher is this temperature higher is the fan speed.
>>> The pwm of the fan is computed on the basis of the following value:
>>> 	- min_temp
>>> 	- range_temp -> max_temp=min_temp+range_temp
>>> 	- min_pwm_value
>>> and of course
>>> 	- "case" sensor
>>>
>>>
>>> The fan_level is an index computed on the basis of the "cpu" temperature (
>>> which is different from the "case" temperature referred above). This
>>> temperature is used to update the min_temp above.
>>>
>>> So the fan speed id computed on the basis of two external sensor:
>>> - cpu sensor
>>> - case sensor.
>>>
>>> To complicate further the things, the range_temp is set to an undocumented
>>> value: this parameter is set via a register (0x25, bit 2:0), which accepted
>>> values between 0x00 and 0x04. However it is set to 0x07
>>>
>>> See http://lxr.free-electrons.com/source/drivers/macintosh/therm_windtunnel.c#L153
>>> and the adm1030 datasheet.
>>>
>>> I am reluctant to change this thing because this driver is for an obsolete
>>> platform (apple stopped the powermac in 2004/2005), and bad or good I have to
>>> suppose that it works. Moreover I am not in the position to test the changes
>>> outside my hardware (1 powermac DP@1Ghz mdd)
>>
>> This seems like a valuable explanation of the meaning of the fan_level
>> values. When I read the code I was wondering what the magic number "11" was
>> doing for instance and this helps clear it up a little. It's a nit perhaps
>> but some of this information might be useful in the commit message for that
>> patch, the code, or both.
>
> I will take in account your suggestion. In case of another revision, I will improve the comment.
>
I just noticed - hwmon_device_register_with_groups() returns ERR_PTR
on errors, not NULL, so checking for a NULL return value won't help
much if there is an error.

Guenter

