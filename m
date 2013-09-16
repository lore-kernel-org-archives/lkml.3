Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3IPMwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 08:52:05 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:50541 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab3IPMvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 08:51:46 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, Steve French <sfrench@samba.org>,
        stable@vger.kernel.org
Subject: [PATCH 05/11] cifs: fix filp leak in cifs_atomic_open()
Date: Mon, 16 Sep 2013 14:51:59 +0200
Message-Id: <1379335925-30858-6-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
References: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

If an error occurs after having called finish_open() then fput() needs to
be called on the already opened file.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Steve French <sfrench@samba.org>
Cc: stable@vger.kernel.org
---
 fs/cifs/dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index d3e2eaa..5384c2a 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -500,6 +500,7 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 		if (server->ops->close)
 			server->ops->close(xid, tcon, &fid);
 		cifs_del_pending_open(&open);
+		fput(file);
 		rc = -ENOMEM;
 	}
 
-- 
1.8.1.4

