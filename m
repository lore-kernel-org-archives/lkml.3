Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab3FGOpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 10:45:19 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:24263 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753212Ab3FGOpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 10:45:18 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH V2] sysfs_notify is only possible on file attributes
Date: Fri,  7 Jun 2013 15:45:13 +0100
Message-Id: <1370616313-4015-1-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130606193752.GA22115@kroah.com>
References: <20130606193752.GA22115@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If sysfs_notify is called on a binary attribute, bad things can
happen, so prevent it.

Note, no in-kernel usage of this is currently present, but in the
future, it's good to be safe.

Changes in V2:
- Also ignore sysfs_notify on dirs, links
- Use WARN_ON rather than silently failing
- Compiled and tested (huge apologies about first submission)

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 fs/sysfs/file.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 602f56d..d2bb7ed 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -449,10 +449,12 @@ void sysfs_notify_dirent(struct sysfs_dirent *sd)
 
 	spin_lock_irqsave(&sysfs_open_dirent_lock, flags);
 
-	od = sd->s_attr.open;
-	if (od) {
-		atomic_inc(&od->event);
-		wake_up_interruptible(&od->poll);
+	if (!WARN_ON(sysfs_type(sd) != SYSFS_KOBJ_ATTR)) {
+		od = sd->s_attr.open;
+		if (od) {
+			atomic_inc(&od->event);
+			wake_up_interruptible(&od->poll);
+		}
 	}
 
 	spin_unlock_irqrestore(&sysfs_open_dirent_lock, flags);
-- 
1.7.10.4

