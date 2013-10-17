Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab3JQMMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 08:12:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46538 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753373Ab3JQMMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 08:12:14 -0400
Date: Thu, 17 Oct 2013 13:11:35 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/7] arm64: move encode_insn_immediate() from module.c
 to insn.c
Message-ID: <20131017121135.GK18765@mudshark.cambridge.arm.com>
References: <1381990781-27814-1-git-send-email-liuj97@gmail.com>
 <1381990781-27814-4-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381990781-27814-4-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 07:19:36AM +0100, Jiang Liu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> Function encode_insn_immediate() will be used by other instruction
> manipulate related functions, so move it into insn.c and rename it
> as aarch64_insn_encode_immediate().
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Jiang Liu <liuj97@gmail.com>
> ---
>  arch/arm64/include/asm/insn.h |  14 ++++
>  arch/arm64/kernel/insn.c      |  58 ++++++++++++++++
>  arch/arm64/kernel/module.c    | 152 +++++++++++++-----------------------------
>  3 files changed, 117 insertions(+), 107 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
> index fc439b9..d62b601 100644
> --- a/arch/arm64/include/asm/insn.h
> +++ b/arch/arm64/include/asm/insn.h
> @@ -42,6 +42,18 @@ enum aarch64_insn_encoding_class {
>                                          * system instructions */
>  };
> 
> +enum aarch64_insn_imm_type {
> +       AARCH64_INSN_IMM_MOVK,
> +       AARCH64_INSN_IMM_ADR,
> +       AARCH64_INSN_IMM_26,
> +       AARCH64_INSN_IMM_19,
> +       AARCH64_INSN_IMM_16,
> +       AARCH64_INSN_IMM_14,
> +       AARCH64_INSN_IMM_12,
> +       AARCH64_INSN_IMM_9,
> +       AARCH64_INSN_IMM_MAX
> +};
> +
>  #define        __AARCH64_INSN_FUNCS(abbr, mask, val)   \
>  static __always_inline bool aarch64_insn_is_##abbr(u32 code) \
>  { return (code & (mask)) == (val); }   \
> @@ -80,6 +92,8 @@ static __always_inline void aarch64_insn_write(void *addr, u32 insn)
>  }
> 
>  enum aarch64_insn_encoding_class aarch64_get_insn_class(u32 insn);
> +u32 aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
> +                                 u32 insn, u64 imm);
>  bool aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn);
> 
>  int aarch64_insn_patch_text_nosync(void *addrs[], u32 insns[], int cnt);
> diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
> index 8dd5fbe..344d23ed 100644
> --- a/arch/arm64/kernel/insn.c
> +++ b/arch/arm64/kernel/insn.c
> @@ -147,3 +147,61 @@ int __kprobes aarch64_insn_patch_text(void *addrs[], u32 insns[], int cnt)
> 
>         return ret;
>  }
> +
> +u32 aarch64_insn_encode_immediate(enum aarch64_insn_imm_type type,
> +                                 u32 insn, u64 imm)
> +{
> +       u32 immlo, immhi, lomask, himask, mask;
> +       int shift;
> +
> +       switch (type) {
> +       case AARCH64_INSN_IMM_MOVK:
> +               mask = BIT(16) - 1;
> +               shift = 5;
> +               break;

This is just AARCH64_INSN_IMM_16 now that we're not dealing with MOV
relocations. You can kill INSN_IMM_MOVK in the enum.

The rest of the patch looks fine.

Will
