Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbaK3KZM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 05:25:12 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:63001 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbaK3KZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 05:25:07 -0500
Date: Sun, 30 Nov 2014 11:25:46 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com,
        peter.maydell@linaro.org, agraf@suse.de, jan.kiszka@siemens.com,
        dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de,
        pbonzini@redhat.com, Gleb Natapov <gleb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] KVM: arm64: re-factor hyp.S debug register code
Message-ID: <20141130102546.GI23653@cbox>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
 <1416931805-23223-7-git-send-email-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416931805-23223-7-git-send-email-alex.bennee@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 04:10:04PM +0000, Alex Bennée wrote:
> This is a pre-cursor to sharing the code with the guest debug support.
> This replaces the big macro that fishes data out of a fixed location
> with a more general helper macro to restore a set of debug registers. It
> uses macro substitution so it can be re-used for debug control and value
> registers. It does however rely on the debug registers being 64 bit
> aligned (as they happen to be in the hyp ABI).

can you enforce that somewhere?

> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> 
> diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
> index c0bc218..b38ce3d 100644
> --- a/arch/arm64/kvm/hyp.S
> +++ b/arch/arm64/kvm/hyp.S
> @@ -490,65 +490,12 @@
>  	msr	mdscr_el1,	x25
>  .endm
>  
> -.macro restore_debug
> -	// x2: base address for cpu context
> -	// x3: tmp register
> -
> -	mrs	x26, id_aa64dfr0_el1
> -	ubfx	x24, x26, #12, #4	// Extract BRPs
> -	ubfx	x25, x26, #20, #4	// Extract WRPs
> -	mov	w26, #15
> -	sub	w24, w26, w24		// How many BPs to skip
> -	sub	w25, w26, w25		// How many WPs to skip
> -
> -	add	x3, x2, #CPU_SYSREG_OFFSET(DBGBCR0_EL1)
> -
> -	adr	x26, 1f
> -	add	x26, x26, x24, lsl #2
> -	br	x26
> -1:
> -	ldr	x20, [x3, #(15 * 8)]
> -	ldr	x19, [x3, #(14 * 8)]
> -	ldr	x18, [x3, #(13 * 8)]
> -	ldr	x17, [x3, #(12 * 8)]
> -	ldr	x16, [x3, #(11 * 8)]
> -	ldr	x15, [x3, #(10 * 8)]
> -	ldr	x14, [x3, #(9 * 8)]
> -	ldr	x13, [x3, #(8 * 8)]
> -	ldr	x12, [x3, #(7 * 8)]
> -	ldr	x11, [x3, #(6 * 8)]
> -	ldr	x10, [x3, #(5 * 8)]
> -	ldr	x9, [x3, #(4 * 8)]
> -	ldr	x8, [x3, #(3 * 8)]
> -	ldr	x7, [x3, #(2 * 8)]
> -	ldr	x6, [x3, #(1 * 8)]
> -	ldr	x5, [x3, #(0 * 8)]
> -
> +.macro setup_debug_registers type
> +        // x3: pointer to register set
> +        // x4: number of registers to copy
> +        // x5..x20/x26 trashed

does this mean x5 through x20, and x26, get trashed or that potentially
x5 thgough x26 get trashed?  I'm assuming the first, so replace the
slash with 'and' would be more clear.

>  	adr	x26, 1f
> -	add	x26, x26, x24, lsl #2
> -	br	x26
> -1:
> -	msr	dbgbcr15_el1, x20
> -	msr	dbgbcr14_el1, x19
> -	msr	dbgbcr13_el1, x18
> -	msr	dbgbcr12_el1, x17
> -	msr	dbgbcr11_el1, x16
> -	msr	dbgbcr10_el1, x15
> -	msr	dbgbcr9_el1, x14
> -	msr	dbgbcr8_el1, x13
> -	msr	dbgbcr7_el1, x12
> -	msr	dbgbcr6_el1, x11
> -	msr	dbgbcr5_el1, x10
> -	msr	dbgbcr4_el1, x9
> -	msr	dbgbcr3_el1, x8
> -	msr	dbgbcr2_el1, x7
> -	msr	dbgbcr1_el1, x6
> -	msr	dbgbcr0_el1, x5
> -
> -	add	x3, x2, #CPU_SYSREG_OFFSET(DBGBVR0_EL1)
> -
> -	adr	x26, 1f
> -	add	x26, x26, x24, lsl #2
> +	add	x26, x26, x4, lsl #2
>  	br	x26
>  1:
>  	ldr	x20, [x3, #(15 * 8)]
> @@ -569,116 +516,25 @@
>  	ldr	x5, [x3, #(0 * 8)]
>  
>  	adr	x26, 1f
> -	add	x26, x26, x24, lsl #2
> -	br	x26
> -1:
> -	msr	dbgbvr15_el1, x20
> -	msr	dbgbvr14_el1, x19
> -	msr	dbgbvr13_el1, x18
> -	msr	dbgbvr12_el1, x17
> -	msr	dbgbvr11_el1, x16
> -	msr	dbgbvr10_el1, x15
> -	msr	dbgbvr9_el1, x14
> -	msr	dbgbvr8_el1, x13
> -	msr	dbgbvr7_el1, x12
> -	msr	dbgbvr6_el1, x11
> -	msr	dbgbvr5_el1, x10
> -	msr	dbgbvr4_el1, x9
> -	msr	dbgbvr3_el1, x8
> -	msr	dbgbvr2_el1, x7
> -	msr	dbgbvr1_el1, x6
> -	msr	dbgbvr0_el1, x5
> -
> -	add	x3, x2, #CPU_SYSREG_OFFSET(DBGWCR0_EL1)
> -
> -	adr	x26, 1f
> -	add	x26, x26, x25, lsl #2
> +	add	x26, x26, x4, lsl #2
>  	br	x26
>  1:
> -	ldr	x20, [x3, #(15 * 8)]
> -	ldr	x19, [x3, #(14 * 8)]
> -	ldr	x18, [x3, #(13 * 8)]
> -	ldr	x17, [x3, #(12 * 8)]
> -	ldr	x16, [x3, #(11 * 8)]
> -	ldr	x15, [x3, #(10 * 8)]
> -	ldr	x14, [x3, #(9 * 8)]
> -	ldr	x13, [x3, #(8 * 8)]
> -	ldr	x12, [x3, #(7 * 8)]
> -	ldr	x11, [x3, #(6 * 8)]
> -	ldr	x10, [x3, #(5 * 8)]
> -	ldr	x9, [x3, #(4 * 8)]
> -	ldr	x8, [x3, #(3 * 8)]
> -	ldr	x7, [x3, #(2 * 8)]
> -	ldr	x6, [x3, #(1 * 8)]
> -	ldr	x5, [x3, #(0 * 8)]
> -
> -	adr	x26, 1f
> -	add	x26, x26, x25, lsl #2
> -	br	x26
> -1:
> -	msr	dbgwcr15_el1, x20
> -	msr	dbgwcr14_el1, x19
> -	msr	dbgwcr13_el1, x18
> -	msr	dbgwcr12_el1, x17
> -	msr	dbgwcr11_el1, x16
> -	msr	dbgwcr10_el1, x15
> -	msr	dbgwcr9_el1, x14
> -	msr	dbgwcr8_el1, x13
> -	msr	dbgwcr7_el1, x12
> -	msr	dbgwcr6_el1, x11
> -	msr	dbgwcr5_el1, x10
> -	msr	dbgwcr4_el1, x9
> -	msr	dbgwcr3_el1, x8
> -	msr	dbgwcr2_el1, x7
> -	msr	dbgwcr1_el1, x6
> -	msr	dbgwcr0_el1, x5
> -
> -	add	x3, x2, #CPU_SYSREG_OFFSET(DBGWVR0_EL1)
> -
> -	adr	x26, 1f
> -	add	x26, x26, x25, lsl #2
> -	br	x26
> -1:
> -	ldr	x20, [x3, #(15 * 8)]
> -	ldr	x19, [x3, #(14 * 8)]
> -	ldr	x18, [x3, #(13 * 8)]
> -	ldr	x17, [x3, #(12 * 8)]
> -	ldr	x16, [x3, #(11 * 8)]
> -	ldr	x15, [x3, #(10 * 8)]
> -	ldr	x14, [x3, #(9 * 8)]
> -	ldr	x13, [x3, #(8 * 8)]
> -	ldr	x12, [x3, #(7 * 8)]
> -	ldr	x11, [x3, #(6 * 8)]
> -	ldr	x10, [x3, #(5 * 8)]
> -	ldr	x9, [x3, #(4 * 8)]
> -	ldr	x8, [x3, #(3 * 8)]
> -	ldr	x7, [x3, #(2 * 8)]
> -	ldr	x6, [x3, #(1 * 8)]
> -	ldr	x5, [x3, #(0 * 8)]
> -
> -	adr	x26, 1f
> -	add	x26, x26, x25, lsl #2
> -	br	x26
> -1:
> -	msr	dbgwvr15_el1, x20
> -	msr	dbgwvr14_el1, x19
> -	msr	dbgwvr13_el1, x18
> -	msr	dbgwvr12_el1, x17
> -	msr	dbgwvr11_el1, x16
> -	msr	dbgwvr10_el1, x15
> -	msr	dbgwvr9_el1, x14
> -	msr	dbgwvr8_el1, x13
> -	msr	dbgwvr7_el1, x12
> -	msr	dbgwvr6_el1, x11
> -	msr	dbgwvr5_el1, x10
> -	msr	dbgwvr4_el1, x9
> -	msr	dbgwvr3_el1, x8
> -	msr	dbgwvr2_el1, x7
> -	msr	dbgwvr1_el1, x6
> -	msr	dbgwvr0_el1, x5
> -
> -	ldr	x21, [x2, #CPU_SYSREG_OFFSET(MDCCINT_EL1)]
> -	msr	mdccint_el1, x21
> +	msr	\type\()15_el1, x20
> +	msr	\type\()14_el1, x19
> +	msr	\type\()13_el1, x18
> +	msr	\type\()12_el1, x17
> +	msr	\type\()11_el1, x16
> +	msr	\type\()10_el1, x15
> +	msr	\type\()9_el1, x14
> +	msr	\type\()8_el1, x13
> +	msr	\type\()7_el1, x12
> +	msr	\type\()6_el1, x11
> +	msr	\type\()5_el1, x10
> +	msr	\type\()4_el1, x9
> +	msr	\type\()3_el1, x8
> +	msr	\type\()2_el1, x7
> +	msr	\type\()1_el1, x6
> +	msr	\type\()0_el1, x5
>  .endm
>  
>  .macro skip_32bit_state tmp, target
> @@ -929,8 +785,34 @@ __save_debug:
>  	save_debug
>  	ret
>  
> +/* Restore saved guest debug state */
>  __restore_debug:
> -	restore_debug
> +	// x2: base address for cpu context
> +	// x3: ptr to guest registers passed to setup_debug_registers
> +	// x5..x20/x26: trashed
> +
> +	mrs	x26, id_aa64dfr0_el1
> +	ubfx	x24, x26, #12, #4	// Extract BRPs
> +	ubfx	x25, x26, #20, #4	// Extract WRPs
> +	mov	w26, #15
> +	sub	w24, w26, w24		// How many BPs to skip
> +	sub	w25, w26, w25		// How many WPs to skip
> +
> +	mov     x4, x24
> +	add	x3, x2, #CPU_SYSREG_OFFSET(DBGBCR0_EL1)
> +	setup_debug_registers dbgbcr
> +	add	x3, x2, #CPU_SYSREG_OFFSET(DBGBVR0_EL1)
> +	setup_debug_registers dbgbvr
> +
> +	mov     x4, x25
> +	add	x3, x2, #CPU_SYSREG_OFFSET(DBGWCR0_EL1)
> +	setup_debug_registers dbgwcr
> +	add	x3, x2, #CPU_SYSREG_OFFSET(DBGWVR0_EL1)
> +	setup_debug_registers dbgwvr
> +
> +	ldr	x21, [x2, #CPU_SYSREG_OFFSET(MDCCINT_EL1)]
> +	msr	mdccint_el1, x21
> +
>  	ret
>  
>  __save_fpsimd:
> -- 
> 2.1.3
> 
