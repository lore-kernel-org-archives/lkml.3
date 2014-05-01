Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaEAAhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:37:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54180 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbaEAAhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:37:31 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>
CC: Tony Lindgren <tony@atomide.com>, Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCHv5 RFC 15/15] hwspinlock/core: change return codes of_hwspin_lock_request_specific
Date: Wed, 30 Apr 2014 19:34:36 -0500
Message-ID: <1398904476-26200-16-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398904476-26200-1-git-send-email-s-anna@ti.com>
References: <1398904476-26200-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed the return statements to return an ERR_PTR instead of NULL
in case of an error. This patch helps with deferred probing of any
client users if the corresponding hwspinlock bank is not yet registered
with the hwspinlock core.

Signed-off-by: Suman Anna <s-anna@ti.com>
---
TODO: Collapse into Patch4,
	 "hwspinlock/core: add common OF helpers"
	if accepted to go with the current series
---
 Documentation/hwspinlock.txt         | 4 ++--
 drivers/hwspinlock/hwspinlock_core.c | 9 +++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/Documentation/hwspinlock.txt b/Documentation/hwspinlock.txt
index bf1c7e46..10d7ecc 100644
--- a/Documentation/hwspinlock.txt
+++ b/Documentation/hwspinlock.txt
@@ -50,8 +50,8 @@ independent, drivers.
 
   struct hwspinlock *of_hwspin_lock_request_specific(
 		struct device_node *np,	const char *propname, int index);
-   - assign a specific hwspinlock id and return its address, or NULL
-     if that hwspinlock is already in use. This function is the OF
+   - assign a specific hwspinlock id and return its address, or an equivalent
+     ERR_PTR() if that hwspinlock is already in use. This function is the OF
      equivalent of hwspin_lock_request_specific() function, and provides
      a means for users of the hwspinlock module to request a specific
      hwspinlock using the phandle of the hwspinlock device.
diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
index 56c4303..a838dbd 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -722,7 +722,8 @@ EXPORT_SYMBOL_GPL(hwspin_lock_request_specific);
  * lock number is indexed relative to the hwspinlock device, unlike the
  * hwspin_lock_request_specific() which is an absolute lock number.
  *
- * Returns the address of the assigned hwspinlock, or NULL on error
+ * Returns the address of the assigned hwspinlock, or an equivalent
+ * ERR_PTR() on error
  */
 struct hwspinlock *of_hwspin_lock_request_specific(struct device_node *np,
 						   const char *propname,
@@ -736,7 +737,7 @@ struct hwspinlock *of_hwspin_lock_request_specific(struct device_node *np,
 	ret = of_parse_phandle_with_args(np, propname, "#hwlock-cells", index,
 					 &args);
 	if (ret)
-		return NULL;
+		return ERR_PTR(ret);
 
 	mutex_lock(&hwspinlock_tree_lock);
 	list_for_each_entry(bank, &hwspinlock_devices, list)
@@ -744,11 +745,11 @@ struct hwspinlock *of_hwspin_lock_request_specific(struct device_node *np,
 			break;
 	mutex_unlock(&hwspinlock_tree_lock);
 	if (&bank->list == &hwspinlock_devices)
-		return NULL;
+		return ERR_PTR(-EPROBE_DEFER);
 
 	id = bank->ops->of_xlate(bank, &args);
 	if (id < 0 || id >= bank->num_locks)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	id += bank->base_id;
 	return hwspin_lock_request_specific(id);
-- 
1.9.2

