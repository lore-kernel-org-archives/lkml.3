Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbbATDkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:40:49 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:52049 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbbATDkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:40:47 -0500
Date: Mon, 19 Jan 2015 19:40:40 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: Behaviour of smp_mb__{before,after}_spin* and acquire/release
Message-ID: <20150120034040.GN9719@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20150113163353.GE31784@arm.com>
 <20150113184510.GA31525@redhat.com>
 <20150114113147.GG4050@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150114113147.GG4050@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012003-0013-0000-0000-0000080E7833
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 11:31:47AM +0000, Will Deacon wrote:
> Hi Oleg,
> 
> On Tue, Jan 13, 2015 at 06:45:10PM +0000, Oleg Nesterov wrote:
> > On 01/13, Will Deacon wrote:
> > >
> > >   1. Does smp_mb__before_spinlock actually have to order prior loads
> > >      against later loads and stores? Documentation/memory-barriers.txt
> > >      says it does, but that doesn't match the comment
> > 
> > The comment says that smp_mb__before_spinlock() + spin_lock() should
> > only serialize STOREs with LOADs. This is because it was added to ensure
> > that the setting of condition can't race with ->state check in ttwu().
> 
> Yup, that makes sense. The comment is consistent with the code, and I think
> the code is doing what it's supposed to do.
> 
> > But since we use wmb() it obviously serializes STOREs with STORES. I do
> > not know if this should be documented, but we already have another user
> > which seems to rely on this fact: set_tlb_flush_pending().
> 
> In which case, it's probably a good idea to document that too.
> 
> > As for "prior loads", this doesn't look true...
> 
> Agreed. I'd propose something like the diff below, but it also depends on
> my second question since none of this is true for smp_load_acquire.

OK, finally getting to this, apologies for the delay...

It does look like I was momentarily confusing the memory ordering implied
by lock acquisition with that by smp_lock_acquire().  Your patch looks good,
would you be willing to resend with commit log and Signed-off-by?

							Thanx, Paul

> Will
> 
> --->8
> 
> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
> index 70a09f8a0383..9c0e3c45a807 100644
> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -1724,10 +1724,9 @@ for each construct.  These operations all imply certain barriers:
> 
>       Memory operations issued before the ACQUIRE may be completed after
>       the ACQUIRE operation has completed.  An smp_mb__before_spinlock(),
> -     combined with a following ACQUIRE, orders prior loads against
> -     subsequent loads and stores and also orders prior stores against
> -     subsequent stores.  Note that this is weaker than smp_mb()!  The
> -     smp_mb__before_spinlock() primitive is free on many architectures.
> +     combined with a following ACQUIRE, orders prior stores against
> +     subsequent loads and stores. Note that this is weaker than smp_mb()!
> +     The smp_mb__before_spinlock() primitive is free on many architectures.
> 
>   (2) RELEASE operation implication:
> 
> 

