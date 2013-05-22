Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab3EVM62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 08:58:28 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38115 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab3EVM61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 08:58:27 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 22 May 2013 14:58:08 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: stephan.gatzka@gmail.com
Cc: Tejun Heo <tj@kernel.org>, Peter Hurley <peter@hurleysoftware.com>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: function call fw_iso_resource_mange(..) (core-iso.c) does not
 return
Message-ID: <20130522145808.1ec7bea7@stein>
In-Reply-To: <51145028d1c880d68e0a88d863faa71c@gatzka.org>
References: <8ac7ca3200325ddf85ba57aa6d000f70@gatzka.org>
	<519BA6AC.1080600@hurleysoftware.com>
	<20130521231847.GA6985@mtj.dyndns.org>
	<20130522094840.472b263e@stein>
	<51145028d1c880d68e0a88d863faa71c@gatzka.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 22 Stephan Gatzka wrote:
[I wrote:]
> > A third (fourth?) way to fix it --- feasible or not --- would be to break
> > the dependency between the worklets.  In this case, use a timer to cancel
> > outbound transactions if the request-transmit IRQ event was not received
> > before a timeout.  We had such a timeout in the older ieee1394 drivers and
> > we also had it in earlier versions of the firewire drivers, at a risk of a
> > race between CPU and OHCI.
> 
> Why do we need a timer? If we guarantee that bus_reset_work() always 
> make progress (if we put it into its own queue), it should always be 
> able to complete the corresponding completion object the other works are 
> waiting for.

We don't need a timer if the dual-wq solution is implemented.  It's just
that there are four different solutions possible in principle.  Any one
of these fixes is sufficient on its own:

Problem --- A WQ_MEM_RECLAIM workqueue will, for some periods of time,
offer a concurrency level of only 1; particularly during memory reclaim,
but also in some other situations due to the way how it is implemented (as
far as I understood yesterday's posts).  Therefore, interdependent works
must not be inserted into the same WQ_MEM_RECLAIM workqueue instance.

Solution 1 --- Don't set the WQ_MEM_RECLAIM flag.  This is only possible
if memory reclaim does not depend on any one of the works that are
inserted into this queue.  (This solution is therefore not available to
an SBP-2 initiator.)

Solution 2 --- Perform interdependent works in different queue instances.
(Keep the WQ_MEM_RECLAIM flag set at those workqueues that have to take
work which is necessary for progress of memory reclaim.  If this and only
this solution is employed for an SBP-2 initiator, we need two if not more
WQ_MEM_RECLAIM workqueue instances.)

Solution 3 --- Remove the dependency between worklets:

	Solution 3a --- Remove the lower-level worklet altogether.
	E.g. reimplement the lower-level worklet as a tasklet.

	Solution 3b --- Remove the higher-level worklet's dependency.
	E.g. reimplement the higher-level worklet such that it is woken by
	a timer and then aborts or reschedules ( = lets the lower-level
	worklet bubble up in the queue).
-- 
Stefan Richter
-=====-===-= -=-= =-==-
http://arcgraph.de/sr/
