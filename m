Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab3IYOAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 10:00:39 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:17811 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755641Ab3IYOAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 10:00:37 -0400
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Sep 2013 10:00:37 EDT
Date: Wed, 25 Sep 2013 09:52:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mario Kleiner <mario.kleiner@tuebingen.mpg.de>
Cc: Ville =?UTF-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Peter Hurley <peter@hurleysoftware.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: [Intel-gfx] BUG: sleeping function called from invalid context
 on 3.10.10-rt7
Message-ID: <20130925095259.7138eb68@gandalf.local.home>
In-Reply-To: <5242674A.8020100@tuebingen.mpg.de>
References: <20130911102809.GA31663@uudg.org>
	<20130911092623.42efd930@gandalf.local.home>
	<5230895B.5070400@hurleysoftware.com>
	<20130911113845.6d56a556@gandalf.local.home>
	<5230C52E.3050801@hurleysoftware.com>
	<5238B288.3000704@hurleysoftware.com>
	<CAKMK7uG9s8W6yebkmuJe0XHGsoru4_9FzGqfmKWtMFyCAfQZqA@mail.gmail.com>
	<523CC728.4040302@tuebingen.mpg.de>
	<20130923083841.GT4531@intel.com>
	<5242674A.8020100@tuebingen.mpg.de>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013 06:32:10 +0200
Mario Kleiner <mario.kleiner@tuebingen.mpg.de> wrote:


> I assume if a spin_lock_irqsave doesn't really disable interrupts on a 
> RT kernel with normal spinlocks then local_irq_disable won't really 
> disable interrupts either?
> 

That is incorrect. On PREEMPT_RT, you are right about
spin_lock_irqsave() not disabling interrupts, but local_irq_disable()
does indeed disable interrupts.

Open coded local_irq_disable() usually ends up being a bug as it does
nothing to synchronize interrupts from other CPUs. But most of those
bugs have been removed, and there are some very legit reasons for using
local_irq_disable(). PREEMPT_RT honors those.

The reason PREEMPT_RT does not disable interrupts for
spin_lock_irqsave(), is because that's usually used for when a
interrupt uses the same spinlock. You need the irqsave() part in order
to prevent a deadlock, if the code that has the spinlock gets preempted
by the interrupt and that interrupt tries to grab the same lock.

Because PREEMPT_RT runs interrupts as threads, we don't have that issue,
because if the interrupt preempts the holder of the lock and it tries
to grab the same lock, it will just block like any other thread trying
to grab that lock. That is, spinlocks turn into mutexes on PREEMPT_RT.

-- Steve
