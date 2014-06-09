Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbaFIJMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:12:01 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58442 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754873AbaFIIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Atilla Filiz <atilla.filiz@essensium.com>,
        Jonathan Cameron <jic23@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 054/146] iio:imu:mpu6050: Fixed segfault in Invensens MPU driver due to null dereference
Date: Mon,  9 Jun 2014 10:49:49 +0200
Message-Id: <361f937995467af9221608315b6db80766ca5ef4.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Atilla Filiz <atilla.filiz@essensium.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b9b3a41893c3f1be67b5aacfa525969914bea0e9 upstream.

The driver segfaults when the kernel boots with device tree as the
platform data is then not present and the pointer is deferenced without
checking it is not null.  This patch introduces such a check avoiding the
crash.

Signed-off-by: Atilla Filiz <atilla.filiz@essensium.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
index df7f1e1157ae..27a91768cc72 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -661,6 +661,7 @@ static int inv_mpu_probe(struct i2c_client *client,
 {
 	struct inv_mpu6050_state *st;
 	struct iio_dev *indio_dev;
+	struct inv_mpu6050_platform_data *pdata;
 	int result;
 
 	if (!i2c_check_functionality(client->adapter,
@@ -673,8 +674,10 @@ static int inv_mpu_probe(struct i2c_client *client,
 
 	st = iio_priv(indio_dev);
 	st->client = client;
-	st->plat_data = *(struct inv_mpu6050_platform_data
-				*)dev_get_platdata(&client->dev);
+	pdata = (struct inv_mpu6050_platform_data
+			*)dev_get_platdata(&client->dev);
+	if (pdata)
+		st->plat_data = *pdata;
 	/* power is turned on inside check chip type*/
 	result = inv_check_and_setup_chip(st, id);
 	if (result)
-- 
1.9.3

