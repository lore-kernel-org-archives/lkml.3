Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaBZLGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 06:06:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.130]:52771 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaBZLCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 06:02:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Michael Schmitz <schmitzmic@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 02/16] scsi: atari_scsi: fix sleep_on race
Date: Wed, 26 Feb 2014 12:01:42 +0100
Message-Id: <1393412516-3762435-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:TZXHjdMVycb9koJrEaNSPL3n3dk5mcodUcD3AsYWU99
 bIUV1bDauKxZlwjareBgM3t4rIT9ZmMqNPyYNqZvRABvjyCt20
 ytOsqHAaZIzauziTzMryu9GUL8MqbuYmILRMqYRWClU1rwRufP
 hwpFmbhsac6KALSDUUdVGCPw0Xzq0PtLFv5i0MAlcAKDQ5+zJ9
 l6I4mzYVR0QIYXRrfdCfkk5foIfAnhZIfsZtS+WLWj5I2Bk+zm
 dB6S2kci/cQHi+zE5aY+J3rcoRdkjrDT6ksSZpVZrfzHGrpNxv
 lsQb7AWT9FynQyx644wPBm6y/GBIJS+OtotJMCPVEq71yfgX+z
 3BXmePa1y1NhXk3NY9asGv+VopQwze0PpJ76y1zym
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sleep_on is known broken and going away. The atari_scsi driver is one of
two remaining users in the falcon_get_lock() function, which is a rather
crazy piece of code. This does not attempt to fix the driver's locking
scheme in general, but at least prevents falcon_get_lock from going to
sleep when no other thread holds the same lock or tries to get it,
and we no longer schedule with irqs disabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/atari_scsi.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index a3e6c8a..b33ce34 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -90,6 +90,7 @@
 #include <linux/init.h>
 #include <linux/nvram.h>
 #include <linux/bitops.h>
+#include <linux/wait.h>
 
 #include <asm/setup.h>
 #include <asm/atarihw.h>
@@ -549,8 +550,10 @@ static void falcon_get_lock(void)
 
 	local_irq_save(flags);
 
-	while (!in_irq() && falcon_got_lock && stdma_others_waiting())
-		sleep_on(&falcon_fairness_wait);
+	wait_event_cmd(falcon_fairness_wait,
+		       !in_irq() && falcon_got_lock && stdma_others_waiting(),
+		       local_irq_restore(flags),
+		       local_irq_save(flags));
 
 	while (!falcon_got_lock) {
 		if (in_irq())
@@ -562,7 +565,10 @@ static void falcon_get_lock(void)
 			falcon_trying_lock = 0;
 			wake_up(&falcon_try_wait);
 		} else {
-			sleep_on(&falcon_try_wait);
+			wait_event_cmd(falcon_try_wait,
+				       falcon_got_lock && !falcon_trying_lock,
+				       local_irq_restore(flags),
+				       local_irq_save(flags));
 		}
 	}
 
-- 
1.8.3.2

