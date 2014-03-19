Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaCSS7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 14:59:22 -0400
Received: from mail-oa0-f73.google.com ([209.85.219.73]:34958 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbaCSS7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 14:59:20 -0400
From: Alec Berg <alecaberg@chromium.org>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vincent Palatin <vpalatin@chromium.org>,
        olof@lixom.net, Alec Berg <alecaberg@chromium.org>
Subject: [PATCH] iio: querying buffer scan_mask should return 0/1
Date: Wed, 19 Mar 2014 11:50:44 -0700
Message-Id: <1395255044-20173-1-git-send-email-alecaberg@chromium.org>
X-Mailer: git-send-email 1.9.0.279.gdc9e3eb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that querying the IIO buffer scan_mask returns a value of
0 or 1. Currently querying the scan mask has the value returned
by test_bit(), which returns either true or false. For some
architectures test_bit() may return -1 for true, which will appear
to return an error when returning from iio_scan_mask_query().

Additionally, it's important for the sysfs interface to consistently
return the same thing when querying the scan_mask.

Signed-off-by: Alec Berg <alecaberg@chromium.org>
---
 drivers/iio/industrialio-buffer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index c67d83b..fe25042 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -165,7 +165,8 @@ static ssize_t iio_scan_el_show(struct device *dev,
 	int ret;
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 
-	ret = test_bit(to_iio_dev_attr(attr)->address,
+	/* Ensure ret is 0 or 1. */
+	ret = !!test_bit(to_iio_dev_attr(attr)->address,
 		       indio_dev->buffer->scan_mask);
 
 	return sprintf(buf, "%d\n", ret);
@@ -866,7 +867,8 @@ int iio_scan_mask_query(struct iio_dev *indio_dev,
 	if (!buffer->scan_mask)
 		return 0;
 
-	return test_bit(bit, buffer->scan_mask);
+	/* Ensure return value is 0 or 1. */
+	return !!test_bit(bit, buffer->scan_mask);
 };
 EXPORT_SYMBOL_GPL(iio_scan_mask_query);
 
-- 
1.9.0.279.gdc9e3eb

