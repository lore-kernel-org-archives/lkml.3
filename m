Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab3GLT2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 15:28:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757423Ab3GLT2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 15:28:45 -0400
Date: Thu, 11 Jul 2013 19:15:39 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com,
        glommer@parallels.com, tglx@linutronix.de, jeremy@goop.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove sched notifier for cross-cpu migrations
Message-ID: <20130711221539.GA10973@amt.cnet>
References: <20130710103440.GO25631@dyad.programming.kicks-ass.net>
 <20130711012157.GA21489@amt.cnet>
 <20130711081025.GE5895@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130711081025.GE5895@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 11:10:25AM +0300, Gleb Natapov wrote:
> On Wed, Jul 10, 2013 at 10:21:57PM -0300, Marcelo Tosatti wrote:
> > 
> > Linux as a guest on KVM hypervisor, the only user of the pvclock      
> > vsyscall interface, does not require notification on task migration 
> > because:
> > 
> > 1. cpu ID number maps 1:1 to per-CPU pvclock time info.
> > 2. per-CPU pvclock time info is updated if the
> >    underlying CPU changes.
> > 3. that version is increased whenever underlying CPU 
> >    changes.
> > 
> Is this the case with KVM though? IIRC KVM does not updates kvmclock
> on vcpu migration if host has synchronized TSC.

KVM does not update kvmclock on vcpu->pcpu migration if the 
master clock scheme is used, which depends on synchronized TSC.
In that case, it is safe to migrate a thread/vcpu to another cpu without
updating kvmclock area (because all vcpus contain the same value as
system timestamp and different tsc_timestamps, but all (tsc_timestamps)
usable as deltas on any given pcpu.

So the 3 items are necessary in the general case of hypervisor
maintaining distinct kvmclock vcpu areas (copy&pasted the comment from
the code comment).

