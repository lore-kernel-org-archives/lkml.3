Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439AbaK2QUK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 11:20:10 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:55596 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaK2QUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 11:20:07 -0500
Date: Sat, 29 Nov 2014 17:20:45 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com,
        peter.maydell@linaro.org, agraf@suse.de, jan.kiszka@siemens.com,
        dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de,
        pbonzini@redhat.com, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] KVM: arm: guest debug, define API headers
Message-ID: <20141129162045.GC23653@cbox>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
 <1416931805-23223-3-git-send-email-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416931805-23223-3-git-send-email-alex.bennee@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 04:10:00PM +0000, Alex Bennée wrote:
> This commit defines the API headers for guest debugging. There are two
> architecture specific debug structures:
> 
>   - kvm_guest_debug_arch, allows us to pass in HW debug registers
>   - kvm_debug_exit_arch, signals the exact debug exit and address
> 
> The type of debugging being used is control by the architecture specific
s/control/controlled/ ?
> control bits of the kvm_guest_debug->control flags in the ioctl
> structure.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> 
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 8e38878..de2450c 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -93,10 +93,30 @@ struct kvm_sregs {
>  struct kvm_fpu {
>  };
>  
> +/* See ARM ARM D7.3: Debug Registers

/* needs to go on a separate line.

> + *
> + * The control registers are stored as 64bit values as the setup code
> + * is shared with the normal cpu context restore code in hyp.S which
> + * is 64 bit only.

is this comment here because the architecture defines them as 32-bits?
If so, adding that would make this comment make more sense.

> + */
> +#define KVM_ARM_NDBG_REGS 16
>  struct kvm_guest_debug_arch {
> +	__u64 dbg_bcr[KVM_ARM_NDBG_REGS];
> +	__u64 dbg_bvr[KVM_ARM_NDBG_REGS];
> +	__u64 dbg_wcr[KVM_ARM_NDBG_REGS];
> +	__u64 dbg_wvr[KVM_ARM_NDBG_REGS];
>  };
>  
> +/* Exit types which define why we did a debug exit */
> +#define KVM_DEBUG_EXIT_ERROR		0x0
> +#define KVM_DEBUG_EXIT_SINGLE_STEP	0x1
> +#define KVM_DEBUG_EXIT_SW_BKPT		0x2
> +#define KVM_DEBUG_EXIT_HW_BKPT		0x3
> +#define KVM_DEBUG_EXIT_HW_WTPT		0x4
> +
>  struct kvm_debug_exit_arch {
> +	__u64 address;
> +	__u32 exit_type;
>  };
>  
>  struct kvm_sync_regs {
> @@ -198,4 +218,12 @@ struct kvm_arch_memory_slot {
>  
>  #endif
>  
> +/* Architecture related debug defines - upper 16 bits of

same not with commenting style here

> + * kvm_guest_debug->control
> + */
> +#define KVM_GUESTDBG_USE_SW_BP_SHIFT	16
> +#define KVM_GUESTDBG_USE_SW_BP		(1 << KVM_GUESTDBG_USE_SW_BP_SHIFT)
> +#define KVM_GUESTDBG_USE_HW_BP_SHIFT	17
> +#define KVM_GUESTDBG_USE_HW_BP		(1 << KVM_GUESTDBG_USE_HW_BP_SHIFT)
> +
>  #endif /* __ARM_KVM_H__ */
> -- 
> 2.1.3
> 
