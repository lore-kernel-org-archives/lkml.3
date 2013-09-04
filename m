Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762780Ab3IDO0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:26:50 -0400
Received: from a194-110.smtp-out.amazonses.com ([199.255.194.110]:12189 "EHLO
	a194-110.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762589Ab3IDO0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:26:48 -0400
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Sep 2013 10:26:48 EDT
Date: Wed, 4 Sep 2013 14:17:09 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Will Deacon <will.deacon@arm.com>
cc: Tejun Heo <tj@kernel.org>,
        "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [gcv v3 27/35] arm: Replace __get_cpu_var uses
In-Reply-To: <20130904093335.GA8007@mudshark.cambridge.arm.com>
Message-ID: <00000140e9557be9-1523eeab-c0f6-45a0-881c-9336a8a6cf85-000000@email.amazonses.com>
References: <20130828193457.140443630@linux.com> <00000140c67834c9-cc2bec76-2d70-48d1-a35b-6e2d5dedf22b-000000@email.amazonses.com> <20130830100105.GF25628@mudshark.cambridge.arm.com> <00000140e4440576-ae4236ee-3073-4f94-b569-d17396e57513-000000@email.amazonses.com>
 <20130904093335.GA8007@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.110
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Sep 2013, Will Deacon wrote:

> > Did you apply the first patch of this series which is a bug fix?
>
> No, sorry, I didn't see that. Do you have a branch anywhere that I can play
> with?

It was merged in Linus tree yesterday.

> > I do not see any special code for ARM for this_cpu_inc_return. The
> > fallback solution in the core code is to disable interrupts for the
> > inc_return and arch/arm/include/asm/percpu.h includes
> > asm-generic/percpu.h.
> >
> > Where did you see it using a lock?
>
> God knows! You're completely right, and we simply disable interrupts which I
> somehow misread as taking a lock. However, is it guaranteed that mixing
> an atomic64_* access with a this_cpu_inc_return will retain atomicity
> between the two? E.g. if you get interrupted during an atomic64_xchg
> operation, the interrupt handler issues this_cpu_inc_return, then on return
> to the xchg operation it must reissue any reads that had been executed
> prior to the interrupt. This should work on ARM/ARM64 (returning from the
> interrupt will clear the exclusive monitor) but I don't know about other
> architectures.

You cannot get interrupted during an atomic64_xchg operation. atomic and
this_cpu operations are stricly serialzed since both should be behaving
like single instructions. __this_cpu ops relax that requirement in case
the arch code incurs significant overhead to make that happen. In cases
where we know that preemption/interrupt disable etc takes care of things
__this_cpu ops come into play.

