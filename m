Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656AbaDXByb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 21:54:31 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:56757 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaDXBy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 21:54:29 -0400
Date: Wed, 23 Apr 2014 18:46:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        joern@logfs.org, peterz@infradead.org,
        Andrew Morton <akpm@linux-foundation.org>, cxie@redhat.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH RFC] sysrq: rcu-ify __handle_sysrq
Message-ID: <20140424014648.GK4496@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140423125352.704f9fb2@annuminas.surriel.com>
 <alpine.LRH.2.00.1404232329020.1491@twin.jikos.cz>
 <535833AE.6010505@redhat.com>
 <alpine.LRH.2.00.1404232349350.1491@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1404232349350.1491@twin.jikos.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042401-1344-0000-0000-0000011C6A91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 11:51:55PM +0200, Jiri Kosina wrote:
> On Wed, 23 Apr 2014, Rik van Riel wrote:
> 
> > >> Echoing values into /proc/sysrq-trigger seems to be a popular way to
> > >> get information out of the kernel. However, dumping information about
> > >> thousands of processes, or hundreds of CPUs to serial console can
> > >> result in IRQs being blocked for minutes, resulting in various kinds
> > >> of cascade failures.
> > >>
> > >> The most common failure is due to interrupts being blocked for a very
> > >> long time. This can lead to things like failed IO requests, and other
> > >> things the system cannot easily recover from.
> > >>
> > >> This problem is easily fixable by making __handle_sysrq use RCU
> > >> instead of spin_lock_irqsave.
> > >>
> > >> This leaves the warning that RCU grace periods have not elapsed for a
> > >> long time, but the system will come back from that automatically.
> > > 
> > > This, however, will make RCU stall detector to send NMI to all online CPUs 
> > > so that they can dump their stacks.

Hey, if dumping the stacks once is a good idea, dumping them twice
must be twice as good, right?  ;-)

> > It already does that, since several of the longer-running
> > sysrq handlers already grab rcu_read_lock(), for example
> > show_state().
> > 
> > > IOW, this might actually make the whole sysrq dump last for much longer, 
> > > and have the log polluted with all-CPU dumps for no good reason.
> > > 
> > > I wonder whether explicitly setting rcu_cpu_stall_suppress during sysrq 
> > > handling might be a viable workaround for this.
> > 
> > I suppose that would do the trick.
> 
> I can imagine Paul opposing this though ... this variable is supposed to 
> be changed only by cmdline/modparam, not really flipped during runtime as 
> a bandaid ... let's add Paul to CC.

Well, we already crowbar it to 1 when panic starts, see rcu_panic().

How about something like the following?

	void rcu_sysrq_start(void)
	{
		rcu_cpu_stall_suppress = 2;
	}

	void rcu_sysrq_end(void)
	{
		if (rcu_cpu_stall_suppress == 2)
			rcu_cpu_stall_suppress = 0;
	}

If there get to be too many more different reasons for temporarily
suppressing RCU CPU stall warnings, I can then swap out to a better
implementation, for some definition or another of "better".

							Thanx, Paul

