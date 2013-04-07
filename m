Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934593Ab3DGX0x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:26:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46592 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759308Ab3DGX0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:26:51 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Al Viro" <viro@zeniv.linux.org.uk>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.513879356@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [32/74] vt: synchronize_rcu() under spinlock is not nice...
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit e8cd81693bbbb15db57d3c9aa7dd90eda4842874 upstream.

vcs_poll_data_free() calls unregister_vt_notifier(), which calls
atomic_notifier_chain_unregister(), which calls synchronize_rcu().
Do it *after* we'd dropped ->f_lock.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/vt/vc_screen.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index e4ca345..d7799de 100644
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

