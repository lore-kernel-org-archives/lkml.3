Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531AbaICMYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:24:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067AbaICMYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:24:09 -0400
Message-ID: <54070842.2000700@redhat.com>
Date: Wed, 03 Sep 2014 08:23:30 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-kernel@vger.kernel.org, Peter Tyser <ptyser@xes-inc.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] x86, lpc, Allow only one load of lpc_ich
References: <1409695097-5831-1-git-send-email-prarit@redhat.com> <20140903074315.GB28985@lee--X1> <5406E9B0.101@redhat.com> <20140903113535.GE28985@lee--X1> <540701B5.3020409@redhat.com> <20140903121941.GF28985@lee--X1>
In-Reply-To: <20140903121941.GF28985@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/03/2014 08:19 AM, Lee Jones wrote:
> On Wed, 03 Sep 2014, Prarit Bhargava wrote:
>> On 09/03/2014 07:35 AM, Lee Jones wrote:
>>>>>> This occurs because there are two LPC devices on the system:
>>>>>>
>>>>>> 00:1f.0 ISA bridge: Intel Corporation 82801JIB (ICH10) LPC Interface Controller
>>>>>> 80:1f.0 ISA bridge: Intel Corporation 82801JIB (ICH10) LPC Interface Controller
>>>>>>
>>>>>> which AFAICT is a hardware configuration error that can be resolved in
>>>>>> firmware by hiding the second LPC device.  Having two of these results in
>>>>>> two GPIO mappings and two Watchdog Timers which doesn't make much sense.
>>>>>>
>>>>>> An end user has no idea what the splats mean.  We should inform the user that
>>>>>> the issue lies with the hardware and that they should contact their vendor
>>>>>> for resolution.
>>>>>
>>>>> Why is it a problem for 2 of these devices to exist on a single system?
>>>>>
>>>>> Shouldn't the driver just be able to handle 2 devices?
>>>>>
>>
>>>>
>>>> You end up with two watchdogs on the same system (and more confusingly they use
>>>> the same global interface).  Additionally you end up with two sets of GPIOs
>>>> which also use the same global interface ... not good.
>>>
>>> I understand the problem with the _driver_, but why is it a problem
>>> that two of these _devices_ exist on one system?  Bailing out of the
>>> second .probe() sounds hacky to me.  The driver should know that this
>>> is possible and act accordingly, or the second devices shouldn't be
>>> registered.
>>>
>>> Can these devices be controlled seperately?  
>>
>> Let's just try and address this for now ... They can be controlled separately
>> but that's not the issue here.
>>
>> Consider just the watchdog timer (because it is easier to explain).  The way the
>> watchdog timer works is that we write to it every 30 seconds (or so ... it
>> depends on your setup obviously).  If we don't write to it within 30 seconds the
>> system will panic and reboot.
>>
>> Now ... suppose you have two on a system.  To what end? It doesn't make sense to
>> have two.  Either you can write from userspace or you can't.  Now you have two
>> running with different timeouts -- why?  That doesn't make sense either.  It
> 
> You only have 2 running if you start them both.
> 
>> isn't like the one with the longer timeout is ever going to cause a reboot.
>>
>> Does that explain things better?  It's a not a real-world scenario.
> 
> On the h/w I'm currently working on, we have 3 Watchdogs.

"3": what are they?  Are they all system-level watchdogs?  I can understand the
BMC having a watchdog, the system HW having a watchdog (which is what we're
talking about here), and I'm sure we can think of other watchdogs ... but two
that are EXACTLY the same?

> 
>> You also asked ...
>>
>>> Then why do they [have two devices specified]?
>>
>> Because the vendor didn't/forgot to hide one from the kernel in BIOS -- hence
>> FW_BUG.
> 
> If only one is useful, why have the second one in the first place?

That's just it -- it shouldn't have been exposed (again, according to Intel).

> 
> If the devices are present and we can see them, why not have 2?  Some
> users might find a use for them.

No one will.

> 
> In the WARNING you submitted only sysfs was having a hard time.
> Perhaps the real fix would be to allow the Watchdog and GPIO driver to
> change their name when registering, so they can each have their own
> sysfs entries.

/me scratches head.

How does that help having multiple devices which shouldn't be exposed?

P.

> 
