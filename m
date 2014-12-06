Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaLFBqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 20:46:00 -0500
Received: from exprod5og118.obsmtp.com ([64.18.0.160]:58582 "HELO
	exprod5og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750862AbaLFBp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 20:45:58 -0500
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH] serial: 8250: add support for ACPI-probed serial port for X-Gene platform
Date: Fri,  5 Dec 2014 17:45:57 -0800
Message-Id: <1417830357-31560-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable APM X-Gene SoC serial port functionality when using ACPI table to
initialize serial port.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 drivers/tty/serial/8250/8250_dw.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index beea6ca..e8e6b20 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -310,10 +310,20 @@ static int dw8250_probe_of(struct uart_port *p,
 static int dw8250_probe_acpi(struct uart_8250_port *up,
 			     struct dw8250_data *data)
 {
+	const struct acpi_device_id *id;
 	struct uart_port *p = &up->port;
 
 	dw8250_setup_port(up);
 
+	id = acpi_match_device(p->dev->driver->acpi_match_table, p->dev);
+	if (!id)
+		return -ENODEV;
+
+	if (!p->uartclk)
+		if (device_property_read_u32(p->dev, "clock-frequency",
+					     &p->uartclk))
+			return -EINVAL;
+
 	p->iotype = UPIO_MEM32;
 	p->serial_in = dw8250_serial_in32;
 	p->serial_out = dw8250_serial_out32;
@@ -536,6 +546,7 @@ static const struct acpi_device_id dw8250_acpi_match[] = {
 	{ "INT3435", 0 },
 	{ "80860F0A", 0 },
 	{ "8086228A", 0 },
+	{ "APMC0D08", 0},
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, dw8250_acpi_match);
-- 
1.9.1

