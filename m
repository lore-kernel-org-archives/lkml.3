Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab3LSL61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:58:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45035 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab3LSL6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:58:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 127/208] usb: musb: only cancel work if it is initialized
Date: Thu, 19 Dec 2013 11:53:45 +0000
Message-Id: <1387454106-19326-128-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 66fadea5b79c07154126bb0db375be915f611246 upstream.

Since commit c5340bd14 ("usb: musb: cancel work on removal") the workqueue
is cancelled but then if we bail out before the workqueue is setup we
get this:

|INFO: trying to register non-static key.
|the code is fine but needs lockdep annotation.
|turning off the locking correctness validator.
|CPU: 0 PID: 708 Comm: modprobe Not tainted 3.12.0+ #435
|[<c00867bc>] (lock_acquire+0xf0/0x108) from [<c00529d0>] (flush_work+0x38/0x2ec)
|[<c00529d0>] (flush_work+0x38/0x2ec) from [<c0052d24>] (__cancel_work_timer+0xa0/0x134)
|[<c0052d24>] (__cancel_work_timer+0xa0/0x134) from [<bf0e4ae4>] (musb_free+0x40/0x60 [musb_hdrc])
|[<bf0e4ae4>] (musb_free+0x40/0x60 [musb_hdrc]) from [<bf0e5364>] (musb_probe+0x678/0xb78 [musb_hdrc])
|[<bf0e5364>] (musb_probe+0x678/0xb78 [musb_hdrc]) from [<c0294bf0>] (platform_drv_probe+0x1c/0x24)
|[<c0294bf0>] (platform_drv_probe+0x1c/0x24) from [<c0293970>] (driver_probe_device+0x90/0x224)
|[<c0293970>] (driver_probe_device+0x90/0x224) from [<c0291ef0>] (bus_for_each_drv+0x60/0x8c)
|[<c0291ef0>] (bus_for_each_drv+0x60/0x8c) from [<c02938bc>] (device_attach+0x80/0xa4)
|[<c02938bc>] (device_attach+0x80/0xa4) from [<c0292b24>] (bus_probe_device+0x88/0xac)
|[<c0292b24>] (bus_probe_device+0x88/0xac) from [<c0291490>] (device_add+0x388/0x6c8)
|[<c0291490>] (device_add+0x388/0x6c8) from [<c02952a0>] (platform_device_add+0x188/0x22c)
|[<c02952a0>] (platform_device_add+0x188/0x22c) from [<bf11ea30>] (dsps_probe+0x294/0x394 [musb_dsps])
|[<bf11ea30>] (dsps_probe+0x294/0x394 [musb_dsps]) from [<c0294bf0>] (platform_drv_probe+0x1c/0x24)
|platform musb-hdrc.1.auto: Driver musb-hdrc requests probe deferral
|musb-hdrc musb-hdrc.1.auto: musb_init_controller failed with status -517

This patch moves the init part to earlier part so it can be cleaned as
part of the fail3 label because now it is surrounded by the fail4 label.
Step two is to remove it from musb_free() and add it to the two cleanup
paths (error path and device removal) separately.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/musb/musb_core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index a3c6000..d3fcb9b 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1810,7 +1810,6 @@ static void musb_free(struct musb *musb)
 			disable_irq_wake(musb->nIrq);
 		free_irq(musb->nIrq, musb);
 	}
-	cancel_work_sync(&musb->irq_work);
 	if (is_dma_capable() && musb->dma_controller) {
 		struct dma_controller	*c = musb->dma_controller;
 
@@ -1909,6 +1908,9 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 	musb_platform_disable(musb);
 	musb_generic_disable(musb);
 
+	/* Init IRQ workqueue before request_irq */
+	INIT_WORK(&musb->irq_work, musb_irq_work);
+
 	/* setup musb parts of the core (especially endpoints) */
 	status = musb_core_init(plat->config->multipoint
 			? MUSB_CONTROLLER_MHDRC
@@ -1918,9 +1920,6 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 
 	setup_timer(&musb->otg_timer, musb_otg_timer_func, (unsigned long) musb);
 
-	/* Init IRQ workqueue before request_irq */
-	INIT_WORK(&musb->irq_work, musb_irq_work);
-
 	/* attach to the IRQ */
 	if (request_irq(nIrq, musb->isr, 0, dev_name(dev), musb)) {
 		dev_err(dev, "request_irq %d failed!\n", nIrq);
@@ -1994,6 +1993,7 @@ fail4:
 	musb_host_cleanup(musb);
 
 fail3:
+	cancel_work_sync(&musb->irq_work);
 	pm_runtime_put_sync(musb->controller);
 
 fail2:
@@ -2050,6 +2050,7 @@ static int musb_remove(struct platform_device *pdev)
 	musb_exit_debugfs(musb);
 	musb_shutdown(pdev);
 
+	cancel_work_sync(&musb->irq_work);
 	musb_free(musb);
 	device_init_wakeup(dev, 0);
 #ifndef CONFIG_MUSB_PIO_ONLY
-- 
1.8.3.2

