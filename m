Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965725Ab3GSFkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:40:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965646Ab3GSF0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:26:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pavel Shilovsky <pshilovsky@samba.org>,
        Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>
Subject: [ 02/72] CIFS: Fix a deadlock when a file is reopened
Date: Thu, 18 Jul 2013 22:25:19 -0700
Message-Id: <20130719052600.022992619@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <pshilovsky@samba.org>

commit 689c3db4d57a73bee6c5ad7797fce7b54d32a87c upstream.

If we request reading or writing on a file that needs to be
reopened, it causes the deadlock: we are already holding rw
semaphore for reading and then we try to acquire it for writing
in cifs_relock_file. Fix this by acquiring the semaphore for
reading in cifs_relock_file due to we don't make any changes in
locks and don't need a write access.

Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/file.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -553,11 +553,10 @@ cifs_relock_file(struct cifsFileInfo *cf
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	int rc = 0;
 
-	/* we are going to update can_cache_brlcks here - need a write access */
-	down_write(&cinode->lock_sem);
+	down_read(&cinode->lock_sem);
 	if (cinode->can_cache_brlcks) {
-		/* can cache locks - no need to push them */
-		up_write(&cinode->lock_sem);
+		/* can cache locks - no need to relock */
+		up_read(&cinode->lock_sem);
 		return rc;
 	}
 
@@ -568,7 +567,7 @@ cifs_relock_file(struct cifsFileInfo *cf
 	else
 		rc = tcon->ses->server->ops->push_mand_locks(cfile);
 
-	up_write(&cinode->lock_sem);
+	up_read(&cinode->lock_sem);
 	return rc;
 }
 


