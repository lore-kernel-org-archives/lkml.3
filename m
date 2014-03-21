Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760412AbaCUQQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 12:16:57 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:7761 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420AbaCUQQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 12:16:52 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4OAJdlLFNbtAWg/2dsb2JhbABZgwaDR8AmAgKBFBd0glMTHCMYgQIkE4d9AdAAjmqEPwSYSAGKWYdYgy48
Date: Fri, 21 Mar 2014 17:18:30 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: reiserfs-devel@vger.kernel.org, akpm <akpm@linux-foundation.org>
Subject: [RFC 1/1] fs/reiserfs/journal.c: Remove obsolete  __GFP_NOFAIL
Message-Id: <20140321171830.ef47fdea1a3a2f2921c8fe86@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Loop around congestion_wait on allocation failure/alloc_journal_list
like already fixed in other FS.

(Does it need returning -ENOMEM after some retries ?)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/reiserfs/journal.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index fd77703..e8c56a9 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -2487,8 +2487,13 @@ static int journal_read(struct super_block *sb)
 static struct reiserfs_journal_list *alloc_journal_list(struct super_block *s)
 {
 	struct reiserfs_journal_list *jl;
-	jl = kzalloc(sizeof(struct reiserfs_journal_list),
-		     GFP_NOFS | __GFP_NOFAIL);
+
+	do {
+		jl = kzalloc(sizeof(struct reiserfs_journal_list), GFP_NOFS);
+		if (unlikely(!jl))
+			congestion_wait(BLK_RW_ASYNC, HZ/50);
+	} while (!jl)
+
 	INIT_LIST_HEAD(&jl->j_list);
 	INIT_LIST_HEAD(&jl->j_working_list);
 	INIT_LIST_HEAD(&jl->j_tail_bh_list);
-- 
1.8.4.5

