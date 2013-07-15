Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab3GOSxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:53:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43757 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688Ab3GOSxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:53:53 -0400
Message-ID: <51E443AD.3020907@zytor.com>
Date: Mon, 15 Jul 2013 11:47:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eli Friedman <eli.friedman@gmail.com>,
        Jim Grosbach <grosbach@apple.com>, Stephen Checkoway <s@pahtak.org>,
        LLVMdev <llvmdev@cs.uiuc.edu>
Subject: Re: [PATCH] x86/asm: avoid mnemonics without type suffix
References: <1373806562-30422-1-git-send-email-artagnon@gmail.com> <51E2FAB9.9050900@goop.org>
In-Reply-To: <51E2FAB9.9050900@goop.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2013 12:23 PM, Jeremy Fitzhardinge wrote:
> (resent without HTML)
> 
> On 07/14/2013 05:56 AM, Ramkumar Ramachandra wrote:
>> 1c54d77 (x86: partial unification of asm-x86/bitops.h, 2008-01-30)
>> changed a bunch of btrl/btsl instructions to btr/bts, with the following
>> justification:
>>
>>   The inline assembly for the bit operations has been changed to remove
>>   explicit sizing hints on the instructions, so the assembler will pick
>>   the appropriate instruction forms depending on the architecture and
>>   the context.
>>
>> Unfortunately, GNU as does no such thing, and the AT&T syntax manual
>> [1] contains no references to any such inference.  As evidenced by the
>> following experiment, gas always disambiguates btr/bts to btrl/btsl.
>> Feed the following input to gas:
>>
>>   btrl	$1, 0
>>   btr	$1, 0
>>   btsl	$1, 0
>>   bts	$1, 0
> 
> When I originally did those patches, I was careful make sure that we
> didn't give implied sizes to operations with only immediate and/or
> memory operands because - in general - gas can't infer the operation
> size from such operands. However, in the case of the bit test/set
> operations, the memory access size is not really derived from the
> operation size (the SDM is a bit vague), and even if it were it would be
> an operation rather than semantic difference.  So there's no real
> problem with gas choosing 'l' as a default size in the absence of any
> explicit override or constraint.
> 
>> Check that btr matches btrl, and bts matches btsl in both cases:
>>
>>   $ as --32 -a in.s
>>   $ as --64 -a in.s
>>
>> To avoid giving readers the illusion of such an inference, and for
>> clarity, change btr/bts back to btrl/btsl.  Also, llvm-mc refuses to
>> disambiguate btr/bts automatically.
> 
> That sounds reasonable for all other operations because it makes a real
> semantic difference, but overly strict for bit operations.
> 

To be fair, we *ought to* be able to do something like:

	asm volatile(LOCK_PREFIX "bts%z0 %1,%0"
 			: BITOP_ADDR(addr) : "Ir" (nr) : "memory");

... but some older version of gcc are broken and emit "ll" rather than
"q".  Furthermore, since that would actually result in *worse* code
emitted overall (unnecessary REX prefixes), I'm not exactly happy on the
idea.

	-hpa

