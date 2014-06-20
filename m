Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967100AbaFTNrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 09:47:21 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19149 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965330AbaFTNrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 09:47:19 -0400
Date: Fri, 20 Jun 2014 09:46:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, boris.ostrovsky@oracle.com,
        paulmck@linux.vnet.ibm.com, riel@redhat.com,
        torvalds@linux-foundation.org, raghavendra.kt@linux.vnet.ibm.com,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 10/11] qspinlock: Paravirt support
Message-ID: <20140620134608.GA11545@laptop.dumpdata.com>
References: <20140615124657.264658593@chello.nl>
 <20140615130154.213923590@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140615130154.213923590@chello.nl>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 02:47:07PM +0200, Peter Zijlstra wrote:
> Add minimal paravirt support.
> 
> The code aims for minimal impact on the native case.

Woot!
> 
> On the lock side we add one jump label (asm_goto) and 4 paravirt
> callee saved calls that default to NOPs. The only effects are the
> extra NOPs and some pointless MOVs to accomodate the calling
> convention. No register spills happen because of this (x86_64).
> 
> On the unlock side we have one paravirt callee saved call, which
> defaults to the actual unlock sequence: "movb $0, (%rdi)" and a NOP.
> 
> The actual paravirt code comes in 3 parts;
> 
>  - init_node; this initializes the extra data members required for PV
>    state. PV state data is kept 1 cacheline ahead of the regular data.
> 
>  - link_and_wait_node/kick_node; these are paired with the regular MCS
>    queueing and are placed resp. before/after the paired MCS ops.
> 
>  - wait_head/queue_unlock; the interesting part here is finding the
>    head node to kick.
> 
> Tracking the head is done in two parts, firstly the pv_wait_head will
> store its cpu number in whichever node is pointed to by the tail part
> of the lock word. Secondly, pv_link_and_wait_node() will propagate the
> existing head from the old to the new tail node.

I dug in the code and I have some comments about it, but before
I post them I was wondering if you have any plans to run any performance
tests against the PV ticketlock with normal and over-committed scenarios?

Looking at this with a pen and paper I see that compared to
PV ticketlock for the CPUs that are contending on the queue (so they
go to pv_wait_head_and_link, then progress to pv_wait_head), they
go sleep twice and get woken up twice. In PV ticketlock the
contending CPUs would only go to sleep once and woken up once it
was their turn.

That of course is the worst case scenario - where the CPU
that has the lock is taking forever to do its job and the
host is quite overcommitted.

Thanks!
