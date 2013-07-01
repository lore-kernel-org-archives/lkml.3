Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab3GAUYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:24:41 -0400
Received: from a9-58.smtp-out.amazonses.com ([54.240.9.58]:59965 "EHLO
	a9-58.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755263Ab3GAUYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:24:39 -0400
Date: Mon, 1 Jul 2013 20:24:38 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 0/7] v2 Provide infrastructure for full-system
 idle
In-Reply-To: <20130701195603.GT3773@linux.vnet.ibm.com>
Message-ID: <0000013f9be88da8-acabdf49-cbac-482b-a4bb-b490f1b5a06a-000000@email.amazonses.com>
References: <20130628200949.GA17458@linux.vnet.ibm.com> <0000013f9bc32a5e-258db1be-840b-4b2f-9b3f-e1e3d5253cfc-000000@email.amazonses.com> <20130701195603.GT3773@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.07.01-54.240.9.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jul 2013, Paul E. McKenney wrote:

> On Mon, Jul 01, 2013 at 07:43:47PM +0000, Christoph Lameter wrote:
> > On Fri, 28 Jun 2013, Paul E. McKenney wrote:
> >
> > > Unfortunately, timekeeping CPU continues taking scheduling-clock
> > > interrupts even when all other CPUs are completely idle, which is
> > > not so good for energy efficiency and battery lifetime.  Clearly, it
> > > would be good to turn off the timekeeping CPU's scheduling-clock tick
> > > when all CPUs are completely idle.  This is conceptually simple, but
> > > we also need good performance and scalability on large systems, which
> > > rules out implementations based on frequently updated global counts of
> > > non-idle CPUs as well as implementations that frequently scan all CPUs.
> > > Nevertheless, we need a single global indicator in order to keep the
> > > overhead of checking acceptably low.
> >
> > Can we turn off timekeeping when no cpu needs time in adaptive mode?
> > Setting breakpoints in the VDSO could force timekeeping on again whenever
> > something needs time. Would this not be simpler?
>
> Might be.  But what causes the breakpoints to be set on a system where
> there is one CPU-bound nohz_full user-mode task with all other CPUs idle?
> Or are you suggesting taking a breakpoint trap on each timekeeping access
> to VDSO?

Well when a tick notices that it is the last one still enabled on the
system and it could disable itself then it would set the breakpoint and
then turn the tick on the last processor off. The code invoked by the
breakpoint would reenable tick processing, update time and then use that
new info to return the correct time.

