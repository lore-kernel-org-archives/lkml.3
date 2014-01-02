Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbaABMMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:12:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55542 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbaABMIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:08:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org
Subject: [PATCH, RFC 19/30] isdn: pcbit: fix interruptible_sleep_on race
Date: Thu,  2 Jan 2014 13:07:43 +0100
Message-Id: <1388664474-1710039-20-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Ky0j/gnvful2pI2wWLLWcuvNG2fI65/ixQX5RaqjNbq
 X2PY38LSE3gOqlL7+uOR0poAJIbA5XwpUp8Imu1iiIYTz79tQJ
 Ov71VCzXw46z5C8fTouuECGhJQSZKVyDavwmtGmtvbOTI4e4P/
 0lXQ1lBYg7vmrcona4EiC2zbmQXgyS9Y4Znx7kENsSqq3oRVVx
 tm7sawtqCrrJ717Uh96cFgfqZlb5tGpyueW5DGXGJaiMCHgctQ
 zNj0hy8KwM1thxMbkE2nyMvwtDvQpq/VZxfhliL9Vj31XdRE6e
 kptWl05wW9qTgcmWBNDjRHCEjCk+JGAAlJ58j8qb9qQUymVUfZ
 Jjxn/TcjY9FL5KWSKKQzrm/WRECio4+wK4jAvcinL
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

interruptible_sleep_on is racy and going away. In case of pcbit,
the driver would run into a timeout if the card is initialized
before we start waiting for it. This uses wait_event to fix the
race. In order to do this, the state machine handling for the
timeout case has to get trivially reorganized so we actually know
whether the timeout has occorred or not.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org
---
 drivers/isdn/pcbit/drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/pcbit/drv.c b/drivers/isdn/pcbit/drv.c
index 1eaf622..f02cc50 100644
--- a/drivers/isdn/pcbit/drv.c
+++ b/drivers/isdn/pcbit/drv.c
@@ -796,6 +796,7 @@ static void set_running_timeout(unsigned long ptr)
 #endif
 	dev = (struct pcbit_dev *) ptr;
 
+	dev->l2_state = L2_DOWN;
 	wake_up_interruptible(&dev->set_running_wq);
 }
 
@@ -818,7 +819,8 @@ static int set_protocol_running(struct pcbit_dev *dev)
 
 	add_timer(&dev->set_running_timer);
 
-	interruptible_sleep_on(&dev->set_running_wq);
+	wait_event(dev->set_running_wq, dev->l2_state == L2_RUNNING ||
+					dev->l2_state == L2_DOWN);
 
 	del_timer(&dev->set_running_timer);
 
@@ -842,8 +844,6 @@ static int set_protocol_running(struct pcbit_dev *dev)
 		printk(KERN_DEBUG "pcbit: initialization failed\n");
 		printk(KERN_DEBUG "pcbit: firmware not loaded\n");
 
-		dev->l2_state = L2_DOWN;
-
 #ifdef DEBUG
 		printk(KERN_DEBUG "Bank3 = %02x\n",
 		       readb(dev->sh_mem + BANK3));
-- 
1.8.3.2

