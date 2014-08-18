Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbaHRKEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:04:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42515 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbaHRJd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:33:59 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gerd Hoffmann <kraxel@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 024/137] drm/qxl: return IRQ_NONE if it was not our irq
Date: Mon, 18 Aug 2014 10:31:25 +0100
Message-Id: <1408354398-10226-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

