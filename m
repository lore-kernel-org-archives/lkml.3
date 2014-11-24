Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaKXW6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:58:03 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:46748 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaKXW6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:58:01 -0500
Date: Mon, 24 Nov 2014 14:57:54 -0800
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
Message-ID: <20141124225754.GY5050@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CALCETrVNnDEcVu_BteA2gVBeRB7zOsQmrA6JCrE8ez4U=vc0MQ@mail.gmail.com>
 <20141122042056.GY5050@linux.vnet.ibm.com>
 <CALCETrXSY9JpW3uE6H8WYk81sg56qasA2aqmjMPsq5dOtzso=g@mail.gmail.com>
 <20141122234157.GB5050@linux.vnet.ibm.com>
 <CALCETrVzeK=VWnAhpkPhxj9C012ETgArEPmLMFfhKJ7k1pHsXA@mail.gmail.com>
 <20141124205441.GW5050@linux.vnet.ibm.com>
 <CALCETrXBofV3oxDwK4MiSvFQcX3yxX_sL_KY63EZ8DgS8LnJSg@mail.gmail.com>
 <20141124213501.GX5050@linux.vnet.ibm.com>
 <20141124223407.GB8512@linux.vnet.ibm.com>
 <CALCETrUA+z5z6bnOw63-EUiFD4WQtBXm1TE2DSRj3uG+d_k-bQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUA+z5z6bnOw63-EUiFD4WQtBXm1TE2DSRj3uG+d_k-bQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112422-0009-0000-0000-000006946866
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 02:36:18PM -0800, Andy Lutomirski wrote:
> On Mon, Nov 24, 2014 at 2:34 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Mon, Nov 24, 2014 at 01:35:01PM -0800, Paul E. McKenney wrote:

[ . . . ]

> > And the following Promela model claims that your approach works.
> > Should I trust it?  ;-)
> >
> 
> I think so.
> 
> Want to write a patch?  If so, whose tree should it go in?  I can add
> it to my IST series, but that seems a bit odd.

Working on it.  ;-)

							Thanx, Paul

> --Andy
> 
> >                                                         Thanx, Paul
> >
> > ------------------------------------------------------------------------
> >
> > /*
> >  * Promela model for Andy Lutomirski's suggested change to rcu_nmi_enter()
> >  * that allows nesting.
> >  *
> >  * This program is free software; you can redistribute it and/or modify
> >  * it under the terms of the GNU General Public License as published by
> >  * the Free Software Foundation; either version 2 of the License, or
> >  * (at your option) any later version.
> >  *
> >  * This program is distributed in the hope that it will be useful,
> >  * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >  * GNU General Public License for more details.
> >  *
> >  * You should have received a copy of the GNU General Public License
> >  * along with this program; if not, you can access it online at
> >  * http://www.gnu.org/licenses/gpl-2.0.html.
> >  *
> >  * Copyright IBM Corporation, 2014
> >  *
> >  * Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >  */
> >
> > byte dynticks_nesting;
> > byte dynticks_nmi_nesting;
> > byte dynticks;
> > byte busy;
> >
> > /*
> >  * Promela verision of rcu_nmi_enter().
> >  */
> > inline rcu_nmi_enter()
> > {
> >         assert(dynticks_nmi_nesting >= 0);
> >         if
> >         :: (dynticks & 1) == 0 ->
> >                 atomic {
> >                         dynticks = dynticks + 1;
> >                 }
> >                 assert((dynticks & 1) == 1);
> >                 dynticks_nmi_nesting = dynticks_nmi_nesting + 1;
> >                 assert(dynticks_nmi_nesting >= 1);
> >         :: else ->
> >                 dynticks_nmi_nesting = dynticks_nmi_nesting + 2;
> >         fi;
> > }
> >
> > /*
> >  * Promela verision of rcu_nmi_exit().
> >  */
> > inline rcu_nmi_exit()
> > {
> >         assert(dynticks_nmi_nesting > 0);
> >         assert((dynticks & 1) != 0);
> >         if
> >         :: dynticks_nmi_nesting != 1 ->
> >                 dynticks_nmi_nesting = dynticks_nmi_nesting - 2;
> >         :: else ->
> >                 dynticks_nmi_nesting = 0;
> >                 atomic {
> >                         dynticks = dynticks + 1;
> >                 }
> >                 assert((dynticks & 1) == 0);
> >         fi;
> > }
> >
> > /*
> >  * Base-level NMI runs non-atomically.  Crudely emulates process-level
> >  * dynticks-idle entry/exit.
> >  */
> > proctype base_NMI()
> > {
> >         do
> >         ::      if
> >                 :: 1 -> atomic {
> >                                 dynticks = dynticks + 1;
> >                         }
> >                         busy = 0;
> >                 :: 1 -> skip;
> >                 fi;
> >                 rcu_nmi_enter();
> >                 assert((dynticks & 1) == 1);
> >                 rcu_nmi_exit();
> >                 if
> >                 :: busy -> skip;
> >                 :: !busy ->
> >                         atomic {
> >                                 dynticks = dynticks + 1;
> >                         }
> >                         busy = 1;
> >                 fi;
> >         od;
> > }
> >
> > /*
> >  * Nested NMI runs atomically to emulate interrupting base_level().
> >  */
> > proctype nested_NMI()
> > {
> >         do
> >         ::      atomic {
> >                         rcu_nmi_enter();
> >                         assert((dynticks & 1) == 1);
> >                         rcu_nmi_exit();
> >                 }
> >         od;
> > }
> >
> > init {
> >         dynticks_nesting = 0;
> >         dynticks_nmi_nesting = 0;
> >         dynticks = 0;
> >         busy = 0;
> >         run base_NMI();
> >         run nested_NMI();
> > }
> >
> 
> 
> 
> -- 
> Andy Lutomirski
> AMA Capital Management, LLC
> 

