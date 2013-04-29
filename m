Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760903Ab3D2TkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:40:11 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:38460 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760887Ab3D2TkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:40:07 -0400
From: Julien Grall <julien.grall@linaro.org>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: konrad.wilk@oracle.com, Stefano.Stabellini@eu.citrix.com,
        patches@linaro.org, Julien Grall <julien.grall@linaro.org>
Subject: [PATCH] xen: clear IRQ_NOAUTOEN and IRQ_NOREQUEST when a VIRQ is bound
Date: Mon, 29 Apr 2013 20:39:37 +0100
Message-Id: <1367264377-7107-1-git-send-email-julien.grall@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reset the IRQ_NOAUTOEN and IRQ_NOREQUEST flags that are enabled by
default on ARM. If IRQ_NOAUTOEN is set, __setup_irq doesn't call
irq_startup, that is responsible for calling irq_unmask at startup time.
As a result event channels remain masked.

The clear is already made in bind_evtchn_to_irq with commit a8636c0 but was
missing in bind_virq_to_irq.

Signed-off-by: Julien Grall <julien.grall@linaro.org>
---
 drivers/xen/events.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index d8cc812..b0ad226 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -994,6 +994,7 @@ int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
 		WARN_ON(info == NULL || info->type != IRQT_VIRQ);
 	}
 
+	irq_clear_status_flags(irq, IRQ_NOREQUEST|IRQ_NOAUTOEN);
 out:
 	mutex_unlock(&irq_mapping_update_lock);
 
-- 
1.7.10.4

