Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab3DAARd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 20:17:33 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49028 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756030Ab3DAARb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 20:17:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Jean Delvare <khali@linux-fr.org>
Subject: [PATCH] ACPI / I2C: Use parent's ACPI_HANDLE() in acpi_i2c_register_devices()
Date: Mon, 01 Apr 2013 02:25:03 +0200
Message-ID: <2966020.zlpeyGGUDW@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The ACPI handle of struct i2c_adapter's dev member should not be
set, because this causes that struct i2c_adapter to be associated
with the ACPI device node corresponding to its parent as the
second "physical_device", which is incorrect (this happens during
the registration of struct i2c_adapter).  Consequently,
acpi_i2c_register_devices() should use the ACPI handle of the
parent of the struct i2c_adapter it is called for rather than the
struct i2c_adapter's ACPI handle (which should be NULL).

Make that happen and modify the i2c-designware-platdrv driver,
which currently is the only driver for ACPI-enumerated I2C
controller chips, not to set the ACPI handle for the
struct i2c_adapter it creates.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/acpi_i2c.c                     |    2 +-
 drivers/i2c/busses/i2c-designware-platdrv.c |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

Index: linux-pm/drivers/acpi/acpi_i2c.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_i2c.c
+++ linux-pm/drivers/acpi/acpi_i2c.c
@@ -90,7 +90,7 @@ void acpi_i2c_register_devices(struct i2
 	acpi_handle handle;
 	acpi_status status;
 
-	handle = ACPI_HANDLE(&adapter->dev);
+	handle = ACPI_HANDLE(adapter->dev.parent);
 	if (!handle)
 		return;
 
Index: linux-pm/drivers/i2c/busses/i2c-designware-platdrv.c
===================================================================
--- linux-pm.orig/drivers/i2c/busses/i2c-designware-platdrv.c
+++ linux-pm/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -182,7 +182,6 @@ static int dw_i2c_probe(struct platform_
 	adap->algo = &i2c_dw_algo;
 	adap->dev.parent = &pdev->dev;
 	adap->dev.of_node = pdev->dev.of_node;
-	ACPI_HANDLE_SET(&adap->dev, ACPI_HANDLE(&pdev->dev));
 
 	r = i2c_add_numbered_adapter(adap);
 	if (r) {

