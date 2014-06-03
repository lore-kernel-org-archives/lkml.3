Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaFCLkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:40:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43223 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbaFCLkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:40:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Atilla Filiz <atilla.filiz@essensium.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 009/138] iio:imu:mpu6050: Fixed segfault in Invensens MPU driver due to null dereference
Date: Tue,  3 Jun 2014 12:37:35 +0100
Message-Id: <1401795584-22664-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Atilla Filiz <atilla.filiz@essensium.com>

commit b9b3a41893c3f1be67b5aacfa525969914bea0e9 upstream.

The driver segfaults when the kernel boots with device tree as the
platform data is then not present and the pointer is deferenced without
checking it is not null.  This patch introduces such a check avoiding the
crash.

Signed-off-by: Atilla Filiz <atilla.filiz@essensium.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
index fe4c61e219f3..111ac381b40b 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -660,6 +660,7 @@ static int inv_mpu_probe(struct i2c_client *client,
 {
 	struct inv_mpu6050_state *st;
 	struct iio_dev *indio_dev;
+	struct inv_mpu6050_platform_data *pdata;
 	int result;
 
 	if (!i2c_check_functionality(client->adapter,
@@ -675,8 +676,10 @@ static int inv_mpu_probe(struct i2c_client *client,
 	}
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
1.9.1

