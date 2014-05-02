Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbaEBWlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 18:41:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59171 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752109AbaEBWk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 18:40:59 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 1/2] iio: fix possible buffer overflow
Date: Sat,  3 May 2014 00:40:49 +0200
Message-Id: <1399070450-23391-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found using smatch:
drivers/iio/industrialio-core.c:719 iio_device_add_info_mask_type() error:
buffer overflow 'iio_chan_info_postfix' 17 <= 63

It was probably never hit because the info_mask_* members are filled by using
the BIT() macro with values from the iio_chan_info_enum enum that also serve as
the index of the iio_chan_info_postfix array.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/iio/industrialio-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index ede16aec20fb..5e7a67e53879 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -715,7 +715,8 @@ static int iio_device_add_info_mask_type(struct iio_dev *indio_dev,
 {
 	int i, ret, attrcount = 0;
 
-	for_each_set_bit(i, infomask, sizeof(infomask)*8) {
+	for_each_set_bit(i, infomask, min(sizeof(infomask)*8,
+					  ARRAY_SIZE(iio_chan_info_postfix))) {
 		ret = __iio_add_chan_devattr(iio_chan_info_postfix[i],
 					     chan,
 					     &iio_read_channel_info,
-- 
1.9.1

