Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbaFEE1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:27:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44532 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbaFEEW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 198/214] rapidio/tsi721: fix bug in MSI interrupt handling
Date: Wed,  4 Jun 2014 21:19:21 -0700
Message-Id: <20140605041706.065180138@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Bounine <alexandre.bounine@idt.com>

commit 1ccc819da6fda9bee10ab8b72e9adbb5ad3e4959 upstream.

Fix bug in MSI interrupt handling which causes loss of event
notifications.

Typical indication of lost MSI interrupts are stalled message and
doorbell transfers between RapidIO endpoints.  To avoid loss of MSI
interrupts all interrupts from the device must be disabled on entering
the interrupt handler routine and re-enabled when exiting it.
Re-enabling device interrupts will trigger new MSI message(s) if Tsi721
registered new events since entering interrupt handler routine.

This patch is applicable to kernel versions starting from v3.2.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rapidio/devices/tsi721.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/rapidio/devices/tsi721.c
+++ b/drivers/rapidio/devices/tsi721.c
@@ -475,6 +475,10 @@ static irqreturn_t tsi721_irqhandler(int
 	u32 intval;
 	u32 ch_inte;
 
+	/* For MSI mode disable all device-level interrupts */
+	if (priv->flags & TSI721_USING_MSI)
+		iowrite32(0, priv->regs + TSI721_DEV_INTE);
+
 	dev_int = ioread32(priv->regs + TSI721_DEV_INT);
 	if (!dev_int)
 		return IRQ_NONE;
@@ -548,6 +552,13 @@ static irqreturn_t tsi721_irqhandler(int
 			tsi721_pw_handler(mport);
 	}
 
+	/* For MSI mode re-enable device-level interrupts */
+	if (priv->flags & TSI721_USING_MSI) {
+		dev_int = TSI721_DEV_INT_SR2PC_CH | TSI721_DEV_INT_SRIO |
+			TSI721_DEV_INT_SMSG_CH | TSI721_DEV_INT_BDMA_CH;
+		iowrite32(dev_int, priv->regs + TSI721_DEV_INTE);
+	}
+
 	return IRQ_HANDLED;
 }
 


