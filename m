Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbaABMIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:08:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55693 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaABMIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:08:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH, RFC 12/30] parport: fix interruptible_sleep_on race
Date: Thu,  2 Jan 2014 13:07:36 +0100
Message-Id: <1388664474-1710039-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:iolntoCfV+VfxtJ8DBnaoKYmoWF6R0Zg20mChdqzqBK
 fUIzL7ztv+OigEXY/BLfnMZUblx18JB2p7swp2yN0NrbnDFFmc
 6bSzHMmWoTaDQDOhBrGOJQECsOToMmT/I7zE9R/7K4BFulWNGL
 Ik+WdFYYG3zNjgbiJ+x+s0xjhKN9FxVmORvf6G6jGHhUX40DdC
 QmsD7FCbNW3rq5qv7MYFhr2mr9sP95EtP4IYJ1WS013fRxWP/m
 +HHL4SqrkdqDKdPD6H4UyAY7Ss6BBEuaQXsr3zMJLY3zlRAUPd
 f8IOJ9Lyu8yE1saRwztI/3BN4zaYLcjKVfYWwvvX8+XnaV1JyA
 NmR8tHsCFcfgiSgX2AF6ziCWjInF7FhtDmPxwaGUv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interruptible_sleep_on function is can still lead to the
deadlock mentioned in the comment above the caller, and we want
to remove it soon, so replace it now with the race-free
wait_event_interruptible.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@osdl.org>
---
 drivers/parport/share.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/parport/share.c b/drivers/parport/share.c
index 6a83ee1..3fa6624 100644
--- a/drivers/parport/share.c
+++ b/drivers/parport/share.c
@@ -905,7 +905,8 @@ int parport_claim_or_block(struct pardevice *dev)
 		/* If dev->waiting is clear now, an interrupt
 		   gave us the port and we would deadlock if we slept.  */
 		if (dev->waiting) {
-			interruptible_sleep_on (&dev->wait_q);
+			wait_event_interruptible(dev->wait_q,
+						 !dev->waiting);
 			if (signal_pending (current)) {
 				return -EINTR;
 			}
-- 
1.8.3.2

