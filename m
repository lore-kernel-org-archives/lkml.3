Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab3FDWoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:44:20 -0400
Received: from 1wt.eu ([62.212.114.60]:35869 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465Ab3FDWoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:44:16 -0400
Message-Id: <20130604172135.243236388@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:29 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 119/184] jbd: Fix lock ordering bug in journal_unmap_buffer()
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/jbd/transaction.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 4eff79c..1352e60 100644
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
1.7.12.2.21.g234cd45.dirty



