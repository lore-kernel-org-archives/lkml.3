Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761402AbaJDAtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:49:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44722 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbaJCVcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3.16 048/357] Revert "i2c: rcar: remove spinlock"
Date: Fri,  3 Oct 2014 14:27:14 -0700
Message-Id: <20141003212934.899559577@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

commit 91bfe2989af02e709ca01ccf518c4fbda3efc70f upstream.

This reverts commit 150b8be3cda54412ad7b54f5392b513b25c0aaa7.

The I2C core's per-adapter locks can't protect from IRQs, so the driver still
needs a spinlock to protect the register accesses.

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-rcar.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -34,6 +34,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
+#include <linux/spinlock.h>
 
 /* register offsets */
 #define ICSCR	0x00	/* slave ctrl */
@@ -95,6 +96,7 @@ struct rcar_i2c_priv {
 	struct i2c_msg	*msg;
 	struct clk *clk;
 
+	spinlock_t lock;
 	wait_queue_head_t wait;
 
 	int pos;
@@ -365,6 +367,9 @@ static irqreturn_t rcar_i2c_irq(int irq,
 	struct rcar_i2c_priv *priv = ptr;
 	u32 msr;
 
+	/*-------------- spin lock -----------------*/
+	spin_lock(&priv->lock);
+
 	msr = rcar_i2c_read(priv, ICMSR);
 
 	/* Arbitration lost */
@@ -400,6 +405,9 @@ out:
 		wake_up(&priv->wait);
 	}
 
+	spin_unlock(&priv->lock);
+	/*-------------- spin unlock -----------------*/
+
 	return IRQ_HANDLED;
 }
 
@@ -409,14 +417,21 @@ static int rcar_i2c_master_xfer(struct i
 {
 	struct rcar_i2c_priv *priv = i2c_get_adapdata(adap);
 	struct device *dev = rcar_i2c_priv_to_dev(priv);
+	unsigned long flags;
 	int i, ret, timeout;
 
 	pm_runtime_get_sync(dev);
 
+	/*-------------- spin lock -----------------*/
+	spin_lock_irqsave(&priv->lock, flags);
+
 	rcar_i2c_init(priv);
 	/* start clock */
 	rcar_i2c_write(priv, ICCCR, priv->icccr);
 
+	spin_unlock_irqrestore(&priv->lock, flags);
+	/*-------------- spin unlock -----------------*/
+
 	ret = rcar_i2c_bus_barrier(priv);
 	if (ret < 0)
 		goto out;
@@ -428,6 +443,9 @@ static int rcar_i2c_master_xfer(struct i
 			break;
 		}
 
+		/*-------------- spin lock -----------------*/
+		spin_lock_irqsave(&priv->lock, flags);
+
 		/* init each data */
 		priv->msg	= &msgs[i];
 		priv->pos	= 0;
@@ -437,6 +455,9 @@ static int rcar_i2c_master_xfer(struct i
 
 		ret = rcar_i2c_prepare_msg(priv);
 
+		spin_unlock_irqrestore(&priv->lock, flags);
+		/*-------------- spin unlock -----------------*/
+
 		if (ret < 0)
 			break;
 
@@ -540,6 +561,7 @@ static int rcar_i2c_probe(struct platfor
 
 	irq = platform_get_irq(pdev, 0);
 	init_waitqueue_head(&priv->wait);
+	spin_lock_init(&priv->lock);
 
 	adap			= &priv->adap;
 	adap->nr		= pdev->id;


