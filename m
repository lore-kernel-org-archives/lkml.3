Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaILTJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:09:10 -0400
Received: from mout.gmx.net ([212.227.15.19]:49603 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaILTJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:09:08 -0400
From: Peter Huewe <peterhuewe@gmx.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] [REGRESSION] i2c-acpi: Fix NULL Pointer dereference
Date: Fri, 12 Sep 2014 21:09:47 +0200
Message-Id: <1410548987-3558-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.5.5
X-Provags-ID: V03:K0:S63uDPEdyp39V/DkKbwbjenL6ZxyxUsvhuPHggxysb84eY42TuI
 2OjxvAH3ViI8sZIevD+ayMl5CwedNVsGj7XbWDFLqbQKdQ0lScVMroOJuNZuGU+2qpm7Ood
 FeI4vDJxhKk15azb8MkPrAveGuEmYf8qjZaZ5j0iGeVZ+5dzjJX5xOS/zGjk+WE2Ch8+eSV
 ADGCrmdH0USgRfsdezIIw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If adapter->dev.parent == NULL there is a NULL pointer dereference in
acpi_i2c_install_space_handler and acpi_i2c_remove_space_handler.

This is present since introduction of this code:
366047515c6e "i2c: rework kernel config I2C_ACPI" or even
da3c6647ee08 "I2C/ACPI: Clean up I2C ACPI code and Add CONFIG_I2C_ACPI"

The adapter->dev.parent == NULL case is valid for the i2c_stub,
so loading i2c_stub with ACPI_I2C_OPREGION enabled results in an oops.
This is also valid at least for i2c_tiny_usb and i2c_robotfuzz_osif.

Fix by checking whether it is null before calling ACPI_HANDLE.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/i2c/i2c-acpi.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/i2c-acpi.c b/drivers/i2c/i2c-acpi.c
index 0dbc18c..c456b17 100644
--- a/drivers/i2c/i2c-acpi.c
+++ b/drivers/i2c/i2c-acpi.c
@@ -308,10 +308,15 @@ acpi_i2c_space_handler(u32 function, acpi_physical_address command,
 
 int acpi_i2c_install_space_handler(struct i2c_adapter *adapter)
 {
-	acpi_handle handle = ACPI_HANDLE(adapter->dev.parent);
+	acpi_handle handle;
 	struct acpi_i2c_handler_data *data;
 	acpi_status status;
 
+	if (!adapter->dev.parent)
+		return -ENODEV;
+
+	handle = ACPI_HANDLE(adapter->dev.parent);
+
 	if (!handle)
 		return -ENODEV;
 
@@ -344,10 +349,15 @@ int acpi_i2c_install_space_handler(struct i2c_adapter *adapter)
 
 void acpi_i2c_remove_space_handler(struct i2c_adapter *adapter)
 {
-	acpi_handle handle = ACPI_HANDLE(adapter->dev.parent);
+	acpi_handle handle;
 	struct acpi_i2c_handler_data *data;
 	acpi_status status;
 
+	if (!adapter->dev.parent)
+		return;
+
+	handle = ACPI_HANDLE(adapter->dev.parent);
+
 	if (!handle)
 		return;
 
-- 
1.8.5.5

