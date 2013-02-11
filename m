Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468Ab3BKOfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 09:35:36 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52787 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757365Ab3BKOff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 09:35:35 -0500
Date: Mon, 11 Feb 2013 15:35:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 07/33] nohz: Basic full dynticks interface
Message-ID: <20130211143529.GB2749@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Alessio Igor Bogani <abogani@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Metcalf <cmetcalf@tilera.com>,
	Christoph Lameter <cl@linux.com>,
	Geoff Levand <geoff@infradead.org>,
	Gilad Ben Yossef <gilad@benyossef.com>,
	Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Li Zhong <zhong@linux.vnet.ibm.com>,
	Namhyung Kim <namhyung.kim@lge.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
 <1357610913-1080-8-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1357610913-1080-8-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 03:08:07AM +0100, Frederic Weisbecker wrote:

[ … ]

> diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
> index 8601f0d..dc6381d 100644
> --- a/kernel/time/Kconfig
> +++ b/kernel/time/Kconfig
> @@ -70,6 +70,15 @@ config NO_HZ
>  	  only trigger on an as-needed basis both when the system is
>  	  busy and when the system is idle.
>  
> +config NO_HZ_FULL
> +       bool "Full tickless system"

I think you want to say here "Almost-completely tickless system".
"Almost" because of that one CPU outside of the range :-)

> +       depends on NO_HZ && RCU_USER_QS && VIRT_CPU_ACCOUNTING_GEN && RCU_NOCB_CPU && SMP
> +       select CONTEXT_TRACKING_FORCE
> +       help
> +         Try to be tickless everywhere, not just in idle. (You need
> +	 to fill up the full_nohz_mask boot parameter).
> +
> +
>  config HIGH_RES_TIMERS
>  	bool "High Resolution Timer Support"
>  	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 314b9ee..494a2aa 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -142,6 +142,29 @@ static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
>  	profile_tick(CPU_PROFILING);
>  }
>  
> +#ifdef CONFIG_NO_HZ_FULL
> +static cpumask_var_t full_nohz_mask;
> +bool have_full_nohz_mask;
> +
> +int tick_nohz_full_cpu(int cpu)
> +{
> +	if (!have_full_nohz_mask)
> +		return 0;
> +
> +	return cpumask_test_cpu(cpu, full_nohz_mask);
> +}
> +
> +/* Parse the boot-time nohz CPU list from the kernel parameters. */
> +static int __init tick_nohz_full_setup(char *str)
> +{
> +	alloc_bootmem_cpumask_var(&full_nohz_mask);
> +	have_full_nohz_mask = true;
> +	cpulist_parse(str, full_nohz_mask);

Don't you want to check retval of cpulist_parse first here before
assigning have_full_nohz_mask and allocating cpumask var?

We don't trust userspace, you know.

> +	return 1;
> +}
> +__setup("full_nohz=", tick_nohz_full_setup);

I'd guess this kernel parameter needs to go into
Documentation/kernel-parameters.txt along with a referral to
Documentation/cputopology.txt which explains how to specify cpulists for
n00bs like me :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
