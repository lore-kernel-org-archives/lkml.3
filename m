Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab3JBRWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:22:36 -0400
Received: from smtprelay-h31.telenor.se ([213.150.131.4]:54677 "EHLO
	smtprelay-h31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab3JBRWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:22:35 -0400
X-SENDER-IP: [85.230.168.69]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmZlAMxVTFJV5qhFPGdsb2JhbABZgweIbbk4gRcXAwEBAQE4NYIlAQEFOhwTAQ8QCAMOAwMBAgEJJQ8FJQoMDhOICr01Fo1ngVQHBoMZgQQDmACGSY5dOg
X-IronPort-AV: E=Sophos;i="4.90,1019,1371074400"; 
   d="scan'208";a="626646656"
Date: Wed, 2 Oct 2013 19:24:10 +0200
From: Henrik Rydberg <rydberg@euromail.se>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Chris Murphy <bugzilla@colorremedies.com>,
        Josh Boyer <jwboyer@fedoraproject.org>, khali@linux-fr.org,
        lm-sensors@lm-sensors.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: applesmc oops in 3.10/3.11
Message-ID: <20131002172410.GA381@polaris.bitmath.org>
References: <20130927175926.GA6267@roeck-us.net>
 <B6E9FB4C-665C-454E-9DEB-B95B85C1D0E0@colorremedies.com>
 <524615B1.6000106@roeck-us.net>
 <4FFB3671-DDB4-40F7-BA5D-C9AA9391BDA9@colorremedies.com>
 <524A4384.4040403@roeck-us.net>
 <20131002035156.GA566@roeck-us.net>
 <20131002095339.GA2716@polaris.bitmath.org>
 <524C1FE1.4050207@roeck-us.net>
 <20131002163418.GA4557@polaris.bitmath.org>
 <20131002164718.GA7392@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002164718.GA7392@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 09:47:18AM -0700, Guenter Roeck wrote:
> On Wed, Oct 02, 2013 at 06:34:18PM +0200, Henrik Rydberg wrote:
> > > >>One thing I have seen in all logs is the earlier "send_byte fail" message, so
> > > >>I think that is a pre-requisite.
> > > >
> > > >Not necessarily - it could be that the patch actually fixes the root
> > > >cause. One possible scenario is that on recent SMCs, some of the
> > > >commands produce more data than we actually read. This would
> > > >eventually lead to both data corruption and overflow somwhere in the
> > > >SMC internals.  If the original SMC error is interpreted as a read
> > > >buffer overflow, then that problem should be fixed with this patch.
> > > >
> > > 
> > > Good point.
> > > 
> > > But shouldn't we at least get the "flushed %d bytes" warning message in this case ?
> > 
> > The explanation I have there is that the (newer) SMC needs the
> > application to read the 'no more bytes' or it will get confused. It
> > makes sense, if the number of bytes to read is no longer specified.
> > 
> You mean that just reading from APPLESMC_CMD_PORT would solve the problem ?
> That might make sense.

It also points at the possibility of a smaller patch to test, but I
have not had the time to check this very deeply myself:

Thanks,
Henrik

>From 4451da32414080bd0563ee9e061f19bf90463cc5 Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Wed, 2 Oct 2013 19:15:03 +0200
Subject: [PATCH] applesmc remedy take 2

Conjectured problem: there are remnant bytes ready on the data line
which corrupts the read after a failure.

Remedy: assuming bit0 is the read valid line, try to flush it before
starting a new command.

Tests by Chris suggests reading the status is enough for the problem
to go away, which is consistent with a change in the SMC interface,
where the number of bytes to read is no longer specified, but found
out by reading until end of data.

Tested on a MacBookAir3,1, but the original problem has not been
reproduced.
---
 drivers/hwmon/applesmc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 98814d1..c0ff350 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -230,6 +230,7 @@ static int send_argument(const char *key)
 
 static int read_smc(u8 cmd, const char *key, u8 *buffer, u8 len)
 {
+	u8 status, data;
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

