Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab3BLFH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 00:07:29 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:47269 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab3BLFDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 00:03:15 -0500
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
Subject: [PATCH v2 07/13] mailbox: add shared memory mailbox type
Date: Mon, 11 Feb 2013 22:57:06 -0600
Message-ID: <1360645032-9668-8-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360645032-9668-1-git-send-email-s-anna@ti.com>
References: <1360645032-9668-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Loic Pallardy <loic.pallardy@st.com>

Some mailboxes are made up of cross interrupts
and associated shared memory.
Shared memory mapping is fixed and cross interrupt/shared
memory relation make impossible the use of virtio.
Mailbox framework must be enough opened to support
any kind of mailbox.

Signed-off-by: Loic Pallardy <loic.pallardy@st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mailbox/mailbox-omap1.c    | 34 +++++++++++++++++++++++++++++-----
 drivers/mailbox/mailbox-omap2.c    | 16 ++++++++++++----
 drivers/mailbox/mailbox.c          | 38 +++++++++++---------------------------
 drivers/mailbox/mailbox_internal.h | 18 +++++++++---------
 4 files changed, 61 insertions(+), 45 deletions(-)

diff --git a/drivers/mailbox/mailbox-omap1.c b/drivers/mailbox/mailbox-omap1.c
index c7c5b6f..295c32a 100644
--- a/drivers/mailbox/mailbox-omap1.c
+++ b/drivers/mailbox/mailbox-omap1.c
@@ -13,6 +13,7 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/delay.h>
 
 #include "mailbox_internal.h"
 
@@ -38,6 +39,7 @@ struct omap_mbox1_priv {
 	struct omap_mbox1_fifo tx_fifo;
 	struct omap_mbox1_fifo rx_fifo;
 	u32 data;
+	bool empty_flag;
 };
 
 static inline int mbox_read_reg(size_t ofs)
@@ -59,6 +61,7 @@ static void omap1_mbox_fifo_read(struct mailbox *mbox, struct mailbox_msg *msg)
 	priv->data = mbox_read_reg(fifo->data);
 	priv->data |= ((u32) mbox_read_reg(fifo->cmd)) << 16;
 	MAILBOX_FILL_MSG((*msg), 0, priv->data, 0);
+	priv->empty_flag = false;
 }
 
 static int
@@ -76,7 +79,11 @@ omap1_mbox_fifo_write(struct mailbox *mbox, struct mailbox_msg *msg)
 
 static int omap1_mbox_fifo_empty(struct mailbox *mbox)
 {
-	return 0;
+	struct omap_mbox1_priv *priv = (struct omap_mbox1_priv *)mbox->priv;
+	if (priv->empty_flag)
+		return 0;
+	else
+		return 1;
 }
 
 static int omap1_mbox_fifo_full(struct mailbox *mbox)
@@ -87,6 +94,18 @@ static int omap1_mbox_fifo_full(struct mailbox *mbox)
 	return mbox_read_reg(fifo->flag);
 }
 
+static int ompa1_mbox_poll_for_space(struct mailbox *mbox)
+{
+	int ret = 0, i = 1000;
+
+	while (omap1_mbox_fifo_full(mbox)) {
+		if (--i == 0)
+			return -1;
+		udelay(1);
+	}
+	return ret;
+}
+
 /* irq */
 static void
 omap1_mbox_enable_irq(struct mailbox *mbox, mailbox_type_t irq)
@@ -105,17 +124,22 @@ omap1_mbox_disable_irq(struct mailbox *mbox, mailbox_type_t irq)
 static int
 omap1_mbox_is_irq(struct mailbox *mbox, mailbox_type_t irq)
 {
+	struct omap_mbox1_priv *priv = (struct omap_mbox1_priv *)mbox->priv;
+
 	if (irq == IRQ_TX)
 		return 0;
+	if (irq == IRQ_RX)
+		priv->empty_flag = true;
+
 	return 1;
 }
 
 static struct mailbox_ops omap1_mbox_ops = {
 	.type           = MBOX_HW_FIFO1_TYPE,
-	.fifo_read      = omap1_mbox_fifo_read,
-	.fifo_write     = omap1_mbox_fifo_write,
-	.fifo_empty     = omap1_mbox_fifo_empty,
-	.fifo_full      = omap1_mbox_fifo_full,
+	.read           = omap1_mbox_fifo_read,
+	.write          = omap1_mbox_fifo_write,
+	.empty     = omap1_mbox_fifo_empty,
+	.poll_for_space = ompa1_mbox_poll_for_space,
 	.enable_irq     = omap1_mbox_enable_irq,
 	.disable_irq    = omap1_mbox_disable_irq,
 	.is_irq         = omap1_mbox_is_irq,
diff --git a/drivers/mailbox/mailbox-omap2.c b/drivers/mailbox/mailbox-omap2.c
index 2554138..d3a3d84 100644
--- a/drivers/mailbox/mailbox-omap2.c
+++ b/drivers/mailbox/mailbox-omap2.c
@@ -129,6 +129,14 @@ static int omap2_mbox_fifo_full(struct mailbox *mbox)
 	return mbox_read_reg(fifo->fifo_stat);
 }
 
+static int ompa2_mbox_poll_for_space(struct mailbox *mbox)
+{
+	if (omap2_mbox_fifo_full(mbox))
+		return -1;
+
+	return 0;
+}
+
 /* Mailbox IRQ handle functions */
 static void omap2_mbox_enable_irq(struct mailbox *mbox,
 		mailbox_type_t irq)
@@ -216,10 +224,10 @@ static struct mailbox_ops omap2_mbox_ops = {
 	.type           = MBOX_HW_FIFO2_TYPE,
 	.startup        = omap2_mbox_startup,
 	.shutdown       = omap2_mbox_shutdown,
-	.fifo_read      = omap2_mbox_fifo_read,
-	.fifo_write     = omap2_mbox_fifo_write,
-	.fifo_empty     = omap2_mbox_fifo_empty,
-	.fifo_full      = omap2_mbox_fifo_full,
+	.read           = omap2_mbox_fifo_read,
+	.write          = omap2_mbox_fifo_write,
+	.empty          = omap2_mbox_fifo_empty,
+	.poll_for_space = ompa2_mbox_poll_for_space,
 	.enable_irq     = omap2_mbox_enable_irq,
 	.disable_irq    = omap2_mbox_disable_irq,
 	.ack_irq        = omap2_mbox_ack_irq,
diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index ff6595a..08da5b0 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -44,21 +44,17 @@ module_param(mbox_kfifo_size, uint, S_IRUGO);
 MODULE_PARM_DESC(mbox_kfifo_size, "Size of mailbox kfifo (bytes)");
 
 /* Mailbox FIFO handle functions */
-static inline void mbox_fifo_read(struct mailbox *mbox, struct mailbox_msg *msg)
+static inline void mbox_read(struct mailbox *mbox, struct mailbox_msg *msg)
 {
-	mbox->ops->fifo_read(mbox, msg);
+	mbox->ops->read(mbox, msg);
 }
-static inline int mbox_fifo_write(struct mailbox *mbox, struct mailbox_msg *msg)
+static inline int mbox_write(struct mailbox *mbox, struct mailbox_msg *msg)
 {
-	return mbox->ops->fifo_write(mbox, msg);
+	return mbox->ops->write(mbox, msg);
 }
-static inline int mbox_fifo_empty(struct mailbox *mbox)
+static inline int mbox_empty(struct mailbox *mbox)
 {
-	return mbox->ops->fifo_empty(mbox);
-}
-static inline int mbox_fifo_full(struct mailbox *mbox)
-{
-	return mbox->ops->fifo_full(mbox);
+	return mbox->ops->empty(mbox);
 }
 
 /* Mailbox IRQ handle functions */
@@ -77,16 +73,7 @@ static inline int is_mbox_irq(struct mailbox *mbox, mailbox_irq_t irq)
  */
 static int __mbox_poll_for_space(struct mailbox *mbox)
 {
-	int ret = 0, i = 1000;
-
-	while (mbox_fifo_full(mbox)) {
-		if (mbox->ops->type == MBOX_HW_FIFO2_TYPE)
-			return -1;
-		if (--i == 0)
-			return -1;
-		udelay(1);
-	}
-	return ret;
+	return mbox->ops->poll_for_space(mbox);
 }
 
 int mailbox_msg_send(struct mailbox *mbox, struct mailbox_msg *msg)
@@ -102,7 +89,7 @@ int mailbox_msg_send(struct mailbox *mbox, struct mailbox_msg *msg)
 	}
 
 	if (kfifo_is_empty(&mq->fifo) && !__mbox_poll_for_space(mbox)) {
-		ret = mbox_fifo_write(mbox, msg);
+		ret = mbox_write(mbox, msg);
 		goto out;
 	}
 
@@ -181,7 +168,7 @@ static void mbox_tx_tasklet(unsigned long tx_data)
 			msg.pdata = tx_data_buf;
 		}
 
-		ret = mbox_fifo_write(mbox, &msg);
+		ret = mbox_write(mbox, &msg);
 		WARN_ON(ret);
 	}
 }
@@ -236,7 +223,7 @@ static void __mbox_rx_interrupt(struct mailbox *mbox)
 	struct mailbox_msg msg;
 	int len;
 
-	while (!mbox_fifo_empty(mbox)) {
+	while (!mbox_empty(mbox)) {
 		if (unlikely(kfifo_avail(&mq->fifo) <
 				(sizeof(msg) + CONFIG_MBOX_DATA_SIZE))) {
 			mailbox_disable_irq(mbox, IRQ_RX);
@@ -244,7 +231,7 @@ static void __mbox_rx_interrupt(struct mailbox *mbox)
 			goto nomem;
 		}
 
-		mbox_fifo_read(mbox, &msg);
+		mbox_read(mbox, &msg);
 
 		len = kfifo_in(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
 		WARN_ON(len != sizeof(msg));
@@ -254,9 +241,6 @@ static void __mbox_rx_interrupt(struct mailbox *mbox)
 					msg.size);
 			WARN_ON(len != msg.size);
 		}
-
-		if (mbox->ops->type == MBOX_HW_FIFO1_TYPE)
-			break;
 	}
 
 	/* no more messages in the fifo. clear IRQ source. */
diff --git a/drivers/mailbox/mailbox_internal.h b/drivers/mailbox/mailbox_internal.h
index 04f83bf..fb3d32c 100644
--- a/drivers/mailbox/mailbox_internal.h
+++ b/drivers/mailbox/mailbox_internal.h
@@ -17,20 +17,19 @@
 #include <linux/workqueue.h>
 
 typedef int __bitwise mailbox_type_t;
-#define MBOX_HW_FIFO1_TYPE ((__force mailbox_type_t) 1)
-#define MBOX_HW_FIFO2_TYPE ((__force mailbox_type_t) 2)
+#define MBOX_HW_FIFO1_TYPE	((__force mailbox_type_t) 1)
+#define MBOX_HW_FIFO2_TYPE	((__force mailbox_type_t) 2)
+#define MBOX_SHARED_MEM_TYPE	((__force mailbox_type_t) 3)
 
 struct mailbox_ops {
 	mailbox_type_t        type;
 	int             (*startup)(struct mailbox *mbox);
 	void            (*shutdown)(struct mailbox *mbox);
-	/* fifo */
-	void		(*fifo_read)(struct mailbox *mbox,
-						struct mailbox_msg *msg);
-	int             (*fifo_write)(struct mailbox *mbox,
-						struct mailbox_msg *msg);
-	int             (*fifo_empty)(struct mailbox *mbox);
-	int             (*fifo_full)(struct mailbox *mbox);
+	/* mailbox access */
+	void            (*read)(struct mailbox *mbox, struct mailbox_msg *msg);
+	int             (*write)(struct mailbox *mbox, struct mailbox_msg *msg);
+	int             (*empty)(struct mailbox *mbox);
+	int             (*poll_for_space)(struct mailbox *mbox);
 	/* irq */
 	void            (*enable_irq)(struct mailbox *mbox,
 			mailbox_irq_t irq);
@@ -55,6 +54,7 @@ struct mailbox_queue {
 
 struct mailbox {
 	char                    *name;
+	unsigned int            id;
 	unsigned int            irq;
 	struct mailbox_queue  *txq, *rxq;
 	struct mailbox_ops    *ops;
-- 
1.8.1.2

