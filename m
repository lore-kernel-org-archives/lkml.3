Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615AbaIRS37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 14:29:59 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:14300 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932117AbaIRS35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:29:57 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvcNAGYkG1RbsHJU/2dsb2JhbABggw2BKrURAQEEBQFxmwqBCxcBeYQxLyOBGjeIQgGyEZBFhgmJCmQdhDUFnQyVSINgOy+BBoFEAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
Subject: [PATCH 1/1 linux-next] jbd2: Fix sparse context imbalance warning
Date: Thu, 18 Sep 2014 20:29:34 +0200
Message-Id: <1411064974-18304-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

spin_unlock after spin_lock only.

This fixes the following sparse warning:
fs/jbd2/transaction.c:1102:20: warning: context imbalance
in 'jbd2_journal_get_create_access' - different lock contexts for basic block

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/jbd2/transaction.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 5f09370..edb7f59 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1091,6 +1091,7 @@ int jbd2_journal_get_create_access(handle_t *handle, struct buffer_head *bh)
 		JBUFFER_TRACE(jh, "file as BJ_Reserved");
 		spin_lock(&journal->j_list_lock);
 		__jbd2_journal_file_buffer(jh, transaction, BJ_Reserved);
+		spin_unlock(&journal->j_list_lock);
 	} else if (jh->b_transaction == journal->j_committing_transaction) {
 		/* first access by this transaction */
 		jh->b_modified = 0;
@@ -1098,8 +1099,8 @@ int jbd2_journal_get_create_access(handle_t *handle, struct buffer_head *bh)
 		JBUFFER_TRACE(jh, "set next transaction");
 		spin_lock(&journal->j_list_lock);
 		jh->b_next_transaction = transaction;
+		spin_unlock(&journal->j_list_lock);
 	}
-	spin_unlock(&journal->j_list_lock);
 	jbd_unlock_bh_state(bh);
 
 	/*
-- 
1.9.1

