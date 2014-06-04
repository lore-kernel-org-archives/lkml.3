Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbaFEAdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:33:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbaFDXVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Atilla Filiz <atilla.filiz@essensium.com>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.14 085/228] iio:imu:mpu6050: Fixed segfault in Invensens MPU driver due to null dereference
Date: Wed,  4 Jun 2014 16:21:54 -0700
Message-Id: <20140604232350.794759306@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Atilla Filiz <atilla.filiz@essensium.com>

commit b9b3a41893c3f1be67b5aacfa525969914bea0e9 upstream.

The driver segfaults when the kernel boots with device tree as the
platform data is then not present and the pointer is deferenced without
checking it is not null.  This patch introduces such a check avoiding the
crash.

Signed-off-by: Atilla Filiz <atilla.filiz@essensium.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -661,6 +661,7 @@ static int inv_mpu_probe(struct i2c_clie
 {
 	struct inv_mpu6050_state *st;
 	struct iio_dev *indio_dev;
+	struct inv_mpu6050_platform_data *pdata;
 	int result;
 
 	if (!i2c_check_functionality(client->adapter,
@@ -673,8 +674,10 @@ static int inv_mpu_probe(struct i2c_clie
 
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


