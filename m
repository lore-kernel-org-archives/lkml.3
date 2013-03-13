Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399Ab3CMDbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 23:31:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39992 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720Ab3CMD3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 23:29:33 -0400
From: Suman Anna <s-anna@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>, Suman Anna <s-anna@ti.com>,
        Fernando Guzman Lugo <lugo.fernando@gmail.com>
Subject: [PATCHv3 14/14] mailbox: call request_irq after mbox queues are allocated
Date: Tue, 12 Mar 2013 22:24:31 -0500
Message-ID: <1363145071-14820-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mailbox startup code is enabling the interrupt even before
any of the associated mailbox queues are allocated. Any pending
received mailbox message could cause a kernel panic as soon as
the interrupt is enabled due to the dereferencing of non-existing
mailbox queues within the ISR.

Signed-off-by: Fernando Guzman Lugo <lugo.fernando@gmail.com>
Signed-off-by: Suman Anna <s-anna@ti.com>
---
 drivers/mailbox/mailbox.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index c38241a..5fea5c2 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -377,14 +377,6 @@ static int mailbox_startup(struct mailbox *mbox)
 	}
 
 	if (!mbox->use_count++) {
-		ret = request_irq(mbox->irq, mbox_interrupt,
-				IRQF_SHARED | IRQF_NO_SUSPEND,
-				mbox->name, mbox);
-		if (unlikely(ret)) {
-			pr_err("failed to register mailbox interrupt:%d\n",
-					ret);
-			goto fail_request_irq;
-		}
 		mq = mbox_queue_alloc(mbox, NULL, mbox_tx_tasklet);
 		if (!mq) {
 			ret = -ENOMEM;
@@ -399,17 +391,25 @@ static int mailbox_startup(struct mailbox *mbox)
 		}
 		mbox->rxq = mq;
 		mq->mbox = mbox;
+		ret = request_irq(mbox->irq, mbox_interrupt,
+				IRQF_SHARED | IRQF_NO_SUSPEND,
+				mbox->name, mbox);
+		if (unlikely(ret)) {
+			pr_err("failed to register mailbox interrupt:%d\n",
+					ret);
+			goto fail_request_irq;
+		}
 
 		mailbox_enable_irq(mbox, IRQ_RX);
 	}
 	mutex_unlock(&mbox_configured_lock);
 	return 0;
 
+fail_request_irq:
+	mbox_queue_free(mbox->rxq);
 fail_alloc_rxq:
 	mbox_queue_free(mbox->txq);
 fail_alloc_txq:
-	free_irq(mbox->irq, mbox);
-fail_request_irq:
 	if (mbox->ops->shutdown)
 		mbox->ops->shutdown(mbox);
 	mbox->use_count--;
-- 
1.8.1.2

