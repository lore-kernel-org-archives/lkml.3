Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934891Ab3IDOYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:24:12 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51973 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934867Ab3IDOYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:24:10 -0400
Date: Wed, 4 Sep 2013 15:23:24 +0100
From: Will Deacon <will.deacon@arm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>,
        "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [gcv v3 27/35] arm: Replace __get_cpu_var uses
Message-ID: <20130904142324.GD3643@mudshark.cambridge.arm.com>
References: <20130828193457.140443630@linux.com>
 <00000140c67834c9-cc2bec76-2d70-48d1-a35b-6e2d5dedf22b-000000@email.amazonses.com>
 <20130830100105.GF25628@mudshark.cambridge.arm.com>
 <00000140e4440576-ae4236ee-3073-4f94-b569-d17396e57513-000000@email.amazonses.com>
 <20130904093335.GA8007@mudshark.cambridge.arm.com>
 <00000140e9557be9-1523eeab-c0f6-45a0-881c-9336a8a6cf85-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140e9557be9-1523eeab-c0f6-45a0-881c-9336a8a6cf85-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 03:17:09PM +0100, Christoph Lameter wrote:
> On Wed, 4 Sep 2013, Will Deacon wrote:
> > God knows! You're completely right, and we simply disable interrupts which I
> > somehow misread as taking a lock. However, is it guaranteed that mixing
> > an atomic64_* access with a this_cpu_inc_return will retain atomicity
> > between the two? E.g. if you get interrupted during an atomic64_xchg
> > operation, the interrupt handler issues this_cpu_inc_return, then on return
> > to the xchg operation it must reissue any reads that had been executed
> > prior to the interrupt. This should work on ARM/ARM64 (returning from the
> > interrupt will clear the exclusive monitor) but I don't know about other
> > architectures.
> 
> You cannot get interrupted during an atomic64_xchg operation. atomic and
> this_cpu operations are stricly serialzed since both should be behaving
> like single instructions. __this_cpu ops relax that requirement in case
> the arch code incurs significant overhead to make that happen. In cases
> where we know that preemption/interrupt disable etc takes care of things
> __this_cpu ops come into play.

Hmm, why can't you get interrupted during atomic64_xchg? On ARM, we have the
following sequence:

  static inline u64 atomic64_xchg(atomic64_t *ptr, u64 new)
  {
  	u64 result;
  	unsigned long tmp;
  
  	smp_mb();
  
  	__asm__ __volatile__("@ atomic64_xchg\n"
  "1:	ldrexd	%0, %H0, [%3]\n"
  "	strexd	%1, %4, %H4, [%3]\n"
  "	teq	%1, #0\n"
  "	bne	1b"
  	: "=&r" (result), "=&r" (tmp), "+Qo" (ptr->counter)
  	: "r" (&ptr->counter), "r" (new)
  	: "cc");
  
  	smp_mb();
  
  	return result;
  }

which relies on interrupts clearing the exclusive monitor to force us back
around the loop in the inline asm. I could imagine other architectures doing
similar, but only detecting the other writer if it used the same
instructions.

Will
