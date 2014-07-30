Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaG3MeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:34:15 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36722 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752895AbaG3MPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, Dave Airlie <airlied@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 64/94] drm/qxl: return IRQ_NONE if it was not our irq
Date: Wed, 30 Jul 2014 14:14:53 +0200
Message-Id: <5cdebe8864e4f0f8ade5be17cce50bceee69a961.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit fbb60fe35ad579b511de8604b06a30b43846473b upstream.

Return IRQ_NONE if it was not our irq. This is necessary for the case
when qxl is sharing irq line with a device A in a crash kernel. If qxl
is initialized before A and A's irq was raised during this gap,
returning IRQ_HANDLED in this case will cause this irq to be raised
again after EOI since kernel think it was handled but in fact it was
not.

Cc: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/qxl/qxl_irq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/qxl/qxl_irq.c b/drivers/gpu/drm/qxl/qxl_irq.c
index 21393dc4700a..f4b6b89b98f3 100644
--- a/drivers/gpu/drm/qxl/qxl_irq.c
+++ b/drivers/gpu/drm/qxl/qxl_irq.c
@@ -33,6 +33,9 @@ irqreturn_t qxl_irq_handler(DRM_IRQ_ARGS)
 
 	pending = xchg(&qdev->ram_header->int_pending, 0);
 
+	if (!pending)
+		return IRQ_NONE;
+
 	atomic_inc(&qdev->irq_received);
 
 	if (pending & QXL_INTERRUPT_DISPLAY) {
-- 
2.0.1

