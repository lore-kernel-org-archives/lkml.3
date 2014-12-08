Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbaLHP1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:27:45 -0500
Received: from relay02.alfahosting-server.de ([109.237.142.238]:49904 "EHLO
	relay02.alfahosting-server.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752358AbaLHP1n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:27:43 -0500
X-Spam-DCC: : 
Date: Mon, 8 Dec 2014 16:28:10 +0100
From: Richard Leitner <dev@g0hl1n.net>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] misc: ioc4: simplify wave period measurement in
 clock_calibrate
Message-ID: <20141208162810.7b009382@frodo>
In-Reply-To: <CA+V-a8tww3bt7rhMT8Bxn0dwyg4qQTeVKbAKKJxh__zXrKrewA@mail.gmail.com>
References: <20141208132720.16356743@frodo>
	<4066664.BgJJnCmQ3h@wuerfel>
	<20141208141837.752a9968@frodo>
	<CA+V-a8tww3bt7rhMT8Bxn0dwyg4qQTeVKbAKKJxh__zXrKrewA@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Virus-Checker-Version: clamassassin 1.2.4 with ClamAV 0.97.3/19749/Mon Dec  8 12:41:14 2014
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The loop for measuring the square wave periods over some cycles is
refactored to be more easily readable. This includes avoiding a
"by-hand-implemented" for loop with a "real" one and adding some
comments.

Furthermore the following compiler warning is avoided by this patch:
drivers/misc/ioc4.c: In function ‘ioc4_probe’:
drivers/misc/ioc4.c:194:16: warning: ‘start’ may be used uninitialized
in this function [-Wmaybe-uninitialized]
  period = (end - start) /
                ^
drivers/misc/ioc4.c:148:11: note: ‘start’ was declared here
  uint64_t start, end, period;
           ^

Signed-off-by: Richard Leitner <dev@g0hl1n.net>
---
A simplification of this loop was suggested by Andrew Morton [1].
This is my first proposal of such a simplification.

Furthermore I'm not sure if the commit message is sufficient.
Please give me also some feedback on it.

If this simplification is not needed only initializing start to
ktime_get_ns() would fix the compiler warning too.

[1] https://lkml.org/lkml/2014/12/5/76
---
 drivers/misc/ioc4.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/misc/ioc4.c b/drivers/misc/ioc4.c
index 3336ddc..8758d03 100644
--- a/drivers/misc/ioc4.c
+++ b/drivers/misc/ioc4.c
@@ -144,9 +144,9 @@ ioc4_clock_calibrate(struct ioc4_driver_data *idd)
 {
 	union ioc4_int_out int_out;
 	union ioc4_gpcr gpcr;
-	unsigned int state, last_state = 1;
+	unsigned int state, last_state;
 	uint64_t start, end, period;
-	unsigned int count = 0;
+	unsigned int count;
 
 	/* Enable output */
 	gpcr.raw = 0;
@@ -167,19 +167,20 @@ ioc4_clock_calibrate(struct ioc4_driver_data *idd)
 	mmiowb();
 
 	/* Check square wave period averaged over some number of cycles */
-	do {
-		int_out.raw = readl(&idd->idd_misc_regs->int_out.raw);
-		state = int_out.fields.int_out;
-		if (!last_state && state) {
-			count++;
-			if (count == IOC4_CALIBRATE_END) {
-				end = ktime_get_ns();
-				break;
-			} else if (count == IOC4_CALIBRATE_DISCARD)
-				start = ktime_get_ns();
-		}
-		last_state = state;
-	} while (1);
+	start = ktime_get_ns();
+	state = 1; /* make sure the first read isn't a rising edge */
+	for (count = 0; count <= IOC4_CALIBRATE_END; count++) {
+		do { /* wait for a rising edge */
+			last_state = state;
+			int_out.raw = readl(&idd->idd_misc_regs->int_out.raw);
+			state = int_out.fields.int_out;
+		} while (last_state || !state);
+
+		/* discard the first few cycles */
+		if (count == IOC4_CALIBRATE_DISCARD)
+			start = ktime_get_ns();
+	}
+	end = ktime_get_ns();
 
 	/* Calculation rearranged to preserve intermediate precision.
 	 * Logically:
-- 
2.1.3

