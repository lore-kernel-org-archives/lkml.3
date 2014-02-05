Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbaBEUHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:07:53 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48499 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184AbaBEUHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:25 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>, Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 165/213] jbd: Fix lock ordering bug in journal_unmap_buffer()
Date: Wed, 5 Feb 2014 15:02:00 -0500
Message-ID: <1391630568-49251-166-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 25389bb207987b5774182f763b9fb65ff08761c8 upstream.

Commit 09e05d48 introduced a wait for transaction commit into
journal_unmap_buffer() in the case we are truncating a buffer undergoing commit
in the page stradding i_size on a filesystem with blocksize < pagesize. Sadly
we forgot to drop buffer lock before waiting for transaction commit and thus
deadlock is possible when kjournald wants to lock the buffer.

Fix the problem by dropping the buffer lock before waiting for transaction
commit. Since we are still holding page lock (and that is OK), buffer cannot
disappear under us.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/jbd/transaction.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index bc8ab97dcd90..590e23885c98 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -1956,7 +1956,9 @@ retry:
 			spin_unlock(&journal->j_list_lock);
 			jbd_unlock_bh_state(bh);
 			spin_unlock(&journal->j_state_lock);
+			unlock_buffer(bh);
 			log_wait_commit(journal, tid);
+			lock_buffer(bh);
 			goto retry;
 		}
 		/*
-- 
1.8.5.2

