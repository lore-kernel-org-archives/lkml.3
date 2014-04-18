Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaDRMmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:42:39 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:3012
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751185AbaDRMmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:42:32 -0400
X-Greylist: delayed 894 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Apr 2014 08:42:32 EDT
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH 20/28] nios2: Time keeping
Date: Fri, 18 Apr 2014 20:27:03 +0800
Message-ID: <1397824031-4892-17-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397824031-4892-1-git-send-email-lftan@altera.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(199002)(189002)(22564002)(76176999)(99396002)(6806004)(50986999)(80022001)(87286001)(93916002)(88136002)(86362001)(575784001)(50466002)(19580405001)(62966002)(2201001)(92566001)(92726001)(77982001)(2009001)(47776003)(20776003)(80976001)(44976005)(48376002)(83322001)(19580395003)(84676001)(81542001)(97736001)(76482001)(81342001)(77156001)(83072002)(85852003)(42186004)(36756003)(4396001)(87936001)(89996001)(50226001)(46102001)(16796002)(74502001)(31966008)(74662001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB029;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:CC9ED165.2FEADFC5.E0F046BA.6EF79230.206E9;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 018577E36E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add time keeping code for nios2.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/delay.h |  92 +++++++++++++++++++++++++
 arch/nios2/include/asm/timex.h |  27 ++++++++
 arch/nios2/kernel/time.c       | 150 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 269 insertions(+)
 create mode 100644 arch/nios2/include/asm/delay.h
 create mode 100644 arch/nios2/include/asm/timex.h
 create mode 100644 arch/nios2/kernel/time.c

diff --git a/arch/nios2/include/asm/delay.h b/arch/nios2/include/asm/delay.h
new file mode 100644
index 0000000..8070a09
--- /dev/null
+++ b/arch/nios2/include/asm/delay.h
@@ -0,0 +1,92 @@
+/*
+ * Copyright (C) 2004 Microtronix Datacom Ltd
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_NIOS2_DELAY_H
+#define _ASM_NIOS2_DELAY_H
+
+#include <asm/param.h>
+
+static inline void __delay(unsigned long loops)
+{
+	int dummy;
+
+	__asm__ __volatile__(
+	"1:\n\t"
+	"    beq    %0,zero,2f\n\t"
+	"    addi   %0, %0, -1\n\t"
+	"    br     1b\n\t"
+	"2:\n\t"
+	:  "=r" (dummy)		/* Need output for optimizer */
+	:  "0" (loops));	/* %0  Input */
+}
+
+/*
+ * Note that 19 * 226 == 4294 ==~ 2^32 / 10^6, so
+ * loops = (4294 * usecs * loops_per_jiffy * HZ) / 2^32.
+ *
+ * The mul instruction gives us loops = (a * b) / 2^32.
+ * We choose a = usecs * 19 * HZ and b = loops_per_jiffy * 226
+ * because this lets us support a wide range of HZ and
+ * loops_per_jiffy values without either a or b overflowing 2^32.
+ * Thus we need usecs * HZ <= (2^32 - 1) / 19 = 226050910 and
+ * loops_per_jiffy <= (2^32 - 1) / 226 = 19004280
+ * (which corresponds to ~3800 bogomips at HZ = 100).
+ *  -- paulus
+ */
+#define __MAX_UDELAY	(226050910UL/HZ)	/* maximum udelay argument */
+#define __MAX_NDELAY	(4294967295UL/HZ)	/* maximum ndelay argument */
+
+extern unsigned long loops_per_jiffy;
+
+static inline void __udelay(unsigned int x)
+{
+	unsigned int loops;
+
+	/*
+	 * Note, if this is compiled with -mhw-mulx it will produce a "mulxuu"
+	 * (at least in toolchain 145) so there is no need for inline
+	 * assembly here anymore, which might in turn be emulated if unsupported
+	 * by the design.
+	 */
+	loops = (unsigned int)((((unsigned long long)(x) *
+			(unsigned long long)(loops_per_jiffy * 226))) >> 32);
+
+/*
+	__asm__("mulxuu %0,%1,%2" : "=r" (loops) :
+		"r" (x), "r" (loops_per_jiffy * 226));
+*/
+	__delay(loops);
+}
+
+static inline void __ndelay(unsigned int x)
+{
+	unsigned int loops;
+
+	/* see comment in __udelay */
+	loops = (unsigned int)((((unsigned long long)(x) *
+			(unsigned long long)(loops_per_jiffy * 5))) >> 32);
+
+/*
+	__asm__("mulxuu %0,%1,%2" : "=r" (loops) :
+		"r" (x), "r" (loops_per_jiffy * 5));
+*/
+	__delay(loops);
+}
+
+extern void __bad_udelay(void);		/* deliberately undefined */
+extern void __bad_ndelay(void);		/* deliberately undefined */
+
+#define udelay(n) (__builtin_constant_p(n) ? \
+	((n) > __MAX_UDELAY ? __bad_udelay() : __udelay((n) * (19 * HZ))) : \
+	__udelay((n) * (19 * HZ)))
+
+#define ndelay(n) (__builtin_constant_p(n) ? \
+	((n) > __MAX_NDELAY ? __bad_ndelay() : __ndelay((n) * HZ)) : \
+	__ndelay((n) * HZ))
+
+#endif /* _ASM_NIOS2_DELAY_H */
diff --git a/arch/nios2/include/asm/timex.h b/arch/nios2/include/asm/timex.h
new file mode 100644
index 0000000..524b47d79d3dad53b98713f31517e28ac0c99d98
--- /dev/null
+++ b/arch/nios2/include/asm/timex.h
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2010 Thomas Chou <thomas@wytron.com.tw>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#ifndef _ASM_NIOS2_TIMEX_H
+#define _ASM_NIOS2_TIMEX_H
+
+/* Supply dummy tick-rate. Real value will be read from devicetree */
+#define CLOCK_TICK_RATE		(HZ * 100000UL)
+
+#include <asm-generic/timex.h>
+
+#endif
diff --git a/arch/nios2/kernel/time.c b/arch/nios2/kernel/time.c
new file mode 100644
index 0000000..0677ebaa1dffd8213f52a704c6a8366d34c05ca2
--- /dev/null
+++ b/arch/nios2/kernel/time.c
@@ -0,0 +1,150 @@
+/*
+ * Copyright (C) 2013 Altera Corporation
+ * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2004 Microtronix Datacom Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/time.h>
+#include <linux/timex.h>
+#include <linux/profile.h>
+#include <linux/clocksource.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/io.h>
+
+#define	TICK_SIZE		(tick_nsec / 1000)
+#define NIOS2_TIMER_PERIOD	(timer_freq / HZ)
+
+#define ALTERA_TIMER_STATUS_REG		0
+#define ALTERA_TIMER_CONTROL_REG	4
+#define ALTERA_TIMER_PERIODL_REG	8
+#define ALTERA_TIMER_PERIODH_REG	12
+#define ALTERA_TIMER_SNAPL_REG		16
+#define ALTERA_TIMER_SNAPH_REG		20
+
+#define ALTERA_TIMER_CONTROL_ITO_MSK	(0x1)
+#define ALTERA_TIMER_CONTROL_CONT_MSK	(0x2)
+#define ALTERA_TIMER_CONTROL_START_MSK	(0x4)
+#define ALTERA_TIMER_CONTROL_STOP_MSK	(0x8)
+
+static u32 nios2_timer_count;
+static void __iomem *timer_membase;
+static u32 timer_freq;
+
+static inline unsigned long read_timersnapshot(void)
+{
+	unsigned long count;
+
+	outw(0, timer_membase + ALTERA_TIMER_SNAPL_REG);
+	count =
+		inw(timer_membase + ALTERA_TIMER_SNAPH_REG) << 16 |
+		inw(timer_membase + ALTERA_TIMER_SNAPL_REG);
+
+	return count;
+}
+
+static inline void write_timerperiod(unsigned long period)
+{
+	outw(period, timer_membase + ALTERA_TIMER_PERIODL_REG);
+	outw(period >> 16, timer_membase + ALTERA_TIMER_PERIODH_REG);
+}
+
+/*
+ * timer_interrupt() needs to keep up the real-time clock,
+ * as well as call the "xtime_update()" routine every clocktick
+ */
+irqreturn_t timer_interrupt(int irq, void *dummy)
+{
+	/* Clear the interrupt condition */
+	outw(0, timer_membase + ALTERA_TIMER_STATUS_REG);
+	nios2_timer_count += NIOS2_TIMER_PERIOD;
+
+	profile_tick(CPU_PROFILING);
+
+	xtime_update(1);
+
+	update_process_times(user_mode(get_irq_regs()));
+
+	return IRQ_HANDLED;
+}
+
+static cycle_t nios2_timer_read(struct clocksource *cs)
+{
+	unsigned long flags;
+	u32 cycles;
+	u32 tcn;
+
+	local_irq_save(flags);
+	tcn = NIOS2_TIMER_PERIOD - 1 - read_timersnapshot();
+	cycles = nios2_timer_count;
+	local_irq_restore(flags);
+
+	return cycles + tcn;
+}
+
+static struct clocksource nios2_timer = {
+	.name	= "timer",
+	.rating	= 250,
+	.read	= nios2_timer_read,
+	.shift	= 20,
+	.mask	= CLOCKSOURCE_MASK(32),
+	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static struct irqaction nios2_timer_irq = {
+	.name		= "timer",
+	.flags		= IRQF_TIMER,
+	.handler	= timer_interrupt,
+};
+
+static void __init nios2_time_init(struct device_node *timer)
+{
+	int irq;
+	unsigned int ctrl;
+
+	timer_membase = of_iomap(timer, 0);
+	if (!timer_membase)
+		panic("Unable to map timer resource\n");
+
+	if (of_property_read_u32(timer, "clock-frequency", &timer_freq))
+		panic("Unable to get timer clock frequency\n");
+
+	irq = irq_of_parse_and_map(timer, 0);
+	if (irq < 0)
+		panic("Unable to parse timer irq\n");
+
+	if (setup_irq(irq, &nios2_timer_irq))
+		panic("Unable to setup timer irq\n");
+
+	write_timerperiod(NIOS2_TIMER_PERIOD - 1);
+
+	/* clocksource initialize */
+	nios2_timer.mult = clocksource_hz2mult(timer_freq, nios2_timer.shift);
+	clocksource_register(&nios2_timer);
+
+	/* interrupt enable + continuous + start */
+	ctrl = ALTERA_TIMER_CONTROL_ITO_MSK | ALTERA_TIMER_CONTROL_CONT_MSK |
+		ALTERA_TIMER_CONTROL_START_MSK;
+	outw(ctrl, timer_membase + ALTERA_TIMER_CONTROL_REG);
+}
+
+void read_persistent_clock(struct timespec *ts)
+{
+	ts->tv_sec = mktime(2007, 1, 1, 0, 0, 0);
+	ts->tv_nsec = 0;
+}
+
+void __init time_init(void)
+{
+	clocksource_of_init();
+}
+
+CLOCKSOURCE_OF_DECLARE(nios2_timer, "ALTR,timer-1.0", nios2_time_init);
-- 
1.8.3.2

