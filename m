Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936381Ab3DQUD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 16:03:27 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47158 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935448Ab3DQUDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 16:03:24 -0400
Date: Wed, 17 Apr 2013 13:03:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] nohz: New option to default all CPUs in full
 dynticks range
Message-ID: <20130417200316.GH29861@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1366215889-2635-1-git-send-email-fweisbec@gmail.com>
 <1366215889-2635-4-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366215889-2635-4-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041720-5806-0000-0000-000020C514AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 06:24:49PM +0200, Frederic Weisbecker wrote:
> Provide a new kernel config that defaults all CPUs to be part
> of the full dynticks range, except the boot one for timekeeping.
> 
> This default setting is overriden by the nohz_full= boot option
> if passed by the user.
> 
> This is helpful for those who don't need a finegrained range
> of full dynticks CPU and also for automated testing.
> 
> Suggested-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Geoff Levand <geoff@infradead.org>
> Cc: Gilad Ben Yossef <gilad@benyossef.com>
> Cc: Hakan Akkan <hakanakkan@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Li Zhong <zhong@linux.vnet.ibm.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/time/Kconfig      |   10 ++++++++++
>  kernel/time/tick-sched.c |   23 +++++++++++++++++++++--
>  2 files changed, 31 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
> index 358d601..99c3f13 100644
> --- a/kernel/time/Kconfig
> +++ b/kernel/time/Kconfig
> @@ -128,6 +128,16 @@ config NO_HZ_FULL
> 
>  endchoice
> 
> +config NO_HZ_FULL_ALL
> +       bool "Full dynticks system on all CPUs by default"
> +       depends on NO_HZ_FULL
> +       help
> +         If the user doesn't pass the nohz_full boot option to
> +	 define the range of full dynticks CPUs, consider that all
> +	 CPUs in the system are full dynticks by default.
> +	 Note the boot CPU will still be kept outside the range to
> +	 handle the timekeeping duty.
> +
>  config NO_HZ
>  	bool "Old Idle dynticks config"
>  	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index d71a5f2..a76e090 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -203,12 +203,31 @@ static int __cpuinit tick_nohz_cpu_down_callback(struct notifier_block *nfb,
>   */
>  static char __initdata nohz_full_buf[NR_CPUS + 1];
> 
> +static int tick_nohz_init_all(void)
> +{
> +	int err = -1;
> +
> +#ifdef CONFIG_NO_HZ_FULL_ALL
> +	if (!alloc_cpumask_var(&nohz_full_mask, GFP_KERNEL)) {
> +		pr_err("NO_HZ: Can't allocate full dynticks cpumask\n");
> +		return err;
> +	}
> +	err = 0;
> +	cpumask_setall(nohz_full_mask);
> +	cpumask_clear_cpu(smp_processor_id(), nohz_full_mask);
> +	have_nohz_full_mask = true;
> +#endif
> +	return err;
> +}
> +
>  void __init tick_nohz_init(void)
>  {
>  	int cpu;
> 
> -	if (!have_nohz_full_mask)
> -		return;
> +	if (!have_nohz_full_mask) {
> +		if (tick_nohz_init_all() < 0)
> +			return;
> +	}
> 
>  	cpu_notifier(tick_nohz_cpu_down_callback, 0);
> 
> -- 
> 1.7.5.4
> 

