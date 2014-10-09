Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaJIVEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:04:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58942 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaJIVD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:03:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Pavel Shilovsky <pshilovsky@samba.org>,
        Steve French <smfrench@gmail.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 010/163] CIFS: Fix wrong restart readdir for SMB1
Date: Thu,  9 Oct 2014 14:00:35 -0700
Message-Id: <1412888588-26755-11-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <pshilovsky@samba.org>

commit f736906a7669a77cf8cabdcbcf1dc8cb694e12ef upstream.

The existing code calls server->ops->close() that is not
right. This causes XFS test generic/310 to fail. Fix this
by using server->ops->closedir() function.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/cifs/readdir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index b2d1430..e327a92 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -596,8 +596,8 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
 		if (server->ops->dir_needs_close(cfile)) {
 			cfile->invalidHandle = true;
 			spin_unlock(&cifs_file_list_lock);
-			if (server->ops->close)
-				server->ops->close(xid, tcon, &cfile->fid);
+			if (server->ops->close_dir)
+				server->ops->close_dir(xid, tcon, &cfile->fid);
 		} else
 			spin_unlock(&cifs_file_list_lock);
 		if (cfile->srch_inf.ntwrk_buf_start) {
-- 
1.9.1

