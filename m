Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab3J3ANh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 20:13:37 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56563 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864Ab3J3ANg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 20:13:36 -0400
Date: Wed, 30 Oct 2013 00:12:45 +0000
From: Will Deacon <will.deacon@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 2/7] arm64: introduce interfaces to hotpatch kernel
 and module code
Message-ID: <20131030001245.GB25346@mudshark.cambridge.arm.com>
References: <1382109602-27432-1-git-send-email-liuj97@gmail.com>
 <1382109602-27432-3-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382109602-27432-3-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jinag Liu,

Sorry for the delayed review, I've been travelling.

On Fri, Oct 18, 2013 at 04:19:56PM +0100, Jiang Liu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>

If I try and email you at your Huawei address, I get a bounce from the mail
server. Is that expected? If so, it's not very helpful from a commit log
perspective if you use that address as the author on your patches.

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
>  arch/arm64/include/asm/insn.h | 19 ++++++++-
>  arch/arm64/kernel/insn.c      | 91 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 109 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
> index 7499490..7a69491 100644
> --- a/arch/arm64/include/asm/insn.h
> +++ b/arch/arm64/include/asm/insn.h
> @@ -71,8 +71,25 @@ enum aarch64_insn_hint_op {
>  
>  bool aarch64_insn_is_nop(u32 insn);
>  
> -enum aarch64_insn_encoding_class aarch64_get_insn_class(u32 insn);
> +/*
> + * In ARMv8-A, A64 instructions have a fixed length of 32 bits and are always
> + * little-endian.
> + */
> +static __always_inline u32 aarch64_insn_read(void *addr)
> +{
> +	return le32_to_cpu(*(u32 *)addr);
> +}
>  
> +static __always_inline void aarch64_insn_write(void *addr, u32 insn)
> +{
> +	*(u32 *)addr = cpu_to_le32(insn);
> +}

I wouldn't bother with these helpers. You should probably be using
probe_kernel_address or similar, then doing the endianness swabbing on the
return value in-line.

> +enum aarch64_insn_encoding_class aarch64_get_insn_class(u32 insn);
>  bool aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn);
>  
> +int aarch64_insn_patch_text_nosync(void *addr, u32 insn);
> +int aarch64_insn_patch_text_sync(void *addrs[], u32 insns[], int cnt);
> +int aarch64_insn_patch_text(void *addrs[], u32 insns[], int cnt);
> +
>  #endif	/* __ASM_INSN_H */
> diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
> index f5b779f..3879db4 100644
> --- a/arch/arm64/kernel/insn.c
> +++ b/arch/arm64/kernel/insn.c
> @@ -16,6 +16,9 @@
>   */
>  #include <linux/compiler.h>
>  #include <linux/kernel.h>
> +#include <linux/smp.h>
> +#include <linux/stop_machine.h>
> +#include <asm/cacheflush.h>
>  #include <asm/insn.h>
>  
>  static int aarch64_insn_encoding_class[] = {
> @@ -88,3 +91,91 @@ bool __kprobes aarch64_insn_hotpatch_safe(u32 old_insn, u32 new_insn)
>  	return __aarch64_insn_hotpatch_safe(old_insn) &&
>  	       __aarch64_insn_hotpatch_safe(new_insn);
>  }
> +
> +int __kprobes aarch64_insn_patch_text_nosync(void *addr, u32 insn)
> +{
> +	u32 *tp = addr;
> +
> +	/* A64 instructions must be word aligned */
> +	if ((uintptr_t)tp & 0x3)
> +		return -EINVAL;
> +
> +	aarch64_insn_write(tp, insn);
> +	flush_icache_range((uintptr_t)tp, (uintptr_t)tp + sizeof(u32));

sizeof(insn) is clearer here.

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
> +static DEFINE_MUTEX(text_patch_lock);
> +static atomic_t text_patch_id;
> +
> +static int __kprobes aarch64_insn_patch_text_cb(void *arg)
> +{
> +	int i, ret = 0;
> +	struct aarch64_insn_patch *pp = arg;
> +
> +	if (atomic_read(&text_patch_id) == smp_processor_id()) {

You could actually pass in the test_patch_id as zero-initialised parameter
to this function (i.e. it points to something on the stack of the guy
issuing the stop_machine). Then you do an inc_return here. If you see zero,
you go ahead and do the patching.

> +		for (i = 0; ret == 0 && i < pp->insn_cnt; i++)
> +			ret = aarch64_insn_patch_text_nosync(pp->text_addrs[i],
> +							     pp->new_insns[i]);
> +		/* Let other CPU continue */
> +		atomic_set(&text_patch_id, -1);

You're relying on the barrier in flush_icache_range to order this
atomic_set. I think you should add a comment describing that, because it's
very subtle.

> +	} else {
> +		while (atomic_read(&text_patch_id) != -1)
> +			cpu_relax();
> +		isb();
> +	}
> +
> +	return ret;
> +}

I don't think you need the isb -- the exception return should do the trick
(but again, a comment would be useful).

> +
> +int __kprobes aarch64_insn_patch_text_sync(void *addrs[], u32 insns[], int cnt)
> +{
> +	int ret;
> +	struct aarch64_insn_patch patch = {
> +		.text_addrs = addrs,
> +		.new_insns = insns,
> +		.insn_cnt = cnt,
> +	};
> +
> +	if (cnt <= 0)
> +		return -EINVAL;
> +
> +	mutex_lock(&text_patch_lock);

Again, if you use a loacl variable, I don't think you need the mutex. What
do you think?

> +	atomic_set(&text_patch_id, smp_processor_id());
> +	ret = stop_machine(aarch64_insn_patch_text_cb, &patch, cpu_online_mask);

Instead of doing this, why not instead call aarch64_insn_patch_text_nosync
inline, then call kick_all_cpus_sync immediately afterwards, without the
need to stop_machine.

Will
