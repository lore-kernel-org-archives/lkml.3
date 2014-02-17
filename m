Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbaBQRZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:25:06 -0500
Received: from top.free-electrons.com ([176.31.233.9]:40347 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751976AbaBQRZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:25:04 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        stable@vger.kernel.org
Subject: [PATCH] spi: core: Fix Oops in spi_pump_messages error path
Date: Mon, 17 Feb 2014 18:20:37 +0100
Message-Id: <1392657637-5297-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the generic implementation of the transfer_one_message callback was called
by the spi_pump_messages function, if that transfer was to fail, the
spi_finalize_current_message was called twice, once in
spi_transfer_one_message, and one in spi_pump_messages.

This was causing a null pointer dereference in the second call, because the
first one set the ->cur_msg field to NULL.

Since the SPI framework expect the transfer_one_message callback to call
spi_finalize_current_message, we can remove it from spi_pump_messages, together
with any dereference of the ->cur_msg pointer.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: stable@vger.kernel.org
---
 drivers/spi/spi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 23756b0..39f12be 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -756,8 +756,6 @@ static void spi_pump_messages(struct kthread_work *work)
 	if (ret) {
 		dev_err(&master->dev,
 			"failed to transfer one message from queue: %d\n", ret);
-		master->cur_msg->status = ret;
-		spi_finalize_current_message(master);
 		return;
 	}
 }
-- 
1.8.4.2

