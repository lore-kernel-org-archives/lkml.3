Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbaD1KuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:50:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873AbaD1Kt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:49:59 -0400
Message-ID: <535E3249.2010000@redhat.com>
Date: Mon, 28 Apr 2014 12:49:45 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>,
        Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix CR3 and LDT sel should not be saved in
 TSS
References: <1396885067-6491-1-git-send-email-namit@cs.technion.ac.il> <20140416192041.GC8773@amt.cnet>
In-Reply-To: <20140416192041.GC8773@amt.cnet>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 16/04/2014 21:20, Marcelo Tosatti ha scritto:
> On Mon, Apr 07, 2014 at 06:37:47PM +0300, Nadav Amit wrote:
>> According to Intel specifications, only general purpose registers and segment
>> selectors should are saved in the old TSS during 32-bit task-switch.
>
> should be
>
>> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
>> ---
>>  arch/x86/kvm/emulate.c |   10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index 205b17e..0dec502 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -2496,7 +2496,7 @@ static int task_switch_16(struct x86_emulate_ctxt *ctxt,
>>  static void save_state_to_tss32(struct x86_emulate_ctxt *ctxt,
>>  				struct tss_segment_32 *tss)
>>  {
>> -	tss->cr3 = ctxt->ops->get_cr(ctxt, 3);
>> +	/* CR3 and ldt selector are not saved intentionally */
>>  	tss->eip = ctxt->_eip;
>>  	tss->eflags = ctxt->eflags;
>>  	tss->eax = reg_read(ctxt, VCPU_REGS_RAX);
>> @@ -2514,7 +2514,6 @@ static void save_state_to_tss32(struct x86_emulate_ctxt *ctxt,
>>  	tss->ds = get_segment_selector(ctxt, VCPU_SREG_DS);
>>  	tss->fs = get_segment_selector(ctxt, VCPU_SREG_FS);
>>  	tss->gs = get_segment_selector(ctxt, VCPU_SREG_GS);
>> -	tss->ldt_selector = get_segment_selector(ctxt, VCPU_SREG_LDTR);
>>  }
>>
>>  static int load_state_from_tss32(struct x86_emulate_ctxt *ctxt,
>
> Only this hunk is enough ?

I guess there could be a corner case where the beginning or tail of the 
TSS is in a read-only page but EIP...LDT is all writable.

Paolo

>> @@ -2604,6 +2603,8 @@ static int task_switch_32(struct x86_emulate_ctxt *ctxt,
>>  	struct tss_segment_32 tss_seg;
>>  	int ret;
>>  	u32 new_tss_base = get_desc_base(new_desc);
>> +	u32 eip_offset = offsetof(struct tss_segment_32, eip);
>> +	u32 ldt_sel_offset = offsetof(struct tss_segment_32, ldt_selector);
>>
>>  	ret = ops->read_std(ctxt, old_tss_base, &tss_seg, sizeof tss_seg,
>>  			    &ctxt->exception);
>> @@ -2613,8 +2614,9 @@ static int task_switch_32(struct x86_emulate_ctxt *ctxt,
>>
>>  	save_state_to_tss32(ctxt, &tss_seg);
>>
>> -	ret = ops->write_std(ctxt, old_tss_base, &tss_seg, sizeof tss_seg,
>> -			     &ctxt->exception);
>> +	/* Only GP registers and segment selectors are saved */
>> +	ret = ops->write_std(ctxt, old_tss_base + eip_offset, &tss_seg.eip,
>> +			     ldt_sel_offset - eip_offset, &ctxt->exception);
>>  	if (ret != X86EMUL_CONTINUE)
>>  		/* FIXME: need to provide precise fault address */
>>  		return ret;
>> --
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe kvm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

