Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559AbaLECbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 21:31:13 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58181 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932378AbaLECbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 21:31:12 -0500
From: Calvin Owens <calvinowens@fb.com>
To: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: <x86@kernel.org>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Calvin Owens <calvinowens@fb.com>
Subject: [PATCH] x86: mce: Avoid timer double-add during CMCI interrupt storms.
Date: Thu, 4 Dec 2014 18:29:35 -0800
Message-ID: <1417746575-23299-1-git-send-email-calvinowens@fb.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-05_01:2014-12-04,2014-12-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=8 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=26.7046773694174
 compositescore=0.928862112264561 urlsuspect_oldscore=0.928862112264561
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.928862112264561 spamscore=8
 recipient_to_sender_domain_totalscore=46 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412050022
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Intel CMCI interrupt handler calls mce_timer_kick() to force more
frequent polling for MCE events when a CMCI storm occurs and CMCI
interrupts are subsequently disabled.

If a CMCI interrupt storm happens to be detected while the timer
interrupt is executing timer functions, mce_timer_kick() can race with
mce_timer_fn(), which results in a double-add and the following BUG:

	#0 [ffff88047fda3ad0] machine_kexec at ffffffff8102bdf5
	#1 [ffff88047fda3b20] crash_kexec at ffffffff8109e788
	#2 [ffff88047fda3bf0] oops_end at ffffffff815f20e8
	#3 [ffff88047fda3c20] die at ffffffff81005c08
	#4 [ffff88047fda3c50] do_trap at ffffffff815f192b
	#5 [ffff88047fda3cb0] do_invalid_op at ffffffff81002f42
	#6 [ffff88047fda3d60] invalid_op at ffffffff815fa668
	[exception RIP: add_timer_on+234]
	RIP: ffffffff8104d05a RSP: ffff88047fda3e18 RFLAGS: 00010286
	RAX: 0000000000000000 RBX: ffff88047fdacbc0 RCX: 000000001fbee3ff
	RDX: ffff88047fda0000 RSI: 000000000000001d RDI: ffff88047fdacbc0
	RBP: ffff88047fda3e58 R8: 0000000000000000 R9: ffffffff81aa0940
	R10: 0720072007200720 R11: 0720072007200765 R12: ffff880474a6c000
	R13: 0000000000000101 R14: 000000000000001d R15: ffff88047fdacbc0
	ORIG_RAX: ffffffffffffffff CS: 0010 SS: 0018
	#7 [ffff88047fda3e60] mce_timer_fn at ffffffff8101f524
	#8 [ffff88047fda3e80] call_timer_fn at ffffffff8104b4fa
	#9 [ffff88047fda3ec0] run_timer_softirq at ffffffff8104ce70

The timer_add() in mce_timer_kick() is actually unnecessary: since the
timer is re-added by its handler function, the only case in which the
timer doesn't exist is when the CMCI interrupt calls mce_timer_kick() in
the interval between the timer firing and mce_timer_fn() actually being
executed. Thus, the timer work will be performed by mce_timer_fn() just
after the interrupt exits.

This patch removes the add_timer() from mce_timer_kick(), and disables
local interrupts during mce_timer_fn() so that mce_timer_fn() will
always pick up the timer interval value that mce_timer_kick() drops
in the PERCPU variable.

This means that the CMCI interrupt that hits the storm threshold will
call mce_timer_kick() either:

	1) In the interval between the mce_timer firing and mce_timer_fn()
	   disabling local IRQs. In this case, mce_timer_fn() will
	   immediately execute after the CMCI handler exits, and will
	   use the interval loaded in the PERCPU variable from
	   mce_timer_kick() to calculate its next timer interval.

	2) Happen after mce_timer_fn() has done its work, in which case
	   the existing timer will be updated with the new interval if
	   it is before the existing one.

Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 61a9668ce..7074a90 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1286,7 +1286,7 @@ static int cmc_error_seen(void)
 static void mce_timer_fn(unsigned long data)
 {
 	struct timer_list *t = this_cpu_ptr(&mce_timer);
-	unsigned long iv;
+	unsigned long iv, flags;
 	int notify;
 
 	WARN_ON(smp_processor_id() != data);
@@ -1301,6 +1301,9 @@ static void mce_timer_fn(unsigned long data)
 	 * Alert userspace if needed.  If we logged an MCE, reduce the
 	 * polling interval, otherwise increase the polling interval.
 	 */
+
+	local_irq_save(flags);
+
 	iv = __this_cpu_read(mce_next_interval);
 	notify = mce_notify_irq();
 	notify |= cmc_error_seen();
@@ -1316,6 +1319,8 @@ static void mce_timer_fn(unsigned long data)
 		t->expires = jiffies + iv;
 		add_timer_on(t, smp_processor_id());
 	}
+
+	local_irq_restore(flags);
 }
 
 /*
@@ -1330,9 +1335,6 @@ void mce_timer_kick(unsigned long interval)
 	if (timer_pending(t)) {
 		if (time_before(when, t->expires))
 			mod_timer_pinned(t, when);
-	} else {
-		t->expires = round_jiffies(when);
-		add_timer_on(t, smp_processor_id());
 	}
 	if (interval < iv)
 		__this_cpu_write(mce_next_interval, interval);
-- 
2.1.1

