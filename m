Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbbAGHik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:38:40 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:60655 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbbAGHii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:38:38 -0500
Date: Wed, 7 Jan 2015 09:38:34 +0200
From: Asaf Vertz <asaf.vertz@tandemg.com>
To: josh.h.morris@us.ibm.com
Cc: pjk1939@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: [PATCH] rsxx: fix time comparison
Message-ID: <20150107073834.GA9215@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are
modified to use time_before() instead of plain, error-prone math.

Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
---
 drivers/block/rsxx/core.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
index d8b2488..ea527e8 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -25,6 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/reboot.h>
@@ -513,8 +514,8 @@ static void card_event_handler(struct work_struct *work)
 static int card_shutdown(struct rsxx_cardinfo *card)
 {
 	unsigned int state;
-	signed long start;
-	const int timeout = msecs_to_jiffies(120000);
+	unsigned long start;
+	const unsigned long timeout = msecs_to_jiffies(120000);
 	int st;
 
 	/* We can't issue a shutdown if the card is in a transition state */
@@ -524,7 +525,7 @@ static int card_shutdown(struct rsxx_cardinfo *card)
 		if (st)
 			return st;
 	} while (state == CARD_STATE_STARTING &&
-		 (jiffies - start < timeout));
+		 time_before(jiffies, start + timeout));
 
 	if (state == CARD_STATE_STARTING)
 		return -ETIMEDOUT;
@@ -543,7 +544,7 @@ static int card_shutdown(struct rsxx_cardinfo *card)
 		if (st)
 			return st;
 	} while (state != CARD_STATE_SHUTDOWN &&
-		 (jiffies - start < timeout));
+		 time_before(jiffies, start + timeout));
 
 	if (state != CARD_STATE_SHUTDOWN)
 		return -ETIMEDOUT;
-- 
1.7.0.4

