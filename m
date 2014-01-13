Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaAMQBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:01:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52951 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbaAMQBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 033/208] ext4: fix del_timer() misuse for ->s_err_report
Date: Mon, 13 Jan 2014 15:57:54 +0000
Message-Id: <1389628849-1614-34-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b59373b..e222177 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -775,7 +775,7 @@ static void ext4_put_super(struct super_block *sb)
 	}
 
 	ext4_es_unregister_shrinker(sbi);
-	del_timer(&sbi->s_err_report);
+	del_timer_sync(&sbi->s_err_report);
 	ext4_release_system_zone(sb);
 	ext4_mb_release(sb);
 	ext4_ext_release(sb);
@@ -4124,7 +4124,7 @@ failed_mount_wq:
 	}
 failed_mount3:
 	ext4_es_unregister_shrinker(sbi);
-	del_timer(&sbi->s_err_report);
+	del_timer_sync(&sbi->s_err_report);
 	if (sbi->s_flex_groups)
 		ext4_kvfree(sbi->s_flex_groups);
 	percpu_counter_destroy(&sbi->s_freeclusters_counter);
-- 
1.8.3.2

