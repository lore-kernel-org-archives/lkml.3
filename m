Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbaAOV5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:57:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41032 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbaAOV5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:57:47 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Theodore Ts'o" <tytso@mit.edu>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 103/166] ext4: fix del_timer() misuse for ->s_err_report
Date: Wed, 15 Jan 2014 13:51:57 -0800
Message-Id: <1389822780-4729-104-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit 9105bb149bbbc555d2e11ba5166dfe7a24eae09e upstream.

That thing should be del_timer_sync(); consider what happens
if ext4_put_super() call of del_timer() happens to come just as it's
getting run on another CPU.  Since that timer reschedules itself
to run next day, you are pretty much guaranteed that you'll end up
with kfree'd scheduled timer, with usual fun consequences.  AFAICS,
that's -stable fodder all way back to 2010... [the second del_timer_sync()
is almost certainly not needed, but it doesn't hurt either]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b83f75d..c27683e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -861,7 +861,7 @@ static void ext4_put_super(struct super_block *sb)
 			ext4_abort(sb, "Couldn't clean up the journal");
 	}
 
-	del_timer(&sbi->s_err_report);
+	del_timer_sync(&sbi->s_err_report);
 	ext4_release_system_zone(sb);
 	ext4_mb_release(sb);
 	ext4_ext_release(sb);
@@ -4055,7 +4055,7 @@ failed_mount_wq:
 		sbi->s_journal = NULL;
 	}
 failed_mount3:
-	del_timer(&sbi->s_err_report);
+	del_timer_sync(&sbi->s_err_report);
 	if (sbi->s_flex_groups)
 		ext4_kvfree(sbi->s_flex_groups);
 	percpu_counter_destroy(&sbi->s_freeclusters_counter);
-- 
1.8.3.2

