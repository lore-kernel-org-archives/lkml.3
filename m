Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab3KYJnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:43:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35160 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab3KYJnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:43:02 -0500
Date: Mon, 25 Nov 2013 10:42:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [RFC] Control dependencies
Message-ID: <20131125094223.GV10022@twins.programming.kicks-ass.net>
References: <20131121161733.GH10022@twins.programming.kicks-ass.net>
 <20131121180237.GX4138@linux.vnet.ibm.com>
 <20131122134630.GQ3866@twins.programming.kicks-ass.net>
 <528F9B8D.2090806@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528F9B8D.2090806@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 12:59:41PM -0500, Peter Hurley wrote:
> On 11/22/2013 08:46 AM, Peter Zijlstra wrote:
> >How about the below version?
> >
> >---
> >--- a/kernel/events/ring_buffer.c
> >+++ b/kernel/events/ring_buffer.c
> >@@ -61,19 +61,20 @@ static void perf_output_put_handle(struc
> >  	 *
> >  	 *   kernel				user
> >  	 *
> >-	 *   READ ->data_tail			READ ->data_head
> >-	 *   smp_mb()	(A)			smp_rmb()	(C)
> >-	 *   WRITE $data			READ $data
> >-	 *   smp_wmb()	(B)			smp_mb()	(D)
> >-	 *   STORE ->data_head			WRITE ->data_tail
> >+	 *   if (LOAD ->data_tail) {		LOAD ->data_head
> >+	 *			(A)		smp_rmb()	(C)
> >+	 *	STORE $data			LOAD $data
> >+	 *	smp_wmb()	(B)		smp_mb()	(D)
> >+	 *	STORE ->data_head		STORE ->data_tail
> 
> 
> I wasn't subscribed to linux-arch so missed the smp_store_release()
> outcome, if there was one.
> 
> Are (B) and (D) still slated for changing to STORE.rel semantics,
> aka smp_store_release()?

The earlier proposal would have A and C be smp_load_acquire() and B and
D be smp_store_release().

> I realize that, for the perf ring buffer, (D) is in userspace but
> I'm also interested in non-perf situations where (D) would be in the
> kernel.

So we're still debating the exact semantics of smp_store_release(), it
now looks like it needs a heavier memory barrier than previously
thought. In which case using it wouldn't make sense for me anymore.

Note that C and D are in userspace and not in any hot path (usually)
They're only issued once to read an entire buffer backlog at once, so I
don't really care about them all that much.

A and B otoh are in kernel space and are issued for every single event
written, so I'm interested to get them as cheaply as possible.

With this proposed patch, we remove a full barrier, with the earlier
smp_load_acquire() / smp_store_release() patches we would only
downgrade the full barrier to an acquire barrier, which is still more
than no barrier at all.

And now it looks like the smp_store_release() would actually upgrade the
wmb to a full barrier on some systems at least.



