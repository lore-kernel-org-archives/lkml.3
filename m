Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbaFRSXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 14:23:35 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:62056 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaFRSXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 14:23:33 -0400
Message-ID: <53A1D921.2090305@gmail.com>
Date: Wed, 18 Jun 2014 21:23:29 +0300
From: Nadav Amit <nadav.amit@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Eric Northup <digitaleric@google.com>,
        Nadav Amit <namit@cs.technion.ac.il>
CC: Paolo Bonzini <pbonzini@redhat.com>, gleb@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, joro@8bytes.org
Subject: Re: [PATCH 3/3] KVM: x86: correct mwait and monitor emulation
References: <1403101176-23664-1-git-send-email-namit@cs.technion.ac.il>	<1403101176-23664-4-git-send-email-namit@cs.technion.ac.il> <CAG7+5M1T=OSqMLOJjb-txRCL_J_q=KSNV9yOfeP=98YuyD27Fw@mail.gmail.com>
In-Reply-To: <CAG7+5M1T=OSqMLOJjb-txRCL_J_q=KSNV9yOfeP=98YuyD27Fw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/14, 8:59 PM, Eric Northup wrote:
> On Wed, Jun 18, 2014 at 7:19 AM, Nadav Amit <namit@cs.technion.ac.il> wrote:
>> mwait and monitor are currently handled as nop. Considering this behavior, they
>> should still be handled correctly, i.e., check execution conditions and generate
>> exceptions when required. mwait and monitor may also be executed in real-mode
>> and are not handled in that case.  This patch performs the emulation of
>> monitor-mwait according to Intel SDM (other than checking whether interrupt can
>> be used as a break event).
>>
>> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
>> ---
>>   arch/x86/kvm/emulate.c | 41 +++++++++++++++++++++++++++++++++++++++--
>>   arch/x86/kvm/svm.c     | 22 ++--------------------
>>   arch/x86/kvm/vmx.c     | 27 +++++++++++----------------
>>   3 files changed, 52 insertions(+), 38 deletions(-)
>>
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index ef7a5a0..424b58d 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -3344,6 +3344,43 @@ static int em_bswap(struct x86_emulate_ctxt *ctxt)
>>          return X86EMUL_CONTINUE;
>>   }
>>
>> +static int em_monitor(struct x86_emulate_ctxt *ctxt)
>> +{
>> +       int rc;
>> +       struct segmented_address addr;
>> +       u64 rcx = reg_read(ctxt, VCPU_REGS_RCX);
>> +       u64 rax = reg_read(ctxt, VCPU_REGS_RAX);
>> +       u8 byte;
>
> I'd request:
>
> u32 ebx, ecx, edx, eax = 1;
> ctxt->opt->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx);
> if (!(ecx & FFL(MWAIT)))
>          return emulate_ud(ctxt);
>
> and also in em_mwait.
>

I had similar implementation on previous version, which also checked on 
mwait whether "interrupt as break event" matches ECX value. However, I 
was under the impression that it was decided that MWAIT will always be 
emulated as NOP to avoid misbehaving VMs that ignore CPUID (see the 
discussion at http://www.spinics.net/lists/kvm/msg102766.html ).

Nadav
