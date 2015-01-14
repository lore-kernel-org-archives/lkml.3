Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbbANJcD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:32:03 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:46544 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbbANJcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:32:01 -0500
MIME-Version: 1.0
In-Reply-To: <1420949002-3726-3-git-send-email-dave.long@linaro.org>
References: <1420949002-3726-1-git-send-email-dave.long@linaro.org>
	<1420949002-3726-3-git-send-email-dave.long@linaro.org>
Date: Wed, 14 Jan 2015 15:02:00 +0530
Message-ID: <CAHM4w1=nJVr8P-us8+E42kY9jpcWoRKWyd1ASzfsUpb-_DNPYw@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] arm64: Add more test functions to insn.c
From: Pratyush Anand <pratyush.anand@gmail.com>
To: David Long <dave.long@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        William Cohen <wcohen@redhat.com>,
        Steve Capper <steve.capper@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        Pratyush Anand <panand@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2015 at 9:33 AM, David Long <dave.long@linaro.org> wrote:
> From: "David A. Long" <dave.long@linaro.org>
>
> Certain instructions are hard to execute correctly out-of-line (as in
> kprobes).  Test functions are added to insn.[hc] to identify these.  The
> instructions include any that use PC-relative addressing, change the PC,
> or change interrupt masking. For efficiency and simplicity test
> functions are also added for small collections of related instructions.
>
> Signed-off-by: David A. Long <dave.long@linaro.org>
> ---
>  arch/arm64/include/asm/insn.h | 21 +++++++++++++++++++--
>  arch/arm64/kernel/insn.c      | 18 ++++++++++++++++++
>  2 files changed, 37 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
> index e2ff32a..466afd4 100644
> --- a/arch/arm64/include/asm/insn.h
> +++ b/arch/arm64/include/asm/insn.h
> @@ -223,8 +223,13 @@ static __always_inline bool aarch64_insn_is_##abbr(u32 code) \
>  static __always_inline u32 aarch64_insn_get_##abbr##_value(void) \
>  { return (val); }
>
> +__AARCH64_INSN_FUNCS(adr,      0x9F000000, 0x10000000)

Should n't it be
__AARCH64_INSN_FUNCS(adr_adrp,      0x1F000000, 0x10000000)

So, that it also take care about adrp

> +__AARCH64_INSN_FUNCS(prfm_lit, 0xFF000000, 0xD8000000)

[...]

>
> +bool aarch64_insn_uses_literal(u32 insn)
> +{
> +       /* ldr/ldrsw (literal), prfm */
> +
> +       return aarch64_insn_is_ldr_lit(insn) ||
> +               aarch64_insn_is_ldrsw_lit(insn) ||

also aarch64_insn_is_adr_adrp(insn) ||


> +               aarch64_insn_is_prfm_lit(insn);
> +}
> +
> +bool aarch64_insn_is_branch(u32 insn)
> +{
> +       /* b, bl, cb*, tb*, b.cond, br, blr */
> +
> +       return aarch64_insn_is_b_bl_cb_tb(insn) ||
> +               aarch64_insn_is_br_blr(insn) ||

also aarch64_insn_is_ret(insn) ||

> +               aarch64_insn_is_bcond(insn);
> +}
> +
>  /*
