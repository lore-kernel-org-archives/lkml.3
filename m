Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab3IKTHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:07:22 -0400
Received: from fmailer.gwdg.de ([134.76.11.16]:44138 "EHLO fmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab3IKTHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:07:20 -0400
X-Greylist: delayed 2280 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Sep 2013 15:07:20 EDT
Message-ID: <5230BF5E.9000207@tuebingen.mpg.de>
Date: Wed, 11 Sep 2013 21:07:10 +0200
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
References: <20130911102809.GA31663@uudg.org> <20130911092623.42efd930@gandalf.local.home> <5230895B.5070400@hurleysoftware.com> <5230B673.6090800@tuebingen.mpg.de> <20130911143557.14c1fe6a@gandalf.local.home>
In-Reply-To: <20130911143557.14c1fe6a@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11.09.13 20:35, Steven Rostedt wrote:
> On Wed, 11 Sep 2013 20:29:07 +0200
> Mario Kleiner <mario.kleiner@tuebingen.mpg.de> wrote:
>
>> That said, maybe preempt_disable is no longer the optimal choice there
>> and there's some better way to achieve good protection against
>> interruptions of that bit of code? My knowledge here is a bit rusty, and
>> the intel kms drivers and rt stuff has changed quite a bit.
>
> If you set your code to a higher priority than other tasks (and
> interrupts) than it wont be preempted there. Unless of course it blocks
> on a lock, but even then, priority inheritance will take place and it
> still should be rather quick. (unless the holder of the lock is doing
> that strange polling).
>
> -- Steve
>

Right, on a rt kernel. But that creates the problem of not very computer 
savvy users (psychologists and biologists mostly) somehow having to 
choose proper priorities for gpu interrupt threads and for the 
x-server/wayland/..., and not much protection on a non-rt kernel?

preempt_disable() a few years ago looked like a good "plug and play" 
default solution, because the ->get_crtc_scanoutpos() function was 
supposed to have a very low and bounded execution time. At the time we 
wrote the patches for intel/radeon/nouveau, that was the case. Typical 
execution time (= preempt off time) was like 1-4 usecs, even on very low 
end hardware.

Seems that at least intel's kms driver does a lot of things now, which 
can sleep and spin inside that section? I tried to follow the posted 
stack trace, but got lost somewhere around the i915_read32 code and 
power management stuff...

-mario
