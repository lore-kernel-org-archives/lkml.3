Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbaLCOXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:23:18 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:42429 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbaLCOXQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:23:16 -0500
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [CFT PATCH v2 2/2] KVM: x86: support XSAVES usage in the host
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <1416847414-22253-3-git-send-email-pbonzini@redhat.com>
Date: Wed, 3 Dec 2014 16:23:13 +0200
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Nadav Amit <namit@cs.technion.ac.il>, hpa@linux.intel.com,
        Fenghua Yu <fenghua.yu@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <802AF3F4-2631-4979-A8CC-46B406546062@gmail.com>
References: <1416847414-22253-1-git-send-email-pbonzini@redhat.com> <1416847414-22253-3-git-send-email-pbonzini@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> wrote:

> Userspace is expecting non-compacted format for KVM_GET_XSAVE, but
> struct xsave_struct might be using the compacted format.  Convert
> in order to preserve userspace ABI.
> 
> Likewise, userspace is passing non-compacted format for KVM_SET_XSAVE
> but the kernel will pass it to XRSTORS, and we need to convert back.
> 
> Fixes: f31a9f7c71691569359fa7fb8b0acaa44bce0324
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Nadav Amit <namit@cs.technion.ac.il>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> arch/x86/kvm/x86.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++-----
> 1 file changed, 80 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 08b5657e57ed..373b0ab9a32e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3132,15 +3132,89 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
> 	return 0;
> }
> 
> +#define XSTATE_COMPACTION_ENABLED (1ULL << 63)
> +
> +static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
> +{
> +	struct xsave_struct *xsave = &vcpu->arch.guest_fpu.state->xsave;
> +	u64 xstate_bv = vcpu->arch.guest_supported_xcr0 | XSTATE_FPSSE;
> +	u64 valid;
> +
> +	/*
> +	 * Copy legacy XSAVE area, to avoid complications with CPUID
> +	 * leaves 0 and 1 in the loop below.
> +	 */
> +	memcpy(dest, xsave, XSAVE_HDR_OFFSET);
> +
> +	/* Set XSTATE_BV */
> +	*(u64 *)(dest + XSAVE_HDR_OFFSET) = xstate_bv;

I have a problem with this line. I ran some experiments and it has a
side-effect of causing XINUSE (an internal register which saves which state
components are not in the initial state) to be all set. As a results,
after load_xsave runs, when the guest runs xsave instruction, initialised
xsave state components are marked as not-initialised in the guest’s
xstate_bv.

This causes both transparency issues (the VM does not behave as bare-metal
machine). In addition it may cause performance overheads, since from this
point on, xsave and xrstor instructions would save and load state which is
in fact in the initial state.

I think it is better just to replace the last line with:

*(u64 *)(dest + XSAVE_HDR_OFFSET) = xsave->xsave_hdr.xstate_bv

Thanks,
Nadav

