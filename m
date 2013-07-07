Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab3GGTJD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 15:09:03 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:60856 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab3GGTJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 15:09:00 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ferruh Yigit <fery@cypress.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] Input: cyttsp4 - Kill defined but not used compiler warnings
Date: Sun,  7 Jul 2013 21:08:31 +0200
Message-Id: <1373224111-16873-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If both CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME are unset:

drivers/input/touchscreen/cyttsp4_core.c:1556: warning: ‘cyttsp4_core_sleep’ defined but not used
drivers/input/touchscreen/cyttsp4_core.c:1634: warning: ‘cyttsp4_core_wake’ defined but not used

Move cyttsp4_core_sleep(), cyttsp4_core_wake(), and cyttsp4_core_wake_()
(which is called from cyttsp4_core_wake() only) inside the existing section
protected by #if defined(CONFIG_PM_SLEEP) || defined(CONFIG_PM_RUNTIME)

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/input/touchscreen/cyttsp4_core.c |  200 +++++++++++++++---------------
 1 file changed, 100 insertions(+), 100 deletions(-)

diff --git a/drivers/input/touchscreen/cyttsp4_core.c b/drivers/input/touchscreen/cyttsp4_core.c
index edcf799..c49161c2 100644
--- a/drivers/input/touchscreen/cyttsp4_core.c
+++ b/drivers/input/touchscreen/cyttsp4_core.c
@@ -1552,106 +1552,6 @@ exit:
 	return rc;
 }
 
-static int cyttsp4_core_sleep(struct cyttsp4 *cd)
-{
-	int rc;
-
-	rc = cyttsp4_request_exclusive(cd, cd->dev,
-			CY_CORE_SLEEP_REQUEST_EXCLUSIVE_TIMEOUT);
-	if (rc < 0) {
-		dev_err(cd->dev, "%s: fail get exclusive ex=%p own=%p\n",
-				__func__, cd->exclusive_dev, cd->dev);
-		return 0;
-	}
-
-	rc = cyttsp4_core_sleep_(cd);
-
-	if (cyttsp4_release_exclusive(cd, cd->dev) < 0)
-		dev_err(cd->dev, "%s: fail to release exclusive\n", __func__);
-	else
-		dev_vdbg(cd->dev, "%s: pass release exclusive\n", __func__);
-
-	return rc;
-}
-
-static int cyttsp4_core_wake_(struct cyttsp4 *cd)
-{
-	struct device *dev = cd->dev;
-	int rc;
-	u8 mode;
-	int t;
-
-	/* Already woken? */
-	mutex_lock(&cd->system_lock);
-	if (cd->sleep_state == SS_SLEEP_OFF) {
-		mutex_unlock(&cd->system_lock);
-		return 0;
-	}
-	cd->int_status &= ~CY_INT_IGNORE;
-	cd->int_status |= CY_INT_AWAKE;
-	cd->sleep_state = SS_WAKING;
-
-	if (cd->cpdata->power) {
-		dev_dbg(dev, "%s: Power up HW\n", __func__);
-		rc = cd->cpdata->power(cd->cpdata, 1, dev, &cd->ignore_irq);
-	} else {
-		dev_dbg(dev, "%s: No power function\n", __func__);
-		rc = -ENOSYS;
-	}
-	if (rc < 0) {
-		dev_err(dev, "%s: HW Power up fails r=%d\n",
-				__func__, rc);
-
-		/* Initiate a read transaction to wake up */
-		cyttsp4_adap_read(cd, CY_REG_BASE, sizeof(mode), &mode);
-	} else
-		dev_vdbg(cd->dev, "%s: HW power up succeeds\n",
-			__func__);
-	mutex_unlock(&cd->system_lock);
-
-	t = wait_event_timeout(cd->wait_q,
-			(cd->int_status & CY_INT_AWAKE) == 0,
-			msecs_to_jiffies(CY_CORE_WAKEUP_TIMEOUT));
-	if (IS_TMO(t)) {
-		dev_err(dev, "%s: TMO waiting for wakeup\n", __func__);
-		mutex_lock(&cd->system_lock);
-		cd->int_status &= ~CY_INT_AWAKE;
-		/* Try starting up */
-		cyttsp4_queue_startup_(cd);
-		mutex_unlock(&cd->system_lock);
-	}
-
-	mutex_lock(&cd->system_lock);
-	cd->sleep_state = SS_SLEEP_OFF;
-	mutex_unlock(&cd->system_lock);
-
-	cyttsp4_start_wd_timer(cd);
-
-	return 0;
-}
-
-static int cyttsp4_core_wake(struct cyttsp4 *cd)
-{
-	int rc;
-
-	rc = cyttsp4_request_exclusive(cd, cd->dev,
-			CY_CORE_REQUEST_EXCLUSIVE_TIMEOUT);
-	if (rc < 0) {
-		dev_err(cd->dev, "%s: fail get exclusive ex=%p own=%p\n",
-				__func__, cd->exclusive_dev, cd->dev);
-		return 0;
-	}
-
-	rc = cyttsp4_core_wake_(cd);
-
-	if (cyttsp4_release_exclusive(cd, cd->dev) < 0)
-		dev_err(cd->dev, "%s: fail to release exclusive\n", __func__);
-	else
-		dev_vdbg(cd->dev, "%s: pass release exclusive\n", __func__);
-
-	return rc;
-}
-
 static int cyttsp4_startup_(struct cyttsp4 *cd)
 {
 	int retry = CY_CORE_STARTUP_RETRY_COUNT;
@@ -1821,6 +1721,106 @@ static void cyttsp4_free_si_ptrs(struct cyttsp4 *cd)
 }
 
 #if defined(CONFIG_PM_SLEEP) || defined(CONFIG_PM_RUNTIME)
+static int cyttsp4_core_sleep(struct cyttsp4 *cd)
+{
+	int rc;
+
+	rc = cyttsp4_request_exclusive(cd, cd->dev,
+			CY_CORE_SLEEP_REQUEST_EXCLUSIVE_TIMEOUT);
+	if (rc < 0) {
+		dev_err(cd->dev, "%s: fail get exclusive ex=%p own=%p\n",
+				__func__, cd->exclusive_dev, cd->dev);
+		return 0;
+	}
+
+	rc = cyttsp4_core_sleep_(cd);
+
+	if (cyttsp4_release_exclusive(cd, cd->dev) < 0)
+		dev_err(cd->dev, "%s: fail to release exclusive\n", __func__);
+	else
+		dev_vdbg(cd->dev, "%s: pass release exclusive\n", __func__);
+
+	return rc;
+}
+
+static int cyttsp4_core_wake_(struct cyttsp4 *cd)
+{
+	struct device *dev = cd->dev;
+	int rc;
+	u8 mode;
+	int t;
+
+	/* Already woken? */
+	mutex_lock(&cd->system_lock);
+	if (cd->sleep_state == SS_SLEEP_OFF) {
+		mutex_unlock(&cd->system_lock);
+		return 0;
+	}
+	cd->int_status &= ~CY_INT_IGNORE;
+	cd->int_status |= CY_INT_AWAKE;
+	cd->sleep_state = SS_WAKING;
+
+	if (cd->cpdata->power) {
+		dev_dbg(dev, "%s: Power up HW\n", __func__);
+		rc = cd->cpdata->power(cd->cpdata, 1, dev, &cd->ignore_irq);
+	} else {
+		dev_dbg(dev, "%s: No power function\n", __func__);
+		rc = -ENOSYS;
+	}
+	if (rc < 0) {
+		dev_err(dev, "%s: HW Power up fails r=%d\n",
+				__func__, rc);
+
+		/* Initiate a read transaction to wake up */
+		cyttsp4_adap_read(cd, CY_REG_BASE, sizeof(mode), &mode);
+	} else
+		dev_vdbg(cd->dev, "%s: HW power up succeeds\n",
+			__func__);
+	mutex_unlock(&cd->system_lock);
+
+	t = wait_event_timeout(cd->wait_q,
+			(cd->int_status & CY_INT_AWAKE) == 0,
+			msecs_to_jiffies(CY_CORE_WAKEUP_TIMEOUT));
+	if (IS_TMO(t)) {
+		dev_err(dev, "%s: TMO waiting for wakeup\n", __func__);
+		mutex_lock(&cd->system_lock);
+		cd->int_status &= ~CY_INT_AWAKE;
+		/* Try starting up */
+		cyttsp4_queue_startup_(cd);
+		mutex_unlock(&cd->system_lock);
+	}
+
+	mutex_lock(&cd->system_lock);
+	cd->sleep_state = SS_SLEEP_OFF;
+	mutex_unlock(&cd->system_lock);
+
+	cyttsp4_start_wd_timer(cd);
+
+	return 0;
+}
+
+static int cyttsp4_core_wake(struct cyttsp4 *cd)
+{
+	int rc;
+
+	rc = cyttsp4_request_exclusive(cd, cd->dev,
+			CY_CORE_REQUEST_EXCLUSIVE_TIMEOUT);
+	if (rc < 0) {
+		dev_err(cd->dev, "%s: fail get exclusive ex=%p own=%p\n",
+				__func__, cd->exclusive_dev, cd->dev);
+		return 0;
+	}
+
+	rc = cyttsp4_core_wake_(cd);
+
+	if (cyttsp4_release_exclusive(cd, cd->dev) < 0)
+		dev_err(cd->dev, "%s: fail to release exclusive\n", __func__);
+	else
+		dev_vdbg(cd->dev, "%s: pass release exclusive\n", __func__);
+
+	return rc;
+}
+
 static int cyttsp4_core_suspend(struct device *dev)
 {
 	struct cyttsp4 *cd = dev_get_drvdata(dev);
-- 
1.7.9.5

