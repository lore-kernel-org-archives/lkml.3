Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945930AbaD3RvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 13:51:18 -0400
Received: from mail-yk0-f201.google.com ([209.85.160.201]:63410 "EHLO
	mail-yk0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759286AbaD3RvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 13:51:16 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Apr 2014 13:51:16 EDT
From: Doug Anderson <dianders@chromium.org>
To: lee.jones@linaro.org, swarren@nvidia.com, wsa@the-dreams.de
Cc: abrestic@chromium.org, dgreid@chromium.org, olof@lixom.net,
        sjg@chromium.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, David Hendricks <dhendrix@chromium.org>,
        Doug Anderson <dianders@chromium.org>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/7] mfd: cros_ec: spi: calculate delay between transfers correctly
Date: Wed, 30 Apr 2014 10:44:04 -0700
Message-Id: <1398879850-9111-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1398879850-9111-1-git-send-email-dianders@chromium.org>
References: <1398879850-9111-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Hendricks <dhendrix@chromium.org>

To avoid spamming the EC we calculate the time between the previous
transfer and the current transfer and force a delay if the time delta
is too small.

However, a small miscalculation causes the delay period to be
far too short. Most noticably this impacts commands with a long
turnaround time such as EC firmware reads and writes.

Signed-off-by: David Hendricks <dhendrix@chromium.org>
Signed-off-by: Doug Anderson <dianders@chromium.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Simon Glass <sjg@chromium.org>
Tested-by: Andrew Bresticker <abrestic@chromium.org>
Tested-by: Stephen Warren <swarren@nvidia.com>
---
Changes in v3: None
Changes in v2: None

 drivers/mfd/cros_ec_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
index 84af8d7..c185eb6 100644
--- a/drivers/mfd/cros_ec_spi.c
+++ b/drivers/mfd/cros_ec_spi.c
@@ -219,7 +219,7 @@ static int cros_ec_command_spi_xfer(struct cros_ec_device *ec_dev,
 		ktime_get_ts(&ts);
 		delay = timespec_to_ns(&ts) - ec_spi->last_transfer_ns;
 		if (delay < EC_SPI_RECOVERY_TIME_NS)
-			ndelay(delay);
+			ndelay(EC_SPI_RECOVERY_TIME_NS - delay);
 	}
 
 	/* Transmit phase - send our message */
-- 
1.9.1.423.g4596e3a

