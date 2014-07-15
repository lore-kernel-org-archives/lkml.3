Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaGOOYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:24:09 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35175 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaGOOX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:23:56 -0400
Date: Tue, 15 Jul 2014 10:23:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, boris.ostrovsky@oracle.com,
        paulmck@linux.vnet.ibm.com, riel@redhat.com,
        torvalds@linux-foundation.org, raghavendra.kt@linux.vnet.ibm.com,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: Re: [PATCH 10/11] qspinlock: Paravirt support
Message-ID: <20140715142305.GA3403@laptop.dumpdata.com>
References: <20140615124657.264658593@chello.nl>
 <20140615130154.213923590@chello.nl>
 <20140620134608.GA11545@laptop.dumpdata.com>
 <20140707152734.GX6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140707152734.GX6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 05:27:34PM +0200, Peter Zijlstra wrote:
> On Fri, Jun 20, 2014 at 09:46:08AM -0400, Konrad Rzeszutek Wilk wrote:
> > I dug in the code and I have some comments about it, but before
> > I post them I was wondering if you have any plans to run any performance
> > tests against the PV ticketlock with normal and over-committed scenarios?
> 
> I can barely boot a guest.. I'm not sure I can make them do anything
> much at all yet. All this virt crap is totally painful.

HA!

The reason I asked about that is from a pen-and-paper view it looks
suboptimal in the worst case scenario compared to PV ticketlock.

The 'worst case scenario' is when we over-commit (more CPUs than there
are physical CPUs) or have to delay guests (the sum of all virtual
CPUs > physical CPUs and all of the guests are compiling kernels).

In those cases the PV ticketlock goes to sleep and gets woken up
once the ticket holder has finished. In the PV qspinlock we do
wake up the first in queue, but we also wake the next one in queue
so it can progress further. And so on.

Perhaps a better mechanism is just ditch the queue part and utilize
the byte part and under KVM and Xen just do bytelocking (since we
have 8 bits). For the PV halt/waking we can stash in the 'struct mcs'
the current lock that each CPU is waiting for. And the unlocker
can iterate over all of those and wake them all up. Perhaps make
the iteration random. Anyhow, that is how the old PV bytelock under
Xen worked (before 3.11) and it had worked pretty well (it didn't
do it random thought - always started with 'for_each_online_cpu').

Squashing in the ticketlock concept in qspinlock for PV looks
scary.

And as I said - this is all pen-and-paper - so it might be that this
'wake-up-go-sleep-on-the-queue' kick is actually not that bad?

Lastly - thank you for taking a stab at this.
> 


