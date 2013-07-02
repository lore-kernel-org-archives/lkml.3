Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab3GBGQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 02:16:04 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:48049 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab3GBGQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 02:16:02 -0400
Message-ID: <51D26F57.8030400@linux.vnet.ibm.com>
Date: Tue, 02 Jul 2013 11:42:39 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/5] metag: smp: don't spin waiting for CPU to start
References: <1372694659-30176-1-git-send-email-james.hogan@imgtec.com> <1372694659-30176-4-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1372694659-30176-4-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070217-3568-0000-0000-000003DCB0F6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2013 09:34 PM, James Hogan wrote:
> Use a completion to block until a secondary CPU has started up, like ARM
> do, instead of a loop of udelays.
> 
> On Meta, SMP is really SMT, with each "CPU" being a different hardware
> thread on the same Meta processor core, so as well as being more
> efficient and latency friendly, using a completion prevents the bogomips
> of the secondary CPU from being drastically skewed every time by the
> execution of the tight in-cache udelay loop on the other CPU.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat


>  arch/metag/kernel/smp.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/metag/kernel/smp.c b/arch/metag/kernel/smp.c
> index 09979f2..e413875 100644
> --- a/arch/metag/kernel/smp.c
> +++ b/arch/metag/kernel/smp.c
> @@ -8,6 +8,7 @@
>   * published by the Free Software Foundation.
>   */
>  #include <linux/atomic.h>
> +#include <linux/completion.h>
>  #include <linux/delay.h>
>  #include <linux/init.h>
>  #include <linux/spinlock.h>
> @@ -62,6 +63,8 @@ static DEFINE_PER_CPU(struct ipi_data, ipi_data) = {
> 
>  static DEFINE_SPINLOCK(boot_lock);
> 
> +static DECLARE_COMPLETION(cpu_running);
> +
>  /*
>   * "thread" is assumed to be a valid Meta hardware thread ID.
>   */
> @@ -235,20 +238,12 @@ int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
>  	 */
>  	ret = boot_secondary(thread, idle);
>  	if (ret == 0) {
> -		unsigned long timeout;
> -
>  		/*
>  		 * CPU was successfully started, wait for it
>  		 * to come online or time out.
>  		 */
> -		timeout = jiffies + HZ;
> -		while (time_before(jiffies, timeout)) {
> -			if (cpu_online(cpu))
> -				break;
> -
> -			udelay(10);
> -			barrier();
> -		}
> +		wait_for_completion_timeout(&cpu_running,
> +					    msecs_to_jiffies(1000));
> 
>  		if (!cpu_online(cpu))
>  			ret = -EIO;
> @@ -391,6 +386,7 @@ asmlinkage void secondary_start_kernel(void)
>  	 * OK, now it's safe to let the boot CPU continue
>  	 */
>  	set_cpu_online(cpu, true);
> +	complete(&cpu_running);
> 
>  	/*
>  	 * Enable local interrupts.
> 

