Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab3IHDUA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:20:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56174 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756519Ab3IHDSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:48 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Piotr Sarna" <p.sarna@partner.samsung.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Bartlomiej Zolnierkiewicz" <b.zolnierkie@samsung.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.546017633@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [062/121] ext4: fix mount/remount error messages for incompatible
 mount options
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/super.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3372,7 +3372,7 @@ static int ext4_fill_super(struct super_
 		}
 		if (test_opt(sb, DIOREAD_NOLOCK)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "both data=journal and delalloc");
+				 "both data=journal and dioread_nolock");
 			goto failed_mount;
 		}
 		if (test_opt(sb, DELALLOC))
@@ -4539,6 +4539,21 @@ static int ext4_remount(struct super_blo
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
 

