Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994Ab3BLFD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 00:03:28 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34506 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932936Ab3BLFD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 00:03:26 -0500
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
Subject: [PATCH v2 09/13] mailbox: add no_irq send message
Date: Mon, 11 Feb 2013 22:57:08 -0600
Message-ID: <1360645032-9668-10-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360645032-9668-1-git-send-email-s-anna@ti.com>
References: <1360645032-9668-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Loic Pallardy <loic.pallardy@st.com>

For debug purpose, mailbox must be available when
interrupts are disabled to collect dump information.

Signed-off-by: Loic Pallardy <loic.pallardy@st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mailbox/mailbox.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mailbox.h   |  3 +++
 2 files changed, 69 insertions(+)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 35813f5..eaaf87e 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -110,6 +110,72 @@ out:
 }
 EXPORT_SYMBOL(mailbox_msg_send);
 
+#define TRANSFER_TIMEOUT 30000 /* Becomes ~3s timeout */
+
+static struct mailbox_msg no_irq_msg_res;
+
+struct mailbox_msg *mailbox_msg_send_receive_no_irq(struct mailbox *mbox,
+		struct mailbox_msg *msg)
+{
+	int ret = 0;
+	int count = 0;
+
+	BUG_ON(!irqs_disabled());
+
+	if (likely(mbox->ops->write && mbox->ops->read)) {
+		if (__mbox_poll_for_space(mbox)) {
+			ret = -EBUSY;
+			goto out;
+		}
+		mbox->ops->write(mbox, msg);
+		while (!is_mbox_irq(mbox, IRQ_RX)) {
+			udelay(100);
+			cpu_relax();
+			count++;
+			if (count > TRANSFER_TIMEOUT) {
+				pr_err("%s: Error: transfer timed out\n",
+						__func__);
+				ret = -EINVAL;
+				goto out;
+			}
+		}
+		mbox->ops->read(mbox, &no_irq_msg_res);
+		ack_mbox_irq(mbox, IRQ_RX);
+	} else {
+		ret = -EINVAL;
+	}
+
+out:
+	BUG_ON(ret < 0);
+
+	return &no_irq_msg_res;
+}
+EXPORT_SYMBOL(mailbox_msg_send_receive_no_irq);
+
+int mailbox_msg_send_no_irq(struct mailbox *mbox,
+		struct mailbox_msg *msg)
+{
+	int ret = 0;
+
+	BUG_ON(!irqs_disabled());
+
+	if (likely(mbox->ops->write)) {
+		if (__mbox_poll_for_space(mbox)) {
+			ret = -EBUSY;
+			goto out;
+		}
+		mbox->ops->write(mbox, msg);
+	} else {
+		ret = -EINVAL;
+	}
+
+out:
+	WARN_ON(ret < 0);
+
+	return ret;
+}
+EXPORT_SYMBOL(mailbox_msg_send_no_irq);
+
 void mailbox_save_ctx(struct mailbox *mbox)
 {
 	if (!mbox->ops->save_ctx) {
diff --git a/include/linux/mailbox.h b/include/linux/mailbox.h
index f8730b4..a41b67d 100644
--- a/include/linux/mailbox.h
+++ b/include/linux/mailbox.h
@@ -28,6 +28,9 @@ struct mailbox_msg {
 }
 
 int mailbox_msg_send(struct mailbox *, struct mailbox_msg *msg);
+struct mailbox_msg *mailbox_msg_send_receive_no_irq(struct mailbox *,
+		struct mailbox_msg *msg);
+int mailbox_msg_send_no_irq(struct mailbox *, struct mailbox_msg *msg);
 
 struct mailbox *mailbox_get(const char *, struct notifier_block *nb);
 void mailbox_put(struct mailbox *mbox, struct notifier_block *nb);
-- 
1.8.1.2

