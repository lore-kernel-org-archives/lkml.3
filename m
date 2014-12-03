Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaLCH1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:27:50 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:56093 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaLCH1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:27:49 -0500
From: Rob Ward <robert.ward114@googlemail.com>
X-Google-Original-From: Rob Ward <rob@rob-thinkpad>
Date: Wed, 3 Dec 2014 07:27:36 +0000 (GMT)
To: joern@lazybastard.org, dwmw2@infradead.org, computersforpeace@gmail.com
cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: [PATCH V3] mtd: phram: Allow multiple phram devices on cmd
 line
In-Reply-To: <alpine.DEB.2.10.1411091618160.7838@rob-thinkpad>
Message-ID: <alpine.DEB.2.10.1412030722110.7838@rob-thinkpad>
References: <alpine.DEB.2.10.1410211859030.7838@rob-thinkpad> <alpine.DEB.2.10.1411091618160.7838@rob-thinkpad>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 900dbad52b2cc88b46c5716b1afd22698f6d83aa Mon Sep 17 00:00:00 2001
From: Rob Ward <robert.ward114@googlemail.com>
Date: Tue, 21 Oct 2014 17:46:53 +0100
Subject: [PATCH] mtd: phram: Allow multiple phram devices on cmd line

Allow the phram module the ability to create multiple phram mtd
devices via the kernel command line.

Currently the phram module only allows a single mtd device to be
created via the kernel command line. This is due to the phram
module having to store the values until it is initialised
later. This storage is done using a single char[] meaning when
the module_param_call is made the previous value is overidden.

This change modifies the phram system to use a char[][] allowing
multiple devices to be created.

The array size if controlled using the new config option
CONFIG_MTD_PHRAM_MAX_CMDLINE_ARGS that allows the maximum
number of devices to be specified. Currently this option
defaults to a value of 1 leaving the behaviour unchanged.

If the array is full a message is printed to the console and the
module_param_call returns.

To test, in all cases an area of memory needs to be reserved via
the command line e.g. memmap=10M$114M

To test with phram build into the kernel on the command line add
the following:

phram.phram=alpha,114Mi,1Mi phram.phram=beta,115Mi,1Mi

If CONFIG_MTD_PHRAM_MAX_CMDLINE_ARGS is left as default i.e. 1
then the first device, alpha will be created only. If the value of
CONFIG_MTD_PHRAM_MAX_CMDLINE_ARGS is increased to 2 or more then
both alpha and beta will be created.

To test phram built as a module insmod with the following arguments:

phram=gamma,114Mi,1Mi phram=delta,115Mi,1Mi

In this case two devices should be created.

Signed-off-by: Rob Ward <robert.ward114@googlemail.com>
---
 drivers/mtd/devices/Kconfig | 12 ++++++++++++
 drivers/mtd/devices/phram.c | 39 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
index c49d0b1..5fdc80b 100644
--- a/drivers/mtd/devices/Kconfig
+++ b/drivers/mtd/devices/Kconfig
@@ -136,6 +136,18 @@ config MTD_PHRAM
 	  doesn't have access to, memory beyond the mem=xxx limit, nvram,
 	  memory on the video card, etc...
 
+config MTD_PHRAM_MAX_CMDLINE_ARGS
+	int "Max number of devices via Kernel command line"
+	depends on MTD_PHRAM=y
+	default 1
+	help
+	  Specify the number of phram devices that can be initialised
+	  using the Kernel command line.
+
+	  This option is only applicable when phram is built into the
+	  Kernel. When built as a module many devices can be specified
+	  at module insmod.
+
 config MTD_LART
 	tristate "28F160xx flash driver for LART"
 	depends on SA1100_LART
diff --git a/drivers/mtd/devices/phram.c b/drivers/mtd/devices/phram.c
index effd9a4..b42678e 100644
--- a/drivers/mtd/devices/phram.c
+++ b/drivers/mtd/devices/phram.c
@@ -212,9 +212,13 @@ static int phram_init_called;
  * - phram.phram=<device>,<address>,<size> for built-in case
  * We leave 64 bytes for the device name, 20 for the address and 20 for the
  * size.
+ *
+ * The maximum number of devices supported is controlled by the
+ * MTD_PHRAM_MAX_CMDLINE_ARGS config option
+ *
  * Example: phram.phram=rootfs,0xa0000000,512Mi
  */
-static char phram_paramline[64 + 20 + 20];
+static char phram_paramline[CONFIG_MTD_PHRAM_MAX_CMDLINE_ARGS][64 + 20 + 20];
 #endif
 
 static int phram_setup(const char *val)
@@ -271,6 +275,8 @@ static int phram_param_call(const char *val, struct kernel_param *kp)
 #ifdef MODULE
 	return phram_setup(val);
 #else
+	int i;
+
 	/*
 	 * If more parameters are later passed in via
 	 * /sys/module/phram/parameters/phram
@@ -290,9 +296,25 @@ static int phram_param_call(const char *val, struct kernel_param *kp)
 	 * phram_setup().
 	 */
 
-	if (strlen(val) >= sizeof(phram_paramline))
+	if (strlen(val) >= sizeof(phram_paramline[0]))
 		return -ENOSPC;
-	strcpy(phram_paramline, val);
+
+	/*
+	 * Check if any space is left in the array. If no space
+	 * is left then print warning and return 0
+	 */
+
+	if (phram_paramline[ARRAY_SIZE(phram_paramline) - 1][0]) {
+		pr_warn("exceeded limit via cmd_line - %s ignored", val);
+		return 0;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(phram_paramline); i++) {
+		if (!phram_paramline[i][0]) {
+			strcpy(phram_paramline[i], val);
+			break;
+		}
+	}
 
 	return 0;
 #endif
@@ -307,8 +329,15 @@ static int __init init_phram(void)
 	int ret = 0;
 
 #ifndef MODULE
-	if (phram_paramline[0])
-		ret = phram_setup(phram_paramline);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(phram_paramline); i++) {
+		if (phram_paramline[i][0]) {
+			ret = phram_setup(phram_paramline[i]);
+			if (ret)
+				break;
+		}
+	}
 	phram_init_called = 1;
 #endif
 
-- 
2.0.2

