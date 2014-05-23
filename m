Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbaEWJlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:41:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:52808 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbaEWJlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:41:22 -0400
Message-ID: <1400838066.29150.69.camel@pasglop>
Subject: [PATCH] tty/hvc/hvc_console: Fix wakeup of HVC thread on hvc_kick()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>
Date: Fri, 23 May 2014 19:41:06 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some backends call hvc_kick() to wakeup the HVC thread from its
slumber upon incoming characters. This however doesn't work
properly because it uses msleep_interruptible() which is mostly
immune to wake_up_process(). It will basically go back to sleep
until the timeout is expired (only signals can really wake it).

Replace it with a simple shedule_timeout_interruptible() instead,
which may wakeup earlier every now and then but we really don't
care in this case.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 drivers/tty/hvc/hvc_console.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index 94f9e3a..1094265 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -760,10 +760,17 @@ static int khvcd(void *unused)
 			if (poll_mask == 0)
 				schedule();
 			else {
+				unsigned long j_timeout;
+
 				if (timeout < MAX_TIMEOUT)
 					timeout += (timeout >> 6) + 1;
 
-				msleep_interruptible(timeout);
+				/*
+				 * We don't use msleep_interruptible otherwise
+				 * "kick" will fail to wake us up
+				 */
+				j_timeout = msecs_to_jiffies(timeout) + 1;
+				schedule_timeout_interruptible(j_timeout);
 			}
 		}
 		__set_current_state(TASK_RUNNING);


