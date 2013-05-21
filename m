Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab3EUU3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 16:29:24 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55052 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab3EUU3X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 16:29:23 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 21 May 2013 22:28:17 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: stephan.gatzka@gmail.com
Cc: linux1394-devel@lists.sourceforge.net, peter@hurleysoftware.com,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: function call fw_iso_resource_mange(..) (core-iso.c) does not
 return
Message-ID: <20130521222817.3626b59d@stein>
In-Reply-To: <8ac7ca3200325ddf85ba57aa6d000f70@gatzka.org>
References: <8ac7ca3200325ddf85ba57aa6d000f70@gatzka.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Cc: LKML and Tejun.  Not adding Ralf, I think he is subscribed.)

On May 21 Stephan Gatzka wrote:
> Hi!
> 
> I want to keep you informed about that issue, Ralf described some month 
> ago:
> 
> http://marc.info/?l=linux1394-devel&m=136152042914650&w=2
> 
> We instrumented the workqueue and got a lot of insight how it works. :)
> 
> The deadlock occurs mainly because the firewire workqueue is allocated 
> with WQ_MEM_RECLAIM. That's why a so called rescuer thread is started 
> while allocating the wq.
> 
> This rescuer thread is responsible to keep the queue working even under 
> high memory pressure so that a memory allocation might sleep. If that 
> happens, all work of that workqueue is designated to that particular 
> rescuer thread. The work in this rescuer thread is done strictly 
> sequential. Now we have the situation that the rescuer thread runs 
> fw_device_init->read_config_rom->read_rom->fw_run_transaction. 
> fw_run_transaction blocks waiting for the completion object. This 
> completion object will be completed in bus_reset_work, but this work 
> will never executed in the rescuer thread.
> 
> The interesting question is why the firewire wq stuff is designated to 
> the rescuer thread because we are definitely not under high memory 
> pressure. I looked into the workqueue code and  found that the work is 
> shifted to the rescuer a new worker thread could not be allocated in a 
> certain time (static bool maybe_create_worker(struct global_cwq *gcwq) 
> in workqueue.c). This timeout (MAYDAY_INITIAL_TIMEOUT) is set to 10ms.

If I recall correctly what was written earlier in this thread, the fact
that firewire-ohci schedules its work from IRQ context seems to matter.
If so, then this raises the generally interesting question how to use
workqueue as bottom half of an interrupt handler.¹  Does this necessitate
separate workqueues --- one for the BH worklets and another for worklets
that depend on the BH worklets?²

But Ralf wrote on March 12:  "Other tests have shown that even the own
workqueue is not enough.  The deadlock also occurs here.  Not nearly as
often, but it happens.  Only  with the tasklet can I yet be sure that the
deadlock does not occur."  So, having a private workqueue just for this
single BH worklet alone is still not the answer.

--------
 ¹) Worklets as bottom halves --- as alternative to tasklets as bottom
    halves --- have been suggested by RT folks in the past because there
    is more control over CPU scheduling of worklets compared to tasklets,
    obviously.

 ²) In the firewire-subsystem, we have a subsystem workqueue for various
    work from firewire-core and occasional work from upper-layer drivers
    IOW protocol drivers.  A while ago we converted a low-level driver IRQ
    BH from tasklet to worklet in order to be able to do some sleeping
    stuff in it. However, progress of the core and upper layer work
    depends on the IRQ BH to be executed concurrently.

> What I don't understand is that the create_worker() call is not 
> satisfied within 10ms. We run the stuff on a 400Mhz PowerPC with Xenomai 
> realtime extension. Because we have a lot of firewire participants, we 
> got a log of bus resets when starting up the whole system. Maybe we 
> spend too much time during the interrupts, but that's just a rough guess 
> right now. We will look further into that issue.

Wait a minute --- I seem to be reading of Xenomai RT extensions for the
first time in this thread.  Has the problem been reproduced on a mainline
kernel too?  (Mainline plus Ralf's firewire upper layer driver maybe, but
without any other 3rd party stuff please.  Actually the issue should be
reproducible even without an upper layer driver performing
fw_iso_resource_manage in fw_workqueue context, shouldn't it?)


There was one or two /other/ reports about split transactions never
completing, i.e. not even timing out, on the ffado-user or ffado-devel
mailinglist:  The userland Jack audio server got stuck in
drivers/firewire/core-cdev.c::fw_device_op_release().  However, whether
this was the same problem or a different one altogether is not known to
me.  There is at least one known hardware³ bug which we do not handle in
yet which can lead to this, orthogonally to the workqueue problem which we
are discussing here.  ---  Long story short, Ralf may possibly be the
only one who suffers from this problem so far, which makes it even more
important to verify whether or not this is a mainline problem.)

--------
 ³) JMB38x

> Our workaround is to declare the firewire workqueue as CPU_INTENSIVE. 
> This gives a slight different execution model in the normal case (no 
> work running on the rescuer thread). Maybe it's worth to think about 
> that because some work looks rather heavy to me.
> 
> Regards,
> 
> Stephan

There is quite a bit going on in firewire-ohci's and firewire-core's parts
of self-ID-complete event handling.  But I suspect that stuff like that is
still not in the league for which CPU_INTENSIVE was intended for
(cryptography etc.).
-- 
Stefan Richter
-=====-===-= -=-= =-=-=
http://arcgraph.de/sr/
