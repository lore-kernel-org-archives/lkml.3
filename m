Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab3KRKb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 05:31:29 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:53744 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3KRKbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 05:31:14 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rhyland Klein <rklein@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: [PATCH 1/3] mfd: cros ec: spi: Add delay for raising CS
Date: Mon, 18 Nov 2013 11:30:47 +0100
Message-Id: <1384770649-8593-1-git-send-email-treding@nvidia.com>
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
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 Documentation/devicetree/bindings/mfd/cros-ec.txt |  4 +++
 drivers/mfd/cros_ec_spi.c                         | 30 +++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/cros-ec.txt b/Documentation/devicetree/bindings/mfd/cros-ec.txt
index 5f229c5f6da9..fb3034a87ae0 100644
--- a/Documentation/devicetree/bindings/mfd/cros-ec.txt
+++ b/Documentation/devicetree/bindings/mfd/cros-ec.txt
@@ -17,6 +17,10 @@ Required properties (SPI):
 - compatible: "google,cros-ec-spi"
 - reg: SPI chip select
 
+Optional properties (SPI):
+- google,cros-ec-spi-msg-delay: This property is how long of a delay, in usecs,
+  to use on the last transfer of a message, to force time between transactions.
+
 Required properties (LPC):
 - compatible: "google,cros-ec-lpc"
 - reg: List of (IO address, size) pairs defining the interface uses
diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
index 367ccb58ecb1..d05349a7381e 100644
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
@@ -61,10 +62,13 @@
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
@@ -235,6 +239,17 @@ static int cros_ec_command_spi_xfer(struct cros_ec_device *ec_dev,
 
 	/* turn off CS */
 	spi_message_init(&msg);
+
+	if (ec_spi->end_of_msg_delay) {
+		/*
+		 * Add delay for last transaction, to ensure the rising edge
+		 * doesn't come too soon after the end of the data.
+		 */
+		memset(&trans, '\0', sizeof(trans));
+		trans.delay_usecs = ec_spi->end_of_msg_delay;
+		spi_message_add_tail(&trans, &msg);
+	}
+
 	final_ret = spi_sync(ec_spi->spi, &msg);
 	ktime_get_ts(&ts);
 	ec_spi->last_transfer_ns = timespec_to_ns(&ts);
@@ -281,6 +296,17 @@ static int cros_ec_command_spi_xfer(struct cros_ec_device *ec_dev,
 	return 0;
 }
 
+static void cros_ec_probe_spi_dt(struct cros_ec_spi *ec_spi, struct device *dev)
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
 static int cros_ec_probe_spi(struct spi_device *spi)
 {
 	struct device *dev = &spi->dev;
@@ -302,6 +328,10 @@ static int cros_ec_probe_spi(struct spi_device *spi)
 	if (!ec_dev)
 		return -ENOMEM;
 
+	/* Check for any DT properties */
+	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
+		cros_ec_probe_spi_dt(ec_spi, dev);
+
 	spi_set_drvdata(spi, ec_dev);
 	ec_dev->name = "SPI";
 	ec_dev->dev = dev;
-- 
1.8.4.2

