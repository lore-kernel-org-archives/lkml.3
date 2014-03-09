Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaCISuU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 14:50:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57968 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbaCISuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 14:50:18 -0400
Date: Sun, 9 Mar 2014 19:50:11 +0100
From: Borislav Petkov <bp@alien8.de>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Dave Jones <davej@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [qemu64,+smep,+smap] WARNING: CPU: 1 PID: 0 at
 arch/x86/kernel/cpu/amd.c:220 init_amd()
Message-ID: <20140309185011.GC5745@pd.tnic>
References: <20140307015833.GA10048@localhost>
 <53195336.9080606@linux.intel.com>
 <20140307055035.GA5230@localhost>
 <531A164B.8040402@linux.intel.com>
 <20140307191050.GA10961@redhat.com>
 <531A33A2.5030706@linux.intel.com>
 <20140307213856.GF5255@pd.tnic>
 <531CADC6.6020606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <531CADC6.6020606@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 09, 2014 at 07:07:02PM +0100, Paolo Bonzini wrote:
> tl;dr: do not use qemu64, especially in system emulation mode.  In
> user mode it should work, user mode programs are less susceptible to
> bogus family/member/stepping.  When using dynamic translation in
> system emulation mode, use Haswell,+smap or Opteron_G3,+smep,+smap.
> When using KVM, use whatever CPU model you're running on (or a least
> common denominator if doing migration).
> 
> qemu64's family/member/stepping makes no sense at all.  It is a
> really odd combination that means "enable all features that the QEMU
> dynamic translator supported at some time where people cared about
> -cpu qemu64".  So it has SVM and at the same time it misses
> SMEP/SMAP.  It also lacks some instruction set extensions such as
> BMI and ADX that QEMU does implement (I don't know if the kernel has
> any hand-optimized assembly that uses them).

Nope, not yet. It would definitely be worth to check to see whether they
bring anything performance-wise and if so, alternative-lize them in :-)

> *** If the above already worsened your opinion of virt people, skip
> *** the next three paragraphs.  I don't want to give you a bad day.

qemu+kvm can never worsen my opinion - it is my favourite virt solution!
:-)

> On KVM we always make the vendor the same as the host because of the
> sysenter/syscall mess in 32-bit mode (AMD supports one and Intel
> supports the other).

Oh yeah, there was that.

> But even if you're using Intel the family/member/stepping remains AMD!

Right.

> We really should give a loud warning if qemu64 is used with KVM.  It
> makes no sense with KVM, even less than it does with dynamic
> translation.

Right, yes, so Fengguang did switch to the Haswell model now so the
issue at hand is addressed.

> On TCG it does make some sense that vendor is AMD, because QEMU can
> emulate SVM.  So perhaps we could change the family/member/stepping
> to e.g. an Opteron G3 (the last AMD chip without xsave/xrstor),

I'm looking at target-i386/cpu.c and Opteron_G3 is family 15 decimal.
However, the last AMD Opteron which *didn't* have XSAVE (CPUID
Fn0000_0001_ECX[26]) is family 0x10 AFAIR, i.e. 16 decimal. I dunno
though, whether correcting that would cause other grief. It might be
worth a try to start cleaning up that mess though. :-P

> but then with KVM you would have family=15 on Intel and I don't want
> to go there. Perhaps we could give a loud warning with qemu64+KVM, and
> then do the above.

Yeah, if this warning saves people some time when having to look into
it, it might be worth it.

> You're not adding the bit to TCG_EXT2_FEATURES, so it's masked out.

Ah, there was that too.

But filter_features_for_kvm() clears it too because that bit is reserved
in CPUID on newer AMD and Intel hosts.

> The patch has also some backwards-compatibility gunk missing, and
> we're in hard-freeze now, but if you remind me at the end of April
> (I'm on vacation until April 23) I'll try to fix all this mess for
> QEMU 2.1.

That's some serious vacation - kinda like month and a half. :-)

But I'll probably forget so put it on your TODO list :-) I'm willing to
help out reviewing, should the need arise.

> Well, it's "64" for a reason.  LM in qemu64 is perhaps the only
> thing that makes sense.  :)

Hahaa.

Thanks for the info!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
