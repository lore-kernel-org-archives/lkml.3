Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab3EJMEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 08:04:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450Ab3EJMEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 08:04:12 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>, crrodriguez@opensuse.org
Subject: [PATCH] vfs: Fix invalid ida_remove() call
Date: Fri, 10 May 2013 14:04:11 +0200
Message-Id: <1368187451-6712-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the group id of a shared mount is not allocated, the umount still
tries to call mnt_release_group_id(), which eventually hits a kernel
warning at ida_remove() spewing a message like:
  ida_remove called for id=0 which is not allocated.

This patch fixes the bug simply checking the group id in the caller.

Reported-by: Cristian Rodríguez <crrodriguez@opensuse.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 fs/pnode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/pnode.c b/fs/pnode.c
index 3d2a714..9af0df1 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -83,7 +83,8 @@ static int do_make_slave(struct mount *mnt)
 		if (peer_mnt == mnt)
 			peer_mnt = NULL;
 	}
-	if (IS_MNT_SHARED(mnt) && list_empty(&mnt->mnt_share))
+	if (mnt->mnt_group_id && IS_MNT_SHARED(mnt) &&
+	    list_empty(&mnt->mnt_share))
 		mnt_release_group_id(mnt);
 
 	list_del_init(&mnt->mnt_share);
-- 
1.8.2.1

