Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaB0Cfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 21:35:34 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:54247 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbaB0Cfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 21:35:30 -0500
Date: Wed, 26 Feb 2014 20:34:55 -0600
From: Nishanth Menon <nm@ti.com>
To: Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Mark Brown <broonie@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [RFC PATCH 1/6] PM / Voltagedomain: Add generic clk notifier
 handler for regulator based dynamic voltage scaling
Message-ID: <20140227023455.GA15712@kahuna>
References: <1392755543-28335-1-git-send-email-nm@ti.com>
 <1392755543-28335-2-git-send-email-nm@ti.com>
 <20140225055142.22529.21814@quantum>
 <530D0394.4020208@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <530D0394.4020208@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:56-20140225, Nishanth Menon wrote:
> On 02/24/2014 11:51 PM, Mike Turquette wrote:
> > Quoting Nishanth Menon (2014-02-18 12:32:18)
[...]
> > I'm not sure about trying to capture the "voltdm" as a core concept. It
> > feels a bit unwieldy to me.
> 
> Considering it is a simple collation of regulators and SoC specific
> "magic" which have to be operated in tandem to clock operation, Why
> does it seem unwieldy? Usage of multiple voltage planes in a single
> voltage domain concept does not seem unique to TI processors either:
> For example, imx6q-cpufreq.c uses 3 regulators (arm, pu, soc),
> s5pv210-cpufreq.c uses two regulators (vddarm, vddint), ideally OMAP
> implementation would use two (vdd_mpu, vbb_mpu).
> 
> > I have wondered about making an abstract
> > "performance domain" which is the dvfs analogue to generic power
> > domains. This a reasonable split since gpd are good for idle power
> > savings (e.g. clock gate, power gate, sleep state, etc) and "perf
> > domains" would be good for active power savings (dvfs).
> > 
> > Having a generic container for performance domains might make a good
> > place to stuff all of this glue logic that we keep running into (e.g.
> > CPU and GPU max frequencies that are related), and it might make another
> > nice knob for the thermal folks to use.
> 
> This sounds like one level higher abstraction that we are speaking of
> here? I was'nt intending to solve the bigger picture problem here -
> just an abstraction level that might allow reusablity for multiple
> SoCs. In fact, having an abstraction away for voltage domain(which may
> consist of multiple regulators and any SoC specific magic) purely
> allows us to move towards a direction you mention here.
> 
> > 
> > For the case of the OMAP voltage domains, it would be a place to stuff
> > all of the VC/VP -> ABB -> Smart Reflex AVS stuff.
> > 
> 
> Unfortunately, I dont completely comprehend objection we have to this
> approach (other than an higher level abstraction is needed) and if we
> do have an objection, what is the alternate approach should be for
> representing hardware which this series attempts to present.

I think the following is around the lines of your thought direction -
if Rafael or others have comments on the following approach, it'd be a
good starting point for me to progress.

-->8--
>From 62e50b9f920495db88e5594aa6bceb52e83a443d Mon Sep 17 00:00:00 2001
From: Nishanth Menon <nm@ti.com>
Date: Wed, 26 Feb 2014 10:59:59 -0600
Subject: [PATCH] PM / Runtime: introduce active power management callbacks
 for pm_domain

dev_pm_domain currently handles just device idle power management
using the generic pm_runtime_get|put and related family of functions.

Logically with appropriate pm_domain hooks this can translate to
hardware specific clock and related operations. Given that pm_domains
may contain this information, this provides an opportunity to extend
current pm_runtime do dynamic power operations as well.

What this means for drivers is as follows:

Today, drivers(with some level of complexity) do:
pm_runtime_get_sync(dev);
clk = clk_get(dev, "name");
old_rate = clk_get_rate(clk);
...
clk_set_rate(clk, new_rate);
...
clk_put(clk);
pm_runtime_get_sync(dev);

Instead, on pm_domains that can handle this as part of
pm_domain->active_ops functions, They can now do the following:
pm_runtime_get_sync(dev);
old_rate = pm_runtime_get_rate(dev);
...
pm_runtime_set_rate(dev, new_rate);
...
pm_runtime_put_sync(dev);

Obviously, this'd work for devices that handle a single main
functional clock, but this could reduce complexity of drivers having
to deal with power management details to have pm_runtime as the main
point of interface.

CAVEAT: For power domains that are capable of handling multiple
clocks (example on OMAP, where there are the concepts of interface,
functional and optional clocks per block), appropriate handling will
be necessary from pm_domain callbacks. So, the question about which
clock rate is being controlled or returned to is entirely upto the
pm_domain implementation.

On the otherhand, we can debate about defining and querying ACPI style
"Performance state" instead of frequencies and wrap P-states inside
or the other way around.. but given that majority of drivers using
pm_runtime would rather be interested in frequencies and my naieve
belief that we can index P-states with frequencies, kind of influenced
my choice here of proposing frequencies as base query parameter..
ofcourse, debate is still open here.

Yes, we can still debate if providing yet another wrapper on top of
clock APIs makes sense at all as well.

Nyet-signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/base/power/runtime.c |  101 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/pm.h           |   25 +++++++++--
 include/linux/pm_runtime.h   |   21 +++++++++
 3 files changed, 143 insertions(+), 4 deletions(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 72e00e6..ef230b4 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1401,3 +1401,104 @@ void pm_runtime_remove(struct device *dev)
 	if (dev->power.irq_safe && dev->parent)
 		pm_runtime_put(dev->parent);
 }
+
+/**
+ * pm_runtime_get_rate() - Returns the device operational frequency
+ * @dev:	Device to handle
+ * @rate:	Returns rate in Hz.
+ *
+ * Returns appropriate error value in case of error conditions, else
+ * returns 0 and rate is updated. The pm_domain logic does all the necessary
+ * operation (which may consider magic hardware stuff) to provide the rate.
+ *
+ * NOTE: the rate returned is a snapshot and in many cases just a bypass
+ * to clk api to set the rate.
+ */
+int pm_runtime_get_rate(struct device *dev, unsigned long *rate)
+{
+	unsigned long flags;
+	int error = -ENOSYS;
+
+	if (!rate || !dev)
+		return -EINVAL;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+	if (!pm_runtime_active(dev)) {
+		error = -EINVAL;
+		goto out;
+	}
+
+	if (dev->pm_domain && dev->pm_domain->active_ops.get_rate)
+		error = dev->pm_domain->active_ops.get_rate(dev, rate);
+out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	return error;
+}
+
+/**
+ * pm_runtime_set_rate() - Set a specific rate for the device operation
+ * @dev:	Device to handle
+ * @rate:	Rate to set in Hz
+ *
+ * Returns appropriate error value in case of error conditions, else
+ * returns 0. The pm_domain logic does all the necessary operation (which
+ * may include voltage scale operations or other magic hardware stuff) to
+ * achieve the operation. It is guarenteed that the requested rate is achieved
+ * on returning from this function if return value is 0.
+ */
+int pm_runtime_set_rate(struct device *dev, unsigned long rate)
+{
+	unsigned long flags;
+	int error = -ENOSYS;
+
+	if (!rate || !dev)
+		return -EINVAL;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+	if (!pm_runtime_active(dev)) {
+		error = -EINVAL;
+		goto out;
+	}
+
+	if (dev->pm_domain && dev->pm_domain->active_ops.set_rate)
+		error = dev->pm_domain->active_ops.set_rate(dev, rate);
+out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	return error;
+}
+
+/**
+ * pm_runtime_get_transition_latency() - determine transition latency`
+ * @dev:	Device to handle
+ * @from_rate:	Transition from which rate
+ * @to_rate:	Transition to which rate
+ *
+ * Returns appropriate error value in case of error conditions, else
+ * returns the latency in uSecs for transition between two given rates
+ */
+int pm_runtime_get_transition_latency(struct device *dev,
+				      unsigned long from_rate,
+				      unsigned long to_rate)
+{
+	unsigned long flags;
+	int error = -ENOSYS;
+
+	if (!from_rate || !to_rate || !dev)
+		return -EINVAL;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+	if (!pm_runtime_active(dev)) {
+		error = -EINVAL;
+		goto out;
+	}
+
+	if (dev->pm_domain && dev->pm_domain->active_ops.get_transition_latency)
+		error = dev->pm_domain->active_ops.get_transition_latency(dev,
+				from_rate, to_rate);
+out:
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+
+	return error;
+}
diff --git a/include/linux/pm.h b/include/linux/pm.h
index 8c6583a..f907b27 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -299,6 +299,20 @@ struct dev_pm_ops {
 	int (*runtime_idle)(struct device *dev);
 };
 
+/**
+ * struct dev_pm_active_ops - Active power management operations
+ * @get_rate:	get the current operational frequency
+ * @set_rate:	set the current operational frequency
+ * @get_transition_latency: get the transition latency in uSeconds
+ */
+struct dev_pm_active_ops {
+	int (*get_rate)(struct device *dev, unsigned long *rate);
+	int (*set_rate)(struct device *dev, unsigned long rate);
+	int (*get_transition_latency)(struct device *dev,
+				      unsigned long from_rate,
+				      unsigned long to_rate);
+};
+
 #ifdef CONFIG_PM_SLEEP
 #define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
 	.suspend = suspend_fn, \
@@ -589,13 +603,16 @@ extern void update_pm_runtime_accounting(struct device *dev);
 extern int dev_pm_get_subsys_data(struct device *dev);
 extern int dev_pm_put_subsys_data(struct device *dev);
 
-/*
- * Power domains provide callbacks that are executed during system suspend,
- * hibernation, system resume and during runtime PM transitions along with
- * subsystem-level and driver-level callbacks.
+/**
+ * struct dev_pm_domain - power domain information
+ * @ops: Power domains provide callbacks that are executed during system
+ *	suspend, hibernation, system resume and during runtime PM transitions
+ *	along with subsystem-level and driver-level callbacks.
+ * @active_ops: Active operational callbacks
  */
 struct dev_pm_domain {
 	struct dev_pm_ops	ops;
+	struct dev_pm_active_ops active_ops;
 };
 
 /*
diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index 16c9a62..731a6e4 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -112,6 +112,11 @@ static inline void pm_runtime_mark_last_busy(struct device *dev)
 	ACCESS_ONCE(dev->power.last_busy) = jiffies;
 }
 
+extern int pm_runtime_get_rate(struct device *dev, unsigned long *rate);
+extern int pm_runtime_set_rate(struct device *dev, unsigned long rate);
+extern int pm_runtime_get_transition_latency(struct device *dev,
+					     unsigned long from_rate,
+					     unsigned long to_rate);
 #else /* !CONFIG_PM_RUNTIME */
 
 static inline int __pm_runtime_idle(struct device *dev, int rpmflags)
@@ -162,6 +167,22 @@ static inline unsigned long pm_runtime_autosuspend_expiration(
 static inline void pm_runtime_set_memalloc_noio(struct device *dev,
 						bool enable){}
 
+static inline int pm_runtime_get_rate(struct device *dev, unsigned long *rate)
+{
+	return -ENOSYS;
+}
+
+static inline int pm_runtime_set_rate(struct device *dev, unsigned long rate)
+{
+	return -ENOSYS;
+}
+
+static inline int pm_runtime_get_transition_latency(struct device *dev,
+						    unsigned long from_rate,
+						    unsigned long to_rate)
+{
+	return -ENOSYS;
+}
 #endif /* !CONFIG_PM_RUNTIME */
 
 static inline int pm_runtime_idle(struct device *dev)
-- 
1.7.9.5

-- 
Regards,
Nishanth Menon
