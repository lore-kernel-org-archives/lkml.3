Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaBLITx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:19:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50298 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194AbaBLIOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:10 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Al Viro" <viro@zeniv.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, "Al Viro" <viro@zeniv.linux.org.uk>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.344403920@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 36/79] ext4: fix del_timer() misuse for ->s_err_report
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -819,7 +819,7 @@ static void ext4_put_super(struct super_
 			ext4_abort(sb, "Couldn't clean up the journal");
 	}
 
-	del_timer(&sbi->s_err_report);
+	del_timer_sync(&sbi->s_err_report);
 	ext4_release_system_zone(sb);
 	ext4_mb_release(sb);
 	ext4_ext_release(sb);
@@ -3961,7 +3961,7 @@ failed_mount_wq:
 		sbi->s_journal = NULL;
 	}
 failed_mount3:
-	del_timer(&sbi->s_err_report);
+	del_timer_sync(&sbi->s_err_report);
 	if (sbi->s_flex_groups)
 		ext4_kvfree(sbi->s_flex_groups);
 	percpu_counter_destroy(&sbi->s_freeclusters_counter);

