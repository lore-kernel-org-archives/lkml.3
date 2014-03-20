Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759141AbaCTQbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 12:31:41 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:29460 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbaCTQbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 12:31:38 -0400
Message-ID: <1395333093.14694.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: Tasks stuck in futex code (in 3.14-rc6)
From: Davidlohr Bueso <davidlohr@hp.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
        tglx@linutronix.de, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org, paulus@samba.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Date: Thu, 20 Mar 2014 09:31:33 -0700
In-Reply-To: <1395295019.2612.11.camel@buesod1.americas.hpqcorp.net>
References: <20140319152619.GB10406@linux.vnet.ibm.com>
	 <20140319154705.GB8557@laptop.programming.kicks-ass.net>
	 <20140319170829.GD8557@laptop.programming.kicks-ass.net>
	 <20140320053350.GB30295@linux.vnet.ibm.com>
	 <1395295019.2612.11.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-19 at 22:56 -0700, Davidlohr Bueso wrote:
> On Thu, 2014-03-20 at 11:03 +0530, Srikar Dronamraju wrote:
> > > > Joy,.. let me look at that with ppc in mind.
> > > 
> > > OK; so while pretty much all the comments from that patch are utter
> > > nonsense (what was I thinking), I cannot actually find a real bug.
> > > 
> > > But could you try the below which replaces a control dependency with a
> > > full barrier. The control flow is plenty convoluted that I think the
> > > control barrier isn't actually valid anymore and that might indeed
> > > explain the fail.
> > > 
> > 
> > Unfortunately the patch didnt help. Still seeing tasks stuck
> > 
> > # ps -Ao pid,tt,user,fname,tmout,f,wchan | grep futex
> > 14680 pts/0    root     java         - 0 futex_wait_queue_me
> > 14797 pts/0    root     java         - 0 futex_wait_queue_me
> > # :> /var/log/messages
> > # echo t > /proc/sysrq-trigger 
> > # grep futex_wait_queue_me /var/log/messages | wc -l 
> > 334
> > #
> > 
> > [ 6904.211478] Call Trace:
> > [ 6904.211481] [c000000fa1f1b4d0] [0000000000000020] 0x20 (unreliable)
> > [ 6904.211486] [c000000fa1f1b6a0] [c000000000015208] .__switch_to+0x1e8/0x330
> > [ 6904.211491] [c000000fa1f1b750] [c000000000702f00] .__schedule+0x360/0x8b0
> > [ 6904.211495] [c000000fa1f1b9d0] [c000000000147348] .futex_wait_queue_me+0xf8/0x1a0
> > [ 6904.211500] [c000000fa1f1ba60] [c0000000001486dc] .futex_wait+0x17c/0x2a0
> > [ 6904.211505] [c000000fa1f1bc10] [c00000000014a614] .do_futex+0x254/0xd80
> > [ 6904.211510] [c000000fa1f1bd60] [c00000000014b25c] .SyS_futex+0x11c/0x1d0
> > [ 6904.238874] [c000000fa1f1be30] [c00000000000a0fc] syscall_exit+0x0/0x7c
> > [ 6904.238879] java            S 00003fff825f6044     0 14682  14076 0x00000080
> > 
> > Is there any other information that I provide that can help?
> 
> This problem suggests that we missed a wakeup for a task that was adding
> itself to the queue in a wait path. And the only place that can happen
> is with the hb spinlock check for any pending waiters. Just in case we
> missed some assumption about checking the hash bucket spinlock as a way
> of detecting any waiters (powerpc?), could you revert this commit and
> try the original atomic operations variant:
> 
> https://lkml.org/lkml/2013/12/19/630

hmmm looking at ppc spinlock code, it seems that it doesn't have ticket
spinlocks -- in fact Torsten Duwe has been trying to get them upstream
very recently. Since we rely on the counter for detecting waiters, this
might explain the issue. Could someone confirm this spinlock
implementation difference? 

