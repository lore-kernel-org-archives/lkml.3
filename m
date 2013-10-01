Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab3JALBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 07:01:10 -0400
Received: from mta.proceranetworks.com ([194.153.91.40]:36059 "EHLO
	mta.proceranetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab3JALBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 07:01:08 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Oct 2013 07:01:07 EDT
Date: Tue, 1 Oct 2013 12:55:26 +0200
From: Henrik Rydberg <rydberg@euromail.se>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Chris Murphy <bugzilla@colorremedies.com>,
        Josh Boyer <jwboyer@fedoraproject.org>, khali@linux-fr.org,
        lm-sensors@lm-sensors.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: applesmc oops in 3.10/3.11
Message-ID: <20131001105526.GA481@polaris.bitmath.org>
References: <20130925220838.GB4184@roeck-us.net>
 <20130926063453.GA526@polaris.bitmath.org>
 <CA+5PVA76tjoR+GNaQps_zQmqz=V_GAcQaZLqKcx1ihgUMQBrQw@mail.gmail.com>
 <20130927171256.GA6391@roeck-us.net>
 <71D92187-2092-4975-A707-17452C48EF5A@colorremedies.com>
 <20130927175926.GA6267@roeck-us.net>
 <B6E9FB4C-665C-454E-9DEB-B95B85C1D0E0@colorremedies.com>
 <524615B1.6000106@roeck-us.net>
 <4FFB3671-DDB4-40F7-BA5D-C9AA9391BDA9@colorremedies.com>
 <524A4384.4040403@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524A4384.4040403@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >Warning message triggered with 3.12.0-0.rc3.git0.1.fc21.x86_64.
> >
> >[   10.886016] applesmc: key count changed from 261 to 1174405121
> >
> 
> Explains the crash, but the new key count is very wrong. 1174405121 = 0x46000001.
> Which I guess explains the subsequent memory allocation error in the log.
> 
> Henrik, any idea what might be going on ? Is it possible that the previous
> command failure leaves some state machine in a bad state ?

I seem to recall a report on another similar state problem on newer
machines, so maybe, yes. Older machines seem fine, I have never
encountered the problem myself. Here is a patch to test that
theory. It has been tested to be pretty harmless on two different
generations.

I really really do not want to add an 'if (value is insane)' check ;-)

Thanks,
Henrik

>From d48a9e4e6e45dcd9c7e7ad88df714b92772a62d6 Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Tue, 1 Oct 2013 12:16:09 +0200
Subject: [PATCH] applesmc remedy take 1

Conjectured problem: there are remnant bytes ready on the data line
which corrupts the read after a failure.

Remedy: assuming bit0 is the read valid line, try to flush it before
starting a new command.

Exception: the write-number-of-bytes-to-read command seems to differ
between models (it may not be needed on the newest), so do not try to
flush the data at that particular point.

Tested on a MacBookPro10,1 and a MacBookAir3,1, but the original problem
has not been reproduced, so the actual effect of this patch is unknown.
---
 drivers/hwmon/applesmc.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 98814d1..f6eaf6d1 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -186,10 +186,23 @@ static int wait_read(void)
  * send_byte - Write to SMC port, retrying when necessary. Callers
  * must hold applesmc_lock.
  */
-static int send_byte(u8 cmd, u16 port)
+static int send_byte(u8 cmd, u16 port, bool flush)
 {
-	u8 status;
-	int us;
+	u8 status, data;
+	int us, nskip;
+
+	if (flush) {
+		/* read the data port until bit0 is cleared */
+		for (nskip = 0; nskip < 16; nskip++) {
+			udelay(APPLESMC_MIN_WAIT);
+			status = inb(APPLESMC_CMD_PORT);
+			if (!(status & 0x01))
+				break;
+			data = inb(APPLESMC_DATA_PORT);
+		}
+		if (nskip)
+			pr_warn("flushed %d bytes\n", nskip);
+	}
 
 	outb(cmd, port);
 	for (us = APPLESMC_MIN_WAIT; us < APPLESMC_MAX_WAIT; us <<= 1) {
@@ -215,7 +228,7 @@ static int send_byte(u8 cmd, u16 port)
 
 static int send_command(u8 cmd)
 {
-	return send_byte(cmd, APPLESMC_CMD_PORT);
+	return send_byte(cmd, APPLESMC_CMD_PORT, true);
 }
 
 static int send_argument(const char *key)
@@ -223,7 +236,7 @@ static int send_argument(const char *key)
 	int i;
 
 	for (i = 0; i < 4; i++)
-		if (send_byte(key[i], APPLESMC_DATA_PORT))
+		if (send_byte(key[i], APPLESMC_DATA_PORT, true))
 			return -EIO;
 	return 0;
 }
@@ -237,7 +250,7 @@ static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
 		return -EIO;
 	}
 
-	if (send_byte(len, APPLESMC_DATA_PORT)) {
+	if (send_byte(len, APPLESMC_DATA_PORT, false)) {
 		pr_warn("%.4s: read len fail\n", key);
 		return -EIO;
 	}
@@ -262,13 +275,13 @@ static int write_smc(u8 cmd, const char *key, const u8 *buffer, u8 len)
 		return -EIO;
 	}
 
-	if (send_byte(len, APPLESMC_DATA_PORT)) {
+	if (send_byte(len, APPLESMC_DATA_PORT, true)) {
 		pr_warn("%.4s: write len fail\n", key);
 		return -EIO;
 	}
 
 	for (i = 0; i < len; i++) {
-		if (send_byte(buffer[i], APPLESMC_DATA_PORT)) {
+		if (send_byte(buffer[i], APPLESMC_DATA_PORT, true)) {
 			pr_warn("%s: write data fail\n", key);
 			return -EIO;
 		}
-- 
1.8.3.4

