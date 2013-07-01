Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab3GAPwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 11:52:35 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:57156 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab3GAPwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 11:52:34 -0400
Date: Mon, 1 Jul 2013 08:52:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full v2 2/7] nohz_full: Add rcu_dyntick data for
 scalable detection of all-idle state
Message-ID: <20130701155220.GL3773@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130628200949.GA17458@linux.vnet.ibm.com>
 <1372450222-19420-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1372450222-19420-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130701153150.GB2923@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130701153150.GB2923@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070115-4834-0000-0000-000008969C26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 08:31:50AM -0700, Josh Triplett wrote:
> On Fri, Jun 28, 2013 at 01:10:17PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > This commit adds fields to the rcu_dyntick structure that are used to
> > detect idle CPUs.  These new fields differ from the existing ones in
> > that the existing ones consider a CPU executing in user mode to be idle,
> > where the new ones consider CPUs executing in user mode to be busy.
> 
> Can you explain, both in the commit messages and in the comments added
> by the next commit, *why* this code doesn't consider userspace a
> quiescent state?

Good point!  Does the following explain it?

	Although one of RCU's quiescent states is usermode execution,
	it is not a full-system idle state.  This is because the purpose
	of the full-system idle state is not RCU, but rather determining
	when accurate timekeeping can safely be disabled.  Whenever
	accurate timekeeping is required in a CONFIG_NO_HZ_FULL kernel,
	at least one CPU must keep the scheduling-clock tick going.
	If even one CPU is executing in user mode, accurate timekeeping
	is requires, particularly for architectures where gettimeofday()
	and friends do not enter the kernel.  Only when all CPUs are
	really and truly idle can accurate timekeeping be disabled,
	allowing all CPUs to turn off the scheduling clock interrupt,
	thus greatly improving energy efficiency.

	This naturally raises the question "Why is this code in RCU rather
	than in timekeeping?", and the answer is that RCU has the data
	and infrastructure to efficiently make this determination.

							Thanx, Paul

