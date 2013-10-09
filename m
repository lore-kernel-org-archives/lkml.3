Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab3JII1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 04:27:39 -0400
Received: from mta.proceranetworks.com ([194.153.91.40]:44470 "EHLO
	mta.proceranetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab3JII1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 04:27:36 -0400
Date: Wed, 9 Oct 2013 10:29:39 +0200
From: Henrik Rydberg <rydberg@euromail.se>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Chris Murphy <bugzilla@colorremedies.com>,
        Josh Boyer <jwboyer@fedoraproject.org>, khali@linux-fr.org,
        lm-sensors@lm-sensors.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: applesmc oops in 3.10/3.11
Message-ID: <20131009082939.GA13963@polaris.bitmath.org>
References: <20131002095339.GA2716@polaris.bitmath.org>
 <524C1FE1.4050207@roeck-us.net>
 <20131002163418.GA4557@polaris.bitmath.org>
 <20131002164718.GA7392@roeck-us.net>
 <20131002172410.GA381@polaris.bitmath.org>
 <525346D3.30500@roeck-us.net>
 <6918F624-B267-4DB5-95A2-7E09448CA3E4@colorremedies.com>
 <20131008154809.GB18402@roeck-us.net>
 <20131008162917.GA7773@polaris.bitmath.org>
 <20131008162905.GA20665@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008162905.GA20665@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

> > I want to make one more test tomorrow, then I'll send a proper patch. Thanks!
> > 
> Ok, great.

And here it is, with compiler warning fixed.

Thanks everybody,
Henrik

>From 18fa0f55b764ad0fe5fc49f81bae281e5110ed56 Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Wed, 2 Oct 2013 19:15:03 +0200
Subject: [PATCH] hwmon: (applesmc) Always read until end of data

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
---
 drivers/hwmon/applesmc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 98814d1..3288f13 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -230,6 +230,7 @@ static int send_argument(const char *key)
 
 static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
 {
+	u8 status, data = 0;
 	int i;
 
 	if (send_command(cmd) || send_argument(key)) {
@@ -237,6 +238,7 @@ static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
 		return -EIO;
 	}
 
+	/* This has no effect on newer (2012) SMCs */
 	if (send_byte(len, APPLESMC_DATA_PORT)) {
 		pr_warn("%.4s: read len fail\n", key);
 		return -EIO;
@@ -250,6 +252,17 @@ static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
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
1.8.3.4

