Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3LPLLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 06:11:11 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:51599 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab3LPLLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 06:11:04 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/2] mfd: cros ec: spi: Add delay for raising CS
Date: Mon, 16 Dec 2013 12:09:39 +0100
Message-Id: <1387192180-15333-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rhyland Klein <rklein@nvidia.com>

The EC has specific timing it requires. Add support for an optional delay
after raising CS to fix timing issues. This is configurable based on
a DT property "google,cros-ec-spi-msg-delay".

If this property isn't set, then no delay will be added. However, if set
it will cause a delay equal to the value passed to it to be inserted at
the end of a transaction.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
Reviewed-by: Bernie Thompson <bhthompson@chromium.org>
Reviewed-by: Andrew Bresticker <abrestic@chromium.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v5:
- modify correct hunk to use 0 instead of '\0'
- add Mark's Acked-by

Changes in v4:
- unconditionally call cros_ec_spi_dt_probe() since the driver now
  depends on OF

Changes in v3:
- rename cros_ec_probe_spi_dt() to cros_ec_spi_dt_probe()
- use 0 instead of '\0'

Changes in v2:
- make property description more verbose

 Documentation/devicetree/bindings/mfd/cros-ec.txt |  9 +++++++
 drivers/mfd/cros_ec_spi.c                         | 29 +++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/cros-ec.txt b/Documentation/devicetree/bindings/mfd/cros-ec.txt
index 5f229c5f6da9..8009c3d87f33 100644
--- a/Documentation/devicetree/bindings/mfd/cros-ec.txt
+++ b/Documentation/devicetree/bindings/mfd/cros-ec.txt
@@ -17,6 +17,15 @@ Required properties (SPI):
 - compatible: "google,cros-ec-spi"
 - reg: SPI chip select
 
+Optional properties (SPI):
+- google,cros-ec-spi-msg-delay: Some implementations of the EC require some
+  additional processing time in order to accept new transactions. If the delay
+  between transactions is not long enough the EC may not be able to respond
+  properly to subsequent transactions and cause them to hang. This property
+  specifies the delay, in usecs, introduced between transactions to account
+  for the time required by the EC to get back into a state in which new data
+  can be accepted.
+
 Required properties (LPC):
 - compatible: "google,cros-ec-lpc"
 - reg: List of (IO address, size) pairs defining the interface uses
diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
index d64d88a9e247..8e262bfb603e 100644
--- a/drivers/mfd/cros_ec_spi.c
+++ b/drivers/mfd/cros_ec_spi.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/mfd/cros_ec.h>
 #include <linux/mfd/cros_ec_commands.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/spi/spi.h>
@@ -62,10 +63,13 @@
  * @spi: SPI device we are connected to
  * @last_transfer_ns: time that we last finished a transfer, or 0 if there
  *	if no record
+ * @end_of_msg_delay: used to set the delay_usecs on the spi_transfer that
+ *      is sent when we want to turn off CS at the end of a transaction.
  */
 struct cros_ec_spi {
 	struct spi_device *spi;
 	s64 last_transfer_ns;
+	unsigned int end_of_msg_delay;
 };
 
 static void debug_packet(struct device *dev, const char *name, u8 *ptr,
@@ -238,6 +242,17 @@ static int cros_ec_command_spi_xfer(struct cros_ec_device *ec_dev,
 
 	/* turn off CS */
 	spi_message_init(&msg);
+
+	if (ec_spi->end_of_msg_delay) {
+		/*
+		 * Add delay for last transaction, to ensure the rising edge
+		 * doesn't come too soon after the end of the data.
+		 */
+		memset(&trans, 0, sizeof(trans));
+		trans.delay_usecs = ec_spi->end_of_msg_delay;
+		spi_message_add_tail(&trans, &msg);
+	}
+
 	final_ret = spi_sync(ec_spi->spi, &msg);
 	ktime_get_ts(&ts);
 	ec_spi->last_transfer_ns = timespec_to_ns(&ts);
@@ -284,6 +299,17 @@ static int cros_ec_command_spi_xfer(struct cros_ec_device *ec_dev,
 	return 0;
 }
 
+static void cros_ec_spi_dt_probe(struct cros_ec_spi *ec_spi, struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	u32 val;
+	int ret;
+
+	ret = of_property_read_u32(np, "google,cros-ec-spi-msg-delay", &val);
+	if (!ret)
+		ec_spi->end_of_msg_delay = val;
+}
+
 static int cros_ec_spi_probe(struct spi_device *spi)
 {
 	struct device *dev = &spi->dev;
@@ -305,6 +331,9 @@ static int cros_ec_spi_probe(struct spi_device *spi)
 	if (!ec_dev)
 		return -ENOMEM;
 
+	/* Check for any DT properties */
+	cros_ec_spi_dt_probe(ec_spi, dev);
+
 	spi_set_drvdata(spi, ec_dev);
 	ec_dev->name = "SPI";
 	ec_dev->dev = dev;
-- 
1.8.4.2

