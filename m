Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaL2MZB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 07:25:01 -0500
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:50292 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbaL2MY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 07:24:59 -0500
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Stephen Boyd <sboyd@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>,
        "ddaney.cavm@gmail.com" <ddaney.cavm@gmail.com>,
        "mbohan@codeaurora.org" <mbohan@codeaurora.org>,
        "david.vrabel@citrix.com" <david.vrabel@citrix.com>,
        "david.engraf@sysgo.com" <david.engraf@sysgo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <549DF089.5050201@codeaurora.org>
References: <1395067037-20060-1-git-send-email-stfomichev@yandex-team.ru> <alpine.DEB.2.02.1403191149460.18573@ionos.tec.linutronix.de> <20140319141615.GB11081@stfomichev-desktop.yandex.net> <alpine.DEB.2.10.1406221417510.5170@nanos> <549DF089.5050201@codeaurora.org>
Subject: Re: [PATCH v2] hrtimers: calculate expires_next after all timers are executed
MIME-Version: 1.0
Message-Id: <88351419855894@webcorp01h.yandex-team.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 29 Dec 2014 15:24:54 +0300
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, Thomas didn't yet push the fix.

27.12.2014, 02:34, "Stephen Boyd" <sboyd@codeaurora.org>:
> On 06/22/2014 07:46 AM, Thomas Gleixner wrote:
>>> š+ for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
>>> š+ ktime_t expires;
>> šSo this adds the third incarnation of finding the next expiring timer
>> što the code. Not really helpful.
>>
>> šUntested patch which addresses the issues below.
>
> We think we're running into the same issue that's fixed by this patch,
> but the occurrence is very rare so reproducing is hard. Did this ever go
> anywhere?
>> š-------------------->
>> ššinclude/linux/hrtimer.h | ššš2
>> šškernel/hrtimer.c ššššššš| š162 ++++++++++++++++++++++++++----------------------
>> šš2 files changed, 90 insertions(+), 74 deletions(-)
>>
>> šIndex: linux/include/linux/hrtimer.h
>> š===================================================================
>> š--- linux.orig/include/linux/hrtimer.h
>> š+++ linux/include/linux/hrtimer.h
>> š@@ -141,6 +141,7 @@ struct hrtimer_sleeper {
>> ššš* @get_time: function to retrieve the current time of the clock
>> ššš* @softirq_time: the time when running the hrtimer queue in the softirq
>> ššš* @offset: offset of this clock to the monotonic base
>> š+ * @expires_next: absolute time of the next event on this clock base
>> ššš*/
>> ššstruct hrtimer_clock_base {
>> ššššššššššstruct hrtimer_cpu_base *cpu_base;
>> š@@ -151,6 +152,7 @@ struct hrtimer_clock_base {
>> ššššššššššktime_t (*get_time)(void);
>> ššššššššššktime_t softirq_time;
>> ššššššššššktime_t offset;
>> š+ ktime_t expires_next;
>> šš};
>>
>> ššenum šhrtimer_base_type {
>> šIndex: linux/kernel/hrtimer.c
>> š===================================================================
>> š--- linux.orig/kernel/hrtimer.c
>> š+++ linux/kernel/hrtimer.c
>> š@@ -494,6 +494,36 @@ static inline void debug_deactivate(stru
>> šššššššššštrace_hrtimer_cancel(timer);
>> šš}
>>
>> š+/*
>> š+ * Find the next expiring timer and return the expiry in absolute
>> š+ * CLOCK_MONOTONIC time.
>> š+ */
>> š+static ktime_t hrtimer_get_expires_next(struct hrtimer_cpu_base *cpu_base)
>> š+{
>> š+ ktime_t expires, expires_next = { .tv64 = KTIME_MAX };
>> š+ unsigned long idx, active = cpu_base->active_bases;
>> š+ struct hrtimer_clock_base *base;
>> š+
>> š+ while (active) {
>> š+ idx = __ffs(active);
>> š+ active &= ~(1UL << idx);
>> š+
>> š+ base = cpu_base->clock_base + idx;
>> š+ /* Adjust to CLOCK_MONOTONIC */
>> š+ expires = ktime_sub(base->expires_next, base->offset);
>> š+
>> š+ if (expires.tv64 < expires_next.tv64)
>> š+ expires_next = expires;
>> š+ }
>> š+ /*
>> š+ * If clock_was_set() has changed base->offset the result
>> š+ * might be negative. Fix it up to prevent a false positive in
>> š+ * clockevents_program_event()
>> š+ */
>> š+ expires.tv64 = 0;
>> š+ return expires_next.tv64 < 0 ? expires : expires_next;
>> š+}
>> š+
>> šš/* High resolution timer related functions */
>> šš#ifdef CONFIG_HIGH_RES_TIMERS
>>
>> š@@ -542,32 +572,7 @@ static inline int hrtimer_hres_active(vo
>> ššstatic void
>> ššhrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
>> šš{
>> š- int i;
>> š- struct hrtimer_clock_base *base = cpu_base->clock_base;
>> š- ktime_t expires, expires_next;
>> š-
>> š- expires_next.tv64 = KTIME_MAX;
>> š-
>> š- for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
>> š- struct hrtimer *timer;
>> š- struct timerqueue_node *next;
>> š-
>> š- next = timerqueue_getnext(&base->active);
>> š- if (!next)
>> š- continue;
>> š- timer = container_of(next, struct hrtimer, node);
>> š-
>> š- expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
>> š- /*
>> š- * clock_was_set() has changed base->offset so the
>> š- * result might be negative. Fix it up to prevent a
>> š- * false positive in clockevents_program_event()
>> š- */
>> š- if (expires.tv64 < 0)
>> š- expires.tv64 = 0;
>> š- if (expires.tv64 < expires_next.tv64)
>> š- expires_next = expires;
>> š- }
>> š+ ktime_t expires_next = hrtimer_get_expires_next(cpu_base);
>>
>> ššššššššššif (skip_equal && expires_next.tv64 == cpu_base->expires_next.tv64)
>> ššššššššššššššššššreturn;
>> š@@ -891,6 +896,8 @@ EXPORT_SYMBOL_GPL(hrtimer_forward);
>> ššstatic int enqueue_hrtimer(struct hrtimer *timer,
>> šššššššššššššššššššššššššššššstruct hrtimer_clock_base *base)
>> šš{
>> š+ int leftmost;
>> š+
>> ššššššššššdebug_activate(timer);
>>
>> šššššššššštimerqueue_add(&base->active, &timer->node);
>> š@@ -902,7 +909,13 @@ static int enqueue_hrtimer(struct hrtime
>> ššššššššššš*/
>> šššššššššštimer->state |= HRTIMER_STATE_ENQUEUED;
>>
>> š- return (&timer->node == base->active.next);
>> š+ leftmost = &timer->node == base->active.next;
>> š+ /*
>> š+ * If the new timer is the leftmost, update clock_base->expires_next.
>> š+ */
>> š+ if (leftmost)
>> š+ base->expires_next = hrtimer_get_expires(timer);
>> š+ return leftmost;
>> šš}
>>
>> šš/*
>> š@@ -919,27 +932,45 @@ static void __remove_hrtimer(struct hrti
>> šššššššššššššššššššššššššššššššstruct hrtimer_clock_base *base,
>> šššššššššššššššššššššššššššššššunsigned long newstate, int reprogram)
>> šš{
>> š- struct timerqueue_node *next_timer;
>> š+ struct timerqueue_node *next;
>> š+ struct hrtimer *next_timer;
>> š+ bool first;
>> š+
>> ššššššššššif (!(timer->state & HRTIMER_STATE_ENQUEUED))
>> ššššššššššššššššššgoto out;
>>
>> š- next_timer = timerqueue_getnext(&base->active);
>> š+ /*
>> š+ * If this is not the first timer of the clock base, we just
>> š+ * remove it. No updates, no reprogramming.
>> š+ */
>> š+ first = timerqueue_getnext(&base->active) == &timer->node;
>> šššššššššštimerqueue_del(&base->active, &timer->node);
>> š- if (&timer->node == next_timer) {
>> š+ if (!first)
>> š+ goto out;
>> š+
>> š+ /*
>> š+ * Update cpu base and clock base. This needs to be done
>> š+ * before calling into hrtimer_force_reprogram() as that
>> š+ * relies on active_bases and expires_next.
>> š+ */
>> š+ next = timerqueue_getnext(&base->active);
>> š+ if (!next) {
>> š+ base->cpu_base->active_bases &= ~(1 << base->index);
>> š+ base->expires_next.tv64 = KTIME_MAX;
>> š+ } else {
>> š+ next_timer = container_of(next, struct hrtimer, node);
>> š+ base->expires_next = hrtimer_get_expires(next_timer);
>> š+ }
>> š+
>> šš#ifdef CONFIG_HIGH_RES_TIMERS
>> š- /* Reprogram the clock event device. if enabled */
>> š- if (reprogram && hrtimer_hres_active()) {
>> š- ktime_t expires;
>> š-
>> š- expires = ktime_sub(hrtimer_get_expires(timer),
>> š- šššbase->offset);
>> š- if (base->cpu_base->expires_next.tv64 == expires.tv64)
>> š- hrtimer_force_reprogram(base->cpu_base, 1);
>> š- }
>> š-#endif
>> š+ if (reprogram && hrtimer_hres_active()) {
>> š+ ktime_t expires;
>> š+
>> š+ expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
>> š+ if (base->cpu_base->expires_next.tv64 == expires.tv64)
>> š+ hrtimer_force_reprogram(base->cpu_base, 1);
>> šššššššššš}
>> š- if (!timerqueue_getnext(&base->active))
>> š- base->cpu_base->active_bases &= ~(1 << base->index);
>> š+#endif
>> ššout:
>> šššššššššštimer->state = newstate;
>> šš}
>> š@@ -1154,35 +1185,21 @@ EXPORT_SYMBOL_GPL(hrtimer_get_remaining)
>> ššktime_t hrtimer_get_next_event(void)
>> šš{
>> ššššššššššstruct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
>> š- struct hrtimer_clock_base *base = cpu_base->clock_base;
>> š- ktime_t delta, mindelta = { .tv64 = KTIME_MAX };
>> š+ ktime_t next, delta = { .tv64 = KTIME_MAX };
>> ššššššššššunsigned long flags;
>> š- int i;
>>
>> ššššššššššraw_spin_lock_irqsave(&cpu_base->lock, flags);
>>
>> ššššššššššif (!hrtimer_hres_active()) {
>> š- for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
>> š- struct hrtimer *timer;
>> š- struct timerqueue_node *next;
>> š-
>> š- next = timerqueue_getnext(&base->active);
>> š- if (!next)
>> š- continue;
>> š-
>> š- timer = container_of(next, struct hrtimer, node);
>> š- delta.tv64 = hrtimer_get_expires_tv64(timer);
>> š- delta = ktime_sub(delta, base->get_time());
>> š- if (delta.tv64 < mindelta.tv64)
>> š- mindelta.tv64 = delta.tv64;
>> š- }
>> š+ next = hrtimer_get_expires_next(cpu_base);
>> š+ delta = ktime_sub(next, ktime_get());
>> š+ if (delta.tv64 < 0)
>> š+ delta.tv64 = 0;
>> šššššššššš}
>>
>> ššššššššššraw_spin_unlock_irqrestore(&cpu_base->lock, flags);
>>
>> š- if (mindelta.tv64 < 0)
>> š- mindelta.tv64 = 0;
>> š- return mindelta;
>> š+ return delta;
>> šš}
>> šš#endif
>>
>> š@@ -1292,6 +1309,7 @@ static void __run_hrtimer(struct hrtimer
>> ššš*/
>> ššvoid hrtimer_interrupt(struct clock_event_device *dev)
>> šš{
>> š+ struct hrtimer_clock_base *base;
>> ššššššššššstruct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
>> ššššššššššktime_t expires_next, now, entry_time, delta;
>> ššššššššššint i, retries = 0;
>> š@@ -1303,7 +1321,6 @@ void hrtimer_interrupt(struct clock_even
>> ššššššššššraw_spin_lock(&cpu_base->lock);
>> ššššššššššentry_time = now = hrtimer_update_base(cpu_base);
>> ššretry:
>> š- expires_next.tv64 = KTIME_MAX;
>> šššššššššš/*
>> ššššššššššš* We set expires_next to KTIME_MAX here with cpu_base->lock
>> ššššššššššš* held to prevent that a timer is enqueued in our queue via
>> š@@ -1314,7 +1331,6 @@ retry:
>> ššššššššššcpu_base->expires_next.tv64 = KTIME_MAX;
>>
>> ššššššššššfor (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
>> š- struct hrtimer_clock_base *base;
>> ššššššššššššššššššstruct timerqueue_node *node;
>> ššššššššššššššššššktime_t basenow;
>>
>> š@@ -1342,23 +1358,20 @@ retry:
>> ššššššššššššššššššššššššššš* timer will have to trigger a wakeup anyway.
>> ššššššššššššššššššššššššššš*/
>>
>> š- if (basenow.tv64 < hrtimer_get_softexpires_tv64(timer)) {
>> š- ktime_t expires;
>> š-
>> š- expires = ktime_sub(hrtimer_get_expires(timer),
>> š- šššbase->offset);
>> š- if (expires.tv64 < 0)
>> š- expires.tv64 = KTIME_MAX;
>> š- if (expires.tv64 < expires_next.tv64)
>> š- expires_next = expires;
>> š+ if (basenow.tv64 < hrtimer_get_softexpires_tv64(timer))
>> ššššššššššššššššššššššššššššššššššbreak;
>> š- }
>>
>> šššššššššššššššššššššššššš__run_hrtimer(timer, &basenow);
>> šššššššššššššššššš}
>> šššššššššš}
>>
>> šššššššššš/*
>> š+ * We might have dropped cpu_base->lock and the callbacks
>> š+ * might have added timers. Find the timer which expires first.
>> š+ */
>> š+ expires_next = hrtimer_get_expires_next(cpu_base);
>> š+
>> š+ /*
>> ššššššššššš* Store the new expiry value so the migration code can verify
>> ššššššššššš* against it.
>> ššššššššššš*/
>> š@@ -1678,6 +1691,7 @@ static void init_hrtimers_cpu(int cpu)
>> ššššššššššfor (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
>> ššššššššššššššššššcpu_base->clock_base[i].cpu_base = cpu_base;
>> šššššššššššššššššštimerqueue_init_head(&cpu_base->clock_base[i].active);
>> š+ cpu_base->clock_base[i].expires_next.tv64 = KTIME_MAX;
>> šššššššššš}
>>
>> ššššššššššhrtimer_init_hres(cpu_base);
>
> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> a Linux Foundation Collaborative Project
