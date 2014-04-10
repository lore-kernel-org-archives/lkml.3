Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935534AbaDJPip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 11:38:45 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:33524 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934689AbaDJPim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 11:38:42 -0400
Date: Thu, 10 Apr 2014 11:38:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Clark Williams <williams@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC PATCH RT] rwsem: The return of multi-reader PI rwsems
Message-ID: <20140410113840.6ad8abfe@gandalf.local.home>
In-Reply-To: <5346B2C8.6000207@linutronix.de>
References: <20140409151922.5fa5d999@gandalf.local.home>
	<20140410094430.56ca9ee1@sluggy.gateway.2wire.net>
	<5346B2C8.6000207@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2014 17:03:36 +0200
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> On 04/10/2014 04:44 PM, Clark Williams wrote:
> > The means of each group of five test runs are:
> > 
> > vanilla.log:  1210117 rt.log:  17210953 (14.2 x slower than
> > vanilla) rt-fixes.log:  10062027 (8.3 x slower than vanilla) 
> > rt-multi.log:  3179582  (2.x x slower than vanilla)
> > 
> > 
> > As expected, vanilla kicked RT's butt when hammering on the 
> > mmap_sem. But somewhat unexpectedly, your fixups helped quite a
> > bit and the multi+fixups got RT back into being almost
> > respectable.
> > 
> > Obviously these are just preliminary results on one piece of h/w
> > but it looks promising.
> 
> Is it easy to look at the latency when you have multiple readers and
> and a high prio writer which has to boost all those readers away
> instead just one?
> Or is this something that should not happen for a high prio RT task
> because it has all memory already allocated?

Note, the patch includes a /proc/sys/kernel/rwsem_reader_limit that is
default value set at possible_cpus. The user can change it to any
number. A number of zero means unlimited, and a number of 1 makes it
work like it did without the patch.

This means that a writer will only have to wait for rwsem_reader_limit
readers, which may give a longer latency, but it is still bounded. Also
note that the rwsem is not fair respect to first come first served, but
priority driven. Same priority tasks may be first in first out, but if
there's a writer waiting and a higher priority reader comes along, it
can still get the lock, making the writer wait longer. But as the
reader is higher priority than the writer, that is expected. The same
priority reader will block if there's a writer waiting.

Clark, it would be interesting if you run the test again with my
patches but set rwsem_reader_limit to 1, and see what the impact of
that is.

-- Steve
