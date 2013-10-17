Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244Ab3JQJmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 05:42:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583Ab3JQJmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 05:42:03 -0400
Date: Thu, 17 Oct 2013 12:41:46 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH, RFC] x86-64: properly handle FPU code/data selectors
Message-ID: <20131017094146.GP15657@redhat.com>
References: <525E9BFF02000078000FB74E@nat28.tlf.novell.com>
 <CA+55aFwCe=t4dDbDhHTWhzA3zMEyyS2WSYBP2Sfe0eogGEBS1w@mail.gmail.com>
 <525ECEA102000078000FB906@nat28.tlf.novell.com>
 <CA+55aFybvU39HVUF4sON=Euieqy+Kqsby-DUU=8Gnpggm2fzjw@mail.gmail.com>
 <525ED75402000078000FB95B@nat28.tlf.novell.com>
 <20131017092727.GN15657@redhat.com>
 <525FCB0D02000078000FBBCF@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525FCB0D02000078000FBBCF@nat28.tlf.novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 10:33:33AM +0100, Jan Beulich wrote:
> >>> On 17.10.13 at 11:27, Gleb Natapov <gleb@redhat.com> wrote:
> > On Wed, Oct 16, 2013 at 05:13:40PM +0100, Jan Beulich wrote:
> >> > It preserves *less* state, because the upper 32 bits of rip are now
> >> > corrupted. Any 64-bit application that actually looks at the FP
> >> > rip/rdp fields now get the WRONG VALUES.
> >> 
> >> But again - this isn't being done for ordinary 64-bit applications,
> >> this is only happening for KVM guests. And there not being a
> >> protocol for telling the caller whether a certain context hold
> >> 64-bit offsets or selector/offset pairs shouldn't be a reason to
> >> think of a solution to the problem.
> >> 
> > KVM knows what mode guest vcpu is in. is_long_mode(vcpu) will tell you
> > if it is in long mode or not. No need to guess it.
> 
> So what if that 64-bit guest OS is running a 32-bit app? You can
> only positively know the _current_ guest word size when the
> guest is not in long mode.
> 
KVM obviously knows the complete state of virtual CPU. It can figure the
situation above by looking at CS descriptor, not need to check
is_long_mode() at all. Here is how emulator does it:

        kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);

        ctxt->eflags = kvm_get_rflags(vcpu);
        ctxt->mode = (!is_protmode(vcpu))               ?  X86EMUL_MODE_REAL :
                     (ctxt->eflags & X86_EFLAGS_VM)     ?  X86EMUL_MODE_VM86 :
                     cs_l                               ?  X86EMUL_MODE_PROT64 :
                     cs_db                              ?  X86EMUL_MODE_PROT32 :
                                                           X86EMUL_MODE_PROT16;

--
			Gleb.
