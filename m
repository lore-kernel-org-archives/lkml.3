Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759876Ab3EBWt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 18:49:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:42285 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3EBWt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 18:49:27 -0400
Date: Fri, 3 May 2013 00:49:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: clockevents_program_event WARN_ON preventing boot.
In-Reply-To: <CAE9FiQWFK_ropzW_qQLcNxLYyek8-PHGW-8SxfZJSijvdrss1A@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1305022337470.2891@ionos>
References: <20130430212007.GB18598@redhat.com> <20130430213719.GA14988@redhat.com> <alpine.LFD.2.02.1305021234510.3972@ionos> <20130502154621.GA23990@redhat.com> <alpine.LFD.2.02.1305022152280.2891@ionos> <CAE9FiQXpV451xTzAJyNdC-+-oqF9v8Cy5evcNOHKFffERw2SwA@mail.gmail.com>
 <alpine.LFD.2.02.1305022304370.2891@ionos> <CAE9FiQWFK_ropzW_qQLcNxLYyek8-PHGW-8SxfZJSijvdrss1A@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 May 2013, Yinghai Lu wrote:
> On Thu, May 2, 2013 at 2:19 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Can you please apply the following debug patch and provide the output?
> >
> > diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
> > index c6d6400..b4d9622 100644
> > --- a/kernel/time/clockevents.c
> > +++ b/kernel/time/clockevents.c
> > @@ -207,6 +207,8 @@ int clockevents_program_event(struct clock_event_device *dev, ktime_t expires,
> >
> >         if (unlikely(expires.tv64 < 0)) {
> >                 WARN_ON_ONCE(1);
> > +               printk_once(KERN_INFO "expires %llx, dev->next %llx\n",
> > +                           expires.tv64, dev->next_event.tv64);

> [    3.454628] expires 80000000003d08ff, dev->next 7fffffffffffffff

So dev->next_event == KTIME_MAX. That means that the device has been
shut down, at least I can't see any other reason at that point - we
are not in highres/nohz mode yet. And it still got an interrupt served
for whatever reason. What's even more confusing is that in
tick_handle_periodic() we check for:

        if (dev->mode != CLOCK_EVT_MODE_ONESHOT)
                return;

So if the device is shutdown for real the mode would be
CLOCK_EVT_MODE_SHUTDOWN and we'd never reach that code.

Shut down at that point only happens in context of the broadcast
crap. Your crash:

[   10.272017] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000048
[   10.289803] IP: [<ffffffff810e3c46>] tick_do_broadcast+0x86/0xa0

points to the broadcast stuff as well. 0x48 is the offset of the
broadcast function. So your machine died at:

                td->evtdev->broadcast(mask);

That means, that the cpu was set in the broadcast mask, but the per
cpu event device was not yet registered !?!

That does not make any sense, as we explicitely prevent the broadcast
activation for cpus which have no per cpu tick device registered yet.

I'm fundamentally confused and Daves observation about slub debug does
not make it less confusing.

It'd be nice if you could add some more instrumentation or bisect the
issue.

Thanks,

	tglx
