Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab3HPWjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:39:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51566 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309Ab3HPWiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:38:55 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Piotr Sarna <p.sarna@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 118/133] ext4: fix mount/remount error messages for incompatible mount options
Date: Fri, 16 Aug 2013 15:34:20 -0700
Message-Id: <1376692475-28413-119-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piotr Sarna <p.sarna@partner.samsung.com>

commit 6ae6514b33f941d3386da0dfbe2942766eab1577 upstream.

Commit 5688978 ("ext4: improve handling of conflicting mount options")
introduced incorrect messages shown while choosing wrong mount options.

First of all, both cases of incorrect mount options,
"data=journal,delalloc" and "data=journal,dioread_nolock" result in
the same error message.

Secondly, the problem above isn't solved for remount option: the
mismatched parameter is simply ignored.  Moreover, ext4_msg states
that remount with options "data=journal,delalloc" succeeded, which is
not true.

To fix it up, I added a simple check after parse_options() call to
ensure that data=journal and delalloc/dioread_nolock parameters are
not present at the same time.

Signed-off-by: Piotr Sarna <p.sarna@partner.samsung.com>
Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/super.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1e4b5926..b83f75d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3440,7 +3440,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		}
 		if (test_opt(sb, DIOREAD_NOLOCK)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "both data=journal and delalloc");
+				 "both data=journal and dioread_nolock");
 			goto failed_mount;
 		}
 		if (test_opt(sb, DELALLOC))
@@ -4618,6 +4618,21 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		goto restore_opts;
 	}
 
+	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA) {
+		if (test_opt2(sb, EXPLICIT_DELALLOC)) {
+			ext4_msg(sb, KERN_ERR, "can't mount with "
+				 "both data=journal and delalloc");
+			err = -EINVAL;
+			goto restore_opts;
+		}
+		if (test_opt(sb, DIOREAD_NOLOCK)) {
+			ext4_msg(sb, KERN_ERR, "can't mount with "
+				 "both data=journal and dioread_nolock");
+			err = -EINVAL;
+			goto restore_opts;
+		}
+	}
+
 	if (sbi->s_mount_flags & EXT4_MF_FS_ABORTED)
 		ext4_abort(sb, "Abort forced by user");
 
-- 
1.8.1.2

