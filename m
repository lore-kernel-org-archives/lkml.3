Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028Ab3BLFGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 00:06:44 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34500 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3BLFDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 00:03:17 -0500
From: Suman Anna <s-anna@ti.com>
To: Greg Kroah-Hartman <greg@linuxfoundation.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>, Paul Walmsley <paul@pwsan.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Tejun Heo <tj@kernel.org>, Omar Ramirez Luna <omar.luna@linaro.org>
Subject: [PATCH v2 06/13] mailbox: change protection mechanisms
Date: Mon, 11 Feb 2013 22:57:05 -0600
Message-ID: <1360645032-9668-7-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360645032-9668-1-git-send-email-s-anna@ti.com>
References: <1360645032-9668-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Loic Pallardy <loic.pallardy@st.com>

TX: replace spin by mutex to release CPU
during wait on mailbox resource.

Signed-off-by: Loic Pallardy <loic.pallardy@st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mailbox/mailbox.c          | 5 +++--
 drivers/mailbox/mailbox_internal.h | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 6b43e7c..ff6595a 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -94,7 +94,7 @@ int mailbox_msg_send(struct mailbox *mbox, struct mailbox_msg *msg)
 	struct mailbox_queue *mq = mbox->txq;
 	int ret = 0, len;
 
-	spin_lock_bh(&mq->lock);
+	mutex_lock(&mq->mlock);
 
 	if (kfifo_avail(&mq->fifo) < (sizeof(msg) + msg->size)) {
 		ret = -ENOMEM;
@@ -118,7 +118,7 @@ int mailbox_msg_send(struct mailbox *mbox, struct mailbox_msg *msg)
 	tasklet_schedule(&mbox->txq->tasklet);
 
 out:
-	spin_unlock_bh(&mq->lock);
+	mutex_unlock(&mq->mlock);
 	return ret;
 }
 EXPORT_SYMBOL(mailbox_msg_send);
@@ -289,6 +289,7 @@ static struct mailbox_queue *mbox_queue_alloc(struct mailbox *mbox,
 		return NULL;
 
 	spin_lock_init(&mq->lock);
+	mutex_init(&mq->mlock);
 
 	if (kfifo_alloc(&mq->fifo, mbox_kfifo_size, GFP_KERNEL))
 		goto error;
diff --git a/drivers/mailbox/mailbox_internal.h b/drivers/mailbox/mailbox_internal.h
index ba03910..04f83bf 100644
--- a/drivers/mailbox/mailbox_internal.h
+++ b/drivers/mailbox/mailbox_internal.h
@@ -45,6 +45,7 @@ struct mailbox_ops {
 
 struct mailbox_queue {
 	spinlock_t              lock;
+	struct mutex		mlock;
 	struct kfifo            fifo;
 	struct work_struct      work;
 	struct tasklet_struct   tasklet;
-- 
1.8.1.2

