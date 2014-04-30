Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbaD3Rok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 13:44:40 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:41835 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759285AbaD3Rof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 13:44:35 -0400
From: Doug Anderson <dianders@chromium.org>
To: lee.jones@linaro.org, swarren@nvidia.com, wsa@the-dreams.de
Cc: abrestic@chromium.org, dgreid@chromium.org, olof@lixom.net,
        sjg@chromium.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, Doug Anderson <dianders@chromium.org>,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/7] mfd: cros_ec: spi: Make the cros_ec_spi timeout more reliable
Date: Wed, 30 Apr 2014 10:44:06 -0700
Message-Id: <1398879850-9111-4-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1398879850-9111-1-git-send-email-dianders@chromium.org>
References: <1398879850-9111-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cros_ec_spi transfer had two problems with its timeout code:

1. It looked at the timeout even in the case that it found valid data.
2. If the cros_ec_spi code got switched out for a while, it's possible
   it could get a timeout after a single loop.  Let's be paranoid and
   make sure we do one last transfer after the timeout expires.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Simon Glass <sjg@chromium.org>
Tested-by: Andrew Bresticker <abrestic@chromium.org>
Tested-by: Stephen Warren <swarren@nvidia.com>
---
Changes in v3: None
Changes in v2: None

 drivers/mfd/cros_ec_spi.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
index a2a605d..4f863c3 100644
--- a/drivers/mfd/cros_ec_spi.c
+++ b/drivers/mfd/cros_ec_spi.c
@@ -113,7 +113,9 @@ static int cros_ec_spi_receive_response(struct cros_ec_device *ec_dev,
 
 	/* Receive data until we see the header byte */
 	deadline = jiffies + msecs_to_jiffies(EC_MSG_DEADLINE_MS);
-	do {
+	while (true) {
+		unsigned long start_jiffies = jiffies;
+
 		memset(&trans, 0, sizeof(trans));
 		trans.cs_change = 1;
 		trans.rx_buf = ptr = ec_dev->din;
@@ -134,12 +136,19 @@ static int cros_ec_spi_receive_response(struct cros_ec_device *ec_dev,
 				break;
 			}
 		}
+		if (ptr != end)
+			break;
 
-		if (time_after(jiffies, deadline)) {
+		/*
+		 * Use the time at the start of the loop as a timeout.  This
+		 * gives us one last shot at getting the transfer and is useful
+		 * in case we got context switched out for a while.
+		 */
+		if (time_after(start_jiffies, deadline)) {
 			dev_warn(ec_dev->dev, "EC failed to respond in time\n");
 			return -ETIMEDOUT;
 		}
-	} while (ptr == end);
+	}
 
 	/*
 	 * ptr now points to the header byte. Copy any valid data to the
-- 
1.9.1.423.g4596e3a

