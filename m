Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936608Ab3DHKXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:23:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42646 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935441Ab3DHJvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 014/102] vt: synchronize_rcu() under spinlock is not nice...
Date: Mon,  8 Apr 2013 10:49:29 +0100
Message-Id: <1365414657-29191-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit e8cd81693bbbb15db57d3c9aa7dd90eda4842874 upstream.

vcs_poll_data_free() calls unregister_vt_notifier(), which calls
atomic_notifier_chain_unregister(), which calls synchronize_rcu().
Do it *after* we'd dropped ->f_lock.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/vt/vc_screen.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index fa7268a..6abb92c 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -93,7 +93,7 @@ vcs_poll_data_free(struct vcs_poll_data *poll)
 static struct vcs_poll_data *
 vcs_poll_data_get(struct file *file)
 {
-	struct vcs_poll_data *poll = file->private_data;
+	struct vcs_poll_data *poll = file->private_data, *kill = NULL;
 
 	if (poll)
 		return poll;
@@ -122,10 +122,12 @@ vcs_poll_data_get(struct file *file)
 		file->private_data = poll;
 	} else {
 		/* someone else raced ahead of us */
-		vcs_poll_data_free(poll);
+		kill = poll;
 		poll = file->private_data;
 	}
 	spin_unlock(&file->f_lock);
+	if (kill)
+		vcs_poll_data_free(kill);
 
 	return poll;
 }
-- 
1.8.1.2

