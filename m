Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab3JNKQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:16:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47612 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab3JNKQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:16:56 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, kernel-team@lists.ubuntu.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 087/100] powerpc: Restore registers on error exit from csum_partial_copy_generic()
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
	<1381488130-30235-88-git-send-email-luis.henriques@canonical.com>
Date: Mon, 14 Oct 2013 11:16:48 +0100
In-Reply-To: <1381488130-30235-88-git-send-email-luis.henriques@canonical.com>
	(Luis Henriques's message of "Fri, 11 Oct 2013 11:41:57 +0100")
Message-ID: <87k3hgrwbz.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis Henriques <luis.henriques@canonical.com> writes:

> 3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>
> commit 8f21bd0090052e740944f9397e2be5ac7957ded7 upstream.

I'm dropping this patch as it is causing some build failures on
powerpc configs.

Cheers,
-- 
Luis


>
> The csum_partial_copy_generic() function saves the PowerPC
>non-volatile
> r14, r15, and r16 registers for the main checksum-and-copy loop.
> Unfortunately, it fails to restore them upon error exit from this loop,
> which results in silent corruption of these registers in the presumably
> rare event of an access exception within that loop.
>
> This commit therefore restores these register on error exit from the loop.
>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Anton Blanchard <anton@samba.org>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> ---
>  arch/powerpc/lib/checksum_64.S | 54 +++++++++++++++++++++++++++++++-----------
>  1 file changed, 40 insertions(+), 14 deletions(-)
>
> diff --git a/arch/powerpc/lib/checksum_64.S b/arch/powerpc/lib/checksum_64.S
> index afa2eba..d0e8390 100644
> --- a/arch/powerpc/lib/checksum_64.S
> +++ b/arch/powerpc/lib/checksum_64.S
> @@ -229,19 +229,35 @@ _GLOBAL(csum_partial)
>  	blr
>  
>  
> -	.macro source
> +	.macro srcnr
>  100:
>  	.section __ex_table,"a"
>  	.align 3
> -	.llong 100b,.Lsrc_error
> +	.llong 100b,.Lsrc_error_nr
>  	.previous
>  	.endm
>  
> -	.macro dest
> +	.macro source
> +150:
> +	.section __ex_table,"a"
> +	.align 3
> +	.llong 150b,.Lsrc_error
> +	.previous
> +	.endm
> +
> +	.macro dstnr
>  200:
>  	.section __ex_table,"a"
>  	.align 3
> -	.llong 200b,.Ldest_error
> +	.llong 200b,.Ldest_error_nr
> +	.previous
> +	.endm
> +
> +	.macro dest
> +250:
> +	.section __ex_table,"a"
> +	.align 3
> +	.llong 250b,.Ldest_error
>  	.previous
>  	.endm
>  
> @@ -277,11 +293,11 @@ _GLOBAL(csum_partial_copy_generic)
>  	mtctr	r6
>  
>  1:
> -source;	lhz	r6,0(r3)		/* align to doubleword */
> +srcnr;	lhz	r6,0(r3)		/* align to doubleword */
>  	subi	r5,r5,2
>  	addi	r3,r3,2
>  	adde	r0,r0,r6
> -dest;	sth	r6,0(r4)
> +dstnr;	sth	r6,0(r4)
>  	addi	r4,r4,2
>  	bdnz	1b
>  
> @@ -395,10 +411,10 @@ dest;	std	r16,56(r4)
>  
>  	mtctr	r6
>  3:
> -source;	ld	r6,0(r3)
> +srcnr;	ld	r6,0(r3)
>  	addi	r3,r3,8
>  	adde	r0,r0,r6
> -dest;	std	r6,0(r4)
> +dstnr;	std	r6,0(r4)
>  	addi	r4,r4,8
>  	bdnz	3b
>  
> @@ -408,10 +424,10 @@ dest;	std	r6,0(r4)
>  	srdi.	r6,r5,2
>  	beq	.Lcopy_tail_halfword
>  
> -source;	lwz	r6,0(r3)
> +srcnr;	lwz	r6,0(r3)
>  	addi	r3,r3,4
>  	adde	r0,r0,r6
> -dest;	stw	r6,0(r4)
> +dstnr;	stw	r6,0(r4)
>  	addi	r4,r4,4
>  	subi	r5,r5,4
>  
> @@ -419,10 +435,10 @@ dest;	stw	r6,0(r4)
>  	srdi.	r6,r5,1
>  	beq	.Lcopy_tail_byte
>  
> -source;	lhz	r6,0(r3)
> +srcnr;	lhz	r6,0(r3)
>  	addi	r3,r3,2
>  	adde	r0,r0,r6
> -dest;	sth	r6,0(r4)
> +dstnr;	sth	r6,0(r4)
>  	addi	r4,r4,2
>  	subi	r5,r5,2
>  
> @@ -430,10 +446,10 @@ dest;	sth	r6,0(r4)
>  	andi.	r6,r5,1
>  	beq	.Lcopy_finish
>  
> -source;	lbz	r6,0(r3)
> +srcnr;	lbz	r6,0(r3)
>  	sldi	r9,r6,8			/* Pad the byte out to 16 bits */
>  	adde	r0,r0,r9
> -dest;	stb	r6,0(r4)
> +dstnr;	stb	r6,0(r4)
>  
>  .Lcopy_finish:
>  	addze	r0,r0			/* add in final carry */
> @@ -443,6 +459,11 @@ dest;	stb	r6,0(r4)
>  	blr
>  
>  .Lsrc_error:
> +	ld	r14,STK_REG(R14)(r1)
> +	ld	r15,STK_REG(R15)(r1)
> +	ld	r16,STK_REG(R16)(r1)
> +	addi	r1,r1,STACKFRAMESIZE
> +.Lsrc_error_nr:
>  	cmpdi	0,r7,0
>  	beqlr
>  	li	r6,-EFAULT
> @@ -450,6 +471,11 @@ dest;	stb	r6,0(r4)
>  	blr
>  
>  .Ldest_error:
> +	ld	r14,STK_REG(R14)(r1)
> +	ld	r15,STK_REG(R15)(r1)
> +	ld	r16,STK_REG(R16)(r1)
> +	addi	r1,r1,STACKFRAMESIZE
> +.Ldest_error_nr:
>  	cmpdi	0,r8,0
>  	beqlr
>  	li	r6,-EFAULT
