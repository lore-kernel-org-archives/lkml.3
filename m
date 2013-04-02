Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933701Ab3DBWOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:14:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932800Ab3DBWOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:14:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 24/68] vt: synchronize_rcu() under spinlock is not nice...
Date: Tue,  2 Apr 2013 15:13:13 -0700
Message-Id: <20130402221332.742038715@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221329.915209206@linuxfoundation.org>
References: <20130402221329.915209206@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit e8cd81693bbbb15db57d3c9aa7dd90eda4842874 upstream.

vcs_poll_data_free() calls unregister_vt_notifier(), which calls
atomic_notifier_chain_unregister(), which calls synchronize_rcu().
Do it *after* we'd dropped ->f_lock.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/vc_screen.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -93,7 +93,7 @@ vcs_poll_data_free(struct vcs_poll_data
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


