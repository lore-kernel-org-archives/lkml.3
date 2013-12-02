Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab3LBTrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:47:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab3LBTSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Frank Zago <frank@zago.net>, Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.12 151/212] iio:accel:kxsd9 fix missing mutex unlock
Date: Mon,  2 Dec 2013 11:15:42 -0800
Message-Id: <20131202191304.266995123@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Zago <frank@zago.net>

commit 0ee005c7dc2803125275e24598f0fb37775a6af3 upstream.

This will leave a lock held after reading from the device, preventing
any further reads.

Signed-off-by: Frank Zago <frank@zago.net>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/accel/kxsd9.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/iio/accel/kxsd9.c
+++ b/drivers/iio/accel/kxsd9.c
@@ -112,9 +112,10 @@ static int kxsd9_read(struct iio_dev *in
 	mutex_lock(&st->buf_lock);
 	st->tx[0] = KXSD9_READ(address);
 	ret = spi_sync_transfer(st->us, xfers, ARRAY_SIZE(xfers));
-	if (ret)
-		return ret;
-	return (((u16)(st->rx[0])) << 8) | (st->rx[1] & 0xF0);
+	if (!ret)
+		ret = (((u16)(st->rx[0])) << 8) | (st->rx[1] & 0xF0);
+	mutex_unlock(&st->buf_lock);
+	return ret;
 }
 
 static IIO_CONST_ATTR(accel_scale_available,


