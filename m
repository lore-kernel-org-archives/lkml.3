Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab3J1Osq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:48:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51032 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923Ab3J1Oso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:48:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Henrik Rydberg <rydberg@euromail.se>, Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 08/64] hwmon: (applesmc) Always read until end of data
Date: Mon, 28 Oct 2013 14:47:27 +0000
Message-Id: <1382971703-17393-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/applesmc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 0882b25..dbaf7f4 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -212,6 +212,7 @@ static int send_argument(const char *key)
 
 static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
 {
+	u8 status, data = 0;
 	int i;
 
 	if (send_command(cmd) || send_argument(key)) {
@@ -219,6 +220,7 @@ static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
 		return -EIO;
 	}
 
+	/* This has no effect on newer (2012) SMCs */
 	outb(len, APPLESMC_DATA_PORT);
 
 	for (i = 0; i < len; i++) {
@@ -229,6 +231,17 @@ static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
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
 
-- 
1.8.3.2

