Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbaG3Upg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 16:45:36 -0400
Received: from outrelay06.libero.it ([212.52.84.110]:55653 "EHLO
	outrelay06.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaG3Upf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 16:45:35 -0400
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A0C0203.53D95969.00B3,ss=1,re=0.000,fgs=0
X-libjamoibt: 1823
Message-ID: <53D95AB1.70300@inwind.it>
Date: Wed, 30 Jul 2014 22:50:57 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] therm_windtunnel doesn't work properly on PowerMac G4
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the "log_temp" and "verbose" module parameters.
    
log_temp    enable/disable the temperature logging
verbose     enable/disable the fan tune logging

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

---
 drivers/macintosh/therm_windtunnel.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
index fbe4516..7efba5d 100644
--- a/drivers/macintosh/therm_windtunnel.c
+++ b/drivers/macintosh/therm_windtunnel.c
@@ -44,7 +44,13 @@
 #include <asm/sections.h>
 #include <asm/macio.h>
 
-#define LOG_TEMP		0			/* continuously log temperature */
+static bool log_temp = 0;
+module_param(log_temp, bool, 0644);
+MODULE_PARM_DESC(log_temp, "Enable the temperature logging");
+
+static bool verbose = 1;
+module_param(verbose, bool, 0644);
+MODULE_PARM_DESC(verbose, "Enable the fan speed logging");
 
 static struct {
 	volatile int		running;
@@ -157,11 +163,12 @@ tune_fan( int fan_setting )
 	/* write_reg( x.fan, 0x24, val, 1 ); */
 	write_reg( x.fan, 0x25, val, 1 );
 	write_reg( x.fan, 0x20, 0, 1 );
-	print_temp("CPU-temp: ", x.temp );
-	if( x.casetemp )
+	if (verbose) {
+		print_temp("CPU-temp: ", x.temp );
 		print_temp(", Case: ", x.casetemp );
-	printk(",  Fan: %d (tuned %+d)\n", 11-fan_setting, x.fan_level-fan_setting );
-
+		printk(",  Fan: %d (tuned %+d)\n",
+			11-fan_setting, x.fan_level-fan_setting );
+	}
 	x.fan_level = fan_setting;
 }
 
@@ -179,7 +186,7 @@ poll_temp( void )
 	casetemp = read_reg(x.fan, 0x0b, 1) << 8;
 	casetemp |= (read_reg(x.fan, 0x06, 1) & 0x7) << 5;
 
-	if( LOG_TEMP && x.temp != temp ) {
+	if( log_temp && x.temp != temp ) {
 		print_temp("CPU-temp: ", temp );
 		print_temp(", Case: ", casetemp );
 		printk(",  Fan: %d\n", 11-x.fan_level );
