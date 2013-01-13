Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab3AMR5u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:57:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34936 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754928Ab3AMRpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:22 -0500
Message-Id: <20130113174256.696932018@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:42:59 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 04/49] jbd2: fix assertion failure in jbd2_journal_flush()
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/jbd2/transaction.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index deffd94..cd4485d 100644
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


