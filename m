Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746AbbAYSes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:34:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387AbbAYSKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tyler Baker <tyler.baker@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>
Subject: [PATCH 3.18 130/183] reset: sunxi: fix spinlock initialization
Date: Sun, 25 Jan 2015 10:07:32 -0800
Message-Id: <20150125180815.818726969@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Baker <tyler.baker@linaro.org>

commit 41544f9f38f19cb46dc9a8fa37c58677a0300899 upstream.

Call spin_lock_init() before the spinlocks are used, both in early init
and probe functions preventing a lockdep splat.

I have been observing lockdep complaining [1] during boot on my a80 optimus [2]
when CONFIG_PROVE_LOCKING has been enabled. This patch resolves the splat,
and has been tested on a few other sunxi platforms without issue.

[1] http://storage.kernelci.org/next/next-20150107/arm-multi_v7_defconfig+CONFIG_PROVE_LOCKING=y/lab-tbaker/boot-sun9i-a80-optimus.html
[2] http://kernelci.org/boot/?a80-optimus

Signed-off-by: Tyler Baker <tyler.baker@linaro.org>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/reset/reset-sunxi.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/reset/reset-sunxi.c
+++ b/drivers/reset/reset-sunxi.c
@@ -102,6 +102,8 @@ static int sunxi_reset_init(struct devic
 		goto err_alloc;
 	}
 
+	spin_lock_init(&data->lock);
+
 	data->rcdev.owner = THIS_MODULE;
 	data->rcdev.nr_resets = size * 32;
 	data->rcdev.ops = &sunxi_reset_ops;
@@ -157,6 +159,8 @@ static int sunxi_reset_probe(struct plat
 	if (IS_ERR(data->membase))
 		return PTR_ERR(data->membase);
 
+	spin_lock_init(&data->lock);
+
 	data->rcdev.owner = THIS_MODULE;
 	data->rcdev.nr_resets = resource_size(res) * 32;
 	data->rcdev.ops = &sunxi_reset_ops;


