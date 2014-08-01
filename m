Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbaHAOBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:01:15 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:62885 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbaHAOBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:01:12 -0400
From: Goffredo Baroncelli <kreijack@gmail.com>
X-Google-Original-From: Goffredo Baroncelli <kreijack@inwind.it>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "\"" <jdelvare@suse.de>, "\"" <linux-kernel@vger.kernel.org>,
        "\"" <bryan@whatroute.net>, Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 3/4] Add the "verbose" module option.
Date: Fri,  1 Aug 2014 14:00:49 +0000
Message-Id: <1406901650-20841-4-git-send-email-kreijack@inwind.it>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406901650-20841-1-git-send-email-kreijack@inwind.it>
References: <1406901650-20841-1-git-send-email-kreijack@inwind.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "verbose" option controls the message in the kernel log
verbose = 0   no message
verbose = 1   log only the fan speed changes
verbose = 2   log the fan speed changes and the temperature changes

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 drivers/macintosh/therm_windtunnel.c | 37 +++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
index 1e50455..0c4eb85 100644
--- a/drivers/macintosh/therm_windtunnel.c
+++ b/drivers/macintosh/therm_windtunnel.c
@@ -44,7 +44,11 @@
 #include <asm/sections.h>
 #include <asm/macio.h>
 
-#define LOG_TEMP		0			/* continuously log temperature */
+static int verbose = 1;	  /* see description below */
+module_param(verbose, int, 0644);
+MODULE_PARM_DESC(verbose, "Vebosity level: 0=silent, "
+				"1=log the fan tuning, "
+				"2=log the temperature.");
 
 static struct {
 	volatile int		running;
@@ -157,10 +161,6 @@ tune_fan( int fan_setting )
 	/* write_reg( x.fan, 0x24, val, 1 ); */
 	write_reg( x.fan, 0x25, val, 1 );
 	write_reg( x.fan, 0x20, 0, 1 );
-	print_temp("CPU-temp: ", x.temp );
-	if( x.casetemp )
-		print_temp(", Case: ", x.casetemp );
-	printk(",  Fan: %d (tuned %+d)\n", 11-fan_setting, x.fan_level-fan_setting );
 
 	x.fan_level = fan_setting;
 }
@@ -179,14 +179,6 @@ poll_temp( void )
 	casetemp = read_reg(x.fan, 0x0b, 1) << 8;
 	casetemp |= (read_reg(x.fan, 0x06, 1) & 0x7) << 5;
 
-	if( LOG_TEMP && x.temp != temp ) {
-		print_temp("CPU-temp: ", temp );
-		print_temp(", Case: ", casetemp );
-		printk(",  Fan: %d\n", 11-x.fan_level );
-	}
-	x.temp = temp;
-	x.casetemp = casetemp;
-
 	level = -1;
 	for( i=0; (temp & 0xffff) > fan_table[i].temp ; i++ )
 		;
@@ -200,6 +192,25 @@ poll_temp( void )
 		level = fan_table[i].fan_up_setting;
 	x.upind = i;
 
+	/*
+	 * if verbose >0 log each fan tuning
+	 * if verbose >1 log each cpu temperature change
+	 */
+	if ((verbose > 1 && x.temp != temp ) ||
+	    (verbose > 0 && level >= 0)) {
+		print_temp("CPU-temp: ", temp );
+		if (casetemp)
+			print_temp(", Case: ", casetemp );
+		if (level >= 0)
+			printk(", Fan: %d (tuned %+d)\n", 11-level,
+				x.fan_level-level );
+		else
+			printk(", Fan: %d (tuned +0)\n",x.fan_level);
+	}
+
+	x.temp = temp;
+	x.casetemp = casetemp;
+
 	if( level >= 0 )
 		tune_fan( level );
 }
-- 
2.0.1

