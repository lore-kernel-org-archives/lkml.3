Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbaIDPFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:05:08 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:33866 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaIDPFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:05:06 -0400
Date: Thu, 4 Sep 2014 18:05:00 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@cloudius-systems.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jroedel@suse.de, agraf@suse.de,
        valentine.sinitsyn@gmail.com, jan.kiszka@siemens.com,
        avi@cloudius-systems.com
Subject: Re: [PATCH 3/4] KVM: x86: inject nested page faults on emulated
 instructions
Message-ID: <20140904150500.GA25317@minantech.com>
References: <1409670830-14544-1-git-send-email-pbonzini@redhat.com>
 <1409670830-14544-4-git-send-email-pbonzini@redhat.com>
 <20140904070220.GL9842@cloudius-systems.com>
 <54087343.5050409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54087343.5050409@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 04:12:19PM +0200, Paolo Bonzini wrote:
> Il 04/09/2014 09:02, Gleb Natapov ha scritto:
> > On Tue, Sep 02, 2014 at 05:13:49PM +0200, Paolo Bonzini wrote:
> >> > This is required for the following patch to work correctly.  If a nested page
> >> > fault happens during emulation, we must inject a vmexit, not a page fault.
> >> > Luckily we already have the required machinery: it is enough to return
> >> > X86EMUL_INTERCEPTED instead of X86EMUL_PROPAGATE_FAULT.
> >> > 
> > I wonder why this patch is needed. X86EMUL_PROPAGATE_FAULT causes
> > ctxt->have_exception to be set to true in x86_emulate_insn().
> > x86_emulate_instruction() checks ctxt->have_exception and calls
> > inject_emulated_exception() if it is true. inject_emulated_exception()
> > calls kvm_propagate_fault() where we check if the fault was nested and
> > generate vmexit or a page fault accordingly.
> 
> Good question. :)
> 
> If you do that, KVM gets down to the "if (writeback)" and writes the 
> ctxt->eip from L2 into the L1 EIP.
Heh, that's a bummer. We should not write back if an instruction caused a vmexit.

> 
> Possibly this patch can be replaced by just this?
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 022513b..475e979 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5312,7 +5312,7 @@ restart:
>  
>         if (ctxt->have_exception) {
>                 inject_emulated_exception(vcpu);
> -               r = EMULATE_DONE;
> +               return EMULATE_DONE;
If there was no vmexit we still want to writeback. Perhaps:
    writeback = inject_emulated_exception(vcpu);
and return false if there was vmexit due to nested page fault (or any fault,
can't L1 ask for #GP/#UD intercept that need to be handled here too?)

>         } else if (vcpu->arch.pio.count) {
>                 if (!vcpu->arch.pio.in) {
>                         /* FIXME: return into emulator if single-stepping.  */
> 
> But I'm not sure how to test it, and I like the idea of treating nested page
> faults like other nested vmexits during emulation (which is what this patch
> does).
IMO exits due to instruction intercept and exits due to other interceptable events
that may happen during instruction emulation are sufficiently different to be handled
slightly different. If my assumption about #GP above are correct with current approach it
can be easily handled inside inject_emulated_exception().

--
			Gleb.
