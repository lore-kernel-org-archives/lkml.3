Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbaBZLGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 06:06:19 -0500
Received: from moutng.kundenserver.de ([212.227.126.130]:52150 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbaBZLCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 06:02:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@osdl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 09/16] parport: fix interruptible_sleep_on race
Date: Wed, 26 Feb 2014 12:01:49 +0100
Message-Id: <1393412516-3762435-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:9jw5BCwf3HjJcEYfstptjwsa7hO82T8sZW26Iv4PLXp
 o1iOkx1Otb51lSrF5OjytTb/UUc4gLkP2IGivJY5I+ZVJV4oao
 /IuwqKbL8Ka7F9yPT3Mww7D536GRq/V0/JNclS9Gehmkhrwi/M
 paIf4Bmxyag3+slNmFGfeEdk1hqAD/Ds8LuszMNB2s86AKM4GR
 9PnwlTRF9B12S9KNVJPe60cQs6afsMxqm6aH17WnvzleYXz3dA
 1jGEM/UUHhypU1gMa77B+LwuXGn4xxmGBL9gLRhS07qa9TYMkb
 a2g9Cg3Evar+tDMg2YGXOClv7CeL6Xlu7yys5b8XMwtWnn0lyR
 VV6+A5Llhqs3S9Rb9gdfALe2OyAfnUN5oEP6iZYgm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interruptible_sleep_on function is can still lead to the
deadlock mentioned in the comment above the caller, and we want
to remove it soon, so replace it now with the race-free
wait_event_interruptible.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@osdl.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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

