Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab3IKE7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:59:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab3IKE5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:08 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=r399iZ5zfCAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=H28o2yhh8XgA:10 a=hD80L64hAAAA:8 a=VwQbUJbxAAAA:8 a=H9Nnwyn-LKXlh89lJlIA:9 a=v3rLFGiuRE8A:10 a=jeBq3FmKZ4MA:10 a=ZhPFCbRBB50A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042922.640064282@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Piotr Sarna <p.sarna@partner.samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [183/251] ext4: fix mount/remount error messages for incompatible mount
 options
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0183-ext4-fix-mount-remount-error-messages-for-incompatib.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Piotr Sarna <p.sarna@partner.samsung.com>

[ Upstream commit 6ae6514b33f941d3386da0dfbe2942766eab1577 ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/ext4/super.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ec3f293..7099a33 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3405,7 +3405,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		}
 		if (test_opt(sb, DIOREAD_NOLOCK)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "both data=journal and delalloc");
+				 "both data=journal and dioread_nolock");
 			goto failed_mount;
 		}
 		if (test_opt(sb, DELALLOC))
@@ -4583,6 +4583,21 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
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
1.7.10.4


