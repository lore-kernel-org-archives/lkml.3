Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaIQMhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 08:37:19 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:55198 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbaIQMhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 08:37:16 -0400
Date: Wed, 17 Sep 2014 14:37:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Nadav Amit <namit@cs.technion.ac.il>, pbonzini@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 0/3] x86: structs for cpuid info in x86
Message-ID: <20140917123710.GF2704@gmail.com>
References: <1410870160-28845-1-git-send-email-namit@cs.technion.ac.il>
 <20140916132226.GA13726@gmail.com>
 <54189B3D.3040301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54189B3D.3040301@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nadav Amit <nadav.amit@gmail.com> wrote:

> 
> 
> On 9/16/14 4:22 PM, Ingo Molnar wrote:
> > 
> > * Nadav Amit <namit@cs.technion.ac.il> wrote:
> > 
> >> The code that deals with x86 cpuid fields is hard to follow since it performs
> >> many bit operations and does not refer to cpuid field explicitly.  To
> >> eliminate the need of openning a spec whenever dealing with cpuid fields, this
> >> patch-set introduces structs that reflect the various cpuid functions.
> >>
> >> Thanks for reviewing the patch-set.
> >>
> >> Nadav Amit (3):
> >>   x86: Adding structs to reflect cpuid fields
> >>   x86: Use new cpuid structs in cpuid functions
> >>   KVM: x86: Using cpuid structs in KVM
> >>
> >>  arch/x86/include/asm/cpuid_def.h | 163 +++++++++++++++++++++++++++++++++++++++
> >>  arch/x86/kernel/cpu/common.c     |  56 ++++++++------
> >>  arch/x86/kvm/cpuid.c             |  36 +++++----
> >>  3 files changed, 219 insertions(+), 36 deletions(-)
> >>  create mode 100644 arch/x86/include/asm/cpuid_def.h
> > 
> > I personally like bitfields in theory (they provide type clarity 
> > and abstract robustness, compared to open-coded bitmask numeric 
> > literals that are often used in cpuid using code, obfuscating 
> > cpuid usage), with the big caveat that for many years I didn't 
> > like bitfields in practice: older versions of GCC did a really 
> > poor job of optimizing them.
> > 
> > So such a series would only be acceptable if it's demonstrated 
> > that both 'latest' and 'reasonably old' GCC versions do a good 
> > job in that department, compared to the old open-coded bitmask 
> > ops ...
> > 
> > Comparing the 'size vmlinux' output of before/after kernels would 
> > probably be a good start in seeing the impact of such a change.
> > 
> > If those results are positive then this technique could be 
> > propagated to all cpuid using code in arch/x86/, of which
> > there's plenty.
> 
> Thanks for the quick response. I was not aware GCC behaves this 
> way. I made some small experiments with GCC-4.8 and GCC-4.4 and 
> in brief my conclusions are:
>
> 1. The assembled code of bitmask and bitfields is indeed different.
> 2. GCC-4.8 and GCC-4.4 behave pretty much the same, yet GCC-4.8 appears
> to make better instructions reordering.
> 3. Loading/storing a single bitfield seems to be pretty much optimized
> (marginal advantage from code size point-of-view for bitmask, same
> number of instructions).
> 4. Loading/storing multiple bitfields seems to be somewhat
> under-optimized - multiple accesses to the original value result in ~30%
> more instructions and code-size.

That's better than what I remembered.

> So you are correct - bitfields are less optimized. Nonetheless, 
> since cpuid data is mostly used during startup, and otherwise a 
> single bitfield is usually accessed in each function - I wonder 
> whether it worth keeping the optimized but "obfuscate" code. 
> Obviously, I can guess your answer to this question...

So with the condition that you are actively watching out for 
performance critical code paths, I think the type clarity (i.e. 
bitfields) is a win.

If hpa, tglx or Linus objects I'll yield to that objection 
though.

Opinions, objections?

Thanks,

	Ingo
