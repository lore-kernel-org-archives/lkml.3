Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965366AbaDJDkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:40:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41308 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935114AbaDJDW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Murphy <chris@cmurf.com>, Henrik Rydberg <rydberg@euromail.se>,
        Guenter Roeck <linux@roeck-us.net>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 116/134] hwmon: (applesmc) Always read until end of data
Date: Wed,  9 Apr 2014 20:23:52 -0700
Message-Id: <20140410032314.172521676@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/applesmc.c |   13 +++++++++++++
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
 


