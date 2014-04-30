Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbaD3Rom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 13:44:42 -0400
Received: from mail-vc0-f202.google.com ([209.85.220.202]:45534 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759260AbaD3Rof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 13:44:35 -0400
From: Doug Anderson <dianders@chromium.org>
To: lee.jones@linaro.org, swarren@nvidia.com, wsa@the-dreams.de
Cc: abrestic@chromium.org, dgreid@chromium.org, olof@lixom.net,
        sjg@chromium.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, Doug Anderson <dianders@chromium.org>,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/7] mfd: cros_ec: spi: Increase cros_ec_spi deadline from 5ms to 100ms
Date: Wed, 30 Apr 2014 10:44:07 -0700
Message-Id: <1398879850-9111-5-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1398879850-9111-1-git-send-email-dianders@chromium.org>
References: <1398879850-9111-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're adding i2c tunneling to the list of things that goes over
cros_ec.  i2c tunneling can be slooooooow, so increase our deadline to
100ms to account for that.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Simon Glass <sjg@chromium.org>
Tested-by: Andrew Bresticker <abrestic@chromium.org>
Tested-by: Stephen Warren <swarren@nvidia.com>
---
Changes in v3: None
Changes in v2: None

 drivers/mfd/cros_ec_spi.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
index 4f863c3..0b8d328 100644
--- a/drivers/mfd/cros_ec_spi.c
+++ b/drivers/mfd/cros_ec_spi.c
@@ -39,14 +39,22 @@
 #define EC_MSG_PREAMBLE_COUNT		32
 
 /*
-  * We must get a response from the EC in 5ms. This is a very long
-  * time, but the flash write command can take 2-3ms. The EC command
-  * processing is currently not very fast (about 500us). We could
-  * look at speeding this up and making the flash write command a
-  * 'slow' command, requiring a GET_STATUS wait loop, like flash
-  * erase.
-  */
-#define EC_MSG_DEADLINE_MS		5
+ * Allow for a long time for the EC to respond.  We support i2c
+ * tunneling and support fairly long messages for the tunnel (249
+ * bytes long at the moment).  If we're talking to a 100 kHz device
+ * on the other end and need to transfer ~256 bytes, then we need:
+ *  10 us/bit * ~10 bits/byte * ~256 bytes = ~25ms
+ *
+ * We'll wait 4 times that to handle clock stretching and other
+ * paranoia.
+ *
+ * It's pretty unlikely that we'll really see a 249 byte tunnel in
+ * anything other than testing.  If this was more common we might
+ * consider having slow commands like this require a GET_STATUS
+ * wait loop.  The 'flash write' command would be another candidate
+ * for this, clocking in at 2-3ms.
+ */
+#define EC_MSG_DEADLINE_MS		100
 
 /*
   * Time between raising the SPI chip select (for the end of a
-- 
1.9.1.423.g4596e3a

