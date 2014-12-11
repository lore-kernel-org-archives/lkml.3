Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933614AbaLKCfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 21:35:17 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62416 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933176AbaLKCfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 21:35:15 -0500
Date: Wed, 10 Dec 2014 18:34:38 -0800
From: Calvin Owens <calvinowens@fb.com>
To: Borislav Petkov <bp@alien8.de>
CC: "Luck, Tony" <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>
Subject: Re: [PATCH] x86: mce: Avoid timer double-add during CMCI interrupt
 storms.
Message-ID: <20141211023438.GA3239919@mail.thefacebook.com>
References: <1417746575-23299-1-git-send-email-calvinowens@fb.com>
 <20141209180835.GF3990@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F329640BC@ORSMSX114.amr.corp.intel.com>
 <20141210031102.GB1437888@mail.thefacebook.com>
 <20141210192340.GF17053@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20141210192340.GF17053@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-10_09:2014-12-10,2014-12-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=26.7046773694174
 compositescore=0.928862112264561 urlsuspect_oldscore=0.928862112264561
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.928862112264561 spamscore=0
 recipient_to_sender_domain_totalscore=46 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412110026
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12/10 at 20:23 +0100, Borislav Petkov wrote:
> On Tue, Dec 09, 2014 at 07:11:02PM -0800, Calvin Owens wrote:
> > Just to make sure I understand what you're looking for:
> > 
> > When MCE is initialized, spawn a kthread for each CPU instead of the
> > current timers. If CMCI is supported, we just leave this thread parked,
> > and only process errors from the CMCI interrupt handler.
> > 
> > When a CMCI storm happens, we disable CMCI interrupts and kick the
> > kthread, which polls every HZ/100 until the storm has subsided, at which
> > point it re-enables CMCI interrupts and parks itself.
> > 
> > If CMCI isn't supported though, how is the polling done? You said the
> > dynamic interval is desirable, wouldn't that need to be in the kthread?
> > Having both the kthread and the timer around seems ugly, even if only
> > one is used on a given machine.
> 
> Ok, so in talking with the guys here internally it sounds to me like
> a kernel thread or a workqueue or whatever other facility relying on
> wake_up_process() we take, would have scheduling latency in there and
> get delayed when polling the MCA banks. In a storm condition, this might
> not be such a good idea.
> 
> So we maybe better off with the timer interrupt after all but try
> to decouple the dynamic adjusting of polling frequency for non-CMCI
> machines and do an on/off simpler polling on CMCI machines.
> 
> So what I'm thinking of is:
> 
> * once we've detected CMCI storm, we immediately start polling with
> CMCI_STORM_INTERVAL, i.e. once per second.
> 
> * as long as we keep seeing errors during polling in storm mode, we keep
> that polling frequency.
> 
> * the moment we don't see any errors anymore, we go to
> CMCI_STORM_SUBSIDED and then eventually to CMCI_STORM_NONE.
> 
> The code remains unchanged for CMCI machines which are not in storm
> mode and for non-CMCI machines.
> 
> Anyway, this below is completely untested but it seems simpler to me and
> does away with the adaptive logic for CMCI storms (you might want to
> apply it first as the diff is hardly readable and this code is nasty as
> hell anyway).
> 
> Thoughts?

This doens't fix the original issue though: the timer double-add can
still happen if the CMCI interrupt that hits the STORM threshold pops
off during mce_timer_fn() and calls mce_timer_kick().

The polling is unnecessary on a CMCI-capable machine except in STORMs,
right? Wouldn't it be better to eliminate it in that case?

That said, I ran mce-test with your patch on top of 3.18, looks good
there. But that doesn't simulate CMCI interrupts. 

Thanks,
Calvin

> ---
> diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> index 51b26e895933..1b9733614e4c 100644
> --- a/arch/x86/include/asm/mce.h
> +++ b/arch/x86/include/asm/mce.h
> @@ -108,6 +108,7 @@ struct mca_config {
>  	bool disabled;
>  	bool ser;
>  	bool bios_cmci_threshold;
> +	bool cmci;
>  	u8 banks;
>  	s8 bootlog;
>  	int tolerant;
> diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
> index 10b46906767f..6e4984fc37ce 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
> +++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
> @@ -30,18 +30,19 @@ extern struct mce_bank *mce_banks;
>  extern mce_banks_t mce_banks_ce_disabled;
>  
>  #ifdef CONFIG_X86_MCE_INTEL
> -unsigned long mce_intel_adjust_timer(unsigned long interval);
> +unsigned long cmci_intel_adjust_timer(unsigned long interval);
>  void mce_intel_cmci_poll(void);
>  void mce_intel_hcpu_update(unsigned long cpu);
>  void cmci_disable_bank(int bank);
>  #else
> -# define mce_intel_adjust_timer mce_adjust_timer_default
> +# define cmci_intel_adjust_timer mce_adjust_timer_default
>  static inline void mce_intel_cmci_poll(void) { }
>  static inline void mce_intel_hcpu_update(unsigned long cpu) { }
>  static inline void cmci_disable_bank(int bank) { }
>  #endif
>  
>  void mce_timer_kick(unsigned long interval);
> +int ce_error_seen(void);
>  
>  #ifdef CONFIG_ACPI_APEI
>  int apei_write_mce(struct mce *m);
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index d2c611699cd9..e3f426698164 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1324,7 +1324,7 @@ static unsigned long mce_adjust_timer_default(unsigned long interval)
>  static unsigned long (*mce_adjust_timer)(unsigned long interval) =
>  	mce_adjust_timer_default;
>  
> -static int cmc_error_seen(void)
> +int ce_error_seen(void)
>  {
>  	unsigned long *v = this_cpu_ptr(&mce_polled_error);
>  
> @@ -1334,36 +1334,36 @@ static int cmc_error_seen(void)
>  static void mce_timer_fn(unsigned long data)
>  {
>  	struct timer_list *t = this_cpu_ptr(&mce_timer);
> +	int cpu = smp_processor_id();
>  	unsigned long iv;
> -	int notify;
>  
> -	WARN_ON(smp_processor_id() != data);
> +	WARN_ON(cpu != data);
>  
>  	if (mce_available(this_cpu_ptr(&cpu_info))) {
> -		machine_check_poll(MCP_TIMESTAMP,
> -				this_cpu_ptr(&mce_poll_banks));
> +		machine_check_poll(MCP_TIMESTAMP, this_cpu_ptr(&mce_poll_banks));
>  		mce_intel_cmci_poll();
>  	}
>  
> +	iv = __this_cpu_read(mce_next_interval);
> +
> +	if (mca_cfg.cmci) {
> +		iv = mce_adjust_timer(iv);
> +		goto done;
> +	}
> +
>  	/*
> -	 * Alert userspace if needed.  If we logged an MCE, reduce the
> -	 * polling interval, otherwise increase the polling interval.
> +	 * Alert userspace if needed. If we logged an MCE, reduce the polling
> +	 * interval, otherwise increase the polling interval.
>  	 */
> -	iv = __this_cpu_read(mce_next_interval);
> -	notify = mce_notify_irq();
> -	notify |= cmc_error_seen();
> -	if (notify) {
> +	if (mce_notify_irq())
>  		iv = max(iv / 2, (unsigned long) HZ/100);
> -	} else {
> +	else
>  		iv = min(iv * 2, round_jiffies_relative(check_interval * HZ));
> -		iv = mce_adjust_timer(iv);
> -	}
> +
> +done:
>  	__this_cpu_write(mce_next_interval, iv);
> -	/* Might have become 0 after CMCI storm subsided */
> -	if (iv) {
> -		t->expires = jiffies + iv;
> -		add_timer_on(t, smp_processor_id());
> -	}
> +	t->expires = jiffies + iv;
> +	add_timer_on(t, cpu);
>  }
>  
>  /*
> @@ -1682,7 +1682,7 @@ static void __mcheck_cpu_init_vendor(struct cpuinfo_x86 *c)
>  	switch (c->x86_vendor) {
>  	case X86_VENDOR_INTEL:
>  		mce_intel_feature_init(c);
> -		mce_adjust_timer = mce_intel_adjust_timer;
> +		mce_adjust_timer = cmci_intel_adjust_timer;
>  		break;
>  	case X86_VENDOR_AMD:
>  		mce_amd_feature_init(c);
> diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
> index b3c97bafc123..6b8cbeaaca88 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
> @@ -46,7 +46,7 @@ static DEFINE_RAW_SPINLOCK(cmci_discover_lock);
>  
>  #define CMCI_THRESHOLD		1
>  #define CMCI_POLL_INTERVAL	(30 * HZ)
> -#define CMCI_STORM_INTERVAL	(1 * HZ)
> +#define CMCI_STORM_INTERVAL	(HZ)
>  #define CMCI_STORM_THRESHOLD	15
>  
>  static DEFINE_PER_CPU(unsigned long, cmci_time_stamp);
> @@ -68,6 +68,9 @@ static int cmci_supported(int *banks)
>  	if (mca_cfg.cmci_disabled || mca_cfg.ignore_ce)
>  		return 0;
>  
> +	if (mca_cfg.cmci)
> +		return 1;
> +
>  	/*
>  	 * Vendor check is not strictly needed, but the initial
>  	 * initialization is vendor keyed and this
> @@ -79,7 +82,9 @@ static int cmci_supported(int *banks)
>  		return 0;
>  	rdmsrl(MSR_IA32_MCG_CAP, cap);
>  	*banks = min_t(unsigned, MAX_NR_BANKS, cap & 0xff);
> -	return !!(cap & MCG_CMCI_P);
> +	mca_cfg.cmci = !!(cap & MCG_CMCI_P);
> +
> +	return mca_cfg.cmci;
>  }
>  
>  void mce_intel_cmci_poll(void)
> @@ -97,12 +102,13 @@ void mce_intel_hcpu_update(unsigned long cpu)
>  	per_cpu(cmci_storm_state, cpu) = CMCI_STORM_NONE;
>  }
>  
> -unsigned long mce_intel_adjust_timer(unsigned long interval)
> +unsigned long cmci_intel_adjust_timer(unsigned long interval)
>  {
> -	int r;
> -
> -	if (interval < CMCI_POLL_INTERVAL)
> -		return interval;
> +	if (ce_error_seen() &&
> +	    (__this_cpu_read(cmci_storm_state) == CMCI_STORM_ACTIVE)) {
> +		mce_notify_irq();
> +		return CMCI_STORM_INTERVAL;
> +	}
>  
>  	switch (__this_cpu_read(cmci_storm_state)) {
>  	case CMCI_STORM_ACTIVE:
> @@ -112,8 +118,7 @@ unsigned long mce_intel_adjust_timer(unsigned long interval)
>  		 * timer interval is back to our poll interval.
>  		 */
>  		__this_cpu_write(cmci_storm_state, CMCI_STORM_SUBSIDED);
> -		r = atomic_sub_return(1, &cmci_storm_on_cpus);
> -		if (r == 0)
> +		if (!atomic_sub_return(1, &cmci_storm_on_cpus))
>  			pr_notice("CMCI storm subsided: switching to interrupt mode\n");
>  		/* FALLTHROUGH */
>  
> @@ -178,7 +183,7 @@ static bool cmci_storm_detect(void)
>  	cmci_storm_disable_banks();
>  	__this_cpu_write(cmci_storm_state, CMCI_STORM_ACTIVE);
>  	r = atomic_add_return(1, &cmci_storm_on_cpus);
> -	mce_timer_kick(CMCI_POLL_INTERVAL);
> +	mce_timer_kick(CMCI_STORM_INTERVAL);
>  
>  	if (r == 1)
>  		pr_notice("CMCI storm detected: switching to poll mode\n");
> 
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
