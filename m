Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbaCMUgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 16:36:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57866 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034AbaCMUg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 16:36:28 -0400
From: Joel Fernandes <joelf@TI.com>
To: Tony Lindgren <tony@atomide.com>, Rob Herring <robh@kernel.org>,
        Tero Kristo <t-kristo@TI.com>, Nishanth Menon <nm@TI.com>,
        Suman Anna <s-anna@TI.com>, Felipe Balbi <balbi@TI.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joel Fernandes <joelf@TI.com>
Subject: [RFC 4/5] clocksource: omap-timer: Introduce clocksource driver for OMAP SoCs
Date: Thu, 13 Mar 2014 15:35:18 -0500
Message-ID: <1394742919-32163-5-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394742919-32163-1-git-send-email-joelf@ti.com>
References: <1394742919-32163-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We introduce functions to initialize clocksource and clockevent, use
CLOCKSOURCE_OF_DECLARE to declare the clocksource, and handle the clocksource
selection on a per-SoC basis (Currently only AM335x is supported). Powering up
of the timer will be done with the help of the mach-omap layer function that's
introduced earlier in the series.

We make a local copy of dmtimer API for use by clocksource, the original
dmtimer API in plat-omap is kept as-is till the migration of all SoCs is
completed after which it can't be deleted.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/clocksource/Makefile     |    1 +
 drivers/clocksource/omap-timer.c | 1157 ++++++++++++++++++++++++++++++++++++++
 drivers/clocksource/omap-timer.h |  422 ++++++++++++++
 3 files changed, 1580 insertions(+)
 create mode 100644 drivers/clocksource/omap-timer.c
 create mode 100644 drivers/clocksource/omap-timer.h

diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
index c7ca50a..2ffe698 100644
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@ -37,3 +37,4 @@ obj-$(CONFIG_ARM_ARCH_TIMER)		+= arm_arch_timer.o
 obj-$(CONFIG_ARM_GLOBAL_TIMER)		+= arm_global_timer.o
 obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+= metag_generic.o
 obj-$(CONFIG_ARCH_HAS_TICK_BROADCAST)	+= dummy_timer.o
+obj-y					+= omap-timer.o
diff --git a/drivers/clocksource/omap-timer.c b/drivers/clocksource/omap-timer.c
new file mode 100644
index 0000000..91593d8
--- /dev/null
+++ b/drivers/clocksource/omap-timer.c
@@ -0,0 +1,1157 @@
+/*
+ * drivers/clocksource/omap-timer.c
+ *
+ * OMAP Dual-Mode Timers
+ *
+ * Copyright (C) 2014 Texas Instruments Incorporated - http://www.ti.com/
+ * Joel Fernandes <joelf@ti.com>
+ * Tarun Kanti DebBarma <tarun.kanti@ti.com>
+ * Thara Gopinath <thara@ti.com>
+ *
+ * dmtimer adaptation to platform_driver.
+ *
+ * Copyright (C) 2005 Nokia Corporation
+ * OMAP2 support by Juha Yrjola
+ * API improvements and OMAP2 clock framework support by Timo Teras
+ *
+ * Copyright (C) 2014 Texas Instruments
+ * Added OMAP4 support - Santosh Shilimkar <santosh.shilimkar@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
+ * NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
+ * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * You should have received a copy of the  GNU General Public License along
+ * with this program; if not, write  to the Free Software Foundation, Inc.,
+ * 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/init.h>
+#include <linux/time.h>
+#include <linux/interrupt.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/irq.h>
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
+#include <linux/slab.h>
+#include <linux/sched_clock.h>
+
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/pm_runtime.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+
+#include <linux/of_device.h>
+#include <linux/platform_device.h>
+#include <linux/platform_data/dmtimer-omap.h>
+#include "omap-timer.h"
+/*
+ *  TODO: OMAP1 support removed due to need for header mach/hardware.h
+ *        OMAP2 support may be broken due to lack of cpu_is stuff, see omap_dm_timer_get_errata
+ */
+
+/**
+ * omap_dm_timer_get_errata - get errata flags for a timer
+ *
+ * Get the timer errata flags that are specific to the OMAP device being used.
+ */
+static u32 __init omap_dm_timer_get_errata(void)
+{
+	/* ifdef'd out due to lack of availaibility of soc.h */
+#if 0
+	if (cpu_is_omap24xx())
+		return 0;
+#endif
+	return OMAP_TIMER_ERRATA_I103_I767;
+}
+
+
+/* Below code borrowed from plat-omap/dmtimer.c, everything static'd */
+
+static u32 omap_reserved_systimers;
+static LIST_HEAD(omap_timer_list);
+static DEFINE_SPINLOCK(dm_timer_lock);
+
+enum {
+	REQUEST_ANY = 0,
+	REQUEST_BY_ID,
+	REQUEST_BY_CAP,
+	REQUEST_BY_NODE,
+};
+
+/**
+ * omap_dm_timer_read_reg - read timer registers in posted and non-posted mode
+ * @timer:      timer pointer over which read operation to perform
+ * @reg:        lowest byte holds the register offset
+ *
+ * The posted mode bit is encoded in reg. Note that in posted mode write
+ * pending bit must be checked. Otherwise a read of a non completed write
+ * will produce an error.
+ */
+static inline u32 omap_dm_timer_read_reg(struct omap_dm_timer *timer, u32 reg)
+{
+	WARN_ON((reg & 0xff) < _OMAP_TIMER_WAKEUP_EN_OFFSET);
+	return __omap_dm_timer_read(timer, reg, timer->posted);
+}
+
+/**
+ * omap_dm_timer_write_reg - write timer registers in posted and non-posted mode
+ * @timer:      timer pointer over which write operation is to perform
+ * @reg:        lowest byte holds the register offset
+ * @value:      data to write into the register
+ *
+ * The posted mode bit is encoded in reg. Note that in posted mode the write
+ * pending bit must be checked. Otherwise a write on a register which has a
+ * pending write will be lost.
+ */
+static void omap_dm_timer_write_reg(struct omap_dm_timer *timer, u32 reg,
+		u32 value)
+{
+	WARN_ON((reg & 0xff) < _OMAP_TIMER_WAKEUP_EN_OFFSET);
+	__omap_dm_timer_write(timer, reg, value, timer->posted);
+}
+
+static void omap_timer_restore_context(struct omap_dm_timer *timer)
+{
+	omap_dm_timer_write_reg(timer, OMAP_TIMER_WAKEUP_EN_REG,
+			timer->context.twer);
+	omap_dm_timer_write_reg(timer, OMAP_TIMER_COUNTER_REG,
+			timer->context.tcrr);
+	omap_dm_timer_write_reg(timer, OMAP_TIMER_LOAD_REG,
+			timer->context.tldr);
+	omap_dm_timer_write_reg(timer, OMAP_TIMER_MATCH_REG,
+			timer->context.tmar);
+	omap_dm_timer_write_reg(timer, OMAP_TIMER_IF_CTRL_REG,
+			timer->context.tsicr);
+	__raw_writel(timer->context.tier, timer->irq_ena);
+	omap_dm_timer_write_reg(timer, OMAP_TIMER_CTRL_REG,
+			timer->context.tclr);
+}
+
+static int omap_dm_timer_reset(struct omap_dm_timer *timer)
+{
+	u32 l, timeout = 100000;
+
+	if (timer->revision != 1)
+		return -EINVAL;
+
+	omap_dm_timer_write_reg(timer, OMAP_TIMER_IF_CTRL_REG, 0x06);
+
+	do {
+		l = __omap_dm_timer_read(timer,
+				OMAP_TIMER_V1_SYS_STAT_OFFSET, 0);
+	} while (!l && timeout--);
+
+	if (!timeout) {
+		dev_err(&timer->pdev->dev, "Timer failed to reset\n");
+		return -ETIMEDOUT;
+	}
+
+	/* Configure timer for smart-idle mode */
+	l = __omap_dm_timer_read(timer, OMAP_TIMER_OCP_CFG_OFFSET, 0);
+	l |= 0x2 << 0x3;
+	__omap_dm_timer_write(timer, OMAP_TIMER_OCP_CFG_OFFSET, l, 0);
+
+	timer->posted = 0;
+
+	return 0;
+}
+
+static int omap_dm_timer_prepare(struct omap_dm_timer *timer)
+{
+	int rc;
+
+	/*
+	 * FIXME: OMAP1 devices do not use the clock framework for dmtimers so
+	 * do not call clk_get() for these devices.
+	 */
+	if (!(timer->capability & OMAP_TIMER_NEEDS_RESET)) {
+		timer->fclk = clk_get(&timer->pdev->dev, "fck");
+		if (WARN_ON_ONCE(IS_ERR(timer->fclk))) {
+			dev_err(&timer->pdev->dev, ": No fclk handle.\n");
+			return -EINVAL;
+		}
+	}
+
+	omap_dm_timer_enable(timer);
+
+	if (timer->capability & OMAP_TIMER_NEEDS_RESET) {
+		rc = omap_dm_timer_reset(timer);
+		if (rc) {
+			omap_dm_timer_disable(timer);
+			return rc;
+		}
+	}
+
+	__omap_dm_timer_enable_posted(timer);
+	omap_dm_timer_disable(timer);
+
+	return omap_dm_timer_set_source(timer, OMAP_TIMER_SRC_32_KHZ);
+}
+
+static inline u32 omap_dm_timer_reserved_systimer(int id)
+{
+	return (omap_reserved_systimers & (1 << (id - 1))) ? 1 : 0;
+}
+
+static int omap_dm_timer_reserve_systimer(int id)
+{
+	if (omap_dm_timer_reserved_systimer(id))
+		return -ENODEV;
+
+	omap_reserved_systimers |= (1 << (id - 1));
+
+	return 0;
+}
+
+static struct omap_dm_timer *_omap_dm_timer_request(int req_type, void *data)
+{
+	struct omap_dm_timer *timer = NULL, *t;
+	struct device_node *np = NULL;
+	unsigned long flags;
+	u32 cap = 0;
+	int id = 0;
+
+	switch (req_type) {
+		case REQUEST_BY_ID:
+			id = *(int *)data;
+			break;
+		case REQUEST_BY_CAP:
+			cap = *(u32 *)data;
+			break;
+		case REQUEST_BY_NODE:
+			np = (struct device_node *)data;
+			break;
+		default:
+			/* REQUEST_ANY */
+			break;
+	}
+
+	spin_lock_irqsave(&dm_timer_lock, flags);
+	list_for_each_entry(t, &omap_timer_list, node) {
+		if (t->reserved)
+			continue;
+
+		switch (req_type) {
+			case REQUEST_BY_ID:
+				if (id == t->pdev->id) {
+					timer = t;
+					timer->reserved = 1;
+					goto found;
+				}
+				break;
+			case REQUEST_BY_CAP:
+				if (cap == (t->capability & cap)) {
+					/*
+					 * If timer is not NULL, we have already found
+					 * one timer but it was not an exact match
+					 * because it had more capabilites that what
+					 * was required. Therefore, unreserve the last
+					 * timer found and see if this one is a better
+					 * match.
+					 */
+					if (timer)
+						timer->reserved = 0;
+					timer = t;
+					timer->reserved = 1;
+
+					/* Exit loop early if we find an exact match */
+					if (t->capability == cap)
+						goto found;
+				}
+				break;
+			case REQUEST_BY_NODE:
+				if (np == t->pdev->dev.of_node) {
+					timer = t;
+					timer->reserved = 1;
+					goto found;
+				}
+				break;
+			default:
+				/* REQUEST_ANY */
+				timer = t;
+				timer->reserved = 1;
+				goto found;
+		}
+	}
+found:
+	spin_unlock_irqrestore(&dm_timer_lock, flags);
+
+	if (timer && omap_dm_timer_prepare(timer)) {
+		timer->reserved = 0;
+		timer = NULL;
+	}
+
+	if (!timer)
+		pr_debug("%s: timer request failed!\n", __func__);
+
+	return timer;
+}
+
+static struct omap_dm_timer *omap_dm_timer_request(void)
+{
+	return _omap_dm_timer_request(REQUEST_ANY, NULL);
+}
+
+static struct omap_dm_timer *omap_dm_timer_request_specific(int id)
+{
+	/* Requesting timer by ID is not supported when device tree is used */
+	if (of_have_populated_dt()) {
+		pr_warn("%s: Please use omap_dm_timer_request_by_cap/node()\n",
+				__func__);
+		return NULL;
+	}
+
+	return _omap_dm_timer_request(REQUEST_BY_ID, &id);
+}
+
+/**
+ * omap_dm_timer_request_by_cap - Request a timer by capability
+ * @cap:	Bit mask of capabilities to match
+ *
+ * Find a timer based upon capabilities bit mask. Callers of this function
+ * should use the definitions found in the plat/dmtimer.h file under the
+ * comment "timer capabilities used in hwmod database". Returns pointer to
+ * timer handle on success and a NULL pointer on failure.
+ */
+static struct omap_dm_timer *omap_dm_timer_request_by_cap(u32 cap)
+{
+	return _omap_dm_timer_request(REQUEST_BY_CAP, &cap);
+}
+
+/**
+ * omap_dm_timer_request_by_node - Request a timer by device-tree node
+ * @np:		Pointer to device-tree timer node
+ *
+ * Request a timer based upon a device node pointer. Returns pointer to
+ * timer handle on success and a NULL pointer on failure.
+ */
+static struct omap_dm_timer *omap_dm_timer_request_by_node(struct device_node *np)
+{
+	if (!np)
+		return NULL;
+
+	return _omap_dm_timer_request(REQUEST_BY_NODE, np);
+}
+
+static int omap_dm_timer_free(struct omap_dm_timer *timer)
+{
+	if (unlikely(!timer))
+		return -EINVAL;
+
+	clk_put(timer->fclk);
+
+	WARN_ON(!timer->reserved);
+	timer->reserved = 0;
+	return 0;
+}
+
+static void omap_dm_timer_enable(struct omap_dm_timer *timer)
+{
+	int c;
+
+	pm_runtime_get_sync(&timer->pdev->dev);
+
+	if (!(timer->capability & OMAP_TIMER_ALWON)) {
+		if (timer->get_context_loss_count) {
+			c = timer->get_context_loss_count(&timer->pdev->dev);
+			if (c != timer->ctx_loss_count) {
+				omap_timer_restore_context(timer);
+				timer->ctx_loss_count = c;
+			}
+		} else {
+			omap_timer_restore_context(timer);
+		}
+	}
+}
+
+static void omap_dm_timer_disable(struct omap_dm_timer *timer)
+{
+	pm_runtime_put_sync(&timer->pdev->dev);
+}
+
+static int omap_dm_timer_get_irq(struct omap_dm_timer *timer)
+{
+	if (timer)
+		return timer->irq;
+	return -EINVAL;
+}
+
+static struct clk *omap_dm_timer_get_fclk(struct omap_dm_timer *timer)
+{
+	if (timer && !IS_ERR(timer->fclk))
+		return timer->fclk;
+	return NULL;
+}
+
+static __u32 omap_dm_timer_modify_idlect_mask(__u32 inputmask)
+{
+	BUG();
+
+	return 0;
+}
+
+static int omap_dm_timer_trigger(struct omap_dm_timer *timer)
+{
+	if (unlikely(!timer || pm_runtime_suspended(&timer->pdev->dev))) {
+		pr_err("%s: timer not available or enabled.\n", __func__);
+		return -EINVAL;
+	}
+
+	omap_dm_timer_write_reg(timer, OMAP_TIMER_TRIGGER_REG, 0);
+	return 0;
+}
+
+static int omap_dm_timer_start(struct omap_dm_timer *timer)
+{
+	u32 l;
+
+	if (unlikely(!timer))
+		return -EINVAL;
+
+	omap_dm_timer_enable(timer);
+
+	l = omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
+	if (!(l & OMAP_TIMER_CTRL_ST)) {
+		l |= OMAP_TIMER_CTRL_ST;
+		omap_dm_timer_write_reg(timer, OMAP_TIMER_CTRL_REG, l);
+	}
+
+	/* Save the context */
+	timer->context.tclr = l;
+	return 0;
+}
+
+static int omap_dm_timer_stop(struct omap_dm_timer *timer)
+{
+	unsigned long rate = 0;
+
+	if (unlikely(!timer))
+		return -EINVAL;
+
+	if (!(timer->capability & OMAP_TIMER_NEEDS_RESET))
+		rate = clk_get_rate(timer->fclk);
+
+	__omap_dm_timer_stop(timer, timer->posted, rate);
+
+	/*
+	 * Since the register values are computed and written within
+	 * __omap_dm_timer_stop, we need to use read to retrieve the
+	 * context.
+	 */
+	timer->context.tclr =
+		omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
+	omap_dm_timer_disable(timer);
+	return 0;
+}
+
+static int omap_dm_timer_set_source(struct omap_dm_timer *timer, int source)
+{
+	int ret;
+	char *parent_name = NULL;
+	struct clk *parent;
+	struct dmtimer_platform_data *pdata;
+
+	if (unlikely(!timer))
+		return -EINVAL;
+
+	pdata = timer->pdev->dev.platform_data;
+
+	if (source < 0 || source >= 3)
+		return -EINVAL;
+
+	/*
+	 * FIXME: Used for OMAP1 devices only because they do not currently
+	 * use the clock framework to set the parent clock. To be removed
+	 * once OMAP1 migrated to using clock framework for dmtimers
+	 */
+	if (pdata && pdata->set_timer_src)
+		return pdata->set_timer_src(timer->pdev, source);
+
+	if (IS_ERR(timer->fclk))
+		return -EINVAL;
+
+	switch (source) {
+		case OMAP_TIMER_SRC_SYS_CLK:
+			parent_name = "timer_sys_ck";
+			break;
+
+		case OMAP_TIMER_SRC_32_KHZ:
+			parent_name = "timer_32k_ck";
+			break;
+
+		case OMAP_TIMER_SRC_EXT_CLK:
+			parent_name = "timer_ext_ck";
+			break;
+	}
+
+	parent = clk_get(&timer->pdev->dev, parent_name);
+	if (IS_ERR(parent)) {
+		pr_err("%s: %s not found\n", __func__, parent_name);
+		return -EINVAL;
+	}
+
+	ret = clk_set_parent(timer->fclk, parent);
+	if (ret < 0)
+		pr_err("%s: failed to set %s as parent\n", __func__,
+				parent_name);
+
+	clk_put(parent);
+
+	return ret;
+}
+
+static int omap_dm_timer_set_load(struct omap_dm_timer *timer, int autoreload,
+		unsigned int load)
+{
+	u32 l;
+
+	if (unlikely(!timer))
+		return -EINVAL;
+
+	omap_dm_timer_enable(timer);
+	l = omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
+	if (autoreload)
+		l |= OMAP_TIMER_CTRL_AR;
+	else
+		l &= ~OMAP_TIMER_CTRL_AR;
+	omap_dm_timer_write_reg(timer, OMAP_TIMER_CTRL_REG, l);
+	omap_dm_timer_write_reg(timer, OMAP_TIMER_LOAD_REG, load);
+
+	omap_dm_timer_write_reg(timer, OMAP_TIMER_TRIGGER_REG, 0);
+	/* Save the context */
+	timer->context.tclr = l;
+	timer->context.tldr = load;
+	omap_dm_timer_disable(timer);
+	return 0;
+}
+
+/* Optimized set_load which removes costly spin wait in timer_start */
+static int omap_dm_timer_set_load_start(struct omap_dm_timer *timer, int autoreload,
+		unsigned int load)
+{
+	u32 l;
+
+	if (unlikely(!timer))
+		return -EINVAL;
+
+	omap_dm_timer_enable(timer);
+
+	l = omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
+	if (autoreload) {
+		l |= OMAP_TIMER_CTRL_AR;
+		omap_dm_timer_write_reg(timer, OMAP_TIMER_LOAD_REG, load);
+	} else {
+		l &= ~OMAP_TIMER_CTRL_AR;
+	}
+	l |= OMAP_TIMER_CTRL_ST;
+
+	__omap_dm_timer_load_start(timer, l, load, timer->posted);
+
+	/* Save the context */
+	timer->context.tclr = l;
+	timer->context.tldr = load;
+	timer->context.tcrr = load;
+	return 0;
+}
+
+static int omap_dm_timer_set_match(struct omap_dm_timer *timer, int enable,
+		unsigned int match)
+{
+	u32 l;
+
+	if (unlikely(!timer))
+		return -EINVAL;
+
+	omap_dm_timer_enable(timer);
+	l = omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
+	if (enable)
+		l |= OMAP_TIMER_CTRL_CE;
+	else
+		l &= ~OMAP_TIMER_CTRL_CE;
+	omap_dm_timer_write_reg(timer, OMAP_TIMER_MATCH_REG, match);
+	omap_dm_timer_write_reg(timer, OMAP_TIMER_CTRL_REG, l);
+
+	/* Save the context */
+	timer->context.tclr = l;
+	timer->context.tmar = match;
+	omap_dm_timer_disable(timer);
+	return 0;
+}
+
+static int omap_dm_timer_set_pwm(struct omap_dm_timer *timer, int def_on,
+		int toggle, int trigger)
+{
+	u32 l;
+
+	if (unlikely(!timer))
+		return -EINVAL;
+
+	omap_dm_timer_enable(timer);
+	l = omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
+	l &= ~(OMAP_TIMER_CTRL_GPOCFG | OMAP_TIMER_CTRL_SCPWM |
+			OMAP_TIMER_CTRL_PT | (0x03 << 10));
+	if (def_on)
+		l |= OMAP_TIMER_CTRL_SCPWM;
+	if (toggle)
+		l |= OMAP_TIMER_CTRL_PT;
+	l |= trigger << 10;
+	omap_dm_timer_write_reg(timer, OMAP_TIMER_CTRL_REG, l);
+
+	/* Save the context */
+	timer->context.tclr = l;
+	omap_dm_timer_disable(timer);
+	return 0;
+}
+
+static int omap_dm_timer_set_prescaler(struct omap_dm_timer *timer, int prescaler)
+{
+	u32 l;
+
+	if (unlikely(!timer))
+		return -EINVAL;
+
+	omap_dm_timer_enable(timer);
+	l = omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
+	l &= ~(OMAP_TIMER_CTRL_PRE | (0x07 << 2));
+	if (prescaler >= 0x00 && prescaler <= 0x07) {
+		l |= OMAP_TIMER_CTRL_PRE;
+		l |= prescaler << 2;
+	}
+	omap_dm_timer_write_reg(timer, OMAP_TIMER_CTRL_REG, l);
+
+	/* Save the context */
+	timer->context.tclr = l;
+	omap_dm_timer_disable(timer);
+	return 0;
+}
+
+static int omp_dm_timer_set_int_enable(struct omap_dm_timer *timer,
+		unsigned int value)
+{
+	if (unlikely(!timer))
+		return -EINVAL;
+
+	omap_dm_timer_enable(timer);
+	__omap_dm_timer_int_enable(timer, value);
+
+	/* Save the context */
+	timer->context.tier = value;
+	timer->context.twer = value;
+	omap_dm_timer_disable(timer);
+	return 0;
+}
+
+/**
+ * omap_dm_timer_set_int_disable - disable timer interrupts
+ * @timer:	pointer to timer handle
+ * @mask:	bit mask of interrupts to be disabled
+ *
+ * Disables the specified timer interrupts for a timer.
+ */
+static int omap_dm_timer_set_int_disable(struct omap_dm_timer *timer, u32 mask)
+{
+	u32 l = mask;
+
+	if (unlikely(!timer))
+		return -EINVAL;
+
+	omap_dm_timer_enable(timer);
+
+	if (timer->revision == 1)
+		l = __raw_readl(timer->irq_ena) & ~mask;
+
+	__raw_writel(l, timer->irq_dis);
+	l = omap_dm_timer_read_reg(timer, OMAP_TIMER_WAKEUP_EN_REG) & ~mask;
+	omap_dm_timer_write_reg(timer, OMAP_TIMER_WAKEUP_EN_REG, l);
+
+	/* Save the context */
+	timer->context.tier &= ~mask;
+	timer->context.twer &= ~mask;
+	omap_dm_timer_disable(timer);
+	return 0;
+}
+
+static unsigned int omap_dm_timer_read_status(struct omap_dm_timer *timer)
+{
+	unsigned int l;
+
+	if (unlikely(!timer || pm_runtime_suspended(&timer->pdev->dev))) {
+		pr_err("%s: timer not available or enabled.\n", __func__);
+		return 0;
+	}
+
+	l = __raw_readl(timer->irq_stat);
+
+	return l;
+}
+
+static int omap_dm_timer_write_status(struct omap_dm_timer *timer, unsigned int value)
+{
+	if (unlikely(!timer || pm_runtime_suspended(&timer->pdev->dev)))
+		return -EINVAL;
+
+	__omap_dm_timer_write_status(timer, value);
+
+	return 0;
+}
+
+static unsigned int omap_dm_timer_read_counter(struct omap_dm_timer *timer)
+{
+	if (unlikely(!timer || pm_runtime_suspended(&timer->pdev->dev))) {
+		pr_err("%s: timer not iavailable or enabled.\n", __func__);
+		return 0;
+	}
+
+	return __omap_dm_timer_read_counter(timer, timer->posted);
+}
+
+static int omap_dm_timer_write_counter(struct omap_dm_timer *timer, unsigned int value)
+{
+	if (unlikely(!timer || pm_runtime_suspended(&timer->pdev->dev))) {
+		pr_err("%s: timer not available or enabled.\n", __func__);
+		return -EINVAL;
+	}
+
+	omap_dm_timer_write_reg(timer, OMAP_TIMER_COUNTER_REG, value);
+
+	/* Save the context */
+	timer->context.tcrr = value;
+	return 0;
+}
+
+static int omap_dm_timers_active(void)
+{
+	struct omap_dm_timer *timer;
+
+	list_for_each_entry(timer, &omap_timer_list, node) {
+		if (!timer->reserved)
+			continue;
+
+		if (omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG) &
+				OMAP_TIMER_CTRL_ST) {
+			return 1;
+		}
+	}
+	return 0;
+}
+
+static const struct of_device_id omap_timer_match[];
+
+/**
+ * omap_dm_timer_probe - probe function called for every registered device
+ * @pdev:	pointer to current timer platform device
+ *
+ * Called by driver framework at the end of device registration for all
+ * timer devices.
+ */
+static int omap_dm_timer_probe(struct platform_device *pdev)
+{
+	unsigned long flags;
+	struct omap_dm_timer *timer;
+	struct resource *mem, *irq;
+	struct device *dev = &pdev->dev;
+	const struct of_device_id *match;
+	const struct dmtimer_platform_data *pdata;
+
+	match = of_match_device(of_match_ptr(omap_timer_match), dev);
+	pdata = match ? match->data : dev->platform_data;
+
+	if (!pdata && !dev->of_node) {
+		dev_err(dev, "%s: no platform data.\n", __func__);
+		return -ENODEV;
+	}
+
+	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (unlikely(!irq)) {
+		dev_err(dev, "%s: no IRQ resource.\n", __func__);
+		return -ENODEV;
+	}
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (unlikely(!mem)) {
+		dev_err(dev, "%s: no memory resource.\n", __func__);
+		return -ENODEV;
+	}
+
+	timer = devm_kzalloc(dev, sizeof(struct omap_dm_timer), GFP_KERNEL);
+	if (!timer) {
+		dev_err(dev, "%s: memory alloc failed!\n", __func__);
+		return  -ENOMEM;
+	}
+
+	timer->fclk = ERR_PTR(-ENODEV);
+	timer->io_base = devm_ioremap_resource(dev, mem);
+	if (IS_ERR(timer->io_base))
+		return PTR_ERR(timer->io_base);
+
+	if (dev->of_node) {
+		if (of_find_property(dev->of_node, "ti,timer-alwon", NULL))
+			timer->capability |= OMAP_TIMER_ALWON;
+		if (of_find_property(dev->of_node, "ti,timer-dsp", NULL))
+			timer->capability |= OMAP_TIMER_HAS_DSP_IRQ;
+		if (of_find_property(dev->of_node, "ti,timer-pwm", NULL))
+			timer->capability |= OMAP_TIMER_HAS_PWM;
+		if (of_find_property(dev->of_node, "ti,timer-secure", NULL))
+			timer->capability |= OMAP_TIMER_SECURE;
+	} else {
+		timer->id = pdev->id;
+		timer->capability = pdata->timer_capability;
+		timer->reserved = omap_dm_timer_reserved_systimer(timer->id);
+		timer->get_context_loss_count = pdata->get_context_loss_count;
+	}
+
+	if (pdata)
+		timer->errata = pdata->timer_errata;
+
+	timer->irq = irq->start;
+	timer->pdev = pdev;
+
+	/* Skip pm_runtime_enable for OMAP1 */
+	if (!(timer->capability & OMAP_TIMER_NEEDS_RESET)) {
+		pm_runtime_enable(dev);
+		pm_runtime_irq_safe(dev);
+	}
+
+	if (!timer->reserved) {
+		pm_runtime_get_sync(dev);
+		__omap_dm_timer_init_regs(timer);
+		pm_runtime_put(dev);
+	}
+
+	/* add the timer element to the list */
+	spin_lock_irqsave(&dm_timer_lock, flags);
+	list_add_tail(&timer->node, &omap_timer_list);
+	spin_unlock_irqrestore(&dm_timer_lock, flags);
+
+	dev_dbg(dev, "Device Probed.\n");
+
+	return 0;
+}
+
+/**
+ * omap_dm_timer_remove - cleanup a registered timer device
+ * @pdev:	pointer to current timer platform device
+ *
+ * Called by driver framework whenever a timer device is unregistered.
+ * In addition to freeing platform resources it also deletes the timer
+ * entry from the local list.
+ */
+static int omap_dm_timer_remove(struct platform_device *pdev)
+{
+	struct omap_dm_timer *timer;
+	unsigned long flags;
+	int ret = -EINVAL;
+
+	spin_lock_irqsave(&dm_timer_lock, flags);
+	list_for_each_entry(timer, &omap_timer_list, node)
+		if (!strcmp(dev_name(&timer->pdev->dev),
+					dev_name(&pdev->dev))) {
+			list_del(&timer->node);
+			ret = 0;
+			break;
+		}
+	spin_unlock_irqrestore(&dm_timer_lock, flags);
+
+	return ret;
+}
+
+/* Right now I am only trying to make system timers work
+   in the scheme of things, so disable any post-early boot
+   stuff till then */
+
+#if 0
+static const struct dmtimer_platform_data omap3plus_pdata = {
+	.timer_errata = OMAP_TIMER_ERRATA_I103_I767,
+};
+
+static const struct of_device_id omap_timer_match[] = {
+	{
+		.compatible = "ti,omap2420-timer",
+	},
+	{
+		.compatible = "ti,omap3430-timer",
+		.data = &omap3plus_pdata,
+	},
+	{
+		.compatible = "ti,omap4430-timer",
+		.data = &omap3plus_pdata,
+	},
+	{
+		.compatible = "ti,omap5430-timer",
+		.data = &omap3plus_pdata,
+	},
+	{
+		.compatible = "ti,am335x-timer",
+		.data = &omap3plus_pdata,
+	},
+	{
+		.compatible = "ti,am335x-timer-1ms",
+		.data = &omap3plus_pdata,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, omap_timer_match);
+
+static struct platform_driver omap_dm_timer_driver = {
+	.probe  = omap_dm_timer_probe,
+	.remove = omap_dm_timer_remove,
+	.driver = {
+		.name   = "omap_timer",
+		.of_match_table = of_match_ptr(omap_timer_match),
+	},
+};
+
+early_platform_init("earlytimer", &omap_dm_timer_driver);
+module_platform_driver(omap_dm_timer_driver);
+
+MODULE_DESCRIPTION("OMAP Dual-Mode Timer Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRIVER_NAME);
+MODULE_AUTHOR("Texas Instruments Inc");
+
+#endif
+
+/* Below code borrowed some bits from mach-omap2/timer.c */
+
+int __init omap_dmtimer_powerup(struct omap_dm_timer *timer,
+		struct device_node *np);
+
+
+/* Clockevent code */
+static struct omap_dm_timer clkev;
+
+
+/* Clock event functions */
+static int omap2_gp_timer_set_next_event(unsigned long cycles,
+		struct clock_event_device *evt)
+{
+	__omap_dm_timer_load_start(&clkev, OMAP_TIMER_CTRL_ST,
+			0xffffffff - cycles, OMAP_TIMER_POSTED);
+
+	return 0;
+}
+
+static void omap2_gp_timer_set_mode(enum clock_event_mode mode,
+		struct clock_event_device *evt)
+{
+	u32 period;
+
+	__omap_dm_timer_stop(&clkev, OMAP_TIMER_POSTED, clkev.rate);
+
+	switch (mode) {
+		case CLOCK_EVT_MODE_PERIODIC:
+			period = clkev.rate / HZ;
+			period -= 1;
+			/* Looks like we need to first set the load value separately */
+			__omap_dm_timer_write(&clkev, OMAP_TIMER_LOAD_REG,
+					0xffffffff - period, OMAP_TIMER_POSTED);
+			__omap_dm_timer_load_start(&clkev,
+					OMAP_TIMER_CTRL_AR | OMAP_TIMER_CTRL_ST,
+					0xffffffff - period, OMAP_TIMER_POSTED);
+			break;
+		case CLOCK_EVT_MODE_ONESHOT:
+			break;
+		case CLOCK_EVT_MODE_UNUSED:
+		case CLOCK_EVT_MODE_SHUTDOWN:
+		case CLOCK_EVT_MODE_RESUME:
+			break;
+	}
+}
+
+
+static struct clock_event_device clockevent_gpt = {
+	.features       = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.rating         = 300,
+	.set_next_event = omap2_gp_timer_set_next_event,
+	.set_mode       = omap2_gp_timer_set_mode,
+};
+
+static irqreturn_t omap2_gp_timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *evt = &clockevent_gpt;
+
+	__omap_dm_timer_write_status(&clkev, OMAP_TIMER_INT_OVERFLOW);
+
+	evt->event_handler(evt);
+	return IRQ_HANDLED;
+}
+
+static struct irqaction omap2_gp_timer_irq = {
+	.name           = "gp_timer",
+	.flags          = IRQF_TIMER | IRQF_IRQPOLL,
+	.handler        = omap2_gp_timer_interrupt,
+};
+
+
+/* Clock source functions */
+static struct omap_dm_timer clksrc;
+
+static cycle_t clocksource_read_cycles(struct clocksource *cs)
+{
+	return (cycle_t)__omap_dm_timer_read_counter(&clksrc,
+			OMAP_TIMER_NONPOSTED);
+}
+
+static struct clocksource clocksource_gpt = {
+	.rating         = 300,
+	.read           = clocksource_read_cycles,
+	.mask           = CLOCKSOURCE_MASK(32),
+	.flags          = CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+static u64 notrace dmtimer_read_sched_clock(void)
+{
+	if (clksrc.reserved)
+		return __omap_dm_timer_read_counter(&clksrc,
+				OMAP_TIMER_NONPOSTED);
+
+	return 0;
+}
+
+static int __init omap_dmtimer_init_one(struct omap_dm_timer *timer,
+		struct device_node *np,
+		int posted)
+{
+	timer->irq = irq_of_parse_and_map(np, 0);
+	if (!timer->irq)
+		return -ENXIO;
+
+	timer->io_base = of_iomap(np, 0);
+	if (!timer->io_base)
+		return -ENXIO;
+
+	__omap_dm_timer_init_regs(timer);
+
+	if (posted)
+		__omap_dm_timer_enable_posted(timer);
+
+	/* Check that the intended posted configuration matches the actual */
+	if (posted != timer->posted)
+		return -EINVAL;
+
+	timer->rate = clk_get_rate(timer->fclk);
+	timer->reserved = 1;
+
+	return 0;
+}
+
+static int __init omap_clockevent_init(struct device_node *np)
+{
+	int res;
+
+	clkev.errata = omap_dm_timer_get_errata();
+
+	/*
+	 * For clock-event timers we never read the timer counter and
+	 * so we are not impacted by errata i103 and i767. Therefore,
+	 * we can safely ignore this errata for clock-event timers.
+	 */
+	__omap_dm_timer_override_errata(&clkev, OMAP_TIMER_ERRATA_I103_I767);
+
+	clockevent_gpt.name = "timer_clkev";
+
+	res = omap_dmtimer_init_one(&clkev, np, OMAP_TIMER_POSTED);
+	if (res)
+		return res;
+
+	omap2_gp_timer_irq.dev_id = &clkev;
+	setup_irq(clkev.irq, &omap2_gp_timer_irq);
+
+	__omap_dm_timer_int_enable(&clkev, OMAP_TIMER_INT_OVERFLOW);
+
+	clockevent_gpt.cpumask = cpu_possible_mask;
+	clockevent_gpt.irq = omap_dm_timer_get_irq(&clkev);
+	clockevents_config_and_register(&clockevent_gpt, clkev.rate,
+			3, /* Timer internal resynch latency */
+			0xffffffff);
+
+	pr_info("OMAP clockevent source: %s at %lu Hz\n", clockevent_gpt.name,
+			clkev.rate);
+	return 0;
+}
+
+static int __init omap_clocksource_init(struct device_node *np)
+{
+	int res = 0;
+
+	clksrc.errata = omap_dm_timer_get_errata();
+
+	if (strlen(np->name) > 7) {
+		pr_err("%s: OF node name too big\n", __func__);
+		return -ENODEV;
+	}
+	clocksource_gpt.name = "timer_clksrc";
+
+	res = omap_dmtimer_init_one(&clksrc, np, OMAP_TIMER_NONPOSTED);
+	if (res)
+		return res;
+
+	__omap_dm_timer_load_start(&clksrc,
+			OMAP_TIMER_CTRL_ST | OMAP_TIMER_CTRL_AR, 0,
+			OMAP_TIMER_NONPOSTED);
+	setup_sched_clock(dmtimer_read_sched_clock, 32, clksrc.rate);
+
+	res = clocksource_register_hz(&clocksource_gpt, clksrc.rate);
+	if (res) {
+		pr_err("Could not register clocksource %s\n",
+				clocksource_gpt.name);
+		return res;
+	} else {
+		pr_info("OMAP clocksource: %s at %lu Hz\n",
+				clocksource_gpt.name, clksrc.rate);
+	}
+	return 0;
+}
+
+static int reg_clksrc;
+static int reg_clkev;
+
+static struct property device_disabled = {
+	.name = "status",
+	.length = sizeof("disabled"),
+	.value = "disabled",
+};
+
+static void __init am33xx_clocksource_init(struct device_node *np)
+{
+	if (!reg_clksrc) {
+		if (of_get_property(np, "ti,timer-alwon", NULL)) {
+			omap_dmtimer_powerup(&clksrc, np);
+			clksrc.fclk = of_clk_get(np, 0);
+			omap_clocksource_init(np);
+			of_add_property(np, &device_disabled);
+			reg_clksrc = 1;
+			return;
+		}
+	}
+
+	if (!reg_clkev) {
+		omap_dmtimer_powerup(&clkev, np);
+		clkev.fclk = of_clk_get(np, 0);
+		omap_clockevent_init(np);
+		of_add_property(np, &device_disabled);
+		reg_clkev = 1;
+	}
+}
+
+CLOCKSOURCE_OF_DECLARE(am33xx_timer_1ms, "ti,am335x-timer-1ms",
+		       am33xx_clocksource_init);
+CLOCKSOURCE_OF_DECLARE(am33xx_timer, "ti,am335x-timer",
+		       am33xx_clocksource_init);
diff --git a/drivers/clocksource/omap-timer.h b/drivers/clocksource/omap-timer.h
new file mode 100644
index 0000000..dd85c52
--- /dev/null
+++ b/drivers/clocksource/omap-timer.h
@@ -0,0 +1,422 @@
+/*
+ * drivers/clocksource/omap-timer.h
+ *
+ * OMAP Dual-Mode Timers
+ *
+ * Copyright (C) 2014 Texas Instruments Incorporated - http://www.ti.com/
+ * Joel Fernandes <joelf@ti.com>
+ * Tarun Kanti DebBarma <tarun.kanti@ti.com>
+ * Thara Gopinath <thara@ti.com>
+ *
+ * Platform device conversion and hwmod support.
+ *
+ * Copyright (C) 2005 Nokia Corporation
+ * Author: Lauri Leukkunen <lauri.leukkunen@nokia.com>
+ * PWM and clock framwork support by Timo Teras.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
+ * NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
+ * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ * You should have received a copy of the  GNU General Public License along
+ * with this program; if not, write  to the Free Software Foundation, Inc.,
+ * 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+
+#ifndef __OMAP_TIMER_H
+#define __OMAP_TIMER_H
+
+/* clock sources */
+#define OMAP_TIMER_SRC_SYS_CLK			0x00
+#define OMAP_TIMER_SRC_32_KHZ			0x01
+#define OMAP_TIMER_SRC_EXT_CLK			0x02
+
+/* timer interrupt enable bits */
+#define OMAP_TIMER_INT_CAPTURE			(1 << 2)
+#define OMAP_TIMER_INT_OVERFLOW			(1 << 1)
+#define OMAP_TIMER_INT_MATCH			(1 << 0)
+
+/* trigger types */
+#define OMAP_TIMER_TRIGGER_NONE			0x00
+#define OMAP_TIMER_TRIGGER_OVERFLOW		0x01
+#define OMAP_TIMER_TRIGGER_OVERFLOW_AND_COMPARE	0x02
+
+/* posted mode types */
+#define OMAP_TIMER_NONPOSTED			0x00
+#define OMAP_TIMER_POSTED			0x01
+
+/* timer capabilities used in hwmod database */
+#define OMAP_TIMER_SECURE				0x80000000
+#define OMAP_TIMER_ALWON				0x40000000
+#define OMAP_TIMER_HAS_PWM				0x20000000
+#define OMAP_TIMER_NEEDS_RESET				0x10000000
+#define OMAP_TIMER_HAS_DSP_IRQ				0x08000000
+
+/*
+ * timer errata flags
+ *
+ * Errata i103/i767 impacts all OMAP3/4/5 devices including AM33xx. This
+ * errata prevents us from using posted mode on these devices, unless the
+ * timer counter register is never read. For more details please refer to
+ * the OMAP3/4/5 errata documents.
+ */
+#define OMAP_TIMER_ERRATA_I103_I767			0x80000000
+
+struct omap_timer_capability_dev_attr {
+	u32 timer_capability;
+};
+
+struct timer_regs {
+	u32 tidr;
+	u32 tier;
+	u32 twer;
+	u32 tclr;
+	u32 tcrr;
+	u32 tldr;
+	u32 ttrg;
+	u32 twps;
+	u32 tmar;
+	u32 tcar1;
+	u32 tsicr;
+	u32 tcar2;
+	u32 tpir;
+	u32 tnir;
+	u32 tcvr;
+	u32 tocr;
+	u32 towr;
+};
+
+struct omap_dm_timer {
+	int id;
+	int irq;
+	struct clk *fclk;
+
+	void __iomem	*io_base;
+	void __iomem	*irq_stat;	/* TISR/IRQSTATUS interrupt status */
+	void __iomem	*irq_ena;	/* irq enable */
+	void __iomem	*irq_dis;	/* irq disable, only on v2 ip */
+	void __iomem	*pend;		/* write pending */
+	void __iomem	*func_base;	/* function register base */
+
+	unsigned long rate;
+	unsigned reserved:1;
+	unsigned posted:1;
+	struct timer_regs context;
+	int (*get_context_loss_count)(struct device *);
+	int ctx_loss_count;
+	int revision;
+	u32 capability;
+	u32 errata;
+	struct platform_device *pdev;
+	struct list_head node;
+};
+
+static int omap_dm_timer_reserve_systimer(int id);
+static struct omap_dm_timer *omap_dm_timer_request(void);
+static struct omap_dm_timer *omap_dm_timer_request_specific(int timer_id);
+static struct omap_dm_timer *omap_dm_timer_request_by_cap(u32 cap);
+static struct omap_dm_timer *omap_dm_timer_request_by_node(struct device_node *np);
+static int omap_dm_timer_free(struct omap_dm_timer *timer);
+static void omap_dm_timer_enable(struct omap_dm_timer *timer);
+static void omap_dm_timer_disable(struct omap_dm_timer *timer);
+
+static int omap_dm_timer_get_irq(struct omap_dm_timer *timer);
+
+static u32 omap_dm_timer_modify_idlect_mask(u32 inputmask);
+static struct clk *omap_dm_timer_get_fclk(struct omap_dm_timer *timer);
+
+static int omap_dm_timer_trigger(struct omap_dm_timer *timer);
+static int omap_dm_timer_start(struct omap_dm_timer *timer);
+static int omap_dm_timer_stop(struct omap_dm_timer *timer);
+
+static int omap_dm_timer_set_source(struct omap_dm_timer *timer, int source);
+static int omap_dm_timer_set_load(struct omap_dm_timer *timer, int autoreload, unsigned int value);
+static int omap_dm_timer_set_load_start(struct omap_dm_timer *timer, int autoreload, unsigned int value);
+static int omap_dm_timer_set_match(struct omap_dm_timer *timer, int enable, unsigned int match);
+static int omap_dm_timer_set_pwm(struct omap_dm_timer *timer, int def_on, int toggle, int trigger);
+static int omap_dm_timer_set_prescaler(struct omap_dm_timer *timer, int prescaler);
+
+static int omap_dm_timer_set_int_enable(struct omap_dm_timer *timer,
+					unsigned int value);
+static int omap_dm_timer_set_int_disable(struct omap_dm_timer *timer, u32 mask);
+
+static unsigned int omap_dm_timer_read_status(struct omap_dm_timer *timer);
+static int omap_dm_timer_write_status(struct omap_dm_timer *timer,
+				      unsigned int value);
+static unsigned int omap_dm_timer_read_counter(struct omap_dm_timer *timer);
+static int omap_dm_timer_write_counter(struct omap_dm_timer *timer,
+				       unsigned int value);
+
+static int omap_dm_timers_active(void);
+
+/*
+ * Do not use the defines below, they are not needed. They should be only
+ * used by dmtimer.c and sys_timer related code.
+ */
+
+/*
+ * The interrupt registers are different between v1 and v2 ip.
+ * These registers are offsets from timer->iobase.
+ */
+#define OMAP_TIMER_ID_OFFSET		0x00
+#define OMAP_TIMER_OCP_CFG_OFFSET	0x10
+
+#define OMAP_TIMER_V1_SYS_STAT_OFFSET	0x14
+#define OMAP_TIMER_V1_STAT_OFFSET	0x18
+#define OMAP_TIMER_V1_INT_EN_OFFSET	0x1c
+
+#define OMAP_TIMER_V2_IRQSTATUS_RAW	0x24
+#define OMAP_TIMER_V2_IRQSTATUS		0x28
+#define OMAP_TIMER_V2_IRQENABLE_SET	0x2c
+#define OMAP_TIMER_V2_IRQENABLE_CLR	0x30
+
+/*
+ * The functional registers have a different base on v1 and v2 ip.
+ * These registers are offsets from timer->func_base. The func_base
+ * is samae as io_base for v1 and io_base + 0x14 for v2 ip.
+ *
+ */
+#define OMAP_TIMER_V2_FUNC_OFFSET		0x14
+
+#define _OMAP_TIMER_WAKEUP_EN_OFFSET	0x20
+#define _OMAP_TIMER_CTRL_OFFSET		0x24
+#define		OMAP_TIMER_CTRL_GPOCFG		(1 << 14)
+#define		OMAP_TIMER_CTRL_CAPTMODE	(1 << 13)
+#define		OMAP_TIMER_CTRL_PT		(1 << 12)
+#define		OMAP_TIMER_CTRL_TCM_LOWTOHIGH	(0x1 << 8)
+#define		OMAP_TIMER_CTRL_TCM_HIGHTOLOW	(0x2 << 8)
+#define		OMAP_TIMER_CTRL_TCM_BOTHEDGES	(0x3 << 8)
+#define		OMAP_TIMER_CTRL_SCPWM		(1 << 7)
+#define		OMAP_TIMER_CTRL_CE		(1 << 6) /* compare enable */
+#define		OMAP_TIMER_CTRL_PRE		(1 << 5) /* prescaler enable */
+#define		OMAP_TIMER_CTRL_PTV_SHIFT	2 /* prescaler value shift */
+#define		OMAP_TIMER_CTRL_POSTED		(1 << 2)
+#define		OMAP_TIMER_CTRL_AR		(1 << 1) /* autoreload enable */
+#define		OMAP_TIMER_CTRL_ST		(1 << 0) /* start timer */
+#define _OMAP_TIMER_COUNTER_OFFSET	0x28
+#define _OMAP_TIMER_LOAD_OFFSET		0x2c
+#define _OMAP_TIMER_TRIGGER_OFFSET	0x30
+#define _OMAP_TIMER_WRITE_PEND_OFFSET	0x34
+#define		WP_NONE			0	/* no write pending bit */
+#define		WP_TCLR			(1 << 0)
+#define		WP_TCRR			(1 << 1)
+#define		WP_TLDR			(1 << 2)
+#define		WP_TTGR			(1 << 3)
+#define		WP_TMAR			(1 << 4)
+#define		WP_TPIR			(1 << 5)
+#define		WP_TNIR			(1 << 6)
+#define		WP_TCVR			(1 << 7)
+#define		WP_TOCR			(1 << 8)
+#define		WP_TOWR			(1 << 9)
+#define _OMAP_TIMER_MATCH_OFFSET	0x38
+#define _OMAP_TIMER_CAPTURE_OFFSET	0x3c
+#define _OMAP_TIMER_IF_CTRL_OFFSET	0x40
+#define _OMAP_TIMER_CAPTURE2_OFFSET		0x44	/* TCAR2, 34xx only */
+#define _OMAP_TIMER_TICK_POS_OFFSET		0x48	/* TPIR, 34xx only */
+#define _OMAP_TIMER_TICK_NEG_OFFSET		0x4c	/* TNIR, 34xx only */
+#define _OMAP_TIMER_TICK_COUNT_OFFSET		0x50	/* TCVR, 34xx only */
+#define _OMAP_TIMER_TICK_INT_MASK_SET_OFFSET	0x54	/* TOCR, 34xx only */
+#define _OMAP_TIMER_TICK_INT_MASK_COUNT_OFFSET	0x58	/* TOWR, 34xx only */
+
+/* register offsets with the write pending bit encoded */
+#define	WPSHIFT					16
+
+#define OMAP_TIMER_WAKEUP_EN_REG		(_OMAP_TIMER_WAKEUP_EN_OFFSET \
+							| (WP_NONE << WPSHIFT))
+
+#define OMAP_TIMER_CTRL_REG			(_OMAP_TIMER_CTRL_OFFSET \
+							| (WP_TCLR << WPSHIFT))
+
+#define OMAP_TIMER_COUNTER_REG			(_OMAP_TIMER_COUNTER_OFFSET \
+							| (WP_TCRR << WPSHIFT))
+
+#define OMAP_TIMER_LOAD_REG			(_OMAP_TIMER_LOAD_OFFSET \
+							| (WP_TLDR << WPSHIFT))
+
+#define OMAP_TIMER_TRIGGER_REG			(_OMAP_TIMER_TRIGGER_OFFSET \
+							| (WP_TTGR << WPSHIFT))
+
+#define OMAP_TIMER_WRITE_PEND_REG		(_OMAP_TIMER_WRITE_PEND_OFFSET \
+							| (WP_NONE << WPSHIFT))
+
+#define OMAP_TIMER_MATCH_REG			(_OMAP_TIMER_MATCH_OFFSET \
+							| (WP_TMAR << WPSHIFT))
+
+#define OMAP_TIMER_CAPTURE_REG			(_OMAP_TIMER_CAPTURE_OFFSET \
+							| (WP_NONE << WPSHIFT))
+
+#define OMAP_TIMER_IF_CTRL_REG			(_OMAP_TIMER_IF_CTRL_OFFSET \
+							| (WP_NONE << WPSHIFT))
+
+#define OMAP_TIMER_CAPTURE2_REG			(_OMAP_TIMER_CAPTURE2_OFFSET \
+							| (WP_NONE << WPSHIFT))
+
+#define OMAP_TIMER_TICK_POS_REG			(_OMAP_TIMER_TICK_POS_OFFSET \
+							| (WP_TPIR << WPSHIFT))
+
+#define OMAP_TIMER_TICK_NEG_REG			(_OMAP_TIMER_TICK_NEG_OFFSET \
+							| (WP_TNIR << WPSHIFT))
+
+#define OMAP_TIMER_TICK_COUNT_REG		(_OMAP_TIMER_TICK_COUNT_OFFSET \
+							| (WP_TCVR << WPSHIFT))
+
+#define OMAP_TIMER_TICK_INT_MASK_SET_REG				\
+		(_OMAP_TIMER_TICK_INT_MASK_SET_OFFSET | (WP_TOCR << WPSHIFT))
+
+#define OMAP_TIMER_TICK_INT_MASK_COUNT_REG				\
+		(_OMAP_TIMER_TICK_INT_MASK_COUNT_OFFSET | (WP_TOWR << WPSHIFT))
+
+static inline u32 __omap_dm_timer_read(struct omap_dm_timer *timer, u32 reg,
+						int posted)
+{
+	if (posted)
+		while (__raw_readl(timer->pend) & (reg >> WPSHIFT))
+			cpu_relax();
+
+	return __raw_readl(timer->func_base + (reg & 0xff));
+}
+
+static inline void __omap_dm_timer_write(struct omap_dm_timer *timer,
+					u32 reg, u32 val, int posted)
+{
+	if (posted)
+		while (__raw_readl(timer->pend) & (reg >> WPSHIFT))
+			cpu_relax();
+
+	__raw_writel(val, timer->func_base + (reg & 0xff));
+}
+
+static inline void __omap_dm_timer_init_regs(struct omap_dm_timer *timer)
+{
+	u32 tidr;
+
+	/* Assume v1 ip if bits [31:16] are zero */
+	tidr = __raw_readl(timer->io_base);
+	if (!(tidr >> 16)) {
+		timer->revision = 1;
+		timer->irq_stat = timer->io_base + OMAP_TIMER_V1_STAT_OFFSET;
+		timer->irq_ena = timer->io_base + OMAP_TIMER_V1_INT_EN_OFFSET;
+		timer->irq_dis = timer->io_base + OMAP_TIMER_V1_INT_EN_OFFSET;
+		timer->pend = timer->io_base + _OMAP_TIMER_WRITE_PEND_OFFSET;
+		timer->func_base = timer->io_base;
+	} else {
+		timer->revision = 2;
+		timer->irq_stat = timer->io_base + OMAP_TIMER_V2_IRQSTATUS;
+		timer->irq_ena = timer->io_base + OMAP_TIMER_V2_IRQENABLE_SET;
+		timer->irq_dis = timer->io_base + OMAP_TIMER_V2_IRQENABLE_CLR;
+		timer->pend = timer->io_base +
+			_OMAP_TIMER_WRITE_PEND_OFFSET +
+				OMAP_TIMER_V2_FUNC_OFFSET;
+		timer->func_base = timer->io_base + OMAP_TIMER_V2_FUNC_OFFSET;
+	}
+}
+
+/*
+ * __omap_dm_timer_enable_posted - enables write posted mode
+ * @timer:      pointer to timer instance handle
+ *
+ * Enables the write posted mode for the timer. When posted mode is enabled
+ * writes to certain timer registers are immediately acknowledged by the
+ * internal bus and hence prevents stalling the CPU waiting for the write to
+ * complete. Enabling this feature can improve performance for writing to the
+ * timer registers.
+ */
+static inline void __omap_dm_timer_enable_posted(struct omap_dm_timer *timer)
+{
+	if (timer->posted)
+		return;
+
+	if (timer->errata & OMAP_TIMER_ERRATA_I103_I767) {
+		timer->posted = OMAP_TIMER_NONPOSTED;
+		__omap_dm_timer_write(timer, OMAP_TIMER_IF_CTRL_REG, 0, 0);
+		return;
+	}
+
+	__omap_dm_timer_write(timer, OMAP_TIMER_IF_CTRL_REG,
+			      OMAP_TIMER_CTRL_POSTED, 0);
+	timer->context.tsicr = OMAP_TIMER_CTRL_POSTED;
+	timer->posted = OMAP_TIMER_POSTED;
+}
+
+/**
+ * __omap_dm_timer_override_errata - override errata flags for a timer
+ * @timer:      pointer to timer handle
+ * @errata:	errata flags to be ignored
+ *
+ * For a given timer, override a timer errata by clearing the flags
+ * specified by the errata argument. A specific erratum should only be
+ * overridden for a timer if the timer is used in such a way the erratum
+ * has no impact.
+ */
+static inline void __omap_dm_timer_override_errata(struct omap_dm_timer *timer,
+						   u32 errata)
+{
+	timer->errata &= ~errata;
+}
+
+static inline void __omap_dm_timer_stop(struct omap_dm_timer *timer,
+					int posted, unsigned long rate)
+{
+	u32 l;
+
+	l = __omap_dm_timer_read(timer, OMAP_TIMER_CTRL_REG, posted);
+	if (l & OMAP_TIMER_CTRL_ST) {
+		l &= ~0x1;
+		__omap_dm_timer_write(timer, OMAP_TIMER_CTRL_REG, l, posted);
+#ifdef CONFIG_ARCH_OMAP2PLUS
+		/* Readback to make sure write has completed */
+		__omap_dm_timer_read(timer, OMAP_TIMER_CTRL_REG, posted);
+		/*
+		 * Wait for functional clock period x 3.5 to make sure that
+		 * timer is stopped
+		 */
+		udelay(3500000 / rate + 1);
+#endif
+	}
+
+	/* Ack possibly pending interrupt */
+	__raw_writel(OMAP_TIMER_INT_OVERFLOW, timer->irq_stat);
+}
+
+static inline void __omap_dm_timer_load_start(struct omap_dm_timer *timer,
+						u32 ctrl, unsigned int load,
+						int posted)
+{
+	__omap_dm_timer_write(timer, OMAP_TIMER_COUNTER_REG, load, posted);
+	__omap_dm_timer_write(timer, OMAP_TIMER_CTRL_REG, ctrl, posted);
+}
+
+static inline void __omap_dm_timer_int_enable(struct omap_dm_timer *timer,
+						unsigned int value)
+{
+	__raw_writel(value, timer->irq_ena);
+	__omap_dm_timer_write(timer, OMAP_TIMER_WAKEUP_EN_REG, value, 0);
+}
+
+static inline unsigned int
+__omap_dm_timer_read_counter(struct omap_dm_timer *timer, int posted)
+{
+	return __omap_dm_timer_read(timer, OMAP_TIMER_COUNTER_REG, posted);
+}
+
+static inline void __omap_dm_timer_write_status(struct omap_dm_timer *timer,
+						unsigned int value)
+{
+	__raw_writel(value, timer->irq_stat);
+}
+
+#endif /* __OMAP_TIMER_H */
-- 
1.7.9.5

