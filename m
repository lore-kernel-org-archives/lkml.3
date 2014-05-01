Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbaEAAhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:37:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54181 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbaEAAhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:37:31 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>
CC: Tony Lindgren <tony@atomide.com>, Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCHv5 RFC 14/15] hwspinlock/core: return ERR_PTRs on failure in _request_ api
Date: Wed, 30 Apr 2014 19:34:35 -0500
Message-ID: <1398904476-26200-15-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398904476-26200-1-git-send-email-s-anna@ti.com>
References: <1398904476-26200-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The various hwspin_lock_request* interfaces return a NULL pointer
on error, or a valid hwlock pointer on success. It is standard
practice to pass the error value back to the consumers on failure
cases, so change the functions to return an equivalent ERR_PTR()
value instead of NULL. The regular client api functions are
also modified to check for an invalid hwlock handle.

The consumers MUST check using IS_ERR() when requesting hwlocks
going forward to determine a valid hwlock.

Signed-off-by: Suman Anna <s-anna@ti.com>
---
TODO: Move this patch before the Patch4,
	"hwspinlock/core: add common OF helpers"
	if accepted to go with the current series
---
 Documentation/hwspinlock.txt         | 12 ++++++------
 drivers/hwspinlock/hwspinlock_core.c | 25 ++++++++++++++-----------
 2 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/Documentation/hwspinlock.txt b/Documentation/hwspinlock.txt
index 903d477..bf1c7e46 100644
--- a/Documentation/hwspinlock.txt
+++ b/Documentation/hwspinlock.txt
@@ -35,15 +35,15 @@ independent, drivers.
 2. User API
 
   struct hwspinlock *hwspin_lock_request(void);
-   - dynamically assign an hwspinlock and return its address, or NULL
-     in case an unused hwspinlock isn't available. Users of this
+   - dynamically assign a hwspinlock and return its address, or an equivalent
+     ERR_PTR() in case an unused hwspinlock isn't available. Users of this
      API will usually want to communicate the lock's id to the remote core
      before it can be used to achieve synchronization.
      Should be called from a process context (might sleep).
 
   struct hwspinlock *hwspin_lock_request_specific(unsigned int id);
-   - assign a specific hwspinlock id and return its address, or NULL
-     if that hwspinlock is already in use. Usually board code will
+   - assign a specific hwspinlock id and return its address, or an equivalent
+     ERR_PTR() if that hwspinlock is already in use. Usually board code will
      be calling this function in order to reserve specific hwspinlock
      ids for predefined purposes.
      Should be called from a process context (might sleep).
@@ -172,7 +172,7 @@ int hwspinlock_example1(void)
 
 	/* dynamically assign a hwspinlock */
 	hwlock = hwspin_lock_request();
-	if (!hwlock)
+	if (IS_ERR(hwlock))
 		...
 
 	id = hwspin_lock_get_id(hwlock);
@@ -208,7 +208,7 @@ int hwspinlock_example2(void)
 	 * by board init code.
 	 */
 	hwlock = hwspin_lock_request_specific(PREDEFINED_LOCK_ID);
-	if (!hwlock)
+	if (IS_ERR(hwlock))
 		...
 
 	/* try to take it, but don't spin on it */
diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
index e74b55b..56c4303 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -96,7 +96,7 @@ int __hwspin_trylock(struct hwspinlock *hwlock, int mode, unsigned long *flags)
 {
 	int ret;
 
-	BUG_ON(!hwlock);
+	BUG_ON(IS_ERR_OR_NULL(hwlock));
 	BUG_ON(!flags && mode == HWLOCK_IRQSTATE);
 
 	/*
@@ -235,7 +235,7 @@ EXPORT_SYMBOL_GPL(__hwspin_lock_timeout);
  */
 void __hwspin_unlock(struct hwspinlock *hwlock, int mode, unsigned long *flags)
 {
-	BUG_ON(!hwlock);
+	BUG_ON(IS_ERR_OR_NULL(hwlock));
 	BUG_ON(!flags && mode == HWLOCK_IRQSTATE);
 
 	/*
@@ -600,7 +600,7 @@ static int __hwspin_lock_request(struct hwspinlock *hwlock)
  */
 int hwspin_lock_get_id(struct hwspinlock *hwlock)
 {
-	if (!hwlock) {
+	if (IS_ERR_OR_NULL(hwlock)) {
 		pr_err("invalid hwlock\n");
 		return -EINVAL;
 	}
@@ -620,7 +620,8 @@ EXPORT_SYMBOL_GPL(hwspin_lock_get_id);
  *
  * Should be called from a process context (might sleep)
  *
- * Returns the address of the assigned hwspinlock, or NULL on error
+ * Returns the address of the assigned hwspinlock, or an equivalent ERR_PTR()
+ * on error
  */
 struct hwspinlock *hwspin_lock_request(void)
 {
@@ -634,7 +635,7 @@ struct hwspinlock *hwspin_lock_request(void)
 						0, 1, HWSPINLOCK_UNUSED);
 	if (ret == 0) {
 		pr_warn("a free hwspinlock is not available\n");
-		hwlock = NULL;
+		hwlock = ERR_PTR(-ENXIO);
 		goto out;
 	}
 
@@ -644,7 +645,7 @@ struct hwspinlock *hwspin_lock_request(void)
 	/* mark as used and power up */
 	ret = __hwspin_lock_request(hwlock);
 	if (ret < 0)
-		hwlock = NULL;
+		hwlock = ERR_PTR(ret);
 
 out:
 	mutex_unlock(&hwspinlock_tree_lock);
@@ -663,7 +664,8 @@ EXPORT_SYMBOL_GPL(hwspin_lock_request);
  *
  * Should be called from a process context (might sleep)
  *
- * Returns the address of the assigned hwspinlock, or NULL on error
+ * Returns the address of the assigned hwspinlock, or an equivalent
+ * ERR_PTR() on error
  */
 struct hwspinlock *hwspin_lock_request_specific(unsigned int id)
 {
@@ -676,6 +678,7 @@ struct hwspinlock *hwspin_lock_request_specific(unsigned int id)
 	hwlock = radix_tree_lookup(&hwspinlock_tree, id);
 	if (!hwlock) {
 		pr_warn("hwspinlock %u does not exist\n", id);
+		hwlock = ERR_PTR(-EINVAL);
 		goto out;
 	}
 
@@ -684,7 +687,7 @@ struct hwspinlock *hwspin_lock_request_specific(unsigned int id)
 
 	if (hwlock->type != HWSPINLOCK_RESERVED) {
 		pr_warn("hwspinlock %u is not a reserved lock\n", id);
-		hwlock = NULL;
+		hwlock = ERR_PTR(-EINVAL);
 		goto out;
 	}
 
@@ -692,14 +695,14 @@ struct hwspinlock *hwspin_lock_request_specific(unsigned int id)
 	ret = radix_tree_tag_get(&hwspinlock_tree, id, hwlock->type);
 	if (ret == 0) {
 		pr_warn("hwspinlock %u is already in use\n", id);
-		hwlock = NULL;
+		hwlock = ERR_PTR(-EBUSY);
 		goto out;
 	}
 
 	/* mark as used and power up */
 	ret = __hwspin_lock_request(hwlock);
 	if (ret < 0)
-		hwlock = NULL;
+		hwlock = ERR_PTR(ret);
 
 out:
 	mutex_unlock(&hwspinlock_tree_lock);
@@ -770,7 +773,7 @@ int hwspin_lock_free(struct hwspinlock *hwlock)
 	struct hwspinlock *tmp;
 	int ret;
 
-	if (!hwlock) {
+	if (IS_ERR_OR_NULL(hwlock)) {
 		pr_err("invalid hwlock\n");
 		return -EINVAL;
 	}
-- 
1.9.2

