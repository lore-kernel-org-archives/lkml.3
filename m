Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbaKCK6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:58:24 -0500
Received: from mail-bl2on0098.outbound.protection.outlook.com ([65.55.169.98]:35880
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751343AbaKCKyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:54:52 -0500
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v6 21/29] nios2: Time keeping
Date: Mon, 3 Nov 2014 18:52:17 +0800
Message-ID: <1415011945-3297-22-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415011945-3297-1-git-send-email-lftan@altera.com>
References: <1415011945-3297-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(22564002)(47776003)(97736003)(50226001)(4396001)(42186005)(48376002)(46102003)(50466002)(62966003)(89996001)(33646002)(87286001)(88136002)(87936001)(36756003)(19580395003)(20776003)(64706001)(19580405001)(15975445006)(107046002)(229853001)(21056001)(68736004)(15202345003)(106466001)(104166001)(84676001)(44976005)(6806004)(102836001)(105596002)(31966008)(93916002)(95666004)(2201001)(120916001)(76176999)(99396003)(92726001)(77096003)(50986999)(92566001)(77156002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB592;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB592;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0384275935
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add time keeping code for nios2.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/nios2/include/asm/delay.h |  21 +++
 arch/nios2/include/asm/timex.h |  24 ++++
 arch/nios2/kernel/time.c       | 310 +++++++++++++++++++++++++++++++++++++++++
 arch/nios2/lib/delay.c         |  52 +++++++
 4 files changed, 407 insertions(+)
 create mode 100644 arch/nios2/include/asm/delay.h
 create mode 100644 arch/nios2/include/asm/timex.h
 create mode 100644 arch/nios2/kernel/time.c
 create mode 100644 arch/nios2/lib/delay.c

diff --git a/arch/nios2/include/asm/delay.h b/arch/nios2/include/asm/delay.h
new file mode 100644
index 0000000..098e49b
--- /dev/null
+++ b/arch/nios2/include/asm/delay.h
@@ -0,0 +1,21 @@
+/*
+ * Copyright (C) 2014 Altera Corporation
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
+#include <asm-generic/delay.h>
+
+/* Undefined functions to get compile-time errors */
+extern void __bad_udelay(void);
+extern void __bad_ndelay(void);
+
+extern unsigned long loops_per_jiffy;
+
+#endif /* _ASM_NIOS2_DELAY_H */
diff --git a/arch/nios2/include/asm/timex.h b/arch/nios2/include/asm/timex.h
new file mode 100644
index 0000000..2f2abb2
--- /dev/null
+++ b/arch/nios2/include/asm/timex.h
@@ -0,0 +1,24 @@
+/* Copyright Altera Corporation (C) 2014. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2,
+ * as published by the Free Software Foundation.
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
+typedef unsigned long cycles_t;
+
+extern cycles_t get_cycles(void);
+
+#endif
diff --git a/arch/nios2/kernel/time.c b/arch/nios2/kernel/time.c
new file mode 100644
index 0000000..d90ca1b
--- /dev/null
+++ b/arch/nios2/kernel/time.c
@@ -0,0 +1,310 @@
+/*
+ * Copyright (C) 2013-2014 Altera Corporation
+ * Copyright (C) 2010 Tobias Klauser <tklauser@distanz.ch>
+ * Copyright (C) 2004 Microtronix Datacom Ltd.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/clockchips.h>
+#include <linux/clocksource.h>
+#include <linux/delay.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/io.h>
+#include <linux/slab.h>
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
+struct nios2_timer {
+	void __iomem *base;
+	unsigned long freq;
+	int irq;
+};
+
+struct nios2_clockevent_dev {
+	struct nios2_timer timer;
+	struct clock_event_device ced;
+};
+
+struct nios2_clocksource {
+	struct nios2_timer timer;
+	struct clocksource cs;
+};
+
+static inline struct nios2_clockevent_dev *
+	to_nios2_clkevent(struct clock_event_device *evt)
+{
+	return container_of(evt, struct nios2_clockevent_dev, ced);
+}
+
+static inline struct nios2_clocksource *
+	to_nios2_clksource(struct clocksource *cs)
+{
+	return container_of(cs, struct nios2_clocksource, cs);
+}
+
+static u16 timer_readw(struct nios2_timer *timer, u32 offs)
+{
+	return readw(timer->base + offs);
+}
+
+static void timer_writew(struct nios2_timer *timer, u16 val, u32 offs)
+{
+	writew(val, timer->base + offs);
+}
+
+static inline unsigned long read_timersnapshot(struct nios2_timer *timer)
+{
+	unsigned long count;
+
+	timer_writew(timer, 0, ALTERA_TIMER_SNAPL_REG);
+	count = timer_readw(timer, ALTERA_TIMER_SNAPH_REG) << 16 |
+		timer_readw(timer, ALTERA_TIMER_SNAPL_REG);
+
+	return count;
+}
+
+static cycle_t nios2_timer_read(struct clocksource *cs)
+{
+	struct nios2_clocksource *nios2_cs = to_nios2_clksource(cs);
+	unsigned long flags;
+	u32 count;
+
+	local_irq_save(flags);
+	count = read_timersnapshot(&nios2_cs->timer);
+	local_irq_restore(flags);
+
+	/* Counter is counting down */
+	return ~count;
+}
+
+static struct nios2_clocksource nios2_cs = {
+	.cs = {
+		.name	= "nios2-clksrc",
+		.rating	= 250,
+		.read	= nios2_timer_read,
+		.mask	= CLOCKSOURCE_MASK(32),
+		.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
+	},
+};
+
+cycles_t get_cycles(void)
+{
+	return nios2_timer_read(&nios2_cs.cs);
+}
+
+static void nios2_timer_start(struct nios2_timer *timer)
+{
+	u16 ctrl;
+
+	ctrl = timer_readw(timer, ALTERA_TIMER_CONTROL_REG);
+	ctrl |= ALTERA_TIMER_CONTROL_START_MSK;
+	timer_writew(timer, ctrl, ALTERA_TIMER_CONTROL_REG);
+}
+
+static void nios2_timer_stop(struct nios2_timer *timer)
+{
+	u16 ctrl;
+
+	ctrl = timer_readw(timer, ALTERA_TIMER_CONTROL_REG);
+	ctrl |= ALTERA_TIMER_CONTROL_STOP_MSK;
+	timer_writew(timer, ctrl, ALTERA_TIMER_CONTROL_REG);
+}
+
+static void nios2_timer_config(struct nios2_timer *timer, unsigned long period,
+	enum clock_event_mode mode)
+{
+	u16 ctrl;
+
+	/* The timer's actual period is one cycle greater than the value
+	 * stored in the period register. */
+	 period--;
+
+	ctrl = timer_readw(timer, ALTERA_TIMER_CONTROL_REG);
+	/* stop counter */
+	timer_writew(timer, ctrl | ALTERA_TIMER_CONTROL_STOP_MSK,
+		ALTERA_TIMER_CONTROL_REG);
+
+	/* write new count */
+	timer_writew(timer, period, ALTERA_TIMER_PERIODL_REG);
+	timer_writew(timer, period >> 16, ALTERA_TIMER_PERIODH_REG);
+
+	ctrl |= ALTERA_TIMER_CONTROL_START_MSK | ALTERA_TIMER_CONTROL_ITO_MSK;
+	if (mode == CLOCK_EVT_MODE_PERIODIC)
+		ctrl |= ALTERA_TIMER_CONTROL_CONT_MSK;
+	else
+		ctrl &= ~ALTERA_TIMER_CONTROL_CONT_MSK;
+	timer_writew(timer, ctrl, ALTERA_TIMER_CONTROL_REG);
+}
+
+static int nios2_timer_set_next_event(unsigned long delta,
+	struct clock_event_device *evt)
+{
+	struct nios2_clockevent_dev *nios2_ced = to_nios2_clkevent(evt);
+
+	nios2_timer_config(&nios2_ced->timer, delta, evt->mode);
+
+	return 0;
+}
+
+static void nios2_timer_set_mode(enum clock_event_mode mode,
+	struct clock_event_device *evt)
+{
+	unsigned long period;
+	struct nios2_clockevent_dev *nios2_ced = to_nios2_clkevent(evt);
+	struct nios2_timer *timer = &nios2_ced->timer;
+
+	switch (mode) {
+	case CLOCK_EVT_MODE_PERIODIC:
+		period = DIV_ROUND_UP(timer->freq, HZ);
+		nios2_timer_config(timer, period, CLOCK_EVT_MODE_PERIODIC);
+		break;
+	case CLOCK_EVT_MODE_ONESHOT:
+	case CLOCK_EVT_MODE_UNUSED:
+	case CLOCK_EVT_MODE_SHUTDOWN:
+		nios2_timer_stop(timer);
+		break;
+	case CLOCK_EVT_MODE_RESUME:
+		nios2_timer_start(timer);
+		break;
+	}
+}
+
+irqreturn_t timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = (struct clock_event_device *) dev_id;
+	struct nios2_clockevent_dev *nios2_ced = to_nios2_clkevent(evt);
+
+	/* Clear the interrupt condition */
+	timer_writew(&nios2_ced->timer, 0, ALTERA_TIMER_STATUS_REG);
+	evt->event_handler(evt);
+
+	return IRQ_HANDLED;
+}
+
+static void __init nios2_timer_get_base_and_freq(struct device_node *np,
+				void __iomem **base, u32 *freq)
+{
+	*base = of_iomap(np, 0);
+	if (!*base)
+		panic("Unable to map reg for %s\n", np->name);
+
+	if (of_property_read_u32(np, "clock-frequency", freq))
+		panic("Unable to get %s clock frequency\n", np->name);
+}
+
+static struct nios2_clockevent_dev nios2_ce = {
+	.ced = {
+		.name = "nios2-clkevent",
+		.features = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+		.rating = 250,
+		.shift = 32,
+		.set_next_event = nios2_timer_set_next_event,
+		.set_mode = nios2_timer_set_mode,
+	},
+};
+
+static __init void nios2_clockevent_init(struct device_node *timer)
+{
+	void __iomem *iobase;
+	u32 freq;
+	int irq;
+
+	nios2_timer_get_base_and_freq(timer, &iobase, &freq);
+
+	irq = irq_of_parse_and_map(timer, 0);
+	if (irq < 0)
+		panic("Unable to parse timer irq\n");
+
+	nios2_ce.timer.base = iobase;
+	nios2_ce.timer.irq = irq;
+	nios2_ce.timer.freq = freq;
+
+	nios2_ce.ced.cpumask = cpumask_of(0);
+	nios2_ce.ced.irq = irq;
+
+	nios2_timer_stop(&nios2_ce.timer);
+	/* clear pending interrupt */
+	timer_writew(&nios2_ce.timer, 0, ALTERA_TIMER_STATUS_REG);
+
+	if (request_irq(irq, timer_interrupt, IRQF_TIMER, timer->name,
+		&nios2_ce.ced))
+		panic("Unable to setup timer irq\n");
+
+	clockevents_config_and_register(&nios2_ce.ced, freq, 1, ULONG_MAX);
+}
+
+static __init void nios2_clocksource_init(struct device_node *timer)
+{
+	unsigned int ctrl;
+	void __iomem *iobase;
+	u32 freq;
+
+	nios2_timer_get_base_and_freq(timer, &iobase, &freq);
+
+	nios2_cs.timer.base = iobase;
+	nios2_cs.timer.freq = freq;
+
+	clocksource_register_hz(&nios2_cs.cs, freq);
+
+	timer_writew(&nios2_cs.timer, USHRT_MAX, ALTERA_TIMER_PERIODL_REG);
+	timer_writew(&nios2_cs.timer, USHRT_MAX, ALTERA_TIMER_PERIODH_REG);
+
+	/* interrupt disable + continuous + start */
+	ctrl = ALTERA_TIMER_CONTROL_CONT_MSK | ALTERA_TIMER_CONTROL_START_MSK;
+	timer_writew(&nios2_cs.timer, ctrl, ALTERA_TIMER_CONTROL_REG);
+
+	/* Calibrate the delay loop directly */
+	lpj_fine = freq / HZ;
+}
+
+/*
+ * The first timer instance will use as a clockevent. If there are two or
+ * more instances, the second one gets used as clocksource and all
+ * others are unused.
+*/
+static void __init nios2_time_init(struct device_node *timer)
+{
+	static int num_called;
+
+	switch (num_called) {
+	case 0:
+		nios2_clockevent_init(timer);
+		break;
+	case 1:
+		nios2_clocksource_init(timer);
+		break;
+	default:
+		break;
+	}
+
+	num_called++;
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
+CLOCKSOURCE_OF_DECLARE(nios2_timer, "altr,timer-1.0", nios2_time_init);
diff --git a/arch/nios2/lib/delay.c b/arch/nios2/lib/delay.c
new file mode 100644
index 0000000..088119c
--- /dev/null
+++ b/arch/nios2/lib/delay.c
@@ -0,0 +1,52 @@
+/* Copyright Altera Corporation (C) 2014. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2,
+ * as published by the Free Software Foundation.
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
+#include <linux/module.h>
+#include <asm/delay.h>
+#include <asm/param.h>
+#include <asm/processor.h>
+#include <asm/timex.h>
+
+void __delay(unsigned long cycles)
+{
+	cycles_t start = get_cycles();
+
+	while ((get_cycles() - start) < cycles)
+		cpu_relax();
+}
+EXPORT_SYMBOL(__delay);
+
+void __const_udelay(unsigned long xloops)
+{
+	u64 loops;
+
+	loops = (u64)xloops * loops_per_jiffy * HZ;
+
+	__delay(loops >> 32);
+}
+EXPORT_SYMBOL(__const_udelay);
+
+void __udelay(unsigned long usecs)
+{
+	__const_udelay(usecs * 0x10C7UL); /* 2**32 / 1000000 (rounded up) */
+}
+EXPORT_SYMBOL(__udelay);
+
+void __ndelay(unsigned long nsecs)
+{
+	__const_udelay(nsecs * 0x5UL); /* 2**32 / 1000000000 (rounded up) */
+}
+EXPORT_SYMBOL(__ndelay);
-- 
1.8.2.1

