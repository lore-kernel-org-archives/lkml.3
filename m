Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaKYRN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:13:29 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:39454 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbaKYRN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:13:26 -0500
Date: Tue, 25 Nov 2014 09:13:20 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Josh Triplett <josh@joshtriplett.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v4 2/5] x86, traps: Track entry into and exit from IST
 context
Message-ID: <20141125171320.GA22572@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CALCETrVzeK=VWnAhpkPhxj9C012ETgArEPmLMFfhKJ7k1pHsXA@mail.gmail.com>
 <20141124205441.GW5050@linux.vnet.ibm.com>
 <CALCETrXBofV3oxDwK4MiSvFQcX3yxX_sL_KY63EZ8DgS8LnJSg@mail.gmail.com>
 <20141124213501.GX5050@linux.vnet.ibm.com>
 <20141124223407.GB8512@linux.vnet.ibm.com>
 <CALCETrUA+z5z6bnOw63-EUiFD4WQtBXm1TE2DSRj3uG+d_k-bQ@mail.gmail.com>
 <20141124225754.GY5050@linux.vnet.ibm.com>
 <20141124233101.GA2819@linux.vnet.ibm.com>
 <CALCETrV37kqC658AzBHZ5z_vH2b_1T821q5EfbMcS9Ecpj8EEw@mail.gmail.com>
 <20141124235058.GZ5050@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141124235058.GZ5050@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112517-0017-0000-0000-0000069261DD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 03:50:58PM -0800, Paul E. McKenney wrote:
> On Mon, Nov 24, 2014 at 03:35:55PM -0800, Andy Lutomirski wrote:
> > On Mon, Nov 24, 2014 at 3:31 PM, Paul E. McKenney
> > <paulmck@linux.vnet.ibm.com> wrote:
> > > On Mon, Nov 24, 2014 at 02:57:54PM -0800, Paul E. McKenney wrote:
> > >> On Mon, Nov 24, 2014 at 02:36:18PM -0800, Andy Lutomirski wrote:
> > >> > On Mon, Nov 24, 2014 at 2:34 PM, Paul E. McKenney
> > >> > <paulmck@linux.vnet.ibm.com> wrote:
> > >> > > On Mon, Nov 24, 2014 at 01:35:01PM -0800, Paul E. McKenney wrote:
> > >>
> > >> [ . . . ]
> > >>
> > >> > > And the following Promela model claims that your approach works.
> > >> > > Should I trust it?  ;-)
> > >> > >
> > >> >
> > >> > I think so.

OK, I added some coverage checks and also injected bugs, all of which
it detected, so I am feeling at least a bit more confident in the model,
the updated version of which is included below, along with the script
that runs it.

							Thanx, Paul

------------------------------------------------------------------------
rcu_nmi.spin
------------------------------------------------------------------------

/*
 * Promela model for Andy Lutomirski's suggested change to rcu_nmi_enter()
 * that allows nesting.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, you can access it online at
 * http://www.gnu.org/licenses/gpl-2.0.html.
 *
 * Copyright IBM Corporation, 2014
 *
 * Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
 */

byte dynticks_nmi_nesting = 0;
byte dynticks = 0;
#define BUSY_INCBY 2 /* set to 1 to force failure. */

/*
 * Promela verision of rcu_nmi_enter().
 */
inline rcu_nmi_enter()
{
	byte incby;
	byte tmp;

	incby = BUSY_INCBY;
	assert(dynticks_nmi_nesting >= 0);
	if
	:: (dynticks & 1) == 0 ->
		atomic {
			dynticks = dynticks + 1;
		}
		assert((dynticks & 1) == 1);
		incby = 1;
	:: else ->
		skip;
	fi;
	tmp = dynticks_nmi_nesting;
	tmp = tmp + incby;
	dynticks_nmi_nesting = tmp;
	assert(dynticks_nmi_nesting >= 1);
}

/*
 * Promela verision of rcu_nmi_exit().
 */
inline rcu_nmi_exit()
{
	byte tmp;

	assert(dynticks_nmi_nesting > 0);
	assert((dynticks & 1) != 0);
	if
	:: dynticks_nmi_nesting != 1 ->
		tmp = dynticks_nmi_nesting;
		tmp = tmp - BUSY_INCBY;
		dynticks_nmi_nesting = tmp;
	:: else ->
		dynticks_nmi_nesting = 0;
		atomic {
			dynticks = dynticks + 1;
		}
		assert((dynticks & 1) == 0);
	fi;
}

/*
 * Base-level NMI runs non-atomically.  Crudely emulates process-level
 * dynticks-idle entry/exit.
 */
proctype base_NMI()
{
	byte busy;

	busy = 0;
	do
	::	/* Emulate base-level dynticks and not. */
		if
		:: 1 ->	atomic {
				dynticks = dynticks + 1;
			}
			busy = 1;
		:: 1 ->	skip;
		fi;

		/* Verify that we only sometimes have base-level dynticks. */
		if
		:: busy == 0 -> skip;
		:: busy == 1 -> skip;
		fi;

		/* Model RCU's NMI entry and exit actions. */
		rcu_nmi_enter();
		assert((dynticks & 1) == 1);
		rcu_nmi_exit();

		/* Emulated re-entering base-level dynticks and not. */
		if
		:: !busy -> skip;
		:: busy ->
			atomic {
				dynticks = dynticks + 1;
			}
			busy = 0;
		fi;

		/* We had better now be in dyntick-idle mode. */
		assert((dynticks & 1) == 0);
	od;
}

/*
 * Nested NMI runs atomically to emulate interrupting base_level().
 */
proctype nested_NMI()
{
	do
	::	/*
		 * Use an atomic section to model a nested NMI.  This is
		 * guaranteed to interleave into base_NMI() between a pair
		 * of base_NMI() statements, just as a nested NMI would.
		 */
		atomic {
			/* Verify that we only sometimes are in dynticks. */
			if
			:: (dynticks & 1) == 0 -> skip;
			:: (dynticks & 1) == 1 -> skip;
			fi;

			/* Model RCU's NMI entry and exit actions. */
			rcu_nmi_enter();
			assert((dynticks & 1) == 1);
			rcu_nmi_exit();
		}
	od;
}

init {
	run base_NMI();
	run nested_NMI();
}

------------------------------------------------------------------------
rcu_nmi.sh
------------------------------------------------------------------------

if ! spin -a rcu_nmi.spin
then
	echo Spin errors!!!
	exit 1
fi
if ! cc -DSAFETY -o pan pan.c
then
	echo Compilation errors!!!
	exit 1
fi
./pan -m100000
# For errors: spin -p -l -g -t rcu_nmi.spin < rcu_nmi.spin.trail

