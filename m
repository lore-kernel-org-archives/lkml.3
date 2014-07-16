Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbaGPVEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:04:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:59767 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaGPVEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:43 -0400
Message-Id: <20140716205055.231943815@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:41 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [patch V2 36/64] mfd: cros_ec_spi: Use ktime_get_ns()
References: <20140716205018.175419210@linutronix.de>
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
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/cros_ec_spi.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

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
@@ -239,11 +238,9 @@ static int cros_ec_command_spi_xfer(stru
 
 	/* If it's too soon to do another transaction, wait */
 	if (ec_spi->last_transfer_ns) {
-		struct timespec ts;
 		unsigned long delay;	/* The delay completed so far */
 
-		ktime_get_ts(&ts);
-		delay = timespec_to_ns(&ts) - ec_spi->last_transfer_ns;
+		delay = ktime_get_ns() - ec_spi->last_transfer_ns;
 		if (delay < EC_SPI_RECOVERY_TIME_NS)
 			ndelay(EC_SPI_RECOVERY_TIME_NS - delay);
 	}
@@ -280,8 +277,7 @@ static int cros_ec_command_spi_xfer(stru
 	}
 
 	final_ret = spi_sync(ec_spi->spi, &msg);
-	ktime_get_ts(&ts);
-	ec_spi->last_transfer_ns = timespec_to_ns(&ts);
+	ec_spi->last_transfer_ns = ktime_get_ns();
 	if (!ret)
 		ret = final_ret;
 	if (ret < 0) {


