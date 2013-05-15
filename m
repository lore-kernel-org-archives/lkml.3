Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab3EOQxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:53:32 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:58423 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932902Ab3EOQx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:53:28 -0400
Message-ID: <5193BD85.8030803@linaro.org>
Date: Wed, 15 May 2013 09:53:25 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 07/15] clocksource: Provide unbind interface in sysfs
References: <20130425142452.908423538@linutronix.de> <20130425143435.964218245@linutronix.de> <517F1A27.3030206@linaro.org> <alpine.LFD.2.02.1305151144550.1388@ionos>
In-Reply-To: <alpine.LFD.2.02.1305151144550.1388@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 02:47 AM, Thomas Gleixner wrote:
> On Mon, 29 Apr 2013, John Stultz wrote:
>> On 04/25/2013 01:31 PM, Thomas Gleixner wrote:
>>> With the module refcount held for the current clocksource there is no
>>> way to unload the module.
>>>
>>> Provide a sysfs interface which allows to unbind the clocksource. One
>>> could argue that the clocksource override could be (ab)used to do so,
>>> but the clocksource override cannot be used from the kernel itself,
>>> while an unbind function can be used to programmatically check whether
>>> a clocksource can be shutdown or not.
>>>
>>> The unbind functionality uses the new skip current feature of
>>> clocksource_select and verifies that a fallback clocksource has been
>>> installed. If the clocksource which should be unbound is the current
>>> clocksource and no fallback can be found, unbind returns -EBUSY.
>>>
>>> This does not support the unbinding of a clocksource which is used as
>>> the watchdog clocksource. No point in fostering crappy hardware.
>> So.. if the clocksource you want to unbind is the highest rated continuous
>> clocksource that doesn't need a watchdog (basically what's likely to be in-use
>> and required to be unbinded), its likely to be selected as the watchdog
>> already.
>>
>> ie: on a system that has only HPET/ACPI_PM, you can't unbind HPET, since its a
>> watchdog.
> No. The thing is that I only prevent unbinding if it is used as the
> watchdog. In the above HPET/PM scenario both are potential watchdogs,
> but w/o a user it's valid to unbind one of them.
>
> What I need to prevent is:
>
> TSC is current clocksource and we only have ACPI_PM as watchdog and
> its used. So now you try to unbind ACPI_PM then the TSC would be left
> w/o a watchdog instance. That's what I'm preventing. Will reword the
> changelog accordingly.

You might double check the logic, because I feel like I actually hit 
this issue where on my vm machine w/ only hpet/acpi_pm I couldn't unbind 
the hpet.

Though its been a few weeks, so maybe I'm confusing things?
Let me know if you want me to try to reproduce it.

thanks
-john

