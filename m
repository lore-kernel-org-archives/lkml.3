Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaDALZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:25:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42765 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbaDALTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:19:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 135/144] [media] cx18: check for allocation failure in cx18_read_eeprom()
Date: Tue,  1 Apr 2014 12:15:39 +0100
Message-Id: <1396350948-29910-136-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit e351bf25fa373a3de0be2141b962c5c3c27006a2 upstream.

It upsets static checkers when we don't check for allocation failure.  I
moved the memset() of "tv" earlier so we don't use uninitialized data on
error.
Fixes: 1d212cf0c2d8 ('[media] cx18: struct i2c_client is too big for stack')

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Andy Walls <awalls@md.metrocast.net>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/pci/cx18/cx18-driver.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
index 6386ced..91c694b 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -327,13 +327,16 @@ void cx18_read_eeprom(struct cx18 *cx, struct tveeprom *tv)
 	struct i2c_client *c;
 	u8 eedata[256];
 
+	memset(tv, 0, sizeof(*tv));
+
 	c = kzalloc(sizeof(*c), GFP_KERNEL);
+	if (!c)
+		return;
 
 	strlcpy(c->name, "cx18 tveeprom tmp", sizeof(c->name));
 	c->adapter = &cx->i2c_adap[0];
 	c->addr = 0xa0 >> 1;
 
-	memset(tv, 0, sizeof(*tv));
 	if (tveeprom_read(c, eedata, sizeof(eedata)))
 		goto ret;
 
-- 
1.9.1

