Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459Ab3IBMi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 08:38:59 -0400
Received: from mout.gmx.net ([212.227.17.22]:49703 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756348Ab3IBMi5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 08:38:57 -0400
MIME-Version: 1.0
Message-ID: <trinity-fee99cd2-c238-496b-97c5-988038f82beb-1378125536617@3capp-gmx-bs38>
From: "Super Eichtig" <dbextern@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: tsc2007 driver, read data abort after i2c timeout
Content-Type: text/plain; charset=UTF-8
Date: Mon, 2 Sep 2013 14:38:56 +0200 (CEST)
Importance: normal
Sensitivity: Normal
Content-Transfer-Encoding: 8BIT
X-Priority: 3
X-Provags-ID: V03:K0:mvo3vEgkhPdx2FOvx8sLWeWuxDut3tZK3dTfPYscgjV
 Upo3paqiB5hI9DZ/BMpWuLbjWSgvdM3d1WFuHzhXOVAWR7/p/y
 RtWCBVsg8I7iSyJuQnThDn3vtJJaxN/KsVUqpSFtmmeMMafCNC
 4YEA3118VRayRndxuziSMEHUBFHc4MTv3BM4H095YT77zUaAi2
 go2PJuXorx7bqVxz7f01juEmdHqwFynJ4V54RgbtVlQgu4DkYJ
 H7UHuGEGZayycFHeLjbjLZ0H6+OZOI7Vxxu8xTNzz2RsQnHPEE WceG6c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!
 
In the last few weeks I worked on a problem I had with I2C errors and the effect they had on the touchscreen performance with a TI TSC2007 IC.
For I'm stuck with an old kernel (2.6.28) i used the tsc2003 driver, but the code seems to be close to the tsc2007.c .
 
I came across the funktion "tsc2003_read_values" where 5 I2C transfers are executed after a PenIRQ event (read x,y,z1,z2 and power down).
In this function the return values of the tsc2007_xfer function are ignored. So there will always be 5 tries to access the bus.
In the I2C driver there is a timeout for failed transfers of 5 second. This leads to an overall time for the above function of 25s in case of an error on the i2c bus.
 
In my case it helped a lot to abort the read_values function after an error return value from the _xfer function.
 
I obviously don't know all the details of the tsc code. To this day I don't understand how the transfer recovers and reacts to the next penirq when the first transfer is interrupted and so the tsc-chip is never returned to the "power down and listen to the penirq" state. Maybe there are good reasons not to interrupt the function.
Can you comment on this change? Is it a grave mistake or could this work. It does right now but not understanding all implications means it probably bites me in the ass at one point.
 
Attached you'll find a patch for the tsc2003.c file.
 
Best regards
Sebastian
 
 
diff --git a/drivers/input/touchscreen/tsc2003.c b/drivers/input/touchscreen/tsc2003.c
index 4f3a2c9..7ad62f2 100644
--- a/drivers/input/touchscreen/tsc2003.c
+++ b/drivers/input/touchscreen/tsc2003.c
@@ -115,15 +115,31 @@ static inline int tsc2003_xfer(struct tsc2003 *tsc, u8 cmd)
 
 static void tsc2003_read_values(struct tsc2003 *tsc, struct ts_event *tc)
 {
+    s32 temp;
+
+    tc->y = 0;
+    tc->x = 0;
+    tc->z1 = 0;
+    tc->z2 = 0;
+
     /* y- still on; turn on only y+ (and ADC) */
-    tc->y = tsc2003_xfer(tsc, READ_Y);
+    temp = tsc2003_xfer(tsc, READ_Y);
+    if (temp > 0) tc->y = temp;
+    else return;
 
     /* turn y- off, x+ on, then leave in lowpower */
-    tc->x = tsc2003_xfer(tsc, READ_X);
+    temp = tsc2003_xfer(tsc, READ_X);
+    if (temp > 0) tc->x = temp;
+    else return;
 
     /* turn y+ off, x- on; we'll use formula #1 */
-    tc->z1 = tsc2003_xfer(tsc, READ_Z1);
-    tc->z2 = tsc2003_xfer(tsc, READ_Z2);
+    temp = tsc2003_xfer(tsc, READ_Z1);
+    if (temp > 0) tc->z1 = temp;
+    else return;
+
+    temp = tsc2003_xfer(tsc, READ_Z2);
+    if (temp > 0) tc->z2 = temp;
+    else return;
 
     /* Prepare for next touch reading - power down ADC, enable PENIRQ */
     tsc2003_xfer(tsc, PWRDOWN);
 
 
