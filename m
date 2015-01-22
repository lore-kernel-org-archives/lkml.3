Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbbAVXeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 18:34:14 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:39059 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbbAVXeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 18:34:12 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Peter Meerwald <pmeerw@pmeerw.net>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iio: imu: adis16400: Fix sign extension
Date: Fri, 23 Jan 2015 00:34:02 +0100
Message-Id: <1421969642-18167-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intention is obviously to sign-extend a 12 bit quantity. But
because of C's promotion rules, the assignment is equivalent to "val16
&= 0xfff;". Use the proper API for this.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/iio/imu/adis16400_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/adis16400_core.c b/drivers/iio/imu/adis16400_core.c
index b70873de04ea..fa795dcd5f75 100644
--- a/drivers/iio/imu/adis16400_core.c
+++ b/drivers/iio/imu/adis16400_core.c
@@ -26,6 +26,7 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/debugfs.h>
+#include <linux/bitops.h>
 
 #include <linux/iio/iio.h>
 #include <linux/iio/sysfs.h>
@@ -414,7 +415,7 @@ static int adis16400_read_raw(struct iio_dev *indio_dev,
 		mutex_unlock(&indio_dev->mlock);
 		if (ret)
 			return ret;
-		val16 = ((val16 & 0xFFF) << 4) >> 4;
+		val16 = sign_extend32(val16, 11);
 		*val = val16;
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_OFFSET:
-- 
2.1.3

