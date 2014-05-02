Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbaEBWlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 18:41:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59175 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753056AbaEBWlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 18:41:01 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 2/2] iio: fix possible buffer overflow
Date: Sat,  3 May 2014 00:40:50 +0200
Message-Id: <1399070450-23391-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399070450-23391-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1399070450-23391-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found using smatch:
drivers/iio/industrialio-event.c:327 iio_device_add_event() error: buffer
overflow 'iio_ev_info_text' 3 <= 7

It was probably never hit because the mask_* members of the event_spec struct
are filled by using the BIT() macro with values from the iio_event_info enum
that also serve as the index of the iio_ev_info_text array.

Also, for_each_set_bit takes a number of bits as the size, not a number of
bytes.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/iio/industrialio-event.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/industrialio-event.c b/drivers/iio/industrialio-event.c
index ea6e06b9c7d4..804e90676159 100644
--- a/drivers/iio/industrialio-event.c
+++ b/drivers/iio/industrialio-event.c
@@ -321,7 +321,8 @@ static int iio_device_add_event(struct iio_dev *indio_dev,
 	char *postfix;
 	int ret;
 
-	for_each_set_bit(i, mask, sizeof(*mask)) {
+	for_each_set_bit(i, mask,
+			 min(sizeof(*mask)*8, ARRAY_SIZE(iio_ev_info_text))) {
 		postfix = kasprintf(GFP_KERNEL, "%s_%s_%s",
 				iio_ev_type_text[type], iio_ev_dir_text[dir],
 				iio_ev_info_text[i]);
-- 
1.9.1

