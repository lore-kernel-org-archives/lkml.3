Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab3DAANg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 20:13:36 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49019 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188Ab3DAANf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 20:13:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        grant.likely@secretlab.ca, broonie@opensource.wolfsonmicro.com
Subject: [PATCH] ACPI / SPI: Use parent's ACPI_HANDLE() in acpi_register_spi_devices()
Date: Mon, 01 Apr 2013 02:21:08 +0200
Message-ID: <2747891.0orCNBJG8v@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The ACPI handle of struct spi_master's dev member should not be
set, because this causes that struct spi_master to be associated
with the ACPI device node corresponding to its parent as the
second "physical_device", which is incorrect (this happens during
the registration of struct spi_master).  Consequently,
acpi_register_spi_devices() should use the ACPI handle of the
parent of the struct spi_master it is called for rather than that
struct spi_master's ACPI handle (which should be NULL).

Make that happen and modify the spi-pxa2xx driver, which currently is
the only driver for ACPI-enumerated SPI controller chips, not to set
the ACPI handle for the struct spi_master it creates.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/spi/spi-pxa2xx.c |    1 -
 drivers/spi/spi.c        |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

Index: linux-pm/drivers/spi/spi.c
===================================================================
--- linux-pm.orig/drivers/spi/spi.c
+++ linux-pm/drivers/spi/spi.c
@@ -984,7 +984,7 @@ static void acpi_register_spi_devices(st
 	acpi_status status;
 	acpi_handle handle;
 
-	handle = ACPI_HANDLE(&master->dev);
+	handle = ACPI_HANDLE(master->dev.parent);
 	if (!handle)
 		return;
 
Index: linux-pm/drivers/spi/spi-pxa2xx.c
===================================================================
--- linux-pm.orig/drivers/spi/spi-pxa2xx.c
+++ linux-pm/drivers/spi/spi-pxa2xx.c
@@ -1168,7 +1168,6 @@ static int pxa2xx_spi_probe(struct platf
 
 	master->dev.parent = &pdev->dev;
 	master->dev.of_node = pdev->dev.of_node;
-	ACPI_HANDLE_SET(&master->dev, ACPI_HANDLE(&pdev->dev));
 	/* the spi->mode bits understood by this driver: */
 	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LOOP;
 

