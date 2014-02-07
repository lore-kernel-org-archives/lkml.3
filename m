Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbaBGNCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:02:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41779 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaBGLth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:49:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Santos <daniel.santos@pobox.com>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 080/233] spidev: fix hang when transfer_one_message fails
Date: Fri,  7 Feb 2014 11:44:59 +0000
Message-Id: <1391773652-25214-81-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Santos <daniel.santos@pobox.com>

commit e120cc0dcf2880a4c5c0a6cb27b655600a1cfa1d upstream.

This corrects a problem in spi_pump_messages() that leads to an spi
message hanging forever when a call to transfer_one_message() fails.
This failure occurs in my MCP2210 driver when the cs_change bit is set
on the last transfer in a message, an operation which the hardware does
not support.

Rationale
Since the transfer_one_message() returns an int, we must presume that it
may fail.  If transfer_one_message() should never fail, it should return
void.  Thus, calls to transfer_one_message() should properly manage a
failure.

Fixes: ffbbdd21329f3 (spi: create a message queueing infrastructure)
Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/spi/spi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 978dda2..96310af 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -584,7 +584,9 @@ static void spi_pump_messages(struct kthread_work *work)
 	ret = master->transfer_one_message(master, master->cur_msg);
 	if (ret) {
 		dev_err(&master->dev,
-			"failed to transfer one message from queue\n");
+			"failed to transfer one message from queue: %d\n", ret);
+		master->cur_msg->status = ret;
+		spi_finalize_current_message(master);
 		return;
 	}
 }
-- 
1.8.3.2

