Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab3HBMFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 08:05:32 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44036 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3HBMFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 08:05:19 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-4f-51fba03e0b5e
From: Piotr Sarna <p.sarna@partner.samsung.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, b.zolnierkie@samsung.com,
        Piotr Sarna <p.sarna@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/2] ext4: improve mount/remount error handling
Date: Fri, 02 Aug 2013 14:03:47 +0200
Message-id: <1375445027-25024-2-git-send-email-p.sarna@partner.samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1375445027-25024-1-git-send-email-p.sarna@partner.samsung.com>
References: <1375445027-25024-1-git-send-email-p.sarna@partner.samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t9jAV27Bb8DDU7u57D4+qWDxWLjjPWs
	Fmeb3rBbzJx3h83i8q45bBarFkVZtPb8ZHdg92jZXO7RdOYos8fBd3uYPPq2rGL0+LxJLoA1
	issmJTUnsyy1SN8ugStjW9dj1oIdAhX/bu9ka2DcwtvFyMkhIWAicaShgw3CFpO4cG89kM3F
	ISSwiFFi3/HDzBBOO5PEgg/PGEGq2AT0Jb5cX8MCYosICEpcvvMArIhZ4AyjxMslX9hBEsIC
	9hILum+C2SwCqhJnL08Ea+AV8JaYt/wuaxcjB9A6BYk5k2xAwpwCPhJXlx5lArGFgEranh1k
	nsDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcEg9k9rBuLLB4hCjAAejEg/vg8xf
	gUKsiWXFlbmHGCU4mJVEeP/MBgrxpiRWVqUW5ccXleakFh9ilOZgURLnPdBqHSgkkJ5Ykpqd
	mlqQWgSTZeLglGpgnGSS8lxl7an2Cy5falXuyL6LP3s8PfBeF7sak9/GD+0X6q+e8P5X1jd3
	9Z2QC4pPLc99vcpw5YpsfbRk08b59tni+38emPEsgtvgD0Ox6bZJJ+x8Vp5ZOeHniSLl5VlT
	PXdX7FT71r8kx5nnWA3bAevoL6lxvovnGu1QPzT5u5qUrWGKWJUxrxJLcUaioRZzUXEiAHv5
	1bklAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5688978 ("ext4: improve handling of conflicting mount options")
introduced incorrect messages shown while choosing wrong mount options.

Firstly, both cases of incorrect mount options, "data=journal,delalloc"
and "data=journal,dioread_nolock" result in the same error message.

Secondly, the problem above isn't solved for remount option: the mismatched
parameter is simply ignored. Moreover, ext4_msg states that remount
with options "data=journal,delalloc" succeeded, which is not true.

To fix it up, I added a simple check after parse_options() call to ensure
that data=journal and delalloc/dioread_nolock parameters are not present
at the same time.

Signed-off-by: Piotr Sarna <p.sarna@partner.samsung.com>
Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 fs/ext4/super.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 10f9bb0..ab0b23b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3452,7 +3452,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		}
 		if (test_opt(sb, DIOREAD_NOLOCK)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "both data=journal and delalloc");
+				 "both data=journal and dioread_nolock");
 			goto failed_mount;
 		}
 		if (test_opt(sb, DELALLOC))
@@ -4653,6 +4653,21 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
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
1.7.9.5

