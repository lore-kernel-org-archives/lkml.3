Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbaFSLfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 07:35:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757948AbaFSLfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 07:35:04 -0400
Message-ID: <53A2CAD4.5070208@redhat.com>
Date: Thu, 19 Jun 2014 13:34:44 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Eric Northup <digitaleric@google.com>,
        Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>, joro@8bytes.org
Subject: Re: [PATCH 3/3] KVM: x86: correct mwait and monitor emulation
References: <1403101176-23664-1-git-send-email-namit@cs.technion.ac.il>	<1403101176-23664-4-git-send-email-namit@cs.technion.ac.il> <CAG7+5M1T=OSqMLOJjb-txRCL_J_q=KSNV9yOfeP=98YuyD27Fw@mail.gmail.com>
In-Reply-To: <CAG7+5M1T=OSqMLOJjb-txRCL_J_q=KSNV9yOfeP=98YuyD27Fw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/06/2014 19:59, Eric Northup ha scritto:
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
>>  arch/x86/kvm/emulate.c | 41 +++++++++++++++++++++++++++++++++++++++--
>>  arch/x86/kvm/svm.c     | 22 ++--------------------
>>  arch/x86/kvm/vmx.c     | 27 +++++++++++----------------
>>  3 files changed, 52 insertions(+), 38 deletions(-)
>>
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index ef7a5a0..424b58d 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -3344,6 +3344,43 @@ static int em_bswap(struct x86_emulate_ctxt *ctxt)
>>         return X86EMUL_CONTINUE;
>>  }
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
>         return emulate_ud(ctxt);
>
> and also in em_mwait.

Ignoring the fact that this should never be true 
(KVM_GET_SUPPORTED_CPUID never reports the MWAIT bit), why should 
MONITOR and MWAIT be special?  We do not do this kind of check for SSE 
or AVX instructions.

An alternative is to record the address that was being waited on, and 
invoke PLE (kvm_vcpu_on_spin) if the current address matches the last 
one.  A VMEXIT + emulation takes a couple thousand cycles, which is the 
same order of magnitude as the PLE window.

Even if there is a workaround, I don't think reverting the patch is 
necessary.  The patch was there for a fringe case anyway (recent 
versions of Mac OS X get CPUID right), so I don't think the availability 
of a work around changes the assessment of how ugly/useful MONITOR/MWAIT is.

Paolo
