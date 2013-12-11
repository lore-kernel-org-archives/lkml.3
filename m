Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab3LKMaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:30:10 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56805 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab3LKMaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:30:07 -0500
Message-ID: <1386764955.12005.60.camel@marge.simpson.net>
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <lenb@kernel.org>, Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Date: Wed, 11 Dec 2013 13:29:15 +0100
In-Reply-To: <20131211115239.GA21999@twins.programming.kicks-ass.net>
References: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>
	 <1386478624.4748.19.camel@marge.simpson.net>
	 <CAJvTdKn_2mihtMLiQVNCOp_zokx8CsSr2c5NhbkbfJ-qvma-8Q@mail.gmail.com>
	 <1386559014.4875.16.camel@marge.simpson.net>
	 <1386652637.5374.72.camel@marge.simpson.net>
	 <alpine.DEB.2.02.1312101458040.28330@ionos.tec.linutronix.de>
	 <alpine.DEB.2.02.1312110030330.28330@ionos.tec.linutronix.de>
	 <1386732093.5964.6.camel@marge.simpson.net>
	 <alpine.DEB.2.02.1312111206200.28330@ionos.tec.linutronix.de>
	 <20131211113839.GF21683@pd.tnic>
	 <20131211115239.GA21999@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:Cgb5Nj1ychgZfSQeNzN5wFPSMH44bM/bje2MlSrjFfb
 uFcGH/I73BCQNNRfBvmfG93cNVWXiefVAvXbl5qMBBAh7miyxZ
 NQ0O11N0SM7zUCrB2Fc+K6HxIRHuXokQjFtXzRuBFjgY3fhDCn
 pvKNBLDSbhzRa+jrCCd0lXGulJFeQKFU05YQ+gyRrZihlN0BzM
 q238NEl3ijdLvl+qYtYqneMag/wo8sclMxkZmhqzVgOrSmcp3c
 g1Bp5DIn0s8Yi8v7xqV/HCgsusaQI7w2Z8E5NPrfOLsORob6wv
 mVOLktwKXJfyAA1y0R53UUi24RI96Xt3ROK2slXSSh14MZ3UNj
 OroXsPb25WJqbx8x5HMf5c2jJKGBWMjzB1EswMFZh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-11 at 12:52 +0100, Peter Zijlstra wrote: 
> On Wed, Dec 11, 2013 at 12:38:39PM +0100, Borislav Petkov wrote:
> > Right, if it turns out that this is really the case and that this
> > erratum hasn't been fixed for models later than 29 - we'd need the
> > additional model numbers to set X86_FEATURE_CLFLUSH_MONITOR correctly.
> 
> You also need: https://lkml.org/lkml/2013/11/19/143
> 
> Because obviously not all mwait idle loops check that cpu bit.

I had tried that patch, to see if it would magically make the thing
start working, nope.  I had also tried...

---
 drivers/idle/intel_idle.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/idle/intel_idle.c
===================================================================
--- linux-2.6.orig/drivers/idle/intel_idle.c
+++ linux-2.6/drivers/idle/intel_idle.c
@@ -376,11 +376,14 @@ static int intel_idle(struct cpuidle_dev
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
 
 	if (!current_set_polling_and_test()) {
-
+		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
+			clflush((void *)&current_thread_info()->flags);
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
 		if (!need_resched())
 			__mwait(eax, ecx);
+		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
+			clflush((void *)&current_thread_info()->flags);
 	}
 
 	if (!(lapic_timer_reliable_states & (1 << (cstate))))

..a cflush before _and_ after, among other (shazam!.. darn) guesses, but
nogo.  Turning that into the tglx one liner indeed did fix the thing, as
did adding this to your patch.

---
 arch/x86/include/asm/mwait.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/include/asm/mwait.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mwait.h
+++ linux-2.6/arch/x86/include/asm/mwait.h
@@ -43,7 +43,7 @@ static inline void __mwait(unsigned long
 static inline void mwait_idle_with_hints(unsigned long eax, unsigned long ecx)
 {
 	if (!current_set_polling_and_test()) {
-		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
+//		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);



Grrr.

flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2
ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 x2apic popcnt lahf_lm dtherm
tpr_shadow vnmi flexpriority ept vpid

-Mike

