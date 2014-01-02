Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaABMIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:08:37 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53010 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbaABMIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:08:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Jesper Nilsson <jesper.nilsson@axis.com>,
        Mikael Starvik <starvik@axis.com>, linux-cris-kernel@axis.com
Subject: [PATCH, RFC 13/30] cris: sync_serial: remove interruptible_sleep_on
Date: Thu,  2 Jan 2014 13:07:37 +0100
Message-Id: <1388664474-1710039-14-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:AtAyhA7wInDN2im4+Tm4aMWrQLjh1pNxVM0Mq06PvO8
 QoPt0131g7VAjEZiyRlUXtFTjmINn6SR79ohicL3/Mw1+TtBOY
 UxY8A+W8l8JajyqSzR8pYfyvUKTgSreIEWMIueJ/a9wRHF+YLF
 WW19uekD1yYYSAtD88EHCojH3j/0fq31emJFGIg+8TVgzUTImG
 cnl2DA8Q1NvJS17pFsSlH7yG3fwDTbiCu9d59HbELVePHFey1Q
 9roaWyl8/EvHvtVMPOsF8aAKp/CKMjX0tRYcCOi/pqWGMxp4jy
 vmIU1AVGGCq445McIht/uX7OHfcBe8eCoBSR501knCd2r05ZCO
 XrncxoD7ISM2B4fEuXB2XpYRVPdx0fmcg4IYIsZjZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sleep_on and its variants are racy and going away. This replaces
the two uses in the cris sync_serial drivers with the equivalent
but race-free wait_event_interruptible.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: linux-cris-kernel@axis.com
---
 arch/cris/arch-v10/drivers/sync_serial.c | 4 +++-
 arch/cris/arch-v32/drivers/sync_serial.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/cris/arch-v10/drivers/sync_serial.c b/arch/cris/arch-v10/drivers/sync_serial.c
index a1c498d..485f2bb 100644
--- a/arch/cris/arch-v10/drivers/sync_serial.c
+++ b/arch/cris/arch-v10/drivers/sync_serial.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/timer.h>
+#include <linux/wait.h>
 #include <asm/irq.h>
 #include <asm/dma.h>
 #include <asm/io.h>
@@ -1136,7 +1137,8 @@ static ssize_t sync_serial_read(struct file *file, char *buf,
 		if (file->f_flags & O_NONBLOCK)
 			return -EAGAIN;
 
-		interruptible_sleep_on(&port->in_wait_q);
+		wait_event_interruptible(port->in_wait_q,
+					 !(start == end && !port->full));
 		if (signal_pending(current))
 			return -EINTR;
 
diff --git a/arch/cris/arch-v32/drivers/sync_serial.c b/arch/cris/arch-v32/drivers/sync_serial.c
index 219f704..bbb806b 100644
--- a/arch/cris/arch-v32/drivers/sync_serial.c
+++ b/arch/cris/arch-v32/drivers/sync_serial.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/timer.h>
 #include <linux/spinlock.h>
+#include <linux/wait.h>
 
 #include <asm/io.h>
 #include <dma.h>
@@ -1144,7 +1145,8 @@ static ssize_t sync_serial_read(struct file * file, char * buf,
 		if (file->f_flags & O_NONBLOCK)
 			return -EAGAIN;
 
-		interruptible_sleep_on(&port->in_wait_q);
+		wait_event_interruptible(port->in_wait_q,
+					 !(start == end && !port->full));
 		if (signal_pending(current))
 			return -EINTR;
 
-- 
1.8.3.2

