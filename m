Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab3GQWuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:50:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56295 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757567Ab3GQWut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:50:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pavel Shilovsky <pshilovsky@samba.org>, Steve French <smfrench@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 132/145] CIFS: Fix a deadlock when a file is reopened
Date: Wed, 17 Jul 2013 15:47:44 -0700
Message-Id: <1374101277-7915-133-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/cifs/file.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 1d93ee8..ae62632 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -551,11 +551,10 @@ cifs_relock_file(struct cifsFileInfo *cfile)
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
 
@@ -566,7 +565,7 @@ cifs_relock_file(struct cifsFileInfo *cfile)
 	else
 		rc = tcon->ses->server->ops->push_mand_locks(cfile);
 
-	up_write(&cinode->lock_sem);
+	up_read(&cinode->lock_sem);
 	return rc;
 }
 
-- 
1.8.1.2

