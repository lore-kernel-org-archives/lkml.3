Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaHKEbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 00:31:38 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33223 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaHKEbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 00:31:37 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] drm: Do not use BUG_ON(!spin_is_locked())
Date: Sun, 10 Aug 2014 21:31:31 -0700
Message-Id: <1407731491-22446-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spin_is_locked() always returns false in uniprocessor configurations
and can therefore not be used with BUG_ON. Replace it with
assert_spin_locked(), which exists for that very purpose.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/gpu/drm/msm/mdp/mdp_kms.c          | 2 +-
 drivers/gpu/drm/nouveau/core/core/event.c  | 4 ++--
 drivers/gpu/drm/nouveau/core/core/notify.c | 2 +-
 drivers/gpu/drm/omapdrm/omap_irq.c         | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/mdp/mdp_kms.c b/drivers/gpu/drm/msm/mdp/mdp_kms.c
index 03455b6..92a1531 100644
--- a/drivers/gpu/drm/msm/mdp/mdp_kms.c
+++ b/drivers/gpu/drm/msm/mdp/mdp_kms.c
@@ -34,7 +34,7 @@ static void update_irq(struct mdp_kms *mdp_kms)
 	struct mdp_irq *irq;
 	uint32_t irqmask = mdp_kms->vblank_mask;
 
-	BUG_ON(!spin_is_locked(&list_lock));
+	assert_spin_locked(&list_lock);
 
 	list_for_each_entry(irq, &mdp_kms->irq_list, node)
 		irqmask |= irq->irqmask;
diff --git a/drivers/gpu/drm/nouveau/core/core/event.c b/drivers/gpu/drm/nouveau/core/core/event.c
index 0540a48..9327117 100644
--- a/drivers/gpu/drm/nouveau/core/core/event.c
+++ b/drivers/gpu/drm/nouveau/core/core/event.c
@@ -26,7 +26,7 @@
 void
 nvkm_event_put(struct nvkm_event *event, u32 types, int index)
 {
-	BUG_ON(!spin_is_locked(&event->refs_lock));
+	assert_spin_locked(&event->refs_lock);
 	while (types) {
 		int type = __ffs(types); types &= ~(1 << type);
 		if (--event->refs[index * event->types_nr + type] == 0) {
@@ -39,7 +39,7 @@ nvkm_event_put(struct nvkm_event *event, u32 types, int index)
 void
 nvkm_event_get(struct nvkm_event *event, u32 types, int index)
 {
-	BUG_ON(!spin_is_locked(&event->refs_lock));
+	assert_spin_locked(&event->refs_lock);
 	while (types) {
 		int type = __ffs(types); types &= ~(1 << type);
 		if (++event->refs[index * event->types_nr + type] == 1) {
diff --git a/drivers/gpu/drm/nouveau/core/core/notify.c b/drivers/gpu/drm/nouveau/core/core/notify.c
index 76adb81..f70dbc4 100644
--- a/drivers/gpu/drm/nouveau/core/core/notify.c
+++ b/drivers/gpu/drm/nouveau/core/core/notify.c
@@ -98,7 +98,7 @@ nvkm_notify_send(struct nvkm_notify *notify, void *data, u32 size)
 	struct nvkm_event *event = notify->event;
 	unsigned long flags;
 
-	BUG_ON(!spin_is_locked(&event->list_lock));
+	assert_spin_locked(&event->list_lock);
 	BUG_ON(size != notify->size);
 
 	spin_lock_irqsave(&event->refs_lock, flags);
diff --git a/drivers/gpu/drm/omapdrm/omap_irq.c b/drivers/gpu/drm/omapdrm/omap_irq.c
index f035d2b..3eb097e 100644
--- a/drivers/gpu/drm/omapdrm/omap_irq.c
+++ b/drivers/gpu/drm/omapdrm/omap_irq.c
@@ -34,7 +34,7 @@ static void omap_irq_update(struct drm_device *dev)
 	struct omap_drm_irq *irq;
 	uint32_t irqmask = priv->vblank_mask;
 
-	BUG_ON(!spin_is_locked(&list_lock));
+	assert_spin_locked(&list_lock);
 
 	list_for_each_entry(irq, &priv->irq_list, node)
 		irqmask |= irq->irqmask;
-- 
1.9.1

