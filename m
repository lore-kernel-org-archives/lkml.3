Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbaGWQrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:47:36 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:56650 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbaGWQre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:47:34 -0400
Date: Wed, 23 Jul 2014 18:47:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>,
        Ingo Molnar <mingo@elte.hu>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ring-buffer: Race when writing and swapping cpu
 buffer in parallel
Message-ID: <20140723164721.GH23175@localhost.localdomain>
References: <1405501084-16135-1-git-send-email-pmladek@suse.cz>
 <20140716124356.398e21f4@gandalf.local.home>
 <20140718153443.GC6774@pathway.suse.cz>
 <20140721144324.GG20751@pathway.suse.cz>
 <20140721154317.GS8690@linux.vnet.ibm.com>
 <20140723162845.GF23175@localhost.localdomain>
 <20140723123458.314a43fa@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140723123458.314a43fa@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 12:34:58PM -0400, Steven Rostedt wrote:
> On Wed, 23 Jul 2014 18:28:48 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Mon, Jul 21, 2014 at 08:43:17AM -0700, Paul E. McKenney wrote:
> > > On Mon, Jul 21, 2014 at 04:43:24PM +0200, Petr Mládek wrote:
> > > > 2. Go back, do the swap on any CPU, and do memory barriers via IPI.
> > > > 
> > > >    I wonder if the needed memory barrier in rb_reserve_next_event()
> > > >    could be avoided by calling IPI from ring_buffer_swap_cpu().
> > > > 
> > > >    I mean that rb_reserve_next_event() will include the current check
> > > >    for swapped ring buffer without barriers. But
> > > >    ring_buffer_swap_cpu() will interrupt the affected CPU and
> > > >    basically do the barrier there only when needed.
> > > > 
> > > >    But I am not sure how this is different from calling
> > > >    smp_call_function_single() from ring_buffer_swap_cpu().
> > > >    And I am back on the question why it is dangerous with disabled
> > > >    interrupts. I can't find any clue in git history. And I miss this
> > > >    part of the picture :-(
> > > 
> > > IIRC, deadlock in the case where two CPUs attempt to invoke
> > > smp_call_function_single() at each other, but both have
> > > interrupts disabled.  It might be possible to avoid this by telling
> > > smp_call_function_single() not to wait for a response, but this often
> > > just re-introduces the deadlock at a higher level.
> > 
> > FWIW, this is what smp_call_function_single_async() does. But then the call
> > must synchronized such that no concurrent call happen until the IPI completion.
> > 
> > Otherwise you also have irq_work_queue_on() (not yet upstream but in tip/timers/nohz
> > and tip/sched/core).
> 
> Well, the code in question must wait for the IPI to finish, thus as
> Paul said, we just push the issue to the caller.

Ah right if we need to wait for IPI completion from irqs disabled, I fear we can't.
