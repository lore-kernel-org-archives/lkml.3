Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964937Ab3BMVcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 16:32:23 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:40803 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934131Ab3BMVcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 16:32:22 -0500
Message-ID: <511C0662.8010309@gmail.com>
Date: Wed, 13 Feb 2013 22:32:18 +0100
From: Mircea Gherzan <mgherzan@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Nicolas Schichan <nschichan@freebox.fr>
CC: Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: net: bpf_jit: fix emit_swap16() for non ARMv6+.
References: <1360776125-14542-1-git-send-email-nschichan@freebox.fr> <1360776645-14726-1-git-send-email-nschichan@freebox.fr>
In-Reply-To: <1360776645-14726-1-git-send-email-nschichan@freebox.fr>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.02.2013 18:30, schrieb Nicolas Schichan:
> The original code was generating an lsl instructions using the value
> of ARM_R8 (skb_headlen, possibly uninitialized if no skb_headlen
> access was required) as a shift amount.
> 
> Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
> ---
> Resent due to missing Signed-off-by
> 
>  arch/arm/net/bpf_jit_32.c |   15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
> index a34f1e2..6828ef6 100644
> --- a/arch/arm/net/bpf_jit_32.c
> +++ b/arch/arm/net/bpf_jit_32.c
> @@ -341,10 +341,17 @@ static void emit_load_be16(u8 cond, u8 r_res, u8 r_addr, struct jit_ctx *ctx)
>  
>  static inline void emit_swap16(u8 r_dst, u8 r_src, struct jit_ctx *ctx)
>  {
> -	emit(ARM_LSL_R(ARM_R1, r_src, 8), ctx);
> -	emit(ARM_ORR_S(r_dst, ARM_R1, r_src, SRTYPE_LSL, 8), ctx);
> -	emit(ARM_LSL_I(r_dst, r_dst, 8), ctx);
> -	emit(ARM_LSL_R(r_dst, r_dst, 8), ctx);
> +	/* r_dst = (r_src << 8) | (r_src >> 8) */
> +	emit(ARM_LSL_I(ARM_R1, r_src, 8), ctx);
> +	emit(ARM_ORR_S(r_dst, ARM_R1, r_src, SRTYPE_LSR, 8), ctx);
> +
> +	/*
> +	 * we need to mask out the bits set in r_dst[23:16] due to
> +	 * the first shift instruction.
> +	 *
> +	 * note that 0x8ff is the encoded immediate 0x00ff0000.
> +	 */
> +	emit(ARM_BIC_I(r_dst, r_dst, 0x8ff), ctx);
>  }
>  
>  #else  /* ARMv6+ */

Acked-by: Mircea Gherzan <mgherzan@gmail.com>
