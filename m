Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaAMV3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 16:29:16 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34656 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaAMV3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 16:29:14 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Phil Carmody <phil.carmody@partner.samsung.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] i2c: Re-instate body of i2c_parent_is_i2c_adapter()
Date: Mon, 13 Jan 2014 14:29:04 -0700
Message-Id: <1389648544-4201-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

The body of i2c_parent_is_i2c_adapter() is currently guarded by
CONFIG_I2C_MUX instead.

Among potentially other problems, this resulted in i2c_lock_adapter()
only locking I2C mux child adapters, and not the parent adapter. In
turn, this could allow inter-mingling of mux child selection and I2C
transactions, which could result in I2C transactions being directed to
the wrong I2C bus, and possibly even switching between busses in the
middle of a transaction.

One concrete issue caused by this bug was corrupted HDMI EDID reads
during boot on the NVIDIA Tegra Seaboard system, although this only
became apparent in recent linux-next, when the boot timing was changed
just enough to trigger the race condition.

Fixes: 3923172b3d70 ("i2c: reduce parent checking to a NOOP in non-I2C_MUX case")
Cc: Phil Carmody <phil.carmody@partner.samsung.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 include/linux/i2c.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index eff50e062be8..d9c8dbd3373f 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -445,7 +445,7 @@ static inline void i2c_set_adapdata(struct i2c_adapter *dev, void *data)
 static inline struct i2c_adapter *
 i2c_parent_is_i2c_adapter(const struct i2c_adapter *adapter)
 {
-#if IS_ENABLED(I2C_MUX)
+#if IS_ENABLED(CONFIG_I2C_MUX)
 	struct device *parent = adapter->dev.parent;
 
 	if (parent != NULL && parent->type == &i2c_adapter_type)
-- 
1.8.1.5

