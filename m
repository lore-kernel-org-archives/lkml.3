Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab3APAQC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:16:02 -0500
Received: from mail.kernel.org ([198.145.19.201]:42570 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758367Ab3AOWcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:32:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 111/221] jbd2: fix assertion failure in jbd2_journal_flush()
Date: Tue, 15 Jan 2013 10:50:38 -0800
Message-Id: <20130115185006.061661488@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jbd2/transaction.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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


