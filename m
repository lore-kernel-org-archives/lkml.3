Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193AbaGKNvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:51:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:56209 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbaGKNow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:44:52 -0400
Message-Id: <20140711133708.263040802@linutronix.de>
User-Agent: quilt/0.63-1
Date: Fri, 11 Jul 2014 13:44:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [patch 35/55] mfd: cros_ec_spi: Use ktime_get_ns()
References: <20140711133623.530368377@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=mfd-cros-ec-spi-remove-silly-timestamp-dance.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the ever recurring:
	ts = ktime_get_ts();
	ns = timespec_to_ns(&ts);
with
	ns = ktime_get_ns();

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/cros_ec_spi.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: tip/drivers/mfd/cros_ec_spi.c
===================================================================
--- tip.orig/drivers/mfd/cros_ec_spi.c
+++ tip/drivers/mfd/cros_ec_spi.c
@@ -225,7 +225,6 @@ static int cros_ec_command_spi_xfer(stru
 	u8 *ptr;
 	int sum;
 	int ret = 0, final_ret;
-	struct timespec ts;
 
 	/*
 	 * We have the shared ec_dev buffer plus we do lots of separate spi_sync
@@ -242,8 +241,7 @@ static int cros_ec_command_spi_xfer(stru
 		struct timespec ts;
 		unsigned long delay;	/* The delay completed so far */
 
-		ktime_get_ts(&ts);
-		delay = timespec_to_ns(&ts) - ec_spi->last_transfer_ns;
+		delay = ktime_get_ns() - ec_spi->last_transfer_ns;
 		if (delay < EC_SPI_RECOVERY_TIME_NS)
 			ndelay(EC_SPI_RECOVERY_TIME_NS - delay);
 	}
@@ -280,8 +278,7 @@ static int cros_ec_command_spi_xfer(stru
 	}
 
 	final_ret = spi_sync(ec_spi->spi, &msg);
-	ktime_get_ts(&ts);
-	ec_spi->last_transfer_ns = timespec_to_ns(&ts);
+	ec_spi->last_transfer_ns = ktime_get_ns();
 	if (!ret)
 		ret = final_ret;
 	if (ret < 0) {


