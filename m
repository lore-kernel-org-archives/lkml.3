Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbaDWUMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 16:12:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400AbaDWUM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 16:12:28 -0400
Date: Wed, 23 Apr 2014 17:11:03 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Gleb Natapov <gleb@kernel.org>, Nadav Amit <namit@cs.technion.ac.il>,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] KVM: x86: RSI/RDI/RCX are zero-extended when
 affected by string ops
Message-ID: <20140423201103.GA1167@amt.cnet>
References: <1397777591-6147-1-git-send-email-namit@cs.technion.ac.il>
 <1397794294-8414-1-git-send-email-namit@cs.technion.ac.il>
 <20140420092646.GB30377@minantech.com>
 <5356067D.40003@gmail.com>
 <20140423195832.GA32528@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140423195832.GA32528@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 04:58:32PM -0300, Marcelo Tosatti wrote:
> On Tue, Apr 22, 2014 at 09:04:45AM +0300, Nadav Amit wrote:
> > Gleb,
> > 
> > On 4/20/14, 12:26 PM, Gleb Natapov wrote:
> > >On Fri, Apr 18, 2014 at 07:11:33AM +0300, Nadav Amit wrote:
> > >>When using address-size override prefix with string instructions in long-mode,
> > >>ESI/EDI/ECX are zero extended if they are affected by the instruction
> > >>(incremented/decremented).  Currently, the KVM emulator does not do so.
> > >>
> > >>In addition, although it is not well-documented, when address override prefix
> > >>is used with REP-string instruction, RCX high half is zeroed even if ECX was
> > >>zero on the first iteration. Therefore, the emulator should clear the upper
> > >>part of RCX in this case, as x86 CPUs do.
> > >>
> > >>Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> > >>---
> > >>:100644 100644 69e2636... a69ed67... M	arch/x86/kvm/emulate.c
> > >>  arch/x86/kvm/emulate.c |    4 ++++
> > >>  1 file changed, 4 insertions(+)
> > >>
> > >>diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> > >>index 69e2636..a69ed67 100644
> > >>--- a/arch/x86/kvm/emulate.c
> > >>+++ b/arch/x86/kvm/emulate.c
> > >>@@ -491,6 +491,8 @@ register_address_increment(struct x86_emulate_ctxt *ctxt, unsigned long *reg, in
> > >>  	else
> > >>  		mask = ad_mask(ctxt);
> > >>  	masked_increment(reg, mask, inc);
> > >>+	if (ctxt->ad_bytes == 4)
> > >>+		*reg &= 0xffffffff;
> > >*reg=(u32)*reg; and you can do it inside else part.
> > >
> > >register_address_increment() is used also by jmp_rel and loop instructions,
> > >is this correct for both of those too? Probably yes.
> > >
> > It appears to be so.
> > Results of 32-bit operations are implicitly zero extended to 64-bit
> > values, and this appears to apply to all 32 bit operations,
> > including implicit ones. Therefore it seems to apply to all these
> > operations.
> > 
> > >>  }
> > >>
> > >>  static void rsp_increment(struct x86_emulate_ctxt *ctxt, int inc)
> > >>@@ -4567,6 +4569,8 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
> > >>  	if (ctxt->rep_prefix && (ctxt->d & String)) {
> > >>  		/* All REP prefixes have the same first termination condition */
> > >>  		if (address_mask(ctxt, reg_read(ctxt, VCPU_REGS_RCX)) == 0) {
> > >>+			if (ctxt->ad_bytes == 4)
> > >>+				*reg_write(ctxt, VCPU_REGS_RCX) = 0;
> > >Does zero extension happens even if ECX was zero at the beginning on an instruction or only during
> > >ECX modification. If later it is already covered in register_address_increment, no?
> > The observed behaviour of the Sandy-Bridge I use, is that even if
> > ECX is zero on the first iteration, the high half of RCX is zeroed.
> > Therefore, this is a different case, which was not covered in
> > register_address_increment. I agree it is totally undocumented.
> > Following your previous comment - I may have missed the case in
> > which loop instruction is executed with ECX = 0 while RCX != 0 and
> > the address size is 32 bit. I will test this case soon (yet, it is
> > lower on my priority list).
> 
> In 64-bit mode, the operand size for all near branches (CALL, RET, JCC,
> JCXZ, JMP, and LOOP) is forced to 64 bits.
> 
> These instructions update the 64-bit RIP without the need for a REX
> operand-size prefix.
> 
> The following aspects of near branches are controlled by the effective
> operand size:
> • Truncation of the size of the instruction pointer
> ...
> 
> In 64-bit mode, all of the above actions are forced to 64 bits
> regardless of operand size prefixes (operand size
> prefixes are silently ignored). However, the displacement field for
> relative branches is still limited to 32 bits and the
> address size for near branches is not forced in 64-bit mode.
> Address sizes affect the size of RCX used for JCXZ and LOOP; they also
> impact the address calculation for memory
> indirect branches. Such addresses are 64 bits by default; but they can
> be overridden to 32 bits by an address size
> prefix.
> 
> So it seems your patch incorrectly handles "rex call" for example.

Err, operand size is forced to 64-bits, not address size.

"The following aspects of near branches are controlled by the effective
operand size:
 • Truncation of the size of the instruction pointer"
 
Still, "67h call" should not truncate EIP (which your patch does).

