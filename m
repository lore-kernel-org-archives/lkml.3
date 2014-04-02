Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbaDBLFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 07:05:20 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6304 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758492AbaDBLFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 07:05:14 -0400
From: Lei Wen <leiwen@marvell.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] clocksource: register persistent clock for arm arch_timer
Date: Wed, 2 Apr 2014 19:02:37 +0800
Message-ID: <1396436557-29136-1-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-04-02_01:2014-04-01,2014-04-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1404020036
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since arm's arch_timer's counter would keep accumulated even in the
low power mode, including suspend state, it is very suitable to be
the persistent clock instead of RTC.

While read_persistent_clock calling place shall be rare, like only
suspend/resume place? So we shall don't care for its performance
very much, so use direclty divided by frequency should be accepted
for this reason. Actually archtimer's counter read performance already
be very good, since it is directly access from core's bus, not from
soc, so this is another reason why we choose use divide here.

Final reason for why we don't use multi+shift way is for we may not
call read_persistent_clock for long time, like system long time
not enter into suspend, so that the accumulated cycle difference value
may larger than we used for calculate the multi+shift, thus precise
would be highly affected in such corner case.

Signed-off-by: Lei Wen <leiwen@marvell.com>
---

I am not sure whether it is good to add something like
generic_persistent_clock_read in the new added kernel/time/sched_clock.c?
Since from arch timer's perspective, all it need to do is to pick
the suspend period from the place where sched_clock being stopped/restarted.

Any idea for make the persistent clock reading as one generic function,
like current sched_clock do?


 drivers/clocksource/arm_arch_timer.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 57e823c..5eaa34a 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -23,6 +23,7 @@
 #include <linux/sched_clock.h>
 
 #include <asm/arch_timer.h>
+#include <asm/mach/time.h>
 #include <asm/virt.h>
 
 #include <clocksource/arm_arch_timer.h>
@@ -52,6 +53,8 @@ struct arch_timer {
 #define to_arch_timer(e) container_of(e, struct arch_timer, evt)
 
 static u32 arch_timer_rate;
+static u32 persistent_multi;
+static u32 persistent_div;
 
 enum ppi_nr {
 	PHYS_SECURE_PPI,
@@ -68,6 +71,31 @@ static struct clock_event_device __percpu *arch_timer_evt;
 static bool arch_timer_use_virtual = true;
 static bool arch_timer_mem_use_virtual;
 
+static void get_persistent_clock_multi_div(void)
+{
+	u32 i, tmp;
+
+	tmp = arch_timer_rate;
+	persistent_multi = NSEC_PER_SEC;
+	for (i = 0; i < 9; i ++) {
+		if (tmp % 10)
+			break;
+		tmp /= 10;
+		persistent_multi /= 10;
+	}
+
+	persistent_div = tmp;
+}
+
+static void arch_timer_persistent_clock_read(struct timespec *ts)
+{
+	u64 ns;
+
+	ns = arch_timer_read_counter() * persistent_multi;
+	do_div(ns, persistent_div);
+	*ts = ns_to_timespec(ns);
+}
+
 /*
  * Architected system timer support.
  */
@@ -631,6 +659,9 @@ static void __init arch_timer_common_init(void)
 	arch_timer_banner(arch_timers_present);
 	arch_counter_register(arch_timers_present);
 	arch_timer_arch_init();
+
+	get_persistent_clock_multi_div();
+	register_persistent_clock(NULL, arch_timer_persistent_clock_read);
 }
 
 static void __init arch_timer_init(struct device_node *np)
-- 
1.8.3.2

