Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaELIfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 04:35:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517AbaELIfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 04:35:39 -0400
From: Jason Wang <jasowang@redhat.com>
To: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/qxl: return IRQ_NONE if it was not our irq
Date: Mon, 12 May 2014 16:35:39 +0800
Message-Id: <1399883739-14266-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return IRQ_NONE if it was not our irq. This is necessary for the case
when qxl is sharing irq line with a device A in a crash kernel. If qxl
is initialized before A and A's irq was raised during this gap,
returning IRQ_HANDLED in this case will cause this irq to be raised
again after EOI since kernel think it was handled but in fact it was
not.

Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/gpu/drm/qxl/qxl_irq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/qxl/qxl_irq.c b/drivers/gpu/drm/qxl/qxl_irq.c
index 28f84b4..3485bdc 100644
--- a/drivers/gpu/drm/qxl/qxl_irq.c
+++ b/drivers/gpu/drm/qxl/qxl_irq.c
@@ -33,6 +33,9 @@ irqreturn_t qxl_irq_handler(int irq, void *arg)
 
 	pending = xchg(&qdev->ram_header->int_pending, 0);
 
+	if (!pending)
+		return IRQ_NONE;
+
 	atomic_inc(&qdev->irq_received);
 
 	if (pending & QXL_INTERRUPT_DISPLAY) {
-- 
1.9.1

