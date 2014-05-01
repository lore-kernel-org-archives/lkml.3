Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbaEAAgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:36:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56665 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbaEAAgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:36:43 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>
CC: Tony Lindgren <tony@atomide.com>, Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCHv5 RFC 10/15] hwspinlock/core: prepare core to support reserved locks
Date: Wed, 30 Apr 2014 19:34:31 -0500
Message-ID: <1398904476-26200-11-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398904476-26200-1-git-send-email-s-anna@ti.com>
References: <1398904476-26200-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HwSpinlock core allows requesting either a specific lock or
an available normal lock. The specific locks are usually reserved
during board init time, while the normal available locks are
intended to be assigned at runtime.

This patch prepares the hwspinlock core to support this concept
of reserved locks. A new element is added to struct hwlock to
identify whether it is reserved to be allocated using the
hwspin_lock_request_specific() variants or available for dynamic
allocation. A new tag name, HWSPINLOCK_RESERVED, is introduced
to mark the reserved locks as such.

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 drivers/hwspinlock/hwspinlock_core.c     | 14 ++++++++------
 drivers/hwspinlock/hwspinlock_internal.h |  2 ++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
index ed47e77..c2063bc 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -33,6 +33,7 @@
 
 /* radix tree tags */
 #define HWSPINLOCK_UNUSED	(0) /* tags an hwspinlock as unused */
+#define HWSPINLOCK_RESERVED	(1) /* tags an hwspinlock as reserved */
 
 /*
  * A radix tree is used to maintain the available hwspinlock instances.
@@ -326,7 +327,7 @@ static int hwspin_lock_register_single(struct hwspinlock *hwlock, int id)
 	}
 
 	/* mark this hwspinlock as available */
-	tmp = radix_tree_tag_set(&hwspinlock_tree, id, HWSPINLOCK_UNUSED);
+	tmp = radix_tree_tag_set(&hwspinlock_tree, id, hwlock->type);
 
 	/* self-sanity check which should never fail */
 	WARN_ON(tmp != hwlock);
@@ -344,7 +345,7 @@ static int hwspin_lock_unregister_single(struct hwspinlock *hwlock, int id)
 	mutex_lock(&hwspinlock_tree_lock);
 
 	/* make sure the hwspinlock is not in use (tag is set) */
-	if (!radix_tree_tag_get(&hwspinlock_tree, id, HWSPINLOCK_UNUSED)) {
+	if (!radix_tree_tag_get(&hwspinlock_tree, id, hwlock->type)) {
 		pr_err("hwspinlock %d still in use (or not present)\n", id);
 		ret = -EBUSY;
 		goto out;
@@ -467,6 +468,7 @@ int hwspin_lock_register(struct hwspinlock_device *bank, struct device *dev,
 
 		spin_lock_init(&hwlock->lock);
 		hwlock->bank = bank;
+		hwlock->type = HWSPINLOCK_UNUSED;
 
 		ret = hwspin_lock_register_single(hwlock, base_id + i);
 		if (ret)
@@ -551,7 +553,7 @@ static int __hwspin_lock_request(struct hwspinlock *hwlock)
 
 	/* mark hwspinlock as used, should not fail */
 	tmp = radix_tree_tag_clear(&hwspinlock_tree, hwlock_to_id(hwlock),
-							HWSPINLOCK_UNUSED);
+							hwlock->type);
 
 	/* self-sanity check that should never fail */
 	WARN_ON(tmp != hwlock);
@@ -650,7 +652,7 @@ struct hwspinlock *hwspin_lock_request_specific(unsigned int id)
 	WARN_ON(hwlock_to_id(hwlock) != id);
 
 	/* make sure this hwspinlock is unused */
-	ret = radix_tree_tag_get(&hwspinlock_tree, id, HWSPINLOCK_UNUSED);
+	ret = radix_tree_tag_get(&hwspinlock_tree, id, hwlock->type);
 	if (ret == 0) {
 		pr_warn("hwspinlock %u is already in use\n", id);
 		hwlock = NULL;
@@ -741,7 +743,7 @@ int hwspin_lock_free(struct hwspinlock *hwlock)
 
 	/* make sure the hwspinlock is used */
 	ret = radix_tree_tag_get(&hwspinlock_tree, hwlock_to_id(hwlock),
-							HWSPINLOCK_UNUSED);
+							hwlock->type);
 	if (ret == 1) {
 		dev_err(dev, "%s: hwlock is already free\n", __func__);
 		dump_stack();
@@ -756,7 +758,7 @@ int hwspin_lock_free(struct hwspinlock *hwlock)
 
 	/* mark this hwspinlock as available */
 	tmp = radix_tree_tag_set(&hwspinlock_tree, hwlock_to_id(hwlock),
-							HWSPINLOCK_UNUSED);
+							hwlock->type);
 
 	/* sanity check (this shouldn't happen) */
 	WARN_ON(tmp != hwlock);
diff --git a/drivers/hwspinlock/hwspinlock_internal.h b/drivers/hwspinlock/hwspinlock_internal.h
index 5e42613..1be32ca 100644
--- a/drivers/hwspinlock/hwspinlock_internal.h
+++ b/drivers/hwspinlock/hwspinlock_internal.h
@@ -47,11 +47,13 @@ struct hwspinlock_ops {
  * struct hwspinlock - this struct represents a single hwspinlock instance
  * @bank: the hwspinlock_device structure which owns this lock
  * @lock: initialized and used by hwspinlock core
+ * @type: type of lock, used to distinguish regular locks from reserved locks
  * @priv: private data, owned by the underlying platform-specific hwspinlock drv
  */
 struct hwspinlock {
 	struct hwspinlock_device *bank;
 	spinlock_t lock;
+	unsigned int type;
 	void *priv;
 };
 
-- 
1.9.2

