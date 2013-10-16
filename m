Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760688Ab3JPLMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:12:13 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51162 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760653Ab3JPLML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:12:11 -0400
Date: Wed, 16 Oct 2013 12:11:30 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/7] arm64: introduce interfaces to hotpatch kernel
 and module code
Message-ID: <20131016111130.GE5403@mudshark.cambridge.arm.com>
References: <1381893492-7135-1-git-send-email-liuj97@gmail.com>
 <1381893492-7135-3-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381893492-7135-3-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 04:18:07AM +0100, Jiang Liu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> Introduce three interfaces to patch kernel and module code:
> aarch64_insn_patch_text_nosync():
> 	patch code without synchronization, it's caller's responsibility
> 	to synchronize all CPUs if needed.
> aarch64_insn_patch_text_sync():
> 	patch code and always synchronize with stop_machine()
> aarch64_insn_patch_text():
> 	patch code and synchronize with stop_machine() if needed
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Jiang Liu <liuj97@gmail.com>
> ---
>  arch/arm64/include/asm/insn.h |  7 +++-
>  arch/arm64/kernel/insn.c      | 95 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 101 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
> index e7d1bc8..2dfcdb4 100644
> --- a/arch/arm64/include/asm/insn.h
> +++ b/arch/arm64/include/asm/insn.h
> @@ -47,7 +47,12 @@ __AARCH64_INSN_FUNCS(nop,	0xFFFFFFFF, 0xD503201F)
>  #undef	__AARCH64_INSN_FUNCS
>  
>  enum aarch64_insn_class aarch64_get_insn_class(u32 insn);
> -
> +u32 aarch64_insn_read(void *addr);
> +void aarch64_insn_write(void *addr, u32 insn);
>  bool aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn);
>  
> +int aarch64_insn_patch_text_nosync(void *addrs[], u32 insns[], int cnt);
> +int aarch64_insn_patch_text_sync(void *addrs[], u32 insns[], int cnt);
> +int aarch64_insn_patch_text(void *addrs[], u32 insns[], int cnt);
> +
>  #endif	/* _ASM_ARM64_INSN_H */
> diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
> index 1be4d11..ad4185f 100644
> --- a/arch/arm64/kernel/insn.c
> +++ b/arch/arm64/kernel/insn.c
> @@ -16,6 +16,8 @@
>   */
>  #include <linux/compiler.h>
>  #include <linux/kernel.h>
> +#include <linux/stop_machine.h>
> +#include <asm/cacheflush.h>
>  #include <asm/insn.h>
>  
>  /*
> @@ -84,3 +86,96 @@ bool __kprobes aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn)
>  	return __aarch64_insn_hotpatch_safe(old_insn) &&
>  	       __aarch64_insn_hotpatch_safe(new_insn);
>  }
> +
> +/*
> + * In ARMv8-A, A64 instructions have a fixed length of 32 bits and are always
> + * little-endian. On the other hand, SCTLR_EL1.EE (bit 25, Exception Endianness)
> + * flag controls endianness for EL1 explicit data accesses and stage 1
> + * translation table walks as below:
> + *	0: little-endian
> + *	1: big-endian
> + * So need to handle endianness when patching kernel code.
> + */
> +u32 __kprobes aarch64_insn_read(void *addr)
> +{
> +	u32 insn;
> +
> +#ifdef	__AARCH64EB__
> +	insn = swab32(*(u32 *)addr);
> +#else
> +	insn = *(u32 *)addr;
> +#endif

le32_to_cpu ?

> +
> +	return insn;
> +}
> +
> +void __kprobes aarch64_insn_write(void *addr, u32 insn)
> +{
> +#ifdef	__AARCH64EB__
> +	*(u32 *)addr = swab32(insn);
> +#else
> +	*(u32 *)addr = insn;
> +#endif
> +}

cpu_to_le32 ?

> +int __kprobes aarch64_insn_patch_text_nosync(void *addrs[], u32 insns[],
> +					     int cnt)
> +{
> +	int i;
> +	u32 *tp;
> +
> +	if (cnt <= 0)
> +		return -EINVAL;
> +
> +	for (i = 0; i < cnt; i++) {
> +		tp = addrs[i];
> +		/* A64 instructions must be word aligned */
> +		if ((uintptr_t)tp & 0x3)
> +			return -EINVAL;
> +		aarch64_insn_write(tp, insns[i]);
> +		flush_icache_range((uintptr_t)tp, (uintptr_t)tp + sizeof(u32));

What are you trying to achieve with this cache maintenance for the nosync
case? If you're not synchronising, then you will always have races with the
instruction patching, so I'd argue that this cache flush doesn't buy you
anything.

> +	}
> +
> +	return 0;
> +}
> +
> +struct aarch64_insn_patch {
> +	void	**text_addrs;
> +	u32	*new_insns;
> +	int	insn_cnt;
> +};
> +
> +static int __kprobes aarch64_insn_patch_text_cb(void *arg)
> +{
> +	struct aarch64_insn_patch *pp = arg;
> +
> +	return aarch64_insn_patch_text_nosync(pp->text_addrs, pp->new_insns,
> +					      pp->insn_cnt);
> +}
> +
> +int __kprobes aarch64_insn_patch_text_sync(void *addrs[], u32 insns[], int cnt)
> +{
> +	struct aarch64_insn_patch patch = {
> +		.text_addrs = addrs,
> +		.new_insns = insns,
> +		.insn_cnt = cnt,
> +	};
> +
> +	if (cnt <= 0)
> +		return -EINVAL;
> +
> +	/*
> +	 * Execute __aarch64_insn_patch_text() on every online CPU,
> +	 * which ensure serialization among all online CPUs.
> +	 */
> +	return stop_machine(aarch64_insn_patch_text_cb, &patch, NULL);
> +}
> +
> +int __kprobes aarch64_insn_patch_text(void *addrs[], u32 insns[], int cnt)
> +{
> +	if (cnt == 1 && aarch64_insn_hotpatch_safe(aarch64_insn_read(addrs[0]),
> +						   insns[0]))
> +		return aarch64_insn_patch_text_nosync(addrs, insns, cnt);
> +	else
> +		return aarch64_insn_patch_text_sync(addrs, insns, cnt);
> +}

The other way of doing this for cnt > 1 would be to patch in a branch to
the insns array and then a branch over the original code at the end of the
array. Obviously, this relies on insns being allocated somewhere persistent
(and non-pageable!).

I was wondering whether you could do something clever with BKPT, but
everything I've thought of so far is racy.

Will
