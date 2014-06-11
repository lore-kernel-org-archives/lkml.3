Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbaFKHti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 03:49:38 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:25740 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755504AbaFKHtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 03:49:36 -0400
X-IronPort-AV: E=Sophos;i="5.00,687,1396972800"; 
   d="scan'208";a="31751340"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, David Airlie <airlied@linux.ie>,
        Ben Skeggs <bskeggs@redhat.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
Subject: [RFC PATCH] nouveau: rename aux.c to auxiliary.c for reviewing it on Windows
Date: Wed, 11 Jun 2014 15:53:55 +0800
Message-ID: <1402473247-30468-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I tried to review the linux kernel on Windows in my laptop
and incidentally found that it failed to open the aux.c.

And Microsoft tells me:
(http://msdn.microsoft.com/en-us/library/aa365247.aspx)

> Do not use the following reserved names for the name of a file:
> CON, PRN, AUX, NUL, <snip...>, and LPT9. Also avoid these names
> followed immediately by an extension; for example, NUL.txt
> is not recommended.

The name "aux" is listed above. And it sometimes makes sense to
review linux on windows, so we rename the aux.c to auxiliary.c.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 drivers/gpu/drm/nouveau/Makefile                   |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/i2c/aux.c      |  100 --------------------
 .../gpu/drm/nouveau/core/subdev/i2c/auxiliary.c    |  100 ++++++++++++++++++++
 3 files changed, 101 insertions(+), 101 deletions(-)
 delete mode 100644 drivers/gpu/drm/nouveau/core/subdev/i2c/aux.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/i2c/auxiliary.c

diff --git a/drivers/gpu/drm/nouveau/Makefile b/drivers/gpu/drm/nouveau/Makefile
index b7d2162..cf7be04 100644
--- a/drivers/gpu/drm/nouveau/Makefile
+++ b/drivers/gpu/drm/nouveau/Makefile
@@ -127,7 +127,7 @@ nouveau-y += core/subdev/gpio/nvd0.o
 nouveau-y += core/subdev/gpio/nve0.o
 nouveau-y += core/subdev/i2c/base.o
 nouveau-y += core/subdev/i2c/anx9805.o
-nouveau-y += core/subdev/i2c/aux.o
+nouveau-y += core/subdev/i2c/auxiliary.o
 nouveau-y += core/subdev/i2c/bit.o
 nouveau-y += core/subdev/i2c/nv04.o
 nouveau-y += core/subdev/i2c/nv4e.o
diff --git a/drivers/gpu/drm/nouveau/core/subdev/i2c/aux.c b/drivers/gpu/drm/nouveau/core/subdev/i2c/aux.c
deleted file mode 100644
index 5de074a..0000000
--- a/drivers/gpu/drm/nouveau/core/subdev/i2c/aux.c
+++ /dev/null
@@ -1,100 +0,0 @@
-/*
- * Copyright 2009 Red Hat Inc.
- *
- * Permission is hereby granted, free of charge, to any person obtaining a
- * copy of this software and associated documentation files (the "Software"),
- * to deal in the Software without restriction, including without limitation
- * the rights to use, copy, modify, merge, publish, distribute, sublicense,
- * and/or sell copies of the Software, and to permit persons to whom the
- * Software is furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
- * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
- * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
- * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
- * OTHER DEALINGS IN THE SOFTWARE.
- *
- * Authors: Ben Skeggs
- */
-
-#include <subdev/i2c.h>
-
-int
-nv_rdaux(struct nouveau_i2c_port *port, u32 addr, u8 *data, u8 size)
-{
-	if (port->func->aux) {
-		if (port->func->acquire)
-			port->func->acquire(port);
-		return port->func->aux(port, 9, addr, data, size);
-	}
-	return -ENODEV;
-}
-
-int
-nv_wraux(struct nouveau_i2c_port *port, u32 addr, u8 *data, u8 size)
-{
-	if (port->func->aux) {
-		if (port->func->acquire)
-			port->func->acquire(port);
-		return port->func->aux(port, 8, addr, data, size);
-	}
-	return -ENODEV;
-}
-
-static int
-aux_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
-{
-	struct nouveau_i2c_port *port = adap->algo_data;
-	struct i2c_msg *msg = msgs;
-	int ret, mcnt = num;
-
-	if (!port->func->aux)
-		return -ENODEV;
-	if ( port->func->acquire)
-		port->func->acquire(port);
-
-	while (mcnt--) {
-		u8 remaining = msg->len;
-		u8 *ptr = msg->buf;
-
-		while (remaining) {
-			u8 cnt = (remaining > 16) ? 16 : remaining;
-			u8 cmd;
-
-			if (msg->flags & I2C_M_RD)
-				cmd = 1;
-			else
-				cmd = 0;
-
-			if (mcnt || remaining > 16)
-				cmd |= 4; /* MOT */
-
-			ret = port->func->aux(port, cmd, msg->addr, ptr, cnt);
-			if (ret < 0)
-				return ret;
-
-			ptr += cnt;
-			remaining -= cnt;
-		}
-
-		msg++;
-	}
-
-	return num;
-}
-
-static u32
-aux_func(struct i2c_adapter *adap)
-{
-	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
-}
-
-const struct i2c_algorithm nouveau_i2c_aux_algo = {
-	.master_xfer = aux_xfer,
-	.functionality = aux_func
-};
diff --git a/drivers/gpu/drm/nouveau/core/subdev/i2c/auxiliary.c b/drivers/gpu/drm/nouveau/core/subdev/i2c/auxiliary.c
new file mode 100644
index 0000000..5de074a
--- /dev/null
+++ b/drivers/gpu/drm/nouveau/core/subdev/i2c/auxiliary.c
@@ -0,0 +1,100 @@
+/*
+ * Copyright 2009 Red Hat Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ *
+ * Authors: Ben Skeggs
+ */
+
+#include <subdev/i2c.h>
+
+int
+nv_rdaux(struct nouveau_i2c_port *port, u32 addr, u8 *data, u8 size)
+{
+	if (port->func->aux) {
+		if (port->func->acquire)
+			port->func->acquire(port);
+		return port->func->aux(port, 9, addr, data, size);
+	}
+	return -ENODEV;
+}
+
+int
+nv_wraux(struct nouveau_i2c_port *port, u32 addr, u8 *data, u8 size)
+{
+	if (port->func->aux) {
+		if (port->func->acquire)
+			port->func->acquire(port);
+		return port->func->aux(port, 8, addr, data, size);
+	}
+	return -ENODEV;
+}
+
+static int
+aux_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
+{
+	struct nouveau_i2c_port *port = adap->algo_data;
+	struct i2c_msg *msg = msgs;
+	int ret, mcnt = num;
+
+	if (!port->func->aux)
+		return -ENODEV;
+	if ( port->func->acquire)
+		port->func->acquire(port);
+
+	while (mcnt--) {
+		u8 remaining = msg->len;
+		u8 *ptr = msg->buf;
+
+		while (remaining) {
+			u8 cnt = (remaining > 16) ? 16 : remaining;
+			u8 cmd;
+
+			if (msg->flags & I2C_M_RD)
+				cmd = 1;
+			else
+				cmd = 0;
+
+			if (mcnt || remaining > 16)
+				cmd |= 4; /* MOT */
+
+			ret = port->func->aux(port, cmd, msg->addr, ptr, cnt);
+			if (ret < 0)
+				return ret;
+
+			ptr += cnt;
+			remaining -= cnt;
+		}
+
+		msg++;
+	}
+
+	return num;
+}
+
+static u32
+aux_func(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+}
+
+const struct i2c_algorithm nouveau_i2c_aux_algo = {
+	.master_xfer = aux_xfer,
+	.functionality = aux_func
+};
-- 
1.7.4.4

