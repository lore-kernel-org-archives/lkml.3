Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaGaPbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:31:09 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56430 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaGaPbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:31:06 -0400
Subject: [PATCH 01/18] fence: add debugging lines to fence_is_signaled for the
 callback
To: airlied@linux.ie
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: thellstrom@vmware.com, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, alexander.deucher@amd.com,
        christian.koenig@amd.com
Date: Thu, 31 Jul 2014 17:30:59 +0200
Message-ID: <20140731153059.14619.66697.stgit@patser>
In-Reply-To: <20140731152809.14619.29424.stgit@patser>
References: <20140731152809.14619.29424.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fence_is_signaled callback should support being run in
atomic context, but not in irq context.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 include/linux/fence.h |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/linux/fence.h b/include/linux/fence.h
index d174585b874b..c1a4519ba2f5 100644
--- a/include/linux/fence.h
+++ b/include/linux/fence.h
@@ -143,6 +143,7 @@ struct fence_cb {
  * the second time will be a noop since it was already signaled.
  *
  * Notes on signaled:
+ * Called with interrupts enabled, and never from interrupt context.
  * May set fence->status if returning true.
  *
  * Notes on wait:
@@ -268,15 +269,29 @@ fence_is_signaled_locked(struct fence *fence)
 static inline bool
 fence_is_signaled(struct fence *fence)
 {
+	bool ret;
+
 	if (test_bit(FENCE_FLAG_SIGNALED_BIT, &fence->flags))
 		return true;
 
-	if (fence->ops->signaled && fence->ops->signaled(fence)) {
+	if (!fence->ops->signaled)
+		return false;
+
+	if (config_enabled(CONFIG_PROVE_LOCKING))
+		WARN_ON(in_interrupt() || irqs_disabled());
+
+	if (config_enabled(CONFIG_DEBUG_ATOMIC_SLEEP))
+		preempt_disable();
+
+	ret = fence->ops->signaled(fence);
+
+	if (config_enabled(CONFIG_DEBUG_ATOMIC_SLEEP))
+		preempt_enable();
+
+	if (ret)
 		fence_signal(fence);
-		return true;
-	}
 
-	return false;
+	return ret;
 }
 
 /**

