Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab3FFJqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 05:46:40 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:27768 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754634Ab3FFJqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 05:46:38 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH] Fix null pointer dereference caused by sysfs_notify on binary attribute
Date: Thu,  6 Jun 2013 10:45:20 +0100
Message-Id: <1370511920-8628-1-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would be nice to have this work as expected but for now this is a minimal
fix to prevent the kernel panic.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 fs/sysfs/file.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 602f56d..976819b 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -449,10 +449,12 @@ void sysfs_notify_dirent(struct sysfs_dirent *sd)
 
 	spin_lock_irqsave(&sysfs_open_dirent_lock, flags);
 
-	od = sd->s_attr.open;
-	if (od) {
-		atomic_inc(&od->event);
-		wake_up_interruptible(&od->poll);
+	if (sd->s_attr) {
+		od = sd->s_attr.open;
+		if (od) {
+			atomic_inc(&od->event);
+			wake_up_interruptible(&od->poll);
+		}
 	}
 
 	spin_unlock_irqrestore(&sysfs_open_dirent_lock, flags);
-- 
1.7.10.4

