Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbaKKNZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:25:28 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:65410 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbaKKNZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:25:25 -0500
Message-ID: <54620E59.10709@gmail.com>
Date: Tue, 11 Nov 2014 14:25:45 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: LKML <linux-kernel@vger.kernel.org>, Jean Delvare <jdelvare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [RESEND][PATCH 3/5] Add the "verbose" module option.
References: <1407567003-18332-1-git-send-email-kreijack@inwind.it>
In-Reply-To: <1407567003-18332-1-git-send-email-kreijack@inwind.it>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a "verbose" option to control the message in the kernel log
verbose = 0   no message
verbose = 1   log only the fan speed changes
verbose = 2   log the fan speed changes and the temperature changes

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 drivers/macintosh/therm_windtunnel.c | 38 +++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
index 1e50455..68f1067 100644
--- a/drivers/macintosh/therm_windtunnel.c
+++ b/drivers/macintosh/therm_windtunnel.c
@@ -44,7 +44,9 @@
 #include <asm/sections.h>
 #include <asm/macio.h>
 
-#define LOG_TEMP		0			/* continuously log temperature */
+static int verbose = 1;
+module_param(verbose, int, 0644);
+MODULE_PARM_DESC(verbose, "Verbosity level: 0=silent, 1=log the fan tuning, 2=log the temperature");
 
 static struct {
 	volatile int		running;
@@ -157,10 +159,6 @@ tune_fan( int fan_setting )
 	/* write_reg( x.fan, 0x24, val, 1 ); */
 	write_reg( x.fan, 0x25, val, 1 );
 	write_reg( x.fan, 0x20, 0, 1 );
-	print_temp("CPU-temp: ", x.temp );
-	if( x.casetemp )
-		print_temp(", Case: ", x.casetemp );
-	printk(",  Fan: %d (tuned %+d)\n", 11-fan_setting, x.fan_level-fan_setting );
 
 	x.fan_level = fan_setting;
 }
@@ -168,7 +166,7 @@ tune_fan( int fan_setting )
 static void
 poll_temp( void )
 {
-	int temp, i, level, casetemp;
+	int temp, i, level, casetemp, tempchanged;
 
 	temp = read_reg( x.thermostat, 0, 2 );
 
@@ -179,14 +177,6 @@ poll_temp( void )
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
@@ -200,6 +190,26 @@ poll_temp( void )
 		level = fan_table[i].fan_up_setting;
 	x.upind = i;
 
+	/*
+	 * if verbose >=1 log each fan tuning
+	 * if verbose >=2 log each cpu temperature change
+	 */
+	tempchanged = x.temp != temp || x.casetemp != casetemp;
+	if ((verbose > 1 && tempchanged) ||
+	    (verbose > 0 && level >= 0)) {
+		print_temp(KERN_INFO "CPU-temp: ", temp);
+		if (casetemp)
+			print_temp(", Case: ", casetemp);
+		if (level >= 0)
+			printk(", Fan: %d (tuned %+d)\n", 11-level,
+				x.fan_level-level);
+		else
+			printk(", Fan: %d\n", 11-x.fan_level);
+	}
+
+	x.temp = temp;
+	x.casetemp = casetemp;
+
 	if( level >= 0 )
 		tune_fan( level );
 }
-- 
2.1.0.rc1


