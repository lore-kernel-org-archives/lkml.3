Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbaEDQKw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:10:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655AbaEDPm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alec Berg <alecaberg@chromium.org>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.10 38/86] iio: querying buffer scan_mask should return 0/1
Date: Sun,  4 May 2014 11:41:13 -0400
Message-Id: <20140504154145.564121087@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/industrialio-buffer.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -119,7 +119,8 @@ static ssize_t iio_scan_el_show(struct d
 	int ret;
 	struct iio_dev *indio_dev = dev_to_iio_dev(dev);
 
-	ret = test_bit(to_iio_dev_attr(attr)->address,
+	/* Ensure ret is 0 or 1. */
+	ret = !!test_bit(to_iio_dev_attr(attr)->address,
 		       indio_dev->buffer->scan_mask);
 
 	return sprintf(buf, "%d\n", ret);
@@ -762,7 +763,8 @@ int iio_scan_mask_query(struct iio_dev *
 	if (!buffer->scan_mask)
 		return 0;
 
-	return test_bit(bit, buffer->scan_mask);
+	/* Ensure return value is 0 or 1. */
+	return !!test_bit(bit, buffer->scan_mask);
 };
 EXPORT_SYMBOL_GPL(iio_scan_mask_query);
 


