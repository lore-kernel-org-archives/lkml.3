Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258AbaJVWqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 18:46:23 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34805 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483AbaJVWqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 18:46:20 -0400
Date: Wed, 22 Oct 2014 15:46:14 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: ssantosh@kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        khilman@linaro.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-pm@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        grant.likely@secretlab.ca, ulf.hansson@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/3] PM / clock_ops: Add pm_clk_add_clk()
Message-ID: <20141022224614.GD4250@dtor-ws>
References: <1413809764-21995-1-git-send-email-grygorii.strashko@ti.com>
 <1413809764-21995-2-git-send-email-grygorii.strashko@ti.com>
 <20141022173856.GB28104@dtor-ws>
 <5447FF51.5000401@ti.com>
 <20141022201409.GB4250@dtor-ws>
 <20141022211631.GC4250@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022211631.GC4250@dtor-ws>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 02:16:31PM -0700, Dmitry Torokhov wrote:
> On Wed, Oct 22, 2014 at 01:14:09PM -0700, Dmitry Torokhov wrote:
> > On Wed, Oct 22, 2014 at 10:02:41PM +0300, Grygorii Strashko wrote:
> > > On 10/22/2014 08:38 PM, Dmitry Torokhov wrote:
> > > >On Mon, Oct 20, 2014 at 03:56:02PM +0300, Grygorii Strashko wrote:
> > > >>From: Geert Uytterhoeven <geert+renesas@glider.be>
> > > >>
> > > >>The existing pm_clk_add() allows to pass a clock by con_id. However,
> > > >>when referring to a specific clock from DT, no con_id is available.
> > > >>
> > > >>Add pm_clk_add_clk(), which allows to specify the struct clk * directly.
> > > >>
> > > >>Reviewed-by: Kevin Hilman <khilman@linaro.org>
> > > >>Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > > >>Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> > > >>---
> > > >>
> > > >>  Pay attantion pls, that there is another series of patches
> > > >>  which have been posted already and which depends from this patch
> > > >>    "[PATCH v4 0/3] ARM: rk3288 : Add PM Domain support"
> > > >>    https://lkml.org/lkml/2014/10/20/105
> > > >>
> > > >>  drivers/base/power/clock_ops.c | 41 +++++++++++++++++++++++++++++++----------
> > > >>  include/linux/pm_clock.h       |  8 ++++++++
> > > >>  2 files changed, 39 insertions(+), 10 deletions(-)
> > > >>
> > > >>diff --git a/drivers/base/power/clock_ops.c b/drivers/base/power/clock_ops.c
> > > >>index 7836930..f14b767 100644
> > > >>--- a/drivers/base/power/clock_ops.c
> > > >>+++ b/drivers/base/power/clock_ops.c
> > > >>@@ -53,7 +53,8 @@ static inline int __pm_clk_enable(struct device *dev, struct clk *clk)
> > > >>   */
> > > >>  static void pm_clk_acquire(struct device *dev, struct pm_clock_entry *ce)
> > > >>  {
> > > >>-	ce->clk = clk_get(dev, ce->con_id);
> > > >>+	if (!ce->clk)
> > > >>+		ce->clk = clk_get(dev, ce->con_id);
> > > >>  	if (IS_ERR(ce->clk)) {
> > > >>  		ce->status = PCE_STATUS_ERROR;
> > > >>  	} else {
> > > >>@@ -63,15 +64,8 @@ static void pm_clk_acquire(struct device *dev, struct pm_clock_entry *ce)
> > > >>  	}
> > > >>  }
> > > >>
> > > >>-/**
> > > >>- * pm_clk_add - Start using a device clock for power management.
> > > >>- * @dev: Device whose clock is going to be used for power management.
> > > >>- * @con_id: Connection ID of the clock.
> > > >>- *
> > > >>- * Add the clock represented by @con_id to the list of clocks used for
> > > >>- * the power management of @dev.
> > > >>- */
> > > >>-int pm_clk_add(struct device *dev, const char *con_id)
> > > >>+static int __pm_clk_add(struct device *dev, const char *con_id,
> > > >>+			struct clk *clk)
> > > >>  {
> > > >>  	struct pm_subsys_data *psd = dev_to_psd(dev);
> > > >>  	struct pm_clock_entry *ce;
> > > >>@@ -93,6 +87,8 @@ int pm_clk_add(struct device *dev, const char *con_id)
> > > >>  			kfree(ce);
> > > >>  			return -ENOMEM;
> > > >>  		}
> > > >>+	} else {
> > > >>+		ce->clk = clk;
> 
> Shouldn't this be
> 
> 		ce->clk = __clk_get(clk);
> 
> to account for clk_put() in __pm_clk_remove()?
> 
> > > >>  	}
> > > >>
> > > >>  	pm_clk_acquire(dev, ce);
> > > >>@@ -104,6 +100,31 @@ int pm_clk_add(struct device *dev, const char *con_id)
> > > >>  }
> > > >>
> > > >>  /**
> > > >>+ * pm_clk_add - Start using a device clock for power management.
> > > >>+ * @dev: Device whose clock is going to be used for power management.
> > > >>+ * @con_id: Connection ID of the clock.
> > > >>+ *
> > > >>+ * Add the clock represented by @con_id to the list of clocks used for
> > > >>+ * the power management of @dev.
> > > >>+ */
> > > >>+int pm_clk_add(struct device *dev, const char *con_id)
> > > >>+{
> > > >>+	return __pm_clk_add(dev, con_id, NULL);
> > > >
> > > >Bikeshedding: why do we need __pm_clk_add() and not simply have
> > > >"canonical" pm_clk_add_clk() and then do:
> > > >
> > > >int pm_clk_add(struct device *dev, const char *con_id)
> > > >{
> > > >	struct clk *clk;
> > > >
> > > >	clk = clk_get(dev, con_id);
> > > >	...
> > > >	return pm_clk_add_clk(dev, clk);
> > > >}
> > > 
> > > Hm. I did fast look at code and:
> > > 1) agree - there is a lot of thing which can be optimized ;)
> > > 2) in my strong opinion, this patch is the fastest and simplest
> > > way to introduce new API (take a look on pm_clock_entry->con_id
> > > management code) and It is exactly what we need as of now.
> > 
> > Yeah, I guess. We are lucky we do not crash when we are tryign to print
> > NULL strings (see pm_clk_acquire).
> > 
> > BTW, what is the point of doing pm_clk_add(dev, NULL)? We add clock
> > entry with status PCE_STATUS_ERROR and then have to handle it
> > everywhere? Can we just return -EINVAL if someone triies to pass NULL
> > ass con_id?
> 
> Umm, no, ignore me here, I misread clk_get(dev, NULL) - it won't return
> error. Still, do why do we need to keep clock entry if clk_get() fails
> for some reason?

OK, so what if we do something like the patch below?

Thanks.

-- 
Dmitry


PM / clock_ops: Add pm_clk_remove_clk()

Implement pm_clk_remove_clk() that complements the new pm_clk_add_clk().
Fix reference counting, rework the code to avoid storing invalid clocks,
clean up the code.

Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
---
 drivers/base/power/clock_ops.c | 169 ++++++++++++++++++++---------------------
 1 file changed, 81 insertions(+), 88 deletions(-)

diff --git a/drivers/base/power/clock_ops.c b/drivers/base/power/clock_ops.c
index f14b767..840e133 100644
--- a/drivers/base/power/clock_ops.c
+++ b/drivers/base/power/clock_ops.c
@@ -12,21 +12,21 @@
 #include <linux/pm.h>
 #include <linux/pm_clock.h>
 #include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/clkdev.h>
 #include <linux/slab.h>
 #include <linux/err.h>
 
 #ifdef CONFIG_PM
 
 enum pce_status {
-	PCE_STATUS_NONE = 0,
-	PCE_STATUS_ACQUIRED,
+	PCE_STATUS_ACQUIRED = 0,
+	PCE_STATUS_PREPARED,
 	PCE_STATUS_ENABLED,
-	PCE_STATUS_ERROR,
 };
 
 struct pm_clock_entry {
 	struct list_head node;
-	char *con_id;
 	struct clk *clk;
 	enum pce_status status;
 };
@@ -47,25 +47,13 @@ static inline int __pm_clk_enable(struct device *dev, struct clk *clk)
 }
 
 /**
- * pm_clk_acquire - Acquire a device clock.
- * @dev: Device whose clock is to be acquired.
- * @ce: PM clock entry corresponding to the clock.
+ * pm_clk_add_clk - Start using a device clock for power management.
+ * @dev: Device whose clock is going to be used for power management.
+ * @clk: Clock pointer
+ *
+ * Add the clock to the list of clocks used for the power management of @dev.
  */
-static void pm_clk_acquire(struct device *dev, struct pm_clock_entry *ce)
-{
-	if (!ce->clk)
-		ce->clk = clk_get(dev, ce->con_id);
-	if (IS_ERR(ce->clk)) {
-		ce->status = PCE_STATUS_ERROR;
-	} else {
-		clk_prepare(ce->clk);
-		ce->status = PCE_STATUS_ACQUIRED;
-		dev_dbg(dev, "Clock %s managed by runtime PM.\n", ce->con_id);
-	}
-}
-
-static int __pm_clk_add(struct device *dev, const char *con_id,
-			struct clk *clk)
+int pm_clk_add_clk(struct device *dev, struct clk *clk)
 {
 	struct pm_subsys_data *psd = dev_to_psd(dev);
 	struct pm_clock_entry *ce;
@@ -79,23 +67,19 @@ static int __pm_clk_add(struct device *dev, const char *con_id,
 		return -ENOMEM;
 	}
 
-	if (con_id) {
-		ce->con_id = kstrdup(con_id, GFP_KERNEL);
-		if (!ce->con_id) {
-			dev_err(dev,
-				"Not enough memory for clock connection ID.\n");
-			kfree(ce);
-			return -ENOMEM;
-		}
-	} else {
-		ce->clk = clk;
-	}
+	__clk_get(clk);
 
-	pm_clk_acquire(dev, ce);
+	clk_prepare(clk);
+
+	ce->status = PCE_STATUS_PREPARED;
+	ce->clk = clk;
 
 	spin_lock_irq(&psd->lock);
 	list_add_tail(&ce->node, &psd->clock_list);
 	spin_unlock_irq(&psd->lock);
+
+	dev_dbg(dev, "Clock %s managed by runtime PM.\n", __clk_get_name(clk));
+
 	return 0;
 }
 
@@ -109,19 +93,23 @@ static int __pm_clk_add(struct device *dev, const char *con_id,
  */
 int pm_clk_add(struct device *dev, const char *con_id)
 {
-	return __pm_clk_add(dev, con_id, NULL);
-}
+	struct clk *clk;
+	int retval;
 
-/**
- * pm_clk_add_clk - Start using a device clock for power management.
- * @dev: Device whose clock is going to be used for power management.
- * @clk: Clock pointer
- *
- * Add the clock to the list of clocks used for the power management of @dev.
- */
-int pm_clk_add_clk(struct device *dev, struct clk *clk)
-{
-	return __pm_clk_add(dev, NULL, clk);
+	clk = clk_get(dev, con_id);
+	if (IS_ERR(clk)) {
+		retval = PTR_ERR(clk);
+		dev_err(dev, "Failed to locate lock (con_id %s): %d\n",
+			con_id, retval);
+		return retval;
+	}
+
+	retval = pm_clk_add_clk(dev, clk);
+
+	/* pm_clk_add_clk takes its own reference to clk */
+	clk_put(clk);
+
+	return retval;
 }
 
 /**
@@ -133,32 +121,30 @@ static void __pm_clk_remove(struct pm_clock_entry *ce)
 	if (!ce)
 		return;
 
-	if (ce->status < PCE_STATUS_ERROR) {
-		if (ce->status == PCE_STATUS_ENABLED)
-			clk_disable(ce->clk);
+	if (ce->status == PCE_STATUS_ENABLED)
+		clk_disable(ce->clk);
 
-		if (ce->status >= PCE_STATUS_ACQUIRED) {
-			clk_unprepare(ce->clk);
-			clk_put(ce->clk);
-		}
+	if (ce->status >= PCE_STATUS_ACQUIRED) {
+		clk_unprepare(ce->clk);
+		clk_put(ce->clk);
 	}
 
-	kfree(ce->con_id);
 	kfree(ce);
 }
 
 /**
  * pm_clk_remove - Stop using a device clock for power management.
  * @dev: Device whose clock should not be used for PM any more.
- * @con_id: Connection ID of the clock.
+ * @clk: Clock pointer
  *
- * Remove the clock represented by @con_id from the list of clocks used for
- * the power management of @dev.
+ * Remove the clock from the list of clocks used for the power
+ * management of @dev.
  */
-void pm_clk_remove(struct device *dev, const char *con_id)
+
+void pm_clk_remove_clk(struct device *dev, struct clk *clk)
 {
 	struct pm_subsys_data *psd = dev_to_psd(dev);
-	struct pm_clock_entry *ce;
+	struct pm_clock_entry *ce, *matching_ce = NULL;
 
 	if (!psd)
 		return;
@@ -166,22 +152,35 @@ void pm_clk_remove(struct device *dev, const char *con_id)
 	spin_lock_irq(&psd->lock);
 
 	list_for_each_entry(ce, &psd->clock_list, node) {
-		if (!con_id && !ce->con_id)
-			goto remove;
-		else if (!con_id || !ce->con_id)
-			continue;
-		else if (!strcmp(con_id, ce->con_id))
-			goto remove;
+		if (ce->clk == clk) {
+			matching_ce = ce;
+			list_del(&ce->node);
+			break;
+		}
 	}
 
 	spin_unlock_irq(&psd->lock);
-	return;
 
- remove:
-	list_del(&ce->node);
-	spin_unlock_irq(&psd->lock);
+	__pm_clk_remove(matching_ce);
+}
+
+/**
+ * pm_clk_remove - Stop using a device clock for power management.
+ * @dev: Device whose clock should not be used for PM any more.
+ * @con_id: Connection ID of the clock.
+ *
+ * Remove the clock represented by @con_id from the list of clocks used for
+ * the power management of @dev.
+ */
+void pm_clk_remove(struct device *dev, const char *con_id)
+{
+	struct clk *clk;
 
-	__pm_clk_remove(ce);
+	clk = clk_get(dev, con_id);
+	if (!IS_ERR(clk)) {
+		pm_clk_remove_clk(dev, clk);
+		clk_put(clk);
+	}
 }
 
 /**
@@ -266,10 +265,9 @@ int pm_clk_suspend(struct device *dev)
 	spin_lock_irqsave(&psd->lock, flags);
 
 	list_for_each_entry_reverse(ce, &psd->clock_list, node) {
-		if (ce->status < PCE_STATUS_ERROR) {
-			if (ce->status == PCE_STATUS_ENABLED)
-				clk_disable(ce->clk);
-			ce->status = PCE_STATUS_ACQUIRED;
+		if (ce->status == PCE_STATUS_ENABLED) {
+			clk_disable(ce->clk);
+			ce->status = PCE_STATUS_PREPARED;
 		}
 	}
 
@@ -297,11 +295,9 @@ int pm_clk_resume(struct device *dev)
 	spin_lock_irqsave(&psd->lock, flags);
 
 	list_for_each_entry(ce, &psd->clock_list, node) {
-		if (ce->status < PCE_STATUS_ERROR) {
-			ret = __pm_clk_enable(dev, ce->clk);
-			if (!ret)
-				ce->status = PCE_STATUS_ENABLED;
-		}
+		ret = __pm_clk_enable(dev, ce->clk);
+		if (!ret)
+			ce->status = PCE_STATUS_ENABLED;
 	}
 
 	spin_unlock_irqrestore(&psd->lock, flags);
@@ -390,10 +386,9 @@ int pm_clk_suspend(struct device *dev)
 	spin_lock_irqsave(&psd->lock, flags);
 
 	list_for_each_entry_reverse(ce, &psd->clock_list, node) {
-		if (ce->status < PCE_STATUS_ERROR) {
-			if (ce->status == PCE_STATUS_ENABLED)
-				clk_disable(ce->clk);
-			ce->status = PCE_STATUS_ACQUIRED;
+		if (ce->status == PCE_STATUS_ENABLED) {
+			clk_disable(ce->clk);
+			ce->status = PCE_STATUS_PREPARED;
 		}
 	}
 
@@ -422,11 +417,9 @@ int pm_clk_resume(struct device *dev)
 	spin_lock_irqsave(&psd->lock, flags);
 
 	list_for_each_entry(ce, &psd->clock_list, node) {
-		if (ce->status < PCE_STATUS_ERROR) {
-			ret = __pm_clk_enable(dev, ce->clk);
-			if (!ret)
-				ce->status = PCE_STATUS_ENABLED;
-		}
+		ret = __pm_clk_enable(dev, ce->clk);
+		if (!ret)
+			ce->status = PCE_STATUS_ENABLED;
 	}
 
 	spin_unlock_irqrestore(&psd->lock, flags);
-- 
2.1.0.rc2.206.gedb03e5

:
