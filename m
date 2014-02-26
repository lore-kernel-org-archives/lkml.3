Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaBZLFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 06:05:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.130]:63862 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaBZLCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 06:02:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org
Subject: [PATCH 12/16] isdn: pcbit: fix interruptible_sleep_on race
Date: Wed, 26 Feb 2014 12:01:52 +0100
Message-Id: <1393412516-3762435-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:D/Z3kQM4Vy1TYf19/ZcGNcGAJGehCAHY1oQvru6NEH+
 DD052pUkAJ4DqOqDJEr04iSQvYyNpKIROzDHWbz3ciANMpkklb
 0w89PpxQ2otiKgKdpwZ+gRkxLOEXGTPUNCGpQEXgVqJLyhAtvU
 BdUzfA2SYYCxdy+2gFAcOJqc2kcGTdqKISqoPpCg9z8NuqqFbc
 /siUhKE5umBes7kOqyf0mEw9HEsF32czuMwlnTtLUJ6zurA8W1
 ex5JBI8KXA20tntVtEpjRdQroEBElwW6elZUYmqk2bTmR0rxco
 ELkVQlZQpwHanLn9Jz5rugTtSvMJ8VFmp6fh+8jlvu3WF3/K5v
 tHesLjreUm0lTI5UFdZkjLlJTHVInq2jjghhFDFRR
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

