Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab3LERiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:38:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38408 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428Ab3LERiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:38:04 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Frank Zago <frank@zago.net>, Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 75/90] iio:accel:kxsd9 fix missing mutex unlock
Date: Thu,  5 Dec 2013 17:35:57 +0000
Message-Id: <1386264972-5399-76-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Zago <frank@zago.net>

commit 0ee005c7dc2803125275e24598f0fb37775a6af3 upstream.

This will leave a lock held after reading from the device, preventing
any further reads.

Signed-off-by: Frank Zago <frank@zago.net>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
[ luis: backported to 3.5:
  - adjusted context
  - drivers/iio/accel/kxsd9.c -> drivers/staging/iio/accel/kxsd9.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/iio/accel/kxsd9.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/iio/accel/kxsd9.c b/drivers/staging/iio/accel/kxsd9.c
index 8cf7cd9..cfa77fb 100644
--- a/drivers/staging/iio/accel/kxsd9.c
+++ b/drivers/staging/iio/accel/kxsd9.c
@@ -116,9 +116,10 @@ static int kxsd9_read(struct iio_dev *indio_dev, u8 address)
 	spi_message_add_tail(&xfers[0], &msg);
 	spi_message_add_tail(&xfers[1], &msg);
 	ret = spi_sync(st->us, &msg);
-	if (ret)
-		return ret;
-	return (((u16)(st->rx[0])) << 8) | (st->rx[1] & 0xF0);
+	if (!ret)
+		ret = (((u16)(st->rx[0])) << 8) | (st->rx[1] & 0xF0);
+	mutex_unlock(&st->buf_lock);
+	return ret;
 }
 
 static IIO_CONST_ATTR(accel_scale_available,
-- 
1.8.3.2

