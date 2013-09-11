Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab3IKUXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:23:43 -0400
Received: from fmailer.gwdg.de ([134.76.11.16]:48377 "EHLO fmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab3IKUXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:23:42 -0400
Message-ID: <5230D13C.301@tuebingen.mpg.de>
Date: Wed, 11 Sep 2013 22:23:24 +0200
From: Mario Kleiner <mario.kleiner@tuebingen.mpg.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Hurley <peter@hurleysoftware.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>, Dave Airlie <airlied@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>
Subject: Re: BUG: sleeping function called from invalid context on 3.10.10-rt7
References: <20130911102809.GA31663@uudg.org> <20130911092623.42efd930@gandalf.local.home> <5230895B.5070400@hurleysoftware.com> <5230B673.6090800@tuebingen.mpg.de> <20130911143557.14c1fe6a@gandalf.local.home> <5230BF5E.9000207@tuebingen.mpg.de> <20130911151910.3f415c3b@gandalf.local.home>
In-Reply-To: <20130911151910.3f415c3b@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11.09.13 21:19, Steven Rostedt wrote:
> On Wed, 11 Sep 2013 21:07:10 +0200
> Mario Kleiner <mario.kleiner@tuebingen.mpg.de> wrote:
>
>>
>>
>> On 11.09.13 20:35, Steven Rostedt wrote:
>>> On Wed, 11 Sep 2013 20:29:07 +0200
>>> Mario Kleiner <mario.kleiner@tuebingen.mpg.de> wrote:
>>>
>>>> That said, maybe preempt_disable is no longer the optimal choice there
>>>> and there's some better way to achieve good protection against
>>>> interruptions of that bit of code? My knowledge here is a bit rusty, and
>>>> the intel kms drivers and rt stuff has changed quite a bit.
>>>
>>> If you set your code to a higher priority than other tasks (and
>>> interrupts) than it wont be preempted there. Unless of course it blocks
>>> on a lock, but even then, priority inheritance will take place and it
>>> still should be rather quick. (unless the holder of the lock is doing
>>> that strange polling).
>>>
>>> -- Steve
>>>
>>
>> Right, on a rt kernel. But that creates the problem of not very computer
>> savvy users (psychologists and biologists mostly) somehow having to
>> choose proper priorities for gpu interrupt threads and for the
>> x-server/wayland/..., and not much protection on a non-rt kernel?
>
> IIUC, the preempt_disable() is only for -rt, the non-rt case already
> disables preemption with the spin_locks called before it.
>

Oh, right! should have thought about that. I'm quite sleepy, so my brain 
is not working very well atm.

>>
>> preempt_disable() a few years ago looked like a good "plug and play"
>> default solution, because the ->get_crtc_scanoutpos() function was
>> supposed to have a very low and bounded execution time. At the time we
>> wrote the patches for intel/radeon/nouveau, that was the case. Typical
>> execution time (= preempt off time) was like 1-4 usecs, even on very low
>> end hardware.
>>
>> Seems that at least intel's kms driver does a lot of things now, which
>> can sleep and spin inside that section? I tried to follow the posted
>> stack trace, but got lost somewhere around the i915_read32 code and
>> power management stuff...
>
> Note, the sleeps only happen on -rt, and not in mainline.
>
> If one is going to use -rt for real-time work, it requires a bit more
> knowledge of the system. The problem with RT in general, is that it's
> hard, and anyone telling you they have a generic RT system that
> requires no computer savvyness can also be selling you a bridge over
> the east river.
>
> -- Steve

;) - I know the problem, i spend a lot of time telling that to users of 
my software, although they then generally want some sort of bridges 
anyway. I'm maintaining one of the most popular open-source toolkits for 
neuro-science, and in my experience at least the field of neuro-science 
research has the problem that a lot of people there need good real-time 
behaviour and a lot of flexibility in their hardware and software 
setups, but very few have the necessary technical background. Given the 
limited money they can spend, there's also not much commercial interest 
or probably viability in providing good technical consulting. The few 
proprietary hardware solutions i know of are either unaffordable by the 
majority, or are bridges over the east river, or quite often both. My 
main motivation for luring my users to Linux and contributing some 
little bits sometimes is the hope that some problems can be solved in a 
better way at the system level than piling software workarounds on top 
of hardware workarounds on top of expensive equipment.

But back to the topic, I think a better argument for the 
preempt_disable() there instead of changing code execution priority is 
that i wouldn't know how to set a static priority properly either. The 
timestamping code is also called from drm code (drmWaitVblank ioctl()) 
and it isn't called from the actual experiment software, where i would 
at least roughly know what i'm doing, and could adjust priorities 
dynamically, but from the X-Server, or maybe in the future Wayland, on 
behalf of the OpenGL client app. For the timestamping to work properly, 
one only would need a raised priority (higher than most interrupt kernel 
threads, except the one of the kms driver) for those few lines of 
timestamping code. I don't think it would be good to run xorg or wayland 
permanently at a higher priority than most irq threads, given that the 
display server does not only serve rt apps and is not designed as a 
realtime application. One only wants a short protection from preemption 
during timestamping.

Sorry, i think i'm rambling here quite a bit and i didn't want to 
sidetrack the thread, just give some explanation why i think the 
preempt_disable() is (/was?) justified.

-mario
