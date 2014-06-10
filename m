Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899AbaFJUHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:07:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35444 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359AbaFJTww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:52:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alec Berg <alecaberg@chromium.org>, Jonathan Cameron <jic23@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 053/160] iio: querying buffer scan_mask should return 0/1
Date: Tue, 10 Jun 2014 12:44:53 -0700
Message-Id: <1402429600-20477-54-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/iio/industrialio-buffer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index 7f9152c..4bf831a 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -136,7 +136,8 @@ static ssize_t iio_scan_el_show(struct device *dev,
 	int ret;
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 
-	ret = test_bit(to_iio_dev_attr(attr)->address,
+	/* Ensure ret is 0 or 1. */
+	ret = !!test_bit(to_iio_dev_attr(attr)->address,
 		       indio_dev->buffer->scan_mask);
 
 	return sprintf(buf, "%d\n", ret);
@@ -837,7 +838,8 @@ int iio_scan_mask_query(struct iio_dev *indio_dev,
 	if (!buffer->scan_mask)
 		return 0;
 
-	return test_bit(bit, buffer->scan_mask);
+	/* Ensure return value is 0 or 1. */
+	return !!test_bit(bit, buffer->scan_mask);
 };
 EXPORT_SYMBOL_GPL(iio_scan_mask_query);
 
-- 
1.9.1

