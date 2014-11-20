Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbaKTKFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 05:05:03 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:60435 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757293AbaKTKDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 05:03:23 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 3/5] i2c: recovery: change input parameter to i2c_adapter for prepare/unprepare_recovery
Date: Thu, 20 Nov 2014 12:03:06 +0200
Message-ID: <1416477788-5544-4-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416477788-5544-1-git-send-email-grygorii.strashko@ti.com>
References: <1416477788-5544-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes type of input parameter for .prepare/unprepare_recovery()
callbacks from struct i2c_bus_recovery_info * to struct i2c_adapter *.
This allows to simplify implementation of these callbacks and avoid
type conversations from i2c_bus_recovery_info to i2c_adapter.
The i2c_bus_recovery_info can be simply retrieved from struct i2c_adapter
which contains pointer on it.

CC: Sekhar Nori <nsekhar@ti.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>
CC: Santosh Shilimkar <ssantosh@kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/i2c/i2c-core.c | 4 ++--
 include/linux/i2c.h    | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 2f90ac6..72b6e34 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -563,7 +563,7 @@ static int i2c_generic_recovery(struct i2c_adapter *adap)
 	int i = 0, val = 1, ret = 0;
 
 	if (bri->prepare_recovery)
-		bri->prepare_recovery(bri);
+		bri->prepare_recovery(adap);
 
 	/*
 	 * By this time SCL is high, as we need to give 9 falling-rising edges
@@ -588,7 +588,7 @@ static int i2c_generic_recovery(struct i2c_adapter *adap)
 	}
 
 	if (bri->unprepare_recovery)
-		bri->unprepare_recovery(bri);
+		bri->unprepare_recovery(adap);
 
 	return ret;
 }
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index b556e0a..cf9380f 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -404,8 +404,8 @@ struct i2c_bus_recovery_info {
 	void (*set_scl)(struct i2c_adapter *, int val);
 	int (*get_sda)(struct i2c_adapter *);
 
-	void (*prepare_recovery)(struct i2c_bus_recovery_info *bri);
-	void (*unprepare_recovery)(struct i2c_bus_recovery_info *bri);
+	void (*prepare_recovery)(struct i2c_adapter *);
+	void (*unprepare_recovery)(struct i2c_adapter *);
 
 	/* gpio recovery */
 	int scl_gpio;
-- 
1.9.1

