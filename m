Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763512Ab3ECWLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 18:11:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab3ECWLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 18:11:32 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH v2] fs: Fix hang with BSD accounting on frozen filesystem
Date: Sat,  4 May 2013 00:11:23 +0200
Message-Id: <1367619083-8093-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When BSD process accounting is enabled and logs information to a
filesystem which gets frozen, system easily becomes unusable because
each attempt to account process information blocks. Thus e.g. every task
gets blocked in exit.

It seems better to drop accounting information (which can already happen
when filesystem is running out of space) instead of locking system up.
So we just skip the write if the filesystem is frozen.

Reported-by: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/acct.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

  Hi Al!

  I'm sending an updated fix for BSD process accounting hang. Can you please
merge it? Thanks!
								Honza

diff --git a/kernel/acct.c b/kernel/acct.c
index 85389fe..04606cc 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -540,10 +540,15 @@ static void do_acct_process(struct bsd_acct_struct *acct,
 	ac.ac_swaps = encode_comp_t(0);
 
 	/*
+	 * Get freeze protection. If the fs is frozen, just skip the write
+	 * as we could deadlock the system otherwise.
+	 */
+	if (!sb_start_write_trylock(file_inode(file)->i_sb))
+		goto out;
+	/*
 	 * Kernel segment override to datasegment and write it
 	 * to the accounting file.
 	 */
-	file_start_write(file);
 	fs = get_fs();
 	set_fs(KERNEL_DS);
 	/*
@@ -555,7 +560,7 @@ static void do_acct_process(struct bsd_acct_struct *acct,
 			       sizeof(acct_t), &file->f_pos);
 	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = flim;
 	set_fs(fs);
-	file_end_write(file);
+	sb_end_write(file_inode(file)->i_sb);
 out:
 	revert_creds(orig_cred);
 }
-- 
1.7.1

