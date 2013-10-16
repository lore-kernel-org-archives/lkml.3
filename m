Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934780Ab3JPRqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:46:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934104Ab3JPRqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Murphy <chris@cmurf.com>, Henrik Rydberg <rydberg@euromail.se>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 08/50] hwmon: (applesmc) Always read until end of data
Date: Wed, 16 Oct 2013 10:44:54 -0700
Message-Id: <20131016174359.395585069@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174358.335646140@linuxfoundation.org>
References: <20131016174358.335646140@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/applesmc.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -230,6 +230,7 @@ static int send_argument(const char *key
 
 static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
 {
+	u8 status, data = 0;
 	int i;
 
 	if (send_command(cmd) || send_argument(key)) {
@@ -237,6 +238,7 @@ static int read_smc(u8 cmd, const char *
 		return -EIO;
 	}
 
+	/* This has no effect on newer (2012) SMCs */
 	if (send_byte(len, APPLESMC_DATA_PORT)) {
 		pr_warn("%.4s: read len fail\n", key);
 		return -EIO;
@@ -250,6 +252,17 @@ static int read_smc(u8 cmd, const char *
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
 


