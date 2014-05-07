Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbaEGNN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:13:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45340 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbaEGNNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:13:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alec Berg <alecaberg@chromium.org>, Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 03/70] iio: querying buffer scan_mask should return 0/1
Date: Wed,  7 May 2014 14:12:06 +0100
Message-Id: <1399468393-10140-4-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
References: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alec Berg <alecaberg@chromium.org>

commit 2076a20fc1a06f7b0333c62a2bb4eeeac7ed1bcb upstream.

Ensure that querying the IIO buffer scan_mask returns a value of
0 or 1. Currently querying the scan mask has the value returned
by test_bit(), which returns either true or false. For some
architectures test_bit() may return -1 for true, which will appear
to return an error when returning from iio_scan_mask_query().

Additionally, it's important for the sysfs interface to consistently
return the same thing when querying the scan_mask.

Signed-off-by: Alec Berg <alecaberg@chromium.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iio/industrialio-buffer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index e73033f..54adea8 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -119,7 +119,8 @@ static ssize_t iio_scan_el_show(struct device *dev,
 	int ret;
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 
-	ret = test_bit(to_iio_dev_attr(attr)->address,
+	/* Ensure ret is 0 or 1. */
+	ret = !!test_bit(to_iio_dev_attr(attr)->address,
 		       indio_dev->buffer->scan_mask);
 
 	return sprintf(buf, "%d\n", ret);
@@ -760,7 +761,8 @@ int iio_scan_mask_query(struct iio_dev *indio_dev,
 	if (!buffer->scan_mask)
 		return 0;
 
-	return test_bit(bit, buffer->scan_mask);
+	/* Ensure return value is 0 or 1. */
+	return !!test_bit(bit, buffer->scan_mask);
 };
 EXPORT_SYMBOL_GPL(iio_scan_mask_query);
 
-- 
1.9.1

