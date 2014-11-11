Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaKKUIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 15:08:09 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:37445 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaKKUII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 15:08:08 -0500
Message-ID: <54626CA4.4070508@amacapital.net>
Date: Tue, 11 Nov 2014 12:08:04 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, x86@kernel.org
CC: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 8/8] x86: Use rd/wr fs/gs base in arch_prctl
References: <1415663739-25525-1-git-send-email-andi@firstfloor.org> <1415663739-25525-8-git-send-email-andi@firstfloor.org>
In-Reply-To: <1415663739-25525-8-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 03:55 PM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Convert arch_prctl to use the new instructions to
> change fs/gs if available, instead of using MSRs.
> 
> This is merely a small performance optimization,
> no new functionality.
> 
> With the new instructions the syscall is really obsolete,
> as everything can be set directly in ring 3. But the syscall
> is widely used by existing software, so we still support it.
> 
> The syscall still enforces that the addresses are not
> in kernel space, even though that is not needed more.
> This is mainly so that the programs written for new CPUs
> do not suddenly fail on old CPUs.
> 
> With the new instructions available it prefers to use
> them in the context switch, instead of using the old
> "use GDT segment rewrite" trick.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/process_64.c | 45 ++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 37 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
> index df554e2..010fe15 100644
> --- a/arch/x86/kernel/process_64.c
> +++ b/arch/x86/kernel/process_64.c
> @@ -483,15 +483,23 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
>  	int ret = 0;
>  	int doit = task == current;
>  	int cpu;
> +	int fast_seg = boot_cpu_has(X86_FEATURE_FSGSBASE);
>  
>  	switch (code) {
>  	case ARCH_SET_GS:
> +		/*
> +		 * With fast_seg we don't need that check anymore,
> +		 * but keep it so that programs do not suddenly
> +		 * start failing when run on older CPUs.
> +		 * If you really want to set a address in kernel space
> +		 * use WRGSBASE directly.
> +		 */
>  		if (addr >= TASK_SIZE_OF(task))
>  			return -EPERM;
>  		cpu = get_cpu();
>  		/* handle small bases via the GDT because that's faster to
>  		   switch. */
> -		if (addr <= 0xffffffff) {
> +		if (addr <= 0xffffffff && !fast_seg) {
>  			set_32bit_tls(task, GS_TLS, addr);
>  			if (doit) {
>  				load_TLS(&task->thread, cpu);
> @@ -503,8 +511,17 @@ long do_arch_prctl(struct task_struct *task, int code, unsigned long addr)
>  			task->thread.gsindex = 0;
>  			task->thread.gs = addr;
>  			if (doit) {
> -				load_gs_index(0);
> -				ret = wrmsrl_safe(MSR_KERNEL_GS_BASE, addr);
> +				if (fast_seg) {
> +					local_irq_disable();
> +					swapgs();
> +					loadsegment(gs, 0);
> +					wrgsbase(addr);
> +					swapgs();
> +					local_irq_enable();

Does this (and the other copies of this) need kprobe protection?

--Andy
