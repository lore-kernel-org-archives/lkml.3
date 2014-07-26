Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbaGZTr7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:47:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbaGZTNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gerd Hoffmann <kraxel@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.14 73/87] drm/qxl: return IRQ_NONE if it was not our irq
Date: Sat, 26 Jul 2014 12:02:47 -0700
Message-Id: <20140726190216.984030456@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190214.530473925@linuxfoundation.org>
References: <20140726190214.530473925@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/qxl/qxl_irq.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/qxl/qxl_irq.c
+++ b/drivers/gpu/drm/qxl/qxl_irq.c
@@ -33,6 +33,9 @@ irqreturn_t qxl_irq_handler(int irq, voi
 
 	pending = xchg(&qdev->ram_header->int_pending, 0);
 
+	if (!pending)
+		return IRQ_NONE;
+
 	atomic_inc(&qdev->irq_received);
 
 	if (pending & QXL_INTERRUPT_DISPLAY) {


