Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab3C1ErY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 00:47:24 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:64092 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab3C1ErG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 00:47:06 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, rajagopal.venkat@linaro.org,
        davidb@codeaurora.org, ulf.hansson@linaro.org,
        laurent.pinchart@ideasonboard.com, tglx@linutronix.de,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 2/2] clk: allow reentrant calls into the clk framework
Date: Wed, 27 Mar 2013 21:45:58 -0700
Message-Id: <1364445958-2999-3-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364445958-2999-1-git-send-email-mturquette@linaro.org>
References: <1364368183-24420-1-git-send-email-mturquette@linaro.org>
 <1364445958-2999-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reentrancy into the clock framework is necessary for clock operations
that result in nested calls to the clk api.  A common example is a clock
that is prepared via an i2c transaction, such as a clock inside of a
discrete audio chip or a power management IC.  The i2c subsystem itself
will use the clk api resulting in a deadlock:

clk_prepare(audio_clk)
	i2c_transfer(..)
		clk_prepare(i2c_controller_clk)

The ability to reenter the clock framework prevents this deadlock.

Other use cases exist such as allowing .set_rate callbacks to call
clk_set_parent to achieve the best rate, or to save power in certain
configurations.  Yet another example is performing pinctrl operations
from a clk_ops callback.  Calls into the pinctrl subsystem may call
clk_{un}prepare on an unrelated clock.  Allowing for nested calls to
reenter the clock framework enables both of these use cases.

Reentrancy is implemented by two global pointers that track the owner
currently holding a global lock.  One pointer tracks the owner during
sleepable, mutex-protected operations and the other one tracks the owner
during non-interruptible, spinlock-protected operations.

When the clk framework is entered we try to hold the global lock.  If it
is held we compare the current task id against the current owner; a
match implies a nested call and we reenter.  If the values do not match
then we block on the lock until it is released.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>
Cc: David Brown <davidb@codeaurora.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
Changes since v4:
 * remove uneccesary atomic operations
 * remove casting bugs
 * place reentrancy logic into locking helper functions
 * improve debugging with reference counting and WARNs

 drivers/clk/clk.c |   43 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index bea47d5..fe7c054 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -19,10 +19,17 @@
 #include <linux/of.h>
 #include <linux/device.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 
 static DEFINE_SPINLOCK(enable_lock);
 static DEFINE_MUTEX(prepare_lock);
 
+static struct task_struct *prepare_owner;
+static struct task_struct *enable_owner;
+
+static int prepare_refcnt;
+static int enable_refcnt;
+
 static HLIST_HEAD(clk_root_list);
 static HLIST_HEAD(clk_orphan_list);
 static LIST_HEAD(clk_notifier_list);
@@ -30,21 +37,53 @@ static LIST_HEAD(clk_notifier_list);
 /***           locking             ***/
 static void clk_prepare_lock(void)
 {
-	mutex_lock(&prepare_lock);
+	if (!mutex_trylock(&prepare_lock)) {
+		if (prepare_owner == current) {
+			prepare_refcnt++;
+			return;
+		}
+		mutex_lock(&prepare_lock);
+	}
+	WARN_ON_ONCE(prepare_owner != NULL);
+	WARN_ON_ONCE(prepare_refcnt != 0);
+	prepare_owner = current;
+	prepare_refcnt = 1;
 }
 
 static void clk_prepare_unlock(void)
 {
+	WARN_ON_ONCE(prepare_owner != current);
+	WARN_ON_ONCE(prepare_refcnt == 0);
+
+	if (--prepare_refcnt)
+		return;
+	prepare_owner = NULL;
 	mutex_unlock(&prepare_lock);
 }
 
 static void clk_enable_lock(unsigned long *flags)
 {
-	spin_lock_irqsave(&enable_lock, *flags);
+	if (!spin_trylock_irqsave(&enable_lock, *flags)) {
+		if (enable_owner == current) {
+			enable_refcnt++;
+			return;
+		}
+		spin_lock_irqsave(&enable_lock, *flags);
+	}
+	WARN_ON_ONCE(enable_owner != NULL);
+	WARN_ON_ONCE(enable_refcnt != 0);
+	enable_owner = current;
+	enable_refcnt = 1;
 }
 
 static void clk_enable_unlock(unsigned long *flags)
 {
+	WARN_ON_ONCE(enable_owner != current);
+	WARN_ON_ONCE(enable_refcnt == 0);
+
+	if (--enable_refcnt)
+		return;
+	enable_owner = NULL;
 	spin_unlock_irqrestore(&enable_lock, *flags);
 }
 
-- 
1.7.10.4

