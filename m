Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749AbaAGAK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:10:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768AbaAFWiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.12 029/144] usb: musb: core: Call dma_controller_destroy() in error path only once.
Date: Mon,  6 Jan 2014 14:36:30 -0800
Message-Id: <20140106223746.161040806@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 8d1aad7485e653c2c5fd985b326096f680f7d918 upstream.

In commit f3ce4d5 ("usb: musb: core: call dma_controller_destroy() in the err path")
I erroneously assumed that the dma controller is not removed in the
error patch. This was wrong because it happens later via musb_free().
That means the original commit can be reverted because it is wrong or we
do this, so it is more obvious.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/musb_core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1810,8 +1810,6 @@ static void musb_free(struct musb *musb)
 		free_irq(musb->nIrq, musb);
 	}
 	cancel_work_sync(&musb->irq_work);
-	if (musb->dma_controller)
-		dma_controller_destroy(musb->dma_controller);
 
 	musb_host_free(musb);
 }
@@ -2036,6 +2034,9 @@ static int musb_remove(struct platform_d
 	musb_exit_debugfs(musb);
 	musb_shutdown(pdev);
 
+	if (musb->dma_controller)
+		dma_controller_destroy(musb->dma_controller);
+
 	musb_free(musb);
 	device_init_wakeup(dev, 0);
 	return 0;


