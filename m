Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbaFCNO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:14:57 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:33354 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbaFCNOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:14:54 -0400
X-Greylist: delayed 520 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jun 2014 09:14:54 EDT
Message-ID: <538DC844.2040808@msgid.tls.msk.ru>
Date: Tue, 03 Jun 2014 17:06:12 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Gleb Natapov <gleb@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: x86: kvm: x86.c:  Cleaning up uninitialized variables
References: <1401577506-4112-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <538DB9B4.2070607@redhat.com>
In-Reply-To: <538DB9B4.2070607@redhat.com>
X-Enigmail-Version: 1.6
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

03.06.2014 16:04, Paolo Bonzini wrote:
> Il 01/06/2014 01:05, Rickard Strandqvist ha scritto:
>> There is a risk that the variable will be used without being initialized.
>>
>> This was largely found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> 
> No, there isn't.  The full context looks like this:
> 
>         longmode = is_long_mode(vcpu) && cs_l == 1;
>         if (!longmode) {
>                 param = ((u64)kvm_register_read(vcpu, VCPU_REGS_RDX) << 32) |
>                         (kvm_register_read(vcpu, VCPU_REGS_RAX) & 0xffffffff);
>                 ingpa = ((u64)kvm_register_read(vcpu, VCPU_REGS_RBX) << 32) |
>                         (kvm_register_read(vcpu, VCPU_REGS_RCX) & 0xffffffff);
>                 outgpa = ((u64)kvm_register_read(vcpu, VCPU_REGS_RDI) << 32) |
>                         (kvm_register_read(vcpu, VCPU_REGS_RSI) & 0xffffffff);
>         }
> #ifdef CONFIG_X86_64
>         else {
>                 param = kvm_register_read(vcpu, VCPU_REGS_RCX);
>                 ingpa = kvm_register_read(vcpu, VCPU_REGS_RDX);
>                 outgpa = kvm_register_read(vcpu, VCPU_REGS_R8);
>         }
> #endif
> 
> and longmode must be zero if !CONFIG_X86_64:

This is not the first time this code is attempted to be changed.

Maybe adding an additional #ifdef..endif around the longmode
assignment and the "if" above will solve this for good?

Or maybe something like this:

 #ifdef CONFIG_X86_64
         if (!(is_long_mode(vcpu) && cs_l == 1)) {
 #else
         if (1) {
 #endif
                 param = ((u64)kvm_register_read(vcpu, VCPU_REGS_RDX) << 32) |
                         (kvm_register_read(vcpu, VCPU_REGS_RAX) & 0xffffffff);
                 ingpa = ((u64)kvm_register_read(vcpu, VCPU_REGS_RBX) << 32) |
                         (kvm_register_read(vcpu, VCPU_REGS_RCX) & 0xffffffff);
                 outgpa = ((u64)kvm_register_read(vcpu, VCPU_REGS_RDI) << 32) |
                         (kvm_register_read(vcpu, VCPU_REGS_RSI) & 0xffffffff);
         }
         else {
                 param = kvm_register_read(vcpu, VCPU_REGS_RCX);
                 ingpa = kvm_register_read(vcpu, VCPU_REGS_RDX);
                 outgpa = kvm_register_read(vcpu, VCPU_REGS_R8);
         }

, to make it all explicit and obvious?

Thanks,

/mjt

