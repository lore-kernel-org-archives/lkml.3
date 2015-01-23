Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbbAWLDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 06:03:46 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51095 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbbAWLDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 06:03:42 -0500
Date: Fri, 23 Jan 2015 12:03:35 +0100
From: Borislav Petkov <bp@alien8.de>
To: Calvin Owens <calvinowens@fb.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>
Subject: Re: [PATCH] x86: mce: Avoid timer double-add during CMCI interrupt
 storms.
Message-ID: <20150123110335.GC22635@pd.tnic>
References: <1417746575-23299-1-git-send-email-calvinowens@fb.com>
 <20141209180835.GF3990@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F329640BC@ORSMSX114.amr.corp.intel.com>
 <20141210031102.GB1437888@mail.thefacebook.com>
 <20141210192340.GF17053@pd.tnic>
 <20141211023438.GA3239919@mail.thefacebook.com>
 <20141211144313.GB31140@pd.tnic>
 <20141217001711.GA7152@mail.thefacebook.com>
 <20141217211912.GC8457@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141217211912.GC8457@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 10:19:12PM +0100, Borislav Petkov wrote:
> Ok, thanks. I'll try to give it a run once I get a quiet minute from
> all the CVE fun recently.

Ok, I think we have something which shapes up to be a good
simplification for the storm code and cleans up a bunch of stuff in that
area, see below.

I've uploaded it as a branch if you want to give it a run as there are
other changes to MCE pending for 3.20 which might cause merge conflicts:

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git, branch mce-fb

Shout if there are some issues remaining not addressed.

Thanks.

---
From: Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86, MCE: Cleanup CMCI storm logic

Initially, this started with the yet another report about a race
condition in the CMCI storm adaptive period length thing. Yes, we have
to admit, it is fragile and error prone. So let's simplify it.

The simpler logic is: now, after we enter storm mode, we go straight to
polling with CMCI_STORM_INTERVAL, i.e. once a second. We remain in storm
mode as long as we see errors being logged while polling.

Theoretically, if we see an uninterrupted error stream, we will remain
in storm mode indefinitely and keep polling the MSRs.

However, when the storm is actually a burst of errors, once we have
logged them all, we back out of it after ~5 mins of polling and no more
errors logged.

Making machine_check_poll() return a bool and denoting whether it has
seen an error or not lets us simplify a bunch of code and move the storm
handling private to mce_intel.c.

Some minor cleanups while at it.

Reported-by: Calvin Owens <calvinowens@fb.com>
Link: http://lkml.kernel.org/r/https://lkml.kernel.org/r/1417746575-23299-1-git-send-email-calvinowens@fb.com
Signed-off-by: Tony Luck <tony.luck@intel.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/mce.h                |  8 +--
 arch/x86/kernel/cpu/mcheck/mce-internal.h |  9 ++--
 arch/x86/kernel/cpu/mcheck/mce.c          | 86 ++++++++++++++++---------------
 arch/x86/kernel/cpu/mcheck/mce_intel.c    | 63 ++++++++++++++--------
 4 files changed, 96 insertions(+), 70 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 9b3de99dc004..fd38a23e729f 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -183,11 +183,11 @@ typedef DECLARE_BITMAP(mce_banks_t, MAX_NR_BANKS);
 DECLARE_PER_CPU(mce_banks_t, mce_poll_banks);
 
 enum mcp_flags {
-	MCP_TIMESTAMP = (1 << 0),	/* log time stamp */
-	MCP_UC = (1 << 1),		/* log uncorrected errors */
-	MCP_DONTLOG = (1 << 2),		/* only clear, don't log */
+	MCP_TIMESTAMP	= BIT(0),	/* log time stamp */
+	MCP_UC		= BIT(1),	/* log uncorrected errors */
+	MCP_DONTLOG	= BIT(2),	/* only clear, don't log */
 };
-void machine_check_poll(enum mcp_flags flags, mce_banks_t *b);
+bool machine_check_poll(enum mcp_flags flags, mce_banks_t *b);
 
 int mce_notify_irq(void);
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index 10b46906767f..e12f0bfb45c1 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -14,6 +14,7 @@ enum severity_level {
 };
 
 #define ATTR_LEN		16
+#define INITIAL_CHECK_INTERVAL	5 * 60 /* 5 minutes */
 
 /* One object for each MCE bank, shared by all CPUs */
 struct mce_bank {
@@ -30,13 +31,13 @@ extern struct mce_bank *mce_banks;
 extern mce_banks_t mce_banks_ce_disabled;
 
 #ifdef CONFIG_X86_MCE_INTEL
-unsigned long mce_intel_adjust_timer(unsigned long interval);
-void mce_intel_cmci_poll(void);
+unsigned long cmci_intel_adjust_timer(unsigned long interval);
+bool mce_intel_cmci_poll(void);
 void mce_intel_hcpu_update(unsigned long cpu);
 void cmci_disable_bank(int bank);
 #else
-# define mce_intel_adjust_timer mce_adjust_timer_default
-static inline void mce_intel_cmci_poll(void) { }
+# define cmci_intel_adjust_timer mce_adjust_timer_default
+static inline bool mce_intel_cmci_poll(void) { return false; }
 static inline void mce_intel_hcpu_update(unsigned long cpu) { }
 static inline void cmci_disable_bank(int bank) { }
 #endif
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d23179900755..410807be1a6c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -59,7 +59,7 @@ static DEFINE_MUTEX(mce_chrdev_read_mutex);
 #define CREATE_TRACE_POINTS
 #include <trace/events/mce.h>
 
-#define SPINUNIT 100	/* 100ns */
+#define SPINUNIT		100	/* 100ns */
 
 DEFINE_PER_CPU(unsigned, mce_exception_count);
 
@@ -88,9 +88,6 @@ static DECLARE_WAIT_QUEUE_HEAD(mce_chrdev_wait);
 static DEFINE_PER_CPU(struct mce, mces_seen);
 static int			cpu_missing;
 
-/* CMCI storm detection filter */
-static DEFINE_PER_CPU(unsigned long, mce_polled_error);
-
 /*
  * MCA banks polled by the period polling timer for corrected events.
  * With Intel CMCI, this only has MCA banks which do not support CMCI (if any).
@@ -624,8 +621,9 @@ DEFINE_PER_CPU(unsigned, mce_poll_count);
  * is already totally * confused. In this case it's likely it will
  * not fully execute the machine check handler either.
  */
-void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
+bool machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 {
+	bool error_logged = false;
 	struct mce m;
 	int severity;
 	int i;
@@ -648,7 +646,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		if (!(m.status & MCI_STATUS_VAL))
 			continue;
 
-		this_cpu_write(mce_polled_error, 1);
+
 		/*
 		 * Uncorrected or signalled events are handled by the exception
 		 * handler when it is enabled, so don't process those here.
@@ -681,8 +679,10 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		 * Don't get the IP here because it's unlikely to
 		 * have anything to do with the actual error location.
 		 */
-		if (!(flags & MCP_DONTLOG) && !mca_cfg.dont_log_ce)
+		if (!(flags & MCP_DONTLOG) && !mca_cfg.dont_log_ce) {
+			error_logged = true;
 			mce_log(&m);
+		}
 
 		/*
 		 * Clear state for this bank.
@@ -696,6 +696,8 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 	 */
 
 	sync_core();
+
+	return error_logged;
 }
 EXPORT_SYMBOL_GPL(machine_check_poll);
 
@@ -1257,7 +1259,7 @@ void mce_log_therm_throt_event(__u64 status)
  * poller finds an MCE, poll 2x faster.  When the poller finds no more
  * errors, poll 2x slower (up to check_interval seconds).
  */
-static unsigned long check_interval = 5 * 60; /* 5 minutes */
+static unsigned long check_interval = INITIAL_CHECK_INTERVAL;
 
 static DEFINE_PER_CPU(unsigned long, mce_next_interval); /* in jiffies */
 static DEFINE_PER_CPU(struct timer_list, mce_timer);
@@ -1267,49 +1269,57 @@ static unsigned long mce_adjust_timer_default(unsigned long interval)
 	return interval;
 }
 
-static unsigned long (*mce_adjust_timer)(unsigned long interval) =
-	mce_adjust_timer_default;
+static unsigned long (*mce_adjust_timer)(unsigned long interval) = mce_adjust_timer_default;
 
-static int cmc_error_seen(void)
+static void __restart_timer(struct timer_list *t, unsigned long interval)
 {
-	unsigned long *v = this_cpu_ptr(&mce_polled_error);
+	unsigned long when = jiffies + interval;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	if (timer_pending(t)) {
+		if (time_before(when, t->expires))
+			mod_timer_pinned(t, when);
+	} else {
+		t->expires = round_jiffies(when);
+		add_timer_on(t, smp_processor_id());
+	}
 
-	return test_and_clear_bit(0, v);
+	local_irq_restore(flags);
 }
 
 static void mce_timer_fn(unsigned long data)
 {
 	struct timer_list *t = this_cpu_ptr(&mce_timer);
+	int cpu = smp_processor_id();
 	unsigned long iv;
-	int notify;
 
-	WARN_ON(smp_processor_id() != data);
+	WARN_ON(cpu != data);
+
+	iv = __this_cpu_read(mce_next_interval);
 
 	if (mce_available(this_cpu_ptr(&cpu_info))) {
-		machine_check_poll(MCP_TIMESTAMP,
-				this_cpu_ptr(&mce_poll_banks));
-		mce_intel_cmci_poll();
+		machine_check_poll(MCP_TIMESTAMP, this_cpu_ptr(&mce_poll_banks));
+
+		if (mce_intel_cmci_poll()) {
+			iv = mce_adjust_timer(iv);
+			goto done;
+		}
 	}
 
 	/*
-	 * Alert userspace if needed.  If we logged an MCE, reduce the
-	 * polling interval, otherwise increase the polling interval.
+	 * Alert userspace if needed. If we logged an MCE, reduce the polling
+	 * interval, otherwise increase the polling interval.
 	 */
-	iv = __this_cpu_read(mce_next_interval);
-	notify = mce_notify_irq();
-	notify |= cmc_error_seen();
-	if (notify) {
+	if (mce_notify_irq())
 		iv = max(iv / 2, (unsigned long) HZ/100);
-	} else {
+	else
 		iv = min(iv * 2, round_jiffies_relative(check_interval * HZ));
-		iv = mce_adjust_timer(iv);
-	}
+
+done:
 	__this_cpu_write(mce_next_interval, iv);
-	/* Might have become 0 after CMCI storm subsided */
-	if (iv) {
-		t->expires = jiffies + iv;
-		add_timer_on(t, smp_processor_id());
-	}
+	__restart_timer(t, iv);
 }
 
 /*
@@ -1318,16 +1328,10 @@ static void mce_timer_fn(unsigned long data)
 void mce_timer_kick(unsigned long interval)
 {
 	struct timer_list *t = this_cpu_ptr(&mce_timer);
-	unsigned long when = jiffies + interval;
 	unsigned long iv = __this_cpu_read(mce_next_interval);
 
-	if (timer_pending(t)) {
-		if (time_before(when, t->expires))
-			mod_timer_pinned(t, when);
-	} else {
-		t->expires = round_jiffies(when);
-		add_timer_on(t, smp_processor_id());
-	}
+	__restart_timer(t, interval);
+
 	if (interval < iv)
 		__this_cpu_write(mce_next_interval, interval);
 }
@@ -1628,7 +1632,7 @@ static void __mcheck_cpu_init_vendor(struct cpuinfo_x86 *c)
 	switch (c->x86_vendor) {
 	case X86_VENDOR_INTEL:
 		mce_intel_feature_init(c);
-		mce_adjust_timer = mce_intel_adjust_timer;
+		mce_adjust_timer = cmci_intel_adjust_timer;
 		break;
 	case X86_VENDOR_AMD:
 		mce_amd_feature_init(c);
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index b3c97bafc123..b4a41cf030ed 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -39,6 +39,15 @@
 static DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);
 
 /*
+ * CMCI storm detection backoff counter
+ *
+ * During storm, we reset this counter to INITIAL_CHECK_INTERVAL in case we've
+ * encountered an error. If not, we decrement it by one. We signal the end of
+ * the CMCI storm when it reaches 0.
+ */
+static DEFINE_PER_CPU(int, cmci_backoff_cnt);
+
+/*
  * cmci_discover_lock protects against parallel discovery attempts
  * which could race against each other.
  */
@@ -46,7 +55,7 @@ static DEFINE_RAW_SPINLOCK(cmci_discover_lock);
 
 #define CMCI_THRESHOLD		1
 #define CMCI_POLL_INTERVAL	(30 * HZ)
-#define CMCI_STORM_INTERVAL	(1 * HZ)
+#define CMCI_STORM_INTERVAL	(HZ)
 #define CMCI_STORM_THRESHOLD	15
 
 static DEFINE_PER_CPU(unsigned long, cmci_time_stamp);
@@ -82,11 +91,21 @@ static int cmci_supported(int *banks)
 	return !!(cap & MCG_CMCI_P);
 }
 
-void mce_intel_cmci_poll(void)
+bool mce_intel_cmci_poll(void)
 {
 	if (__this_cpu_read(cmci_storm_state) == CMCI_STORM_NONE)
-		return;
-	machine_check_poll(MCP_TIMESTAMP, this_cpu_ptr(&mce_banks_owned));
+		return false;
+
+	/*
+	 * Reset the counter if we've logged an error in the last poll
+	 * during the storm.
+	 */
+	if (machine_check_poll(MCP_TIMESTAMP, this_cpu_ptr(&mce_banks_owned)))
+		this_cpu_write(cmci_backoff_cnt, INITIAL_CHECK_INTERVAL);
+	else
+		this_cpu_dec(cmci_backoff_cnt);
+
+	return true;
 }
 
 void mce_intel_hcpu_update(unsigned long cpu)
@@ -97,31 +116,32 @@ void mce_intel_hcpu_update(unsigned long cpu)
 	per_cpu(cmci_storm_state, cpu) = CMCI_STORM_NONE;
 }
 
-unsigned long mce_intel_adjust_timer(unsigned long interval)
+unsigned long cmci_intel_adjust_timer(unsigned long interval)
 {
-	int r;
-
-	if (interval < CMCI_POLL_INTERVAL)
-		return interval;
+	if ((this_cpu_read(cmci_backoff_cnt) > 0) &&
+	    (__this_cpu_read(cmci_storm_state) == CMCI_STORM_ACTIVE)) {
+		mce_notify_irq();
+		return CMCI_STORM_INTERVAL;
+	}
 
 	switch (__this_cpu_read(cmci_storm_state)) {
 	case CMCI_STORM_ACTIVE:
+
 		/*
 		 * We switch back to interrupt mode once the poll timer has
-		 * silenced itself. That means no events recorded and the
-		 * timer interval is back to our poll interval.
+		 * silenced itself. That means no events recorded and the timer
+		 * interval is back to our poll interval.
 		 */
 		__this_cpu_write(cmci_storm_state, CMCI_STORM_SUBSIDED);
-		r = atomic_sub_return(1, &cmci_storm_on_cpus);
-		if (r == 0)
+		if (!atomic_sub_return(1, &cmci_storm_on_cpus))
 			pr_notice("CMCI storm subsided: switching to interrupt mode\n");
+
 		/* FALLTHROUGH */
 
 	case CMCI_STORM_SUBSIDED:
 		/*
-		 * We wait for all cpus to go back to SUBSIDED
-		 * state. When that happens we switch back to
-		 * interrupt mode.
+		 * We wait for all CPUs to go back to SUBSIDED state. When that
+		 * happens we switch back to interrupt mode.
 		 */
 		if (!atomic_read(&cmci_storm_on_cpus)) {
 			__this_cpu_write(cmci_storm_state, CMCI_STORM_NONE);
@@ -130,10 +150,8 @@ unsigned long mce_intel_adjust_timer(unsigned long interval)
 		}
 		return CMCI_POLL_INTERVAL;
 	default:
-		/*
-		 * We have shiny weather. Let the poll do whatever it
-		 * thinks.
-		 */
+
+		/* We have shiny weather. Let the poll do whatever it thinks. */
 		return interval;
 	}
 }
@@ -178,7 +196,8 @@ static bool cmci_storm_detect(void)
 	cmci_storm_disable_banks();
 	__this_cpu_write(cmci_storm_state, CMCI_STORM_ACTIVE);
 	r = atomic_add_return(1, &cmci_storm_on_cpus);
-	mce_timer_kick(CMCI_POLL_INTERVAL);
+	mce_timer_kick(CMCI_STORM_INTERVAL);
+	this_cpu_write(cmci_backoff_cnt, INITIAL_CHECK_INTERVAL);
 
 	if (r == 1)
 		pr_notice("CMCI storm detected: switching to poll mode\n");
@@ -195,6 +214,7 @@ static void intel_threshold_interrupt(void)
 {
 	if (cmci_storm_detect())
 		return;
+
 	machine_check_poll(MCP_TIMESTAMP, this_cpu_ptr(&mce_banks_owned));
 	mce_notify_irq();
 }
@@ -286,6 +306,7 @@ void cmci_recheck(void)
 
 	if (!mce_available(raw_cpu_ptr(&cpu_info)) || !cmci_supported(&banks))
 		return;
+
 	local_irq_save(flags);
 	machine_check_poll(MCP_TIMESTAMP, this_cpu_ptr(&mce_banks_owned));
 	local_irq_restore(flags);
-- 
2.2.0.33.gc18b867

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
