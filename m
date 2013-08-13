Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab3HMGet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:34:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467Ab3HMGeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:34:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Piotr Sarna <p.sarna@partner.samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 10/17] ext4: fix mount/remount error messages for incompatible mount options
Date: Mon, 12 Aug 2013 23:35:56 -0700
Message-Id: <20130813063502.554030965@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063501.728847844@linuxfoundation.org>
References: <20130813063501.728847844@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3232,7 +3232,7 @@ static int ext4_fill_super(struct super_
 		}
 		if (test_opt(sb, DIOREAD_NOLOCK)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "both data=journal and delalloc");
+				 "both data=journal and dioread_nolock");
 			goto failed_mount;
 		}
 		if (test_opt(sb, DELALLOC))
@@ -4397,6 +4397,21 @@ static int ext4_remount(struct super_blo
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
 


