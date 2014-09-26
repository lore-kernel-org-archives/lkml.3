Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbaIZKLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:11:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980AbaIZJq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pavel Shilovsky <pshilovsky@samba.org>,
        Steve French <smfrench@gmail.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 110/142] CIFS: Fix wrong directory attributes after rename
Date: Fri, 26 Sep 2014 11:45:21 +0200
Message-Id: <b80e6456dd0c3fa884e5d56c8ea8fd55f6ffe3ad.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Shilovsky <pshilovsky@samba.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b46799a8f28c43c5264ac8d8ffa28b311b557e03 upstream.

When we requests rename we also need to update attributes
of both source and target parent directories. Not doing it
causes generic/309 xfstest to fail on SMB2 mounts. Fix this
by marking these directories for force revalidating.

Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/cifs/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 5f8bdff3a758..36d2b1d6d492 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1689,6 +1689,12 @@ unlink_target:
 				    target_dentry, to_name);
 	}
 
+	/* force revalidate to go get info when needed */
+	CIFS_I(source_dir)->time = CIFS_I(target_dir)->time = 0;
+
+	source_dir->i_ctime = source_dir->i_mtime = target_dir->i_ctime =
+		target_dir->i_mtime = current_fs_time(source_dir->i_sb);
+
 cifs_rename_exit:
 	kfree(info_buf_source);
 	kfree(from_name);
-- 
2.1.0

