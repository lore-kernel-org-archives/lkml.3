Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab3IKTTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:19:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23628 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab3IKTTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:19:12 -0400
X-Authority-Analysis: v=2.0 cv=R/aB6KtX c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=wRe-vSF1Ob0A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=kSsn7R9otuIA:10 a=DMjpEOQyGBSUNNDS83EA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 11 Sep 2013 15:19:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mario Kleiner <mario.kleiner@tuebingen.mpg.de>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>, Dave Airlie <airlied@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: sleeping function called from invalid context on
 3.10.10-rt7
Message-ID: <20130911151910.3f415c3b@gandalf.local.home>
In-Reply-To: <5230BF5E.9000207@tuebingen.mpg.de>
References: <20130911102809.GA31663@uudg.org>
	<20130911092623.42efd930@gandalf.local.home>
	<5230895B.5070400@hurleysoftware.com>
	<5230B673.6090800@tuebingen.mpg.de>
	<20130911143557.14c1fe6a@gandalf.local.home>
	<5230BF5E.9000207@tuebingen.mpg.de>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013 21:07:10 +0200
Mario Kleiner <mario.kleiner@tuebingen.mpg.de> wrote:

> 
> 
> On 11.09.13 20:35, Steven Rostedt wrote:
> > On Wed, 11 Sep 2013 20:29:07 +0200
> > Mario Kleiner <mario.kleiner@tuebingen.mpg.de> wrote:
> >
> >> That said, maybe preempt_disable is no longer the optimal choice there
> >> and there's some better way to achieve good protection against
> >> interruptions of that bit of code? My knowledge here is a bit rusty, and
> >> the intel kms drivers and rt stuff has changed quite a bit.
> >
> > If you set your code to a higher priority than other tasks (and
> > interrupts) than it wont be preempted there. Unless of course it blocks
> > on a lock, but even then, priority inheritance will take place and it
> > still should be rather quick. (unless the holder of the lock is doing
> > that strange polling).
> >
> > -- Steve
> >
> 
> Right, on a rt kernel. But that creates the problem of not very computer 
> savvy users (psychologists and biologists mostly) somehow having to 
> choose proper priorities for gpu interrupt threads and for the 
> x-server/wayland/..., and not much protection on a non-rt kernel?

IIUC, the preempt_disable() is only for -rt, the non-rt case already
disables preemption with the spin_locks called before it.

> 
> preempt_disable() a few years ago looked like a good "plug and play" 
> default solution, because the ->get_crtc_scanoutpos() function was 
> supposed to have a very low and bounded execution time. At the time we 
> wrote the patches for intel/radeon/nouveau, that was the case. Typical 
> execution time (= preempt off time) was like 1-4 usecs, even on very low 
> end hardware.
> 
> Seems that at least intel's kms driver does a lot of things now, which 
> can sleep and spin inside that section? I tried to follow the posted 
> stack trace, but got lost somewhere around the i915_read32 code and 
> power management stuff...

Note, the sleeps only happen on -rt, and not in mainline.

If one is going to use -rt for real-time work, it requires a bit more
knowledge of the system. The problem with RT in general, is that it's
hard, and anyone telling you they have a generic RT system that
requires no computer savvyness can also be selling you a bridge over
the east river.

-- Steve
