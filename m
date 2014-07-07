Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbaGGXzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:55:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbaGGXzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:55:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.10 27/53] hwmon: (ina2xx) Cast to s16 on shunt and current regs
Date: Mon,  7 Jul 2014 16:58:12 -0700
Message-Id: <20140707235830.110334901@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235829.281783607@linuxfoundation.org>
References: <20140707235829.281783607@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Baltieri <fabio.baltieri@gmail.com>

commit c0214f98943b1fe43f7be61b7782b0c8f0836f28 upstream.

All devices supported by ina2xx are bidirectional and report the
measured shunt voltage and power values as a signed 16 bit, but the
current driver implementation caches all registers as u16, leading
to an incorrect sign extension when reporting to userspace in
ina2xx_get_value().

This patch fixes the problem by casting the signed registers to s16.
Tested on an INA219.

Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/ina2xx.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -147,7 +147,8 @@ static int ina2xx_get_value(struct ina2x
 
 	switch (reg) {
 	case INA2XX_SHUNT_VOLTAGE:
-		val = DIV_ROUND_CLOSEST(data->regs[reg],
+		/* signed register */
+		val = DIV_ROUND_CLOSEST((s16)data->regs[reg],
 					data->config->shunt_div);
 		break;
 	case INA2XX_BUS_VOLTAGE:
@@ -159,8 +160,8 @@ static int ina2xx_get_value(struct ina2x
 		val = data->regs[reg] * data->config->power_lsb;
 		break;
 	case INA2XX_CURRENT:
-		/* LSB=1mA (selected). Is in mA */
-		val = data->regs[reg];
+		/* signed register, LSB=1mA (selected), in mA */
+		val = (s16)data->regs[reg];
 		break;
 	default:
 		/* programmer goofed */


