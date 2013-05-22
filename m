Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab3EVHtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:49:11 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33738 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384Ab3EVHtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:49:07 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 22 May 2013 09:48:40 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Hurley <peter@hurleysoftware.com>, stephan.gatzka@gmail.com,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: function call fw_iso_resource_mange(..) (core-iso.c) does not
 return
Message-ID: <20130522094840.472b263e@stein>
In-Reply-To: <20130521231847.GA6985@mtj.dyndns.org>
References: <8ac7ca3200325ddf85ba57aa6d000f70@gatzka.org>
	<519BA6AC.1080600@hurleysoftware.com>
	<20130521231847.GA6985@mtj.dyndns.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 22 Tejun Heo wrote:
> Hello,
> 
> On Tue, May 21, 2013 at 12:54:04PM -0400, Peter Hurley wrote:
> >> This rescuer thread is responsible to keep the queue working even
> >> under high memory pressure so that a memory allocation might
> >> sleep. If that happens, all work of that workqueue is designated to
> >> that particular rescuer thread. The work in this rescuer thread is
> >> done strictly sequential. Now we have the situation that the
> >> rescuer thread runs
> >> fw_device_init->read_config_rom->read_rom->fw_run_transaction. fw_run_transaction
> >> blocks waiting for the completion object. This completion object
> >> will be completed in bus_reset_work, but this work will never
> >> executed in the rescuer thread.
> > 
> > Interesting.
> > 
> > Tejun, is this workqueue behavior as designed?  Ie., that a workqueue used
> > as a domain for forward progress guarantees collapses under certain conditions,
> > such as scheduler overhead and no longer ensures forward progress?
> 
> Yeap, from Documentation/workqueue.txt
> 
>   WQ_MEM_RECLAIM
> 
> 	All wq which might be used in the memory reclaim paths _MUST_
> 	have this flag set.  The wq is guaranteed to have at least one
> 	execution context regardless of memory pressure.
> 		 
> All it guarantees is that there will be at least one execution thread
> working on the workqueue under any conditions.  If there are
> inter-dependent work items which are necessary to make forward
> progress in memory reclaim, they must be put into separate workqueues.
> In turn, workqueues w/ WQ_RESCUER set *must* be able to make forward
> progress in all cases at the concurrency level of 1.  Probably the
> documentation needs a bit of clarification.
[...]
> > I thought the whole point of needing WQ_MEM_RECLAIM is if a SBP-2
> > device is swap.
> > 
> > FWIW, I still believe that we should revert to the original bus
> > reset as tasklet and redo the TI workaround to use
> > TI-workaround-specific versions of non-sleeping PHY accesses.
> 
> The right fix would be either dropping WQ_MEM_RECLAIM or breaking it
> into two workqueues so that work items don't have interdependencies.
> 
> Thanks.

Argh, suddenly it all seems so obvious.  Tejun, Peter, Stephan, thank you
for getting this clarified.

A third (fourth?) way to fix it --- feasible or not --- would be to break
the dependency between the worklets.  In this case, use a timer to cancel
outbound transactions if the request-transmit IRQ event was not received
before a timeout.  We had such a timeout in the older ieee1394 drivers and
we also had it in earlier versions of the firewire drivers, at a risk of a
race between CPU and OHCI.
-- 
Stefan Richter
-=====-===-= -=-= =-==-
http://arcgraph.de/sr/
