Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbaBZLCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 06:02:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.130]:53617 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaBZLCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 06:02:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org
Subject: [PATCH 15/16] isdn: fix multiple sleep_on races
Date: Wed, 26 Feb 2014 12:01:55 +0100
Message-Id: <1393412516-3762435-16-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:RPD8HLnRBOSJEDgje51nkEoiEkZ+q93b5tA+2qSOhAR
 mFxZgjyyoGox5dwjYtNX+3Fil889vrzW60lJL3WGbinj7J5TdN
 N33glb18ifZyy7onjU/M8or8Grl13EZF2OShenj7fzvg7MtzGo
 n9R5MLITDgP1SMM723TF2HACic92VUkBW5agntlX14EqPwfbLk
 B/EMxrj7iRJrJAOg6Lp/kkgJUYXPrJXDN74n0jNED4+PybTO8u
 viRgK0v3SGdAKTg238Q1WJtXsDpLhVqNM+7lS76wdw0mWv81OD
 M3mzKUopR7gEyhyHchnzwEqaMSYOP/tG6/+gm19JQ7tR/XaE/3
 PAP5QUq0oPP0CnkcOlLfhYXjJiCYJd6Kk7RMchJ9I
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The isdn core code uses a couple of wait queues with
interruptible_sleep_on, which is racy and about to get
removed from the kernel. Fortunately, we know for each case
what we are waiting for, so they can all be converted to
the better wait_event_interruptible interface.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org
---
 drivers/isdn/i4l/isdn_common.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index 9bb12ba..130f216 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -777,7 +777,8 @@ isdn_readbchan(int di, int channel, u_char *buf, u_char *fp, int len, wait_queue
 		return 0;
 	if (skb_queue_empty(&dev->drv[di]->rpqueue[channel])) {
 		if (sleep)
-			interruptible_sleep_on(sleep);
+			wait_event_interruptible(*sleep,
+				!skb_queue_empty(&dev->drv[di]->rpqueue[channel]));
 		else
 			return 0;
 	}
@@ -1072,7 +1073,8 @@ isdn_read(struct file *file, char __user *buf, size_t count, loff_t *off)
 				retval = -EAGAIN;
 				goto out;
 			}
-			interruptible_sleep_on(&(dev->info_waitq));
+			wait_event_interruptible(dev->info_waitq,
+						 file->private_data);
 		}
 		p = isdn_statstr();
 		file->private_data = NULL;
@@ -1128,7 +1130,8 @@ isdn_read(struct file *file, char __user *buf, size_t count, loff_t *off)
 				retval = -EAGAIN;
 				goto out;
 			}
-			interruptible_sleep_on(&(dev->drv[drvidx]->st_waitq));
+			wait_event_interruptible(dev->drv[drvidx]->st_waitq,
+						 dev->drv[drvidx]->stavail);
 		}
 		if (dev->drv[drvidx]->interface->readstat) {
 			if (count > dev->drv[drvidx]->stavail)
@@ -1188,8 +1191,8 @@ isdn_write(struct file *file, const char __user *buf, size_t count, loff_t *off)
 			goto out;
 		}
 		chidx = isdn_minor2chan(minor);
-		while ((retval = isdn_writebuf_stub(drvidx, chidx, buf, count)) == 0)
-			interruptible_sleep_on(&dev->drv[drvidx]->snd_waitq[chidx]);
+		wait_event_interruptible(dev->drv[drvidx]->snd_waitq[chidx],
+			(retval = isdn_writebuf_stub(drvidx, chidx, buf, count)));
 		goto out;
 	}
 	if (minor <= ISDN_MINOR_CTRLMAX) {
-- 
1.8.3.2

