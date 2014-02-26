Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaBZLFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 06:05:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.130]:60789 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaBZLCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 06:02:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org
Subject: [PATCH 14/16] isdn: divert, hysdn: fix interruptible_sleep_on race
Date: Wed, 26 Feb 2014 12:01:54 +0100
Message-Id: <1393412516-3762435-15-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:vs1oOiF2Cpa2tjPYInArzNqrFUULRajxDNkjh1O1sia
 dVmqFr4VccHJWcGfvY7pinvjCiJHHsewzfw3OKPSNglD+Q+PG+
 QXu6Gq3uF/irHUxsYR8cGbyhOEvzltxZNYkghzXmEY1NKfZkcy
 7NTiUUr188D3TNBG8gfMgKegpIgP0ng2L+UkUio7YChpmyzLRG
 4WzmQhH6pd4QLKkE19heYOJIDvQbbUHmHql0HRmsWqC5A3MQCG
 hXe3zB/m9OP8wL+osFGPZEBw1L1JPYjykJx/x42r8b8fe2oIfi
 b3oLexWkAw1XBLg3iUz6kRtOW5YeDw6ATxGO8OdCoAZuuRUUSb
 Rhd3vdFAzaGxV/Y7YuOrw9MMODj/Jm1W76icmYGcm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two drivers use identical code for their procfs status
file handling, which contains a small race against status
data becoming available while reading the file.

This uses wait_event_interruptible instead to fix this
particular race and eventually get rid of all sleep_on
instances. There seems to be another race involving
multiple concurrent readers of the same procfs file, which
I don't try to fix here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org
---
 drivers/isdn/divert/divert_procfs.c | 7 ++++---
 drivers/isdn/hysdn/hysdn_proclog.c  | 7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/isdn/divert/divert_procfs.c b/drivers/isdn/divert/divert_procfs.c
index fb4f1ba..1c5dc34 100644
--- a/drivers/isdn/divert/divert_procfs.c
+++ b/drivers/isdn/divert/divert_procfs.c
@@ -86,12 +86,13 @@ isdn_divert_read(struct file *file, char __user *buf, size_t count, loff_t *off)
 	struct divert_info *inf;
 	int len;
 
-	if (!*((struct divert_info **) file->private_data)) {
+	if (!(inf = *((struct divert_info **) file->private_data))) {
 		if (file->f_flags & O_NONBLOCK)
 			return -EAGAIN;
-		interruptible_sleep_on(&(rd_queue));
+		wait_event_interruptible(rd_queue, (inf =
+			*((struct divert_info **) file->private_data)));
 	}
-	if (!(inf = *((struct divert_info **) file->private_data)))
+	if (!inf)
 		return (0);
 
 	inf->usage_cnt--;	/* new usage count */
diff --git a/drivers/isdn/hysdn/hysdn_proclog.c b/drivers/isdn/hysdn/hysdn_proclog.c
index b61e8d5..7b5fd8f 100644
--- a/drivers/isdn/hysdn/hysdn_proclog.c
+++ b/drivers/isdn/hysdn/hysdn_proclog.c
@@ -175,14 +175,15 @@ hysdn_log_read(struct file *file, char __user *buf, size_t count, loff_t *off)
 	int len;
 	hysdn_card *card = PDE_DATA(file_inode(file));
 
-	if (!*((struct log_data **) file->private_data)) {
+	if (!(inf = *((struct log_data **) file->private_data))) {
 		struct procdata *pd = card->proclog;
 		if (file->f_flags & O_NONBLOCK)
 			return (-EAGAIN);
 
-		interruptible_sleep_on(&(pd->rd_queue));
+		wait_event_interruptible(pd->rd_queue, (inf =
+				*((struct log_data **) file->private_data)));
 	}
-	if (!(inf = *((struct log_data **) file->private_data)))
+	if (!inf)
 		return (0);
 
 	inf->usage_cnt--;	/* new usage count */
-- 
1.8.3.2

