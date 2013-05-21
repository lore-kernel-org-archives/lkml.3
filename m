Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab3EUVOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 17:14:10 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55455 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab3EUVOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 17:14:08 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 21 May 2013 23:13:46 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: stephan.gatzka@gmail.com, linux1394-devel@lists.sourceforge.net,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: function call fw_iso_resource_mange(..) (core-iso.c) does not
 return
Message-ID: <20130521231346.1fec9142@stein>
In-Reply-To: <519BA6AC.1080600@hurleysoftware.com>
References: <8ac7ca3200325ddf85ba57aa6d000f70@gatzka.org>
	<519BA6AC.1080600@hurleysoftware.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 21 Peter Hurley wrote:
> [ +cc Tejun Heo]
(+cc lkml)

> On 05/21/2013 04:42 AM, Stephan Gatzka wrote:
> > Hi!
> >
> > I want to keep you informed about that issue, Ralf described some month ago:
> >
> > http://marc.info/?l=linux1394-devel&m=136152042914650&w=2
> >
> > We instrumented the workqueue and got a lot of insight how it works. :)
> 
> Well done!
> 
> > The deadlock occurs mainly because the firewire workqueue is allocated with
> > WQ_MEM_RECLAIM. That's why a so called rescuer thread is started while
> > allocating the wq.
>                                          ^^^^^^
> Are there other conditions which contribute?  For example, Ralf reported that
> having the bus_reset_work on its own wq delayed but did not eliminate the
> deadlock.
> 
> > This rescuer thread is responsible to keep the queue working even under high
> > memory pressure so that a memory allocation might sleep. If that happens,
> > all work of that workqueue is designated to that particular rescuer
> > thread. The work in this rescuer thread is done strictly sequential. Now
> > we have the situation that the rescuer thread runs
> > fw_device_init->read_config_rom->read_rom->fw_run_transaction.
> > fw_run_transaction blocks waiting for the completion object. This
> > completion object will be completed in bus_reset_work, but this work will
> > never executed in the rescuer thread.
> 
> Interesting.
> 
> Tejun, is this workqueue behavior as designed?  Ie., that a workqueue used
> as a domain for forward progress guarantees collapses under certain conditions,
> such as scheduler overhead and no longer ensures forward progress?
> 
> > The interesting question is why the firewire wq stuff is designated to the
> > rescuer thread because we are definitely not under high memory pressure. I
> > looked into the workqueue code and  found that the work is shifted to the
> > rescuer a new worker thread could not be allocated in a certain time (static
> > bool maybe_create_worker(struct global_cwq *gcwq) in workqueue.c). This
> > timeout (MAYDAY_INITIAL_TIMEOUT) is set to 10ms.
> >
> > What I don't understand is that the create_worker() call is not satisfied
> > within 10ms. We run the stuff on a 400Mhz PowerPC with Xenomai realtime
> > extension. Because we have a lot of firewire participants, we got a log of
> > bus resets when starting up the whole system. Maybe we spend too much time
> > during the interrupts, but that's just a rough guess right now. We will
> > look further into that issue.
> 
> I've observed the string of bus resets on startup as well and I think it has to do
> with failing to ack the interrupt promptly because the log printk() takes too long (>50us).
> The point being that I don't think this is contributing to the create_worker() +10ms
> delay.
> 
> > Our workaround is to declare the firewire workqueue as CPU_INTENSIVE. This
> > gives a slight different execution model in the normal case (no work running
> > on the rescuer thread). Maybe it's worth to think about that because some work
> > looks rather heavy to me.
> 
> I thought the whole point of needing WQ_MEM_RECLAIM is if a SBP-2 device is swap.

Yes and no.  If, and only if, there is one or more SBP-2 target present
and bound to the firewire-sbp2 initiator driver and
  - there is a swap device on that target, or/and
  - there is a filesystem on that target mounted writable,
then self-ID-complete handling in firewire-ohci and firewire-core and the
reconnect procedure in firewire-sbp2 must not involve any allocations that
would block on writeback.  (Because writeback to the target is blocked
from bus reset until reconnect.)

> FWIW, I still believe that we should revert to the original bus reset
> as tasklet and redo the TI workaround to use TI-workaround-specific versions
> of non-sleeping PHY accesses.
> 
> Regards,
> Peter Hurley

I am a friend of the self-ID-complete worklet, for two reasons:
  - Even if there was no need for the TI TSB41BA3D workaround (e.g. even
    if we simply stopped supporting TSB41BA3D), it would still be
    worthwhile to have at least the self-ID-complete IRQ BH performed in
    a non-atomic context.  We should try to move as much of the
    firewire-core self-ID-complete handler as possible out of the currently
    spinlock protected section in order make more of this stuff
    preemptible and replace a few GFP_ATOMIC slab allocations by GFP_NOFS
    ones.  (Could be GFP_KERNEL in absence of firewire-sbp2.)
    I would have liked to work on this already long ago, but such is life.
  - How do you propose to access the PHY registers without sleeping?
    Or more to the point:  How do you propose to mix sleeping and
    non-sleeping PHY register accesses?  (Since we can't get rid of
    the sleeping ones.)  If the accesses are not fully serialized, you will
    get corrupt PHY reg reads or writes.  If they are fully serialized, the
    non-sleeping PHY reg accesses need to go a try-lock route and will be
    forced to error out during periods when a sleeping PHY reg access goes
    on, without even the ability to reschedule if it is done in a tasklet
    context.
-- 
Stefan Richter
-=====-===-= -=-= =-=-=
http://arcgraph.de/sr/
