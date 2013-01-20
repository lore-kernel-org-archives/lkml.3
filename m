Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab3ATUvh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 15:51:37 -0500
Received: from mail.openrapids.net ([64.15.138.104]:60610 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752474Ab3ATUvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 15:51:36 -0500
Date: Sun, 20 Jan 2013 15:51:31 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: rp@svcs.cs.pdx.edu, linux-kernel@vger.kernel.org,
        lttng-dev@lists.lttng.org, stern@rowland.harvard.edu,
        khlebnikov@openvz.org, shemminger@vyatta.com,
        christian.babeux@efficios.com
Subject: Re: [lttng-dev] [PATCH] Add ACCESS_ONCE() to avoid compiler
	splitting assignments
Message-ID: <20130120205131.GB19512@Krystal>
References: <20130115181936.GA30319@linux.vnet.ibm.com> <20130115235642.GA31367@Krystal> <20130116125054.GA9734@Krystal> <20130119191752.GA3159@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130119191752.GA3159@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Wed, Jan 16, 2013 at 07:50:54AM -0500, Mathieu Desnoyers wrote:
> > * Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > As noted by Konstantin Khlebnikov, gcc can split assignment of
> > > > constants to long variables (https://lkml.org/lkml/2013/1/15/141),
> > > > though assignment of NULL (0) is OK.  Assuming that a gcc bug is
> > > > fixed (http://gcc.gnu.org/bugzilla/attachment.cgi?id=29169&action=diff
> > > > has a patch), making the store be volatile keeps gcc from splitting.
> > > > 
> > > > This commit therefore applies ACCESS_ONCE() to CMM_STORE_SHARED(),
> > > > which is the underlying primitive used by rcu_assign_pointer().
> > > 
> > > Hi Paul,
> > > 
> > > I recognise that this is an issue in the Linux kernel, since a simple
> > > store is used and expected to be performed atomically when aligned.
> > > However, I think this does not affect liburcu, see below:
> > 
> > Side question: what gcc versions may issue non-atomic volatile stores ?
> > I think we should at least document those. Bug
> > http://gcc.gnu.org/bugzilla/show_bug.cgi?id=55981 seems to target gcc
> > 4.7.2, but I wonder when this issue first appeared on x86 and x86-64
> > (and if it affects other architectures as well).
> 
> I have no idea which versions are affected.  The bug is in the x86
> backend, so is specific to x86, but there might well be similar bugs
> in other architectures.

Results for my quick tests so far:

gcc version 4.4.7 (Debian 4.4.7-2)
gcc version 4.6.3 (Debian 4.6.3-11)
gcc version 4.7.2 (Debian 4.7.2-5)

for x86-64 are affected (all gcc installed currently on my Debian
laptop). I made a simpler test case than the one shown on the bugzilla,
which triggers the issue with -O0 and -O1 (-O2 and -Os optimisations
seems not to show this issue with the simpler test case).  So far, it
seems to only affect stores from immediate value operands (and only some
patterns).

Debian clang version 3.0-6 (tags/RELEASE_30/final) (based on LLVM 3.0)
is not affected for x86-64.

My test case looks like this:

* non-atomic-pointer.c:

volatile void *var;

void fct(void)
{
        asm volatile ("/* test_begin */" : : : "memory");
        var = (void *) 0x100000002;
        var = (void *) 0x300000004;
        asm volatile ("/* test_end */" : : : "memory");
}


* build.sh:

#!/bin/bash

FLAGS="-S ${*}"

function do_build
{
        $1 ${FLAGS} -o non-atomic-pointer-$1.S.output non-atomic-pointer.c
}

do_build gcc-4.4
do_build gcc-4.6
do_build gcc-4.7
do_build gcc-4.7
do_build g++-4.6
do_build g++-4.7
do_build clang


* check.py (might need adaptation for each architecture and O2, Os):

#!/usr/bin/env python

import sys, string, os, re

# count the number of lines with "mov*" instructions between test_begin
# and test_end. Should be 2. Report error if not.

f = open (sys.argv[1], "r")

lines = f.readlines()

within_range = 0
mov_count = 0
error = 0

re_mov = re.compile('	mov.*')
re_begin = re.compile('.*test_begin.*')
re_end = re.compile('.*test_end.*')

output = ""

for line in lines:
	if re_begin.match(line):
		within_range = 1
	elif re_end.match(line):
		within_range = 0
	elif (within_range and re_mov.match(line)):
		output += line
		mov_count += 1

if mov_count > 2:
	error = 1

f.close()

if error > 0:
	print "[Error] expect 2 mov, found " + str(mov_count)
	print output
	1
else:
	0

> 
> > Thanks,
> > 
> > Mathieu
> > 
> > > 
> > > > 
> > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > 
> > > > diff --git a/urcu/system.h b/urcu/system.h
> > > > index 2a45f22..7a1887e 100644
> > > > --- a/urcu/system.h
> > > > +++ b/urcu/system.h
> > > > @@ -49,7 +49,7 @@
> > > >   */
> > > >  #define CMM_STORE_SHARED(x, v)		\
> > > >  	({				\
> > > > -		__typeof__(x) _v = _CMM_STORE_SHARED(x, v);	\
> > > > +		__typeof__(x) CMM_ACCESS_ONCE(_v) = _CMM_STORE_SHARED(x, v);	\
> > > 
> > > Here, the macro "_CMM_STORE_SHARED(x, v)" is doing the actual store.
> > > It stores v into "x". So adding a CMM_ACCESS_ONCE(_v), as you propose
> > > here, is really only making sure the return value (usually unused),
> > > located on the stack, is accessed with a volatile access, which does not
> > > make much sense.
> > > 
> > > What really matters is the _CMM_STORE_SHARED() macro:
> > > 
> > > #define _CMM_STORE_SHARED(x, v) ({ CMM_ACCESS_ONCE(x) = (v); })
> > > 
> > > which already uses a volatile access for the store. So this seems to be
> > > a case where our preemptive use of volatile for stores in addition to
> > > loads made us bug-free for a gcc behavior unexpected at the time we
> > > implemented this macro. Just a touch of paranoia seems to be a good
> > > thing sometimes. ;-)
> > > 
> > > Thoughts ?
> 
> Here is my thought:  You should ignore my "fix".  Please accept my
> apologies for my confusion!

No worries! Thanks for bringing this issue to my attention.

I'm thinking we might want to create a test throwing code with random
immediate values into my python checker script, for various
architectures for a couple of weeks, and see what breaks.

Also, it might be good to test whether some register inputs can generate
code that write into an unsigned long non-atomically. This would be even
more worrying.

Thanks,

Mathieu

> 
> 							Thanx, Paul
> 
> > > Thanks,
> > > 
> > > Mathieu
> > > 
> > > >  		cmm_smp_wmc();		\
> > > >  		_v;			\
> > > >  	})
> > > > 
> > > > 
> > > > _______________________________________________
> > > > lttng-dev mailing list
> > > > lttng-dev@lists.lttng.org
> > > > http://lists.lttng.org/cgi-bin/mailman/listinfo/lttng-dev
> > > 
> > > -- 
> > > Mathieu Desnoyers
> > > EfficiOS Inc.
> > > http://www.efficios.com
> > > 
> > > _______________________________________________
> > > lttng-dev mailing list
> > > lttng-dev@lists.lttng.org
> > > http://lists.lttng.org/cgi-bin/mailman/listinfo/lttng-dev
> > 
> > -- 
> > Mathieu Desnoyers
> > EfficiOS Inc.
> > http://www.efficios.com
> > 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
