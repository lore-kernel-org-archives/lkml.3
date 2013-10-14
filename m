Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab3JNPaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:30:11 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:59066 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239Ab3JNPaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:30:06 -0400
Message-ID: <525C0DF8.8040306@gmail.com>
Date: Mon, 14 Oct 2013 23:30:00 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFT PATCH v2 2/4] arm64: restore FPSIMD to default state for
 kernel and signal contexts
References: <1381674029-430-1-git-send-email-liuj97@gmail.com> <1381674029-430-2-git-send-email-liuj97@gmail.com> <20131014151638.GI10491@mudshark.cambridge.arm.com>
In-Reply-To: <20131014151638.GI10491@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 11:16 PM, Will Deacon wrote:
> On Sun, Oct 13, 2013 at 03:20:18PM +0100, Jiang Liu wrote:
>> From: Jiang Liu <jiang.liu@huawei.com>
>>
>> Restore FPSIMD control and status registers to default values
>> when creating new FPSIMD contexts for kernel context and reset
>> FPSIMD status register when creating FPSIMD context for signal
>> handling, otherwise the stale value in FPSIMD control and status
>> registers may affect the new kernal or signal handling contexts.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> Cc: Jiang Liu <liuj97@gmail.com>
>> ---
>>  arch/arm64/include/asm/fpsimd.h | 16 ++++++++++++++++
>>  arch/arm64/kernel/fpsimd.c      | 11 +++++++++--
>>  arch/arm64/kernel/signal.c      |  1 +
>>  arch/arm64/kernel/signal32.c    |  1 +
>>  4 files changed, 27 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
>> index c43b4ac..b2dc30f 100644
>> --- a/arch/arm64/include/asm/fpsimd.h
>> +++ b/arch/arm64/include/asm/fpsimd.h
>> @@ -50,8 +50,24 @@ struct fpsimd_state {
>>  #define VFP_STATE_SIZE		((32 * 8) + 4)
>>  #endif
>>  
>> +#define	AARCH64_FPCR_DEFAULT_VAL	0
>> +
>>  struct task_struct;
>>  
>> +static inline void fpsimd_init_hw_state(void)
>> +{
>> +	int val = AARCH64_FPCR_DEFAULT_VAL;
>> +
>> +	asm ("msr fpcr, %x0\n"
>> +	     "msr fpsr, xzr\n"
>> +             : : "r"(val));
>> +}
>> +
>> +static inline void fpsimd_clear_fpsr(void)
>> +{
>> +	asm ("msr fpsr, xzr\n");
>> +}
> 
> You have pretty weak asm constraints here...
Hi Will,
	We will add an explicit "volatile" here. But according to GCC docs, it
should have the same effect:
An asm instruction without any output operands is treated identically to
a volatile asm instruction.
Thanks!
Gerry

> 
>>  extern void fpsimd_save_state(struct fpsimd_state *state);
>>  extern void fpsimd_load_state(struct fpsimd_state *state);
>>  
>> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
>> index bb785d2..12a25e5 100644
>> --- a/arch/arm64/kernel/fpsimd.c
>> +++ b/arch/arm64/kernel/fpsimd.c
>> @@ -80,9 +80,14 @@ void fpsimd_thread_switch(struct task_struct *next)
>>  
>>  void fpsimd_flush_thread(void)
>>  {
>> +	struct fpsimd_state *state = &current->thread.fpsimd_state;
>> +
>>  	preempt_disable();
>> -	memset(&current->thread.fpsimd_state, 0, sizeof(struct fpsimd_state));
>> -	fpsimd_load_state(&current->thread.fpsimd_state);
>> +	memset(state, 0, sizeof(struct fpsimd_state));
>> +#if (AARCH64_FPCR_DEFAULT_VAL != 0)
>> +	state->fpcr = AARCH64_FPCR_DEFAULT_VAL;
>> +#endif
>> +	fpsimd_load_state(state);
>>  	preempt_enable();
>>  }
>>  
>> @@ -99,6 +104,8 @@ void kernel_neon_begin(void)
>>  
>>  	if (current->mm)
>>  		fpsimd_save_state(&current->thread.fpsimd_state);
>> +
>> +	fpsimd_init_hw_state();
>>  }
>>  EXPORT_SYMBOL(kernel_neon_begin);
>>  
>> diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
>> index 890a591..4ee231e 100644
>> --- a/arch/arm64/kernel/signal.c
>> +++ b/arch/arm64/kernel/signal.c
>> @@ -52,6 +52,7 @@ static int preserve_fpsimd_context(struct fpsimd_context __user *ctx)
>>  
>>  	/* dump the hardware registers to the fpsimd_state structure */
>>  	fpsimd_save_state(fpsimd);
>> +	fpsimd_clear_fpsr();
> 
> ... so I reckon GCC could reorder these two calls, resulting in corruption
> of the saved state register.
> 
> Will
> 

