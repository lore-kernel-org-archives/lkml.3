Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbaFCNLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:11:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433AbaFCNLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:11:40 -0400
Message-ID: <538DC978.5040300@redhat.com>
Date: Tue, 03 Jun 2014 15:11:20 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Gleb Natapov <gleb@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: x86: kvm: x86.c:  Cleaning up uninitialized variables
References: <1401577506-4112-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <538DB9B4.2070607@redhat.com> <538DC844.2040808@msgid.tls.msk.ru>
In-Reply-To: <538DC844.2040808@msgid.tls.msk.ru>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 03/06/2014 15:06, Michael Tokarev ha scritto:
> 03.06.2014 16:04, Paolo Bonzini wrote:
>> Il 01/06/2014 01:05, Rickard Strandqvist ha scritto:
>>> There is a risk that the variable will be used without being initialized.
>>>
>>> This was largely found by using a static code analysis program called cppcheck.
>>>
>>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>>
>> No, there isn't.  The full context looks like this:
>>
>>         longmode = is_long_mode(vcpu) && cs_l == 1;
>>         if (!longmode) {
>>                 param = ((u64)kvm_register_read(vcpu, VCPU_REGS_RDX) << 32) |
>>                         (kvm_register_read(vcpu, VCPU_REGS_RAX) & 0xffffffff);
>>                 ingpa = ((u64)kvm_register_read(vcpu, VCPU_REGS_RBX) << 32) |
>>                         (kvm_register_read(vcpu, VCPU_REGS_RCX) & 0xffffffff);
>>                 outgpa = ((u64)kvm_register_read(vcpu, VCPU_REGS_RDI) << 32) |
>>                         (kvm_register_read(vcpu, VCPU_REGS_RSI) & 0xffffffff);
>>         }
>> #ifdef CONFIG_X86_64
>>         else {
>>                 param = kvm_register_read(vcpu, VCPU_REGS_RCX);
>>                 ingpa = kvm_register_read(vcpu, VCPU_REGS_RDX);
>>                 outgpa = kvm_register_read(vcpu, VCPU_REGS_R8);
>>         }
>> #endif
>>
>> and longmode must be zero if !CONFIG_X86_64:
>
> This is not the first time this code is attempted to be changed.
>
> Maybe adding an additional #ifdef..endif around the longmode
> assignment and the "if" above will solve this for good?
>
> Or maybe something like this:
>
>  #ifdef CONFIG_X86_64
>          if (!(is_long_mode(vcpu) && cs_l == 1)) {
>  #else
>          if (1) {
>  #endif
>                  param = ((u64)kvm_register_read(vcpu, VCPU_REGS_RDX) << 32) |
>                          (kvm_register_read(vcpu, VCPU_REGS_RAX) & 0xffffffff);
>                  ingpa = ((u64)kvm_register_read(vcpu, VCPU_REGS_RBX) << 32) |
>                          (kvm_register_read(vcpu, VCPU_REGS_RCX) & 0xffffffff);
>                  outgpa = ((u64)kvm_register_read(vcpu, VCPU_REGS_RDI) << 32) |
>                          (kvm_register_read(vcpu, VCPU_REGS_RSI) & 0xffffffff);
>          }
>          else {
>                  param = kvm_register_read(vcpu, VCPU_REGS_RCX);
>                  ingpa = kvm_register_read(vcpu, VCPU_REGS_RDX);
>                  outgpa = kvm_register_read(vcpu, VCPU_REGS_R8);
>          }
>
> , to make it all explicit and obvious?

... and ugly too.

If the first person who got the answer had reported a bug against 
cppcheck, this perhaps would have been avoided.

Paolo

