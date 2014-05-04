Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaEDWBq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 18:01:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:12577 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbaEDWBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 18:01:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,984,1389772800"; 
   d="scan'208";a="427470270"
Message-ID: <5366B8C8.3080700@intel.com>
Date: Sun, 04 May 2014 15:01:44 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC/HACK] x86: Fast return to kernel
References: <210a076ea197ae384705d2c02cfff12a951a62f8.1399057218.git.luto@amacapital.net>	<CA+55aFzfDgeFmzk18xJ+ZvCcm-qCsCtd4RrNxYi0CXdfNbZn_A@mail.gmail.com>	<CALCETrX8wCxRj9=F7_pM_SKdSxSYttMyLZKAWTy9HurAmtfC2w@mail.gmail.com>	<20140504184016.GA16438@gmail.com>	<53669C32.2010601@intel.com> <CA+55aFxA522TJ8ROr0AJMusvYitm2RntBfBNXAK1eych3TP=dw@mail.gmail.com>
In-Reply-To: <CA+55aFxA522TJ8ROr0AJMusvYitm2RntBfBNXAK1eych3TP=dw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2014 02:31 PM, Linus Torvalds wrote:
> On Sun, May 4, 2014 at 12:59 PM, H. Peter Anvin <h.peter.anvin@intel.com> wrote:
>>
>> Maybe let userspace sit in a tight loop doing RDTSC, and look for data
>> points too far apart to have been uninterrupted?
> 
> That won't work, since Andy's patch improves on the "interrupt
> happened in kernel space", not on the user-space interrupt case.
> 

I was thinking about your proposal, not Andy's.

> But some variation on that with a kernel module that does something like
> 
>  - take over one CPU and force tons of timer interrupts on that CPU
> using the local APIC
> 
>  - for (say) ten billion cycles, do something like this in that kernel module:
> 
>    #define TEN_BILLION (10000000000)
> 
>         unsigned long prev = 0, sum = 0, end = rdtsc() + TEN_BILLION;
>         for (;;) {
>                 unsigned long tsc = rdtsc();
>                 if (tsc > end)
>                         break;
>                 if (tsc < prev + 500) {
>                         sum += tsc - prev;
>                 }
>                 prev = tsc;
>         }
> 
> and see how big a fraction of the 10 billion cycles you capture in
> 'sum'.  The bigger the fraction, the less time the timer interrupts
> stole from your CPU.
> 
> That "500" is just a random cut-off. Any interrupt will take more than
> that many TSC cycles. So the above basically counts how much
> uninterrupted time that thread gets.

Yes, same idea, but in a kernel module.

	-hpa


