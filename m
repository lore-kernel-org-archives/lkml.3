Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbaFCMEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:04:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbaFCMER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:04:17 -0400
Message-ID: <538DB9B4.2070607@redhat.com>
Date: Tue, 03 Jun 2014 14:04:04 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Gleb Natapov <gleb@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: x86: kvm: x86.c:  Cleaning up uninitialized variables
References: <1401577506-4112-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1401577506-4112-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 01/06/2014 01:05, Rickard Strandqvist ha scritto:
> There is a risk that the variable will be used without being initialized.
> 
> This was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

No, there isn't.  The full context looks like this:

        longmode = is_long_mode(vcpu) && cs_l == 1;
        if (!longmode) {
                param = ((u64)kvm_register_read(vcpu, VCPU_REGS_RDX) << 32) |
                        (kvm_register_read(vcpu, VCPU_REGS_RAX) & 0xffffffff);
                ingpa = ((u64)kvm_register_read(vcpu, VCPU_REGS_RBX) << 32) |
                        (kvm_register_read(vcpu, VCPU_REGS_RCX) & 0xffffffff);
                outgpa = ((u64)kvm_register_read(vcpu, VCPU_REGS_RDI) << 32) |
                        (kvm_register_read(vcpu, VCPU_REGS_RSI) & 0xffffffff);
        }
#ifdef CONFIG_X86_64
        else {
                param = kvm_register_read(vcpu, VCPU_REGS_RCX);
                ingpa = kvm_register_read(vcpu, VCPU_REGS_RDX);
                outgpa = kvm_register_read(vcpu, VCPU_REGS_R8);
        }
#endif

and longmode must be zero if !CONFIG_X86_64:

static inline int is_long_mode(struct kvm_vcpu *vcpu)
{
#ifdef CONFIG_X86_64
        return vcpu->arch.efer & EFER_LMA;
#else
        return 0;
#endif
}

So it's the static checker that cannot understand #ifdef well
enough and ought to be fixed.

Paolo
