Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3DMVw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 17:52:26 -0400
Received: from mail.ispras.ru ([83.149.199.45]:50006 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788Ab3DMVwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 17:52:25 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] [media] cx88: Fix unsafe locking in suspend-resume
Date: Sun, 14 Apr 2013 01:52:04 +0400
Message-Id: <1365889924-5570-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Legacy PCI suspend-resume handlers are called with interrupts enabled.
But cx8800_suspend/cx8800_resume and cx8802_suspend_common/cx8802_resume_common
use spin_lock/spin_unlock functions to acquire dev->slock, while the same lock is acquired in
the corresponding irq-handlers: cx8800_irq and cx8802_irq.
That means a deadlock is possible if an interrupt happens while suspend or resume owns the lock.

The patch replaces spin_lock/spin_unlock with spin_lock_irqsave/spin_unlock_irqrestore.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/pci/cx88/cx88-mpeg.c  |   10 ++++++----
 drivers/media/pci/cx88/cx88-video.c |   10 ++++++----
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index c9d3182..c6cdbdb 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -532,16 +532,17 @@ static int cx8802_suspend_common(struct pci_dev *pci_dev, pm_message_t state)
 {
 	struct cx8802_dev *dev = pci_get_drvdata(pci_dev);
 	struct cx88_core *core = dev->core;
+	unsigned long flags;
 
 	/* stop mpeg dma */
-	spin_lock(&dev->slock);
+	spin_lock_irqsave(&dev->slock,flags);
 	if (!list_empty(&dev->mpegq.active)) {
 		dprintk( 2, "suspend\n" );
 		printk("%s: suspend mpeg\n", core->name);
 		cx8802_stop_dma(dev);
 		del_timer(&dev->mpegq.timeout);
 	}
-	spin_unlock(&dev->slock);
+	spin_unlock_irqrestore(&dev->slock,flags);
 
 	/* FIXME -- shutdown device */
 	cx88_shutdown(dev->core);
@@ -558,6 +559,7 @@ static int cx8802_resume_common(struct pci_dev *pci_dev)
 {
 	struct cx8802_dev *dev = pci_get_drvdata(pci_dev);
 	struct cx88_core *core = dev->core;
+	unsigned long flags;
 	int err;
 
 	if (dev->state.disabled) {
@@ -584,12 +586,12 @@ static int cx8802_resume_common(struct pci_dev *pci_dev)
 	cx88_reset(dev->core);
 
 	/* restart video+vbi capture */
-	spin_lock(&dev->slock);
+	spin_lock_irqsave(&dev->slock,flags);
 	if (!list_empty(&dev->mpegq.active)) {
 		printk("%s: resume mpeg\n", core->name);
 		cx8802_restart_queue(dev,&dev->mpegq);
 	}
-	spin_unlock(&dev->slock);
+	spin_unlock_irqrestore(&dev->slock,flags);
 
 	return 0;
 }
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index bc78354..d72b403 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -1957,9 +1957,10 @@ static int cx8800_suspend(struct pci_dev *pci_dev, pm_message_t state)
 {
 	struct cx8800_dev *dev = pci_get_drvdata(pci_dev);
 	struct cx88_core *core = dev->core;
+	unsigned long flags;
 
 	/* stop video+vbi capture */
-	spin_lock(&dev->slock);
+	spin_lock_irqsave(&dev->slock,flags);
 	if (!list_empty(&dev->vidq.active)) {
 		printk("%s/0: suspend video\n", core->name);
 		stop_video_dma(dev);
@@ -1970,7 +1971,7 @@ static int cx8800_suspend(struct pci_dev *pci_dev, pm_message_t state)
 		cx8800_stop_vbi_dma(dev);
 		del_timer(&dev->vbiq.timeout);
 	}
-	spin_unlock(&dev->slock);
+	spin_unlock_irqrestore(&dev->slock,flags);
 
 	if (core->ir)
 		cx88_ir_stop(core);
@@ -1989,6 +1990,7 @@ static int cx8800_resume(struct pci_dev *pci_dev)
 {
 	struct cx8800_dev *dev = pci_get_drvdata(pci_dev);
 	struct cx88_core *core = dev->core;
+	unsigned long flags;
 	int err;
 
 	if (dev->state.disabled) {
@@ -2019,7 +2021,7 @@ static int cx8800_resume(struct pci_dev *pci_dev)
 	cx_set(MO_PCI_INTMSK, core->pci_irqmask);
 
 	/* restart video+vbi capture */
-	spin_lock(&dev->slock);
+	spin_lock_irqsave(&dev->slock,flags);
 	if (!list_empty(&dev->vidq.active)) {
 		printk("%s/0: resume video\n", core->name);
 		restart_video_queue(dev,&dev->vidq);
@@ -2028,7 +2030,7 @@ static int cx8800_resume(struct pci_dev *pci_dev)
 		printk("%s/0: resume vbi\n", core->name);
 		cx8800_restart_vbi_queue(dev,&dev->vbiq);
 	}
-	spin_unlock(&dev->slock);
+	spin_unlock_irqrestore(&dev->slock,flags);
 
 	return 0;
 }
-- 
1.7.9.5

