Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaFRQB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:01:57 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:46163 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbaFRQB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:01:56 -0400
Message-ID: <53A1B7EE.7070800@gmail.com>
Date: Wed, 18 Jun 2014 19:01:50 +0300
From: Nadav Amit <nadav.amit@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 9/9] KVM: vmx: vmx instructions handling does not consider
 cs.l
References: <539F059F.8050501@redhat.com> <1403101166-23616-1-git-send-email-namit@cs.technion.ac.il> <1403101166-23616-10-git-send-email-namit@cs.technion.ac.il> <53A1B33A.3080509@redhat.com>
In-Reply-To: <53A1B33A.3080509@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/14, 6:41 PM, Paolo Bonzini wrote:
> Il 18/06/2014 16:19, Nadav Amit ha scritto:
>> VMX instructions use 32-bit operands in 32-bit mode, and 64-bit
>> operands in
>> 64-bit mode.  The current implementation is broken since it does not
>> use the
>> register operands correctly, and always uses 64-bit for reads and writes.
>> Moreover, write to memory in vmwrite only considers long-mode, so it
>> ignores
>> cs.l. This patch fixes this behavior.  The field of vmread/vmwrite is
>> kept
>> intentionally as 64-bit read since if bits [63:32] are not cleared the
>> instruction should fail, according to Intel SDM.
>
> This is not how I read the SDM:
>
> "These instructions fail if given, in 64-bit mode, an operand that sets
> an encoding bit beyond bit 32." (Section 24.11.1.2)
>
> "Outside IA-32e mode, the source operand has 32 bits, regardless of the
> value of CS.D. In 64-bit mode, the source operand has 64 bits; however,
> if bits 63:32 of the source operand are not zero, VMREAD will fail due
> to an attempt to access an unsupported VMCS component (see operation
> section)." (Description of VMREAD in Chapter 30).
>
> I'll fix up the patch myself.
>

Perhaps I am missing something, but I don't see where my mistake is.
The VMREAD source operand is always read as 64-bits and I made no 
changes there. Therefore, if bits 63:32 are not zero, the instruction 
should fail when attempting to access the field.

The value in the source operand of VMWRITE which represents the value 
which should be written is zero-extended outside 64-bit mode.
Quoting: "The effective size of the primary source operand, which may be 
a register or in memory, is always 32 bits outside IA-32e mode (the 
setting of CS.D is ignored with respect to operand size) and 64 bits in 
64-bit mode." (Description of VMWRITE in chapter 30).

Regards,
Nadav


