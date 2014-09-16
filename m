Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbaIPUTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:19:20 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:34507 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbaIPUTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:19:16 -0400
Message-ID: <54189B3D.3040301@gmail.com>
Date: Tue, 16 Sep 2014 23:19:09 +0300
From: Nadav Amit <nadav.amit@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Nadav Amit <namit@cs.technion.ac.il>
CC: pbonzini@redhat.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 0/3] x86: structs for cpuid info in x86
References: <1410870160-28845-1-git-send-email-namit@cs.technion.ac.il> <20140916132226.GA13726@gmail.com>
In-Reply-To: <20140916132226.GA13726@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 9/16/14 4:22 PM, Ingo Molnar wrote:
> 
> * Nadav Amit <namit@cs.technion.ac.il> wrote:
> 
>> The code that deals with x86 cpuid fields is hard to follow since it performs
>> many bit operations and does not refer to cpuid field explicitly.  To
>> eliminate the need of openning a spec whenever dealing with cpuid fields, this
>> patch-set introduces structs that reflect the various cpuid functions.
>>
>> Thanks for reviewing the patch-set.
>>
>> Nadav Amit (3):
>>   x86: Adding structs to reflect cpuid fields
>>   x86: Use new cpuid structs in cpuid functions
>>   KVM: x86: Using cpuid structs in KVM
>>
>>  arch/x86/include/asm/cpuid_def.h | 163 +++++++++++++++++++++++++++++++++++++++
>>  arch/x86/kernel/cpu/common.c     |  56 ++++++++------
>>  arch/x86/kvm/cpuid.c             |  36 +++++----
>>  3 files changed, 219 insertions(+), 36 deletions(-)
>>  create mode 100644 arch/x86/include/asm/cpuid_def.h
> 
> I personally like bitfields in theory (they provide type clarity 
> and abstract robustness, compared to open-coded bitmask numeric 
> literals that are often used in cpuid using code, obfuscating 
> cpuid usage), with the big caveat that for many years I didn't 
> like bitfields in practice: older versions of GCC did a really 
> poor job of optimizing them.
> 
> So such a series would only be acceptable if it's demonstrated 
> that both 'latest' and 'reasonably old' GCC versions do a good 
> job in that department, compared to the old open-coded bitmask 
> ops ...
> 
> Comparing the 'size vmlinux' output of before/after kernels would 
> probably be a good start in seeing the impact of such a change.
> 
> If those results are positive then this technique could be 
> propagated to all cpuid using code in arch/x86/, of which
> there's plenty.

Thanks for the quick response. I was not aware GCC behaves this way. I
made some small experiments with GCC-4.8 and GCC-4.4 and in brief my
conclusions are:
1. The assembled code of bitmask and bitfields is indeed different.
2. GCC-4.8 and GCC-4.4 behave pretty much the same, yet GCC-4.8 appears
to make better instructions reordering.
3. Loading/storing a single bitfield seems to be pretty much optimized
(marginal advantage from code size point-of-view for bitmask, same
number of instructions).
4. Loading/storing multiple bitfields seems to be somewhat
under-optimized - multiple accesses to the original value result in ~30%
more instructions and code-size.

So you are correct - bitfields are less optimized. Nonetheless, since
cpuid data is mostly used during startup, and otherwise a single
bitfield is usually accessed in each function - I wonder whether it
worth keeping the optimized but "obfuscate" code. Obviously, I can guess
your answer to this question...

Nadav
