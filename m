Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbbAUWMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 17:12:19 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:35846 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbbAUWML (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Wed, 21 Jan 2015 17:12:11 -0500
Message-ID: <1421878320.4903.17.camel@stgolabs.net>
Subject: Re: Linux 3.19-rc5
From: Davidlohr Bueso <dave@stgolabs.net>
To: Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        oleg@redhat.com
Date: Wed, 21 Jan 2015 14:12:00 -0800
In-Reply-To: <20150121223701.0c580f7b@neptune.home>
References: <CA+55aFxNk9OCXz7nvKXpRBc0Z85NLXPNkRm1yJf4-KAGB4pHRA@mail.gmail.com>
	 <20150119190216.7ce58d74@neptune.home>
	 <CA+55aFw7aoShsqS_ro5DASbseXFLQs_sE=dwLp_tTNAvD9Y09w@mail.gmail.com>
	 <20150121213733.7522f087@neptune.home>
	 <20150121223701.0c580f7b@neptune.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-21 at 22:37 +0100, Bruno Prémont wrote:
> On Wed, 21 January 2015 Bruno Prémont wrote:
> > On Tue, 20 January 2015 Linus Torvalds wrote:
> > > On Tue, Jan 20, 2015 at 6:02 AM, Bruno Prémont wrote:
> > > >
> > > > No idea yet which rc is the offender (nor exact patch), but on my not
> > > > so recent UP laptop with a pccard slot I have 2 pccardd kernel threads
> > > > converting my laptop into a heater.
> > > >
> > > > lspci for affected nodes:
> > > > 02:06.0 CardBus bridge [0607]: O2 Micro, Inc. OZ711EC1 SmartCardBus Controller [1217:7113] (rev 20)
> > > > 02:06.1 CardBus bridge [0607]: O2 Micro, Inc. OZ711EC1 SmartCardBus Controller [1217:7113] (rev 20)
> > > >
> > > > Very basics I have, before I attempt any bisection:
> > > 
> > > Hmm. I'm not seeing anything recent changing anything in this area, so
> > > I suspect that unless somebody else steps up and says "Ahh, that
> > > sounds like xyz", your bisection is the best option.
> 
> Bisecting to the end did point me at (the warning traces produced in great
> quantities might not be the very same issue as the abusive CPU usage, but
> certainly look very related):
>   [CCing people on CC for the patch]
> 
> commit 8eb23b9f35aae413140d3fda766a98092c21e9b0
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Wed Sep 24 10:18:55 2014 +0200
> 
>     sched: Debug nested sleeps
>     
>     Validate we call might_sleep() with TASK_RUNNING, which catches places
>     where we nest blocking primitives, eg. mutex usage in a wait loop.
>     
>     Since all blocking is arranged through task_struct::state, nesting
>     this will cause the inner primitive to set TASK_RUNNING and the outer
>     will thus not block.
>     
>     Another observed problem is calling a blocking function from
>     schedule()->sched_submit_work()->blk_schedule_flush_plug() which will
>     then destroy the task state for the actual __schedule() call that
>     comes after it.
>     
>     Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>     Cc: tglx@linutronix.de
>     Cc: ilya.dryomov@inktank.com
>     Cc: umgwanakikbuti@gmail.com
>     Cc: oleg@redhat.com
>     Cc: Linus Torvalds <torvalds@linux-foundation.org>
>     Link: http://lkml.kernel.org/r/20140924082242.591637616@infradead.org
>     Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> Which does produce the following trace (hand-copied most important parts of it):
>   Warning: CPU 0 PID: 68 at kernel/sched/core.c:7311 __might_sleep+0x143/0x170
>   do not call blocking ops when !TASK_RUNNING; state=1 set at [<c1436390>] pccardd+0xa0/0x3e0
>   ...
>   Call trace:
>     ...
>     __might_sleep+0x143/0x170
>     ? pccardd+0xa0/0x3e0
>     ? pccardd+0xa0/0x3e0
>     mutex_lock+0x17/0x2a
>     pccardd+0xe9/0x3e0
>     ? pcmcia_socket_uevent+0x30/0x30
> 
> pccardd() is located in drivers/pcmcia/cs.c and seems to be of the structure
> Peter's patch wants to warn about.

Yeah setting current to interruptable so early in the game is bogus. It
should be set after unlocking the skt_mutex.

