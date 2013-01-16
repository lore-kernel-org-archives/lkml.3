Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab3APQIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:08:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36678 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568Ab3APQIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:08:20 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 168/222] jbd2: fix assertion failure in jbd2_journal_flush()
Date: Wed, 16 Jan 2013 13:56:08 -0200
Message-Id: <1358351822-7675-169-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit d7961c7fa4d2e3c3f12be67e21ba8799b5a7238a upstream.

The following race is possible between start_this_handle() and someone
calling jbd2_journal_flush().

Process A                              Process B
start_this_handle().
  if (journal->j_barrier_count) # false
  if (!journal->j_running_transaction) { #true
    read_unlock(&journal->j_state_lock);
                                       jbd2_journal_lock_updates()
                                       jbd2_journal_flush()
                                         write_lock(&journal->j_state_lock);
                                         if (journal->j_running_transaction) {
                                           # false
                                         ... wait for committing trans ...
                                         write_unlock(&journal->j_state_lock);
    ...
    write_lock(&journal->j_state_lock);
    if (!journal->j_running_transaction) { # true
      jbd2_get_transaction(journal, new_transaction);
    write_unlock(&journal->j_state_lock);
    goto repeat; # eventually blocks on j_barrier_count > 0
                                         ...
                                         J_ASSERT(!journal->j_running_transaction);
                                           # fails

We fix the race by rechecking j_barrier_count after reacquiring j_state_lock
in exclusive mode.

Reported-by: yjwsignal@empal.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/jbd2/transaction.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index fb1ab953..2fb20f5 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -209,7 +209,8 @@ repeat:
 		if (!new_transaction)
 			goto alloc_transaction;
 		write_lock(&journal->j_state_lock);
-		if (!journal->j_running_transaction) {
+		if (!journal->j_running_transaction &&
+		    !journal->j_barrier_count) {
 			jbd2_get_transaction(journal, new_transaction);
 			new_transaction = NULL;
 		}
-- 
1.7.9.5

