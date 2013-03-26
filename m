Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab3CZVte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 17:49:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:59397 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab3CZVtd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 17:49:33 -0400
Date: Tue, 26 Mar 2013 22:49:32 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>
Subject: Re: Fixup for 3.4.34 merge conflict
Message-ID: <20130326214932.GD14220@linutronix.de>
References: <1363711834.5938.39.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1363711834.5938.39.camel@gandalf.local.home>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt | 2013-03-19 12:50:34 [-0400]:

>@@ -1054,19 +1032,39 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
> 	 *
> 	 * XXX send_remote_softirq() ?
> 	 */
>-	if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases)) {
>-		ret = hrtimer_enqueue_reprogram(timer, new_base, wakeup);
>-		if (ret) {
>+	if (leftmost && new_base->cpu_base == &__get_cpu_var(hrtimer_bases)
>+		&& hrtimer_enqueue_reprogram(timer, new_base)) {
>+
>+		if (wakeup
>+#ifdef CONFIG_PREEMPT_RT_BASE
>+		    /*
>+		     * Move softirq based timers away from the rbtree in
>+		     * case it expired already. Otherwise we would have a
>+		     * stale base->first entry until the softirq runs.
>+		     */
>+		    && hrtimer_rt_defer(timer)
>+#endif
>+			) {
> 			/*
>-			 * In case we failed to reprogram the timer (mostly
>-			 * because out current timer is already elapsed),
>-			 * remove it again and report a failure. This avoids
>-			 * stale base->first entries.
>+			 * We need to drop cpu_base->lock to avoid a
>+			 * lock ordering issue vs. rq->lock.
> 			 */
>-			debug_deactivate(timer);
>-			__remove_hrtimer(timer, new_base,
>-					timer->state & HRTIMER_STATE_CALLBACK, 0);
>+			raw_spin_unlock(&new_base->cpu_base->lock);
>+			raise_softirq_irqoff(HRTIMER_SOFTIRQ);
>+			local_irq_restore(flags);
>+			return ret;

Hmmm. Your ret here might be 0 or 1. RT did return here always zero
unless it returned -ETIME. This is what I did for v3.8 but I don't claim
to be correct here. Need to re-check this later…

Sebastian
