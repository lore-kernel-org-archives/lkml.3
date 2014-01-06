Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbaAGACG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:02:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195AbaAFWiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, "Theodore Tso" <tytso@mit.edu>
Subject: [PATCH 3.12 053/144] ext4: fix del_timer() misuse for ->s_err_report
Date: Mon,  6 Jan 2014 14:36:54 -0800
Message-Id: <20140106223746.862339396@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -773,7 +773,7 @@ static void ext4_put_super(struct super_
 	}
 
 	ext4_es_unregister_shrinker(sbi);
-	del_timer(&sbi->s_err_report);
+	del_timer_sync(&sbi->s_err_report);
 	ext4_release_system_zone(sb);
 	ext4_mb_release(sb);
 	ext4_ext_release(sb);
@@ -4151,7 +4151,7 @@ failed_mount_wq:
 	}
 failed_mount3:
 	ext4_es_unregister_shrinker(sbi);
-	del_timer(&sbi->s_err_report);
+	del_timer_sync(&sbi->s_err_report);
 	if (sbi->s_flex_groups)
 		ext4_kvfree(sbi->s_flex_groups);
 	percpu_counter_destroy(&sbi->s_freeclusters_counter);


