Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab3FDOo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:44:57 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47168 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755311Ab3FDOox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:44:53 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org
Subject: [PATCH 2/4] inkern: iio_device_put after incorrect return/goto
Date: Tue,  4 Jun 2013 07:44:48 -0700
Message-Id: <d0f7d0eef677250c457c08c8f8ca7e125811f754.1370356776.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <60123fd3175b7cceadf6c335b12e58b797e18f65.1370356776.git.joe@perches.com>
References: <60123fd3175b7cceadf6c335b12e58b797e18f65.1370356776.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code uses

    return foo;
    goto err_type;

when instead the form should have been

    ret = foo;
    goto err_type;

Here this causes a useful iio_device_put to be skipped.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/iio/inkern.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index 795d100..dca4eed 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -124,7 +124,7 @@ static int __of_iio_channel_get(struct iio_channel *channel,
 	channel->indio_dev = indio_dev;
 	index = iiospec.args_count ? iiospec.args[0] : 0;
 	if (index >= indio_dev->num_channels) {
-		return -EINVAL;
+		err = -EINVAL;
 		goto err_put;
 	}
 	channel->channel = &indio_dev->channels[index];
-- 
1.8.1.2.459.gbcd45b4.dirty

