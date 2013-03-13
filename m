Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609Ab3CMQmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 12:42:17 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:34718 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517Ab3CMQmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 12:42:16 -0400
Date: Wed, 13 Mar 2013 18:42:12 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Ben Skeggs <bskeggs@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: linux 3.9-rc1: nouveau crash on PPC
Message-ID: <20130313164212.GD8798@blackmetal.musicnaut.iki.fi>
References: <20130309184431.GF14552@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130309184431.GF14552@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Mar 09, 2013 at 08:44:31PM +0200, Aaro Koskinen wrote:
> There's nouveau crash during boot with 3.9-rc1 on iMac G5 (nVidia GeForce
> FX 5200 Ultra). This happens also with current mainline kernel HEAD
> (0aefda3e8188ad71168bd32152d41b3d72f04087).
> 
> git bisect tells the first bad commit is
> 1d7c71a3e2f77336df536855b0efd2dc5bdeb41b (drm/nouveau/disp: port vblank
> handling to event interface).
> 
> The crash is (manually copied from screen):
> 
> [...]
> 
> Unable to handle kernel paging request for data at address 0x100000000
> 
> call trace:
> nouveau_event_trigger

The cause is event handling linked lists getting corrupted.

I'm not sure how that code is intented to work, but with the below HACK
I can at least boot the iMac without crashing, and get a working display:

diff --git a/drivers/gpu/drm/nouveau/core/core/event.c b/drivers/gpu/drm/nouveau/core/core/event.c
index 6d01e0f..ab8d6c7 100644
--- a/drivers/gpu/drm/nouveau/core/core/event.c
+++ b/drivers/gpu/drm/nouveau/core/core/event.c
@@ -29,7 +29,7 @@ nouveau_event_put_locked(struct nouveau_event *event, int index,
 {
 	if (!--event->index[index].refs)
 		event->disable(event, index);
-	list_del(&handler->head);
+	list_del(&handler->heads[index]);
 }
 
 void
@@ -39,7 +39,7 @@ nouveau_event_put(struct nouveau_event *event, int index,
 	unsigned long flags;
 
 	spin_lock_irqsave(&event->lock, flags);
-	if (index < event->index_nr)
+	if (index < ARRAY_SIZE(handler->heads) && index < event->index_nr)
 		nouveau_event_put_locked(event, index, handler);
 	spin_unlock_irqrestore(&event->lock, flags);
 }
@@ -51,8 +51,8 @@ nouveau_event_get(struct nouveau_event *event, int index,
 	unsigned long flags;
 
 	spin_lock_irqsave(&event->lock, flags);
-	if (index < event->index_nr) {
-		list_add(&handler->head, &event->index[index].list);
+	if (index < ARRAY_SIZE(handler->heads) && index < event->index_nr) {
+		list_add(&handler->heads[index], &event->index[index].list);
 		if (!event->index[index].refs++)
 			event->enable(event, index);
 	}
@@ -69,7 +69,7 @@ nouveau_event_trigger(struct nouveau_event *event, int index)
 		return;
 
 	spin_lock_irqsave(&event->lock, flags);
-	list_for_each_entry_safe(handler, temp, &event->index[index].list, head) {
+	list_for_each_entry_safe(handler, temp, &event->index[index].list, heads[index]) {
 		if (handler->func(handler, index) == NVKM_EVENT_DROP) {
 			nouveau_event_put_locked(event, index, handler);
 		}
diff --git a/drivers/gpu/drm/nouveau/core/include/core/event.h b/drivers/gpu/drm/nouveau/core/include/core/event.h
index 9e09440..ba52172 100644
--- a/drivers/gpu/drm/nouveau/core/include/core/event.h
+++ b/drivers/gpu/drm/nouveau/core/include/core/event.h
@@ -6,7 +6,7 @@
 #define NVKM_EVENT_KEEP 1
 
 struct nouveau_eventh {
-	struct list_head head;
+	struct list_head heads[2];
 	int (*func)(struct nouveau_eventh *, int index);
 };
 
A.
