Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab3KYOLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:11:19 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59006 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754366Ab3KYNxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:45 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Guenter Roeck" <linux@roeck-us.net>,
        "Chris Murphy" <chris@cmurf.com>,
        "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.598097129@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 51/87] hwmon: (applesmc) Always read until end of data
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Henrik Rydberg <rydberg@euromail.se>

commit 25f2bd7f5add608c1d1405938f39c96927b275ca upstream.

The crash reported and investigated in commit 5f4513 turned out to be
caused by a change to the read interface on newer (2012) SMCs.

Tests by Chris show that simply reading the data valid line is enough
for the problem to go away. Additional tests show that the newer SMCs
no longer wait for the number of requested bytes, but start sending
data right away.  Apparently the number of bytes to read is no longer
specified as before, but instead found out by reading until end of
data. Failure to read until end of data confuses the state machine,
which eventually causes the crash.

As a remedy, assuming bit0 is the read valid line, make sure there is
nothing more to read before leaving the read function.

Tested to resolve the original problem, and runtested on MBA3,1,
MBP4,1, MBP8,2, MBP10,1, MBP10,2. The patch seems to have no effect on
machines before 2012.

Tested-by: Chris Murphy <chris@cmurf.com>
Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/applesmc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -212,6 +212,7 @@ static int send_argument(const char *key
 
 static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
 {
+	u8 status, data = 0;
 	int i;
 
 	if (send_command(cmd) || send_argument(key)) {
@@ -219,6 +220,7 @@ static int read_smc(u8 cmd, const char *
 		return -EIO;
 	}
 
+	/* This has no effect on newer (2012) SMCs */
 	outb(len, APPLESMC_DATA_PORT);
 
 	for (i = 0; i < len; i++) {
@@ -229,6 +231,17 @@ static int read_smc(u8 cmd, const char *
 		buffer[i] = inb(APPLESMC_DATA_PORT);
 	}
 
+	/* Read the data port until bit0 is cleared */
+	for (i = 0; i < 16; i++) {
+		udelay(APPLESMC_MIN_WAIT);
+		status = inb(APPLESMC_CMD_PORT);
+		if (!(status & 0x01))
+			break;
+		data = inb(APPLESMC_DATA_PORT);
+	}
+	if (i)
+		pr_warn("flushed %d bytes, last value is: %d\n", i, data);
+
 	return 0;
 }
 

