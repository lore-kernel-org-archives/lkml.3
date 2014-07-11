Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbaGKS33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 14:29:29 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:50109 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaGKS32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 14:29:28 -0400
Date: Fri, 11 Jul 2014 11:29:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, oleg@redhat.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 11/17] rcu: Bind grace-period kthreads to
 non-NO_HZ_FULL CPUs
Message-ID: <20140711182921.GP16041@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1404772701-8804-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140708152358.GF6571@localhost.localdomain>
 <20140708154723.GN4603@linux.vnet.ibm.com>
 <20140708183846.GJ6571@localhost.localdomain>
 <alpine.DEB.2.11.1407111309150.4777@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1407111309150.4777@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071118-1344-0000-0000-000002C59464
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 01:10:41PM -0500, Christoph Lameter wrote:
> On Tue, 8 Jul 2014, Frederic Weisbecker wrote:
> 
> > > I was figuring that a fair number of the kthreads might eventually
> > > be using this, not just for the grace-period kthreads.
> >
> > Ok makes sense. But can we just rename the cpumask to housekeeping_mask?
> 
> That would imply that all no-nohz processors are housekeeping? So all
> processors with a tick are housekeeping?
> 
> Could we make that set configurable? Ideally I'd like to have the ability
> restrict the housekeeping to one processor.

We have a housekeeping_affine() in -rcu that currently assumes that all
no-nohz CPUs are housekeeping CPUs.  It would not be hard to add the
ability to restrict the housekeeping CPUs further.  Coming to agreement
on exactly how to go about doing it might be hard, but read on!  ;-)

Here are some possibilities that come to mind:

1.	Have a housekeeping= boot parameter that takes the list of
	housekeeping CPUs.  You have full control: You break it,
	you get to keep the pieces.

2.	As above, but eliminate any nohz_full= CPUs from the
	housekeeping= list (probably with a splat).

	This of course raises the question about what to do if the
	resulting housekeeping set is empty:

	a.	Complain and let housekeeping tasks run anywhere.

	b.	Complain and restrict housekeeping tasks to !nohz CPUs.

3.	Have a housekeeping= boot parameter that specifies the number
	of housekeeping CPUs, which are taken from the !nohz_full
	list in order.  If too many are specified, complain and either:

	a.	Restrict to !nohz_full CPUs.

	b.	Use the specified number of nohz_full CPUs as
		housekeeping CPUs.

Thoughts?

							Thanx, Paul

