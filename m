Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbaKRPNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:13:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918AbaKROJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:33 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 063/206] UBIFS: fix a race condition
Date: Tue, 18 Nov 2014 15:06:58 +0100
Message-Id: <c52a27957eb0e9f84c7d43767d0b41c6415ee2c8.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 052c28073ff26f771d44ef33952a41d18dadd255 upstream.

Hu (hujianyang@huawei.com) discovered a race condition which may lead to a
situation when UBIFS is unable to mount the file-system after an unclean
reboot. The problem is theoretical, though.

In UBIFS, we have the log, which basically a set of LEBs in a certain area. The
log has the tail and the head.

Every time user writes data to the file-system, the UBIFS journal grows, and
the log grows as well, because we append new reference nodes to the head of the
log. So the head moves forward all the time, while the log tail stays at the
same position.

At any time, the UBIFS master node points to the tail of the log. When we mount
the file-system, we scan the log, and we always start from its tail, because
this is where the master node points to. The only occasion when the tail of the
log changes is the commit operation.

The commit operation has 2 phases - "commit start" and "commit end". The former
is relatively short, and does not involve much I/O. During this phase we mostly
just build various in-memory lists of the things which have to be written to
the flash media during "commit end" phase.

During the commit start phase, what we do is we "clean" the log. Indeed, the
commit operation will index all the data in the journal, so the entire journal
"disappears", and therefore the data in the log become unneeded. So we just
move the head of the log to the next LEB, and write the CS node there. This LEB
will be the tail of the new log when the commit operation finishes.

When the "commit start" phase finishes, users may write more data to the
file-system, in parallel with the ongoing "commit end" operation. At this point
the log tail was not changed yet, it is the same as it had been before we
started the commit. The log head keeps moving forward, though.

The commit operation now needs to write the new master node, and the new master
node should point to the new log tail. After this the LEBs between the old log
tail and the new log tail can be unmapped and re-used again.

And here is the possible problem. We do 2 operations: (a) We first update the
log tail position in memory (see 'ubifs_log_end_commit()'). (b) And then we
write the master node (see the big lock of code in 'do_commit()').

But nothing prevents the log head from moving forward between (a) and (b), and
the log head may "wrap" now to the old log tail. And when the "wrap" happens,
the contends of the log tail gets erased. Now a power cut happens and we are in
trouble. We end up with the old master node pointing to the old tail, which was
erased. And replay fails because it expects the master node to point to the
correct log tail at all times.

This patch merges the abovementioned (a) and (b) operations by moving the master
node change code to the 'ubifs_log_end_commit()' function, so that it runs with
the log mutex locked, which will prevent the log from being changed benween
operations (a) and (b).

Reported-by: hujianyang <hujianyang@huawei.com>
Tested-by: hujianyang <hujianyang@huawei.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ubifs/commit.c |  8 +++-----
 fs/ubifs/log.c    | 11 ++++++++---
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/ubifs/commit.c b/fs/ubifs/commit.c
index aa13ad053b14..26b69b2d4a45 100644
--- a/fs/ubifs/commit.c
+++ b/fs/ubifs/commit.c
@@ -166,10 +166,6 @@ static int do_commit(struct ubifs_info *c)
 	err = ubifs_orphan_end_commit(c);
 	if (err)
 		goto out;
-	old_ltail_lnum = c->ltail_lnum;
-	err = ubifs_log_end_commit(c, new_ltail_lnum);
-	if (err)
-		goto out;
 	err = dbg_check_old_index(c, &zroot);
 	if (err)
 		goto out;
@@ -202,7 +198,9 @@ static int do_commit(struct ubifs_info *c)
 		c->mst_node->flags |= cpu_to_le32(UBIFS_MST_NO_ORPHS);
 	else
 		c->mst_node->flags &= ~cpu_to_le32(UBIFS_MST_NO_ORPHS);
-	err = ubifs_write_master(c);
+
+	old_ltail_lnum = c->ltail_lnum;
+	err = ubifs_log_end_commit(c, new_ltail_lnum);
 	if (err)
 		goto out;
 
diff --git a/fs/ubifs/log.c b/fs/ubifs/log.c
index 36bd4efd0819..be67120fb919 100644
--- a/fs/ubifs/log.c
+++ b/fs/ubifs/log.c
@@ -447,9 +447,9 @@ out:
  * @ltail_lnum: new log tail LEB number
  *
  * This function is called on when the commit operation was finished. It
- * moves log tail to new position and unmaps LEBs which contain obsolete data.
- * Returns zero in case of success and a negative error code in case of
- * failure.
+ * moves log tail to new position and updates the master node so that it stores
+ * the new log tail LEB number. Returns zero in case of success and a negative
+ * error code in case of failure.
  */
 int ubifs_log_end_commit(struct ubifs_info *c, int ltail_lnum)
 {
@@ -477,7 +477,12 @@ int ubifs_log_end_commit(struct ubifs_info *c, int ltail_lnum)
 	spin_unlock(&c->buds_lock);
 
 	err = dbg_check_bud_bytes(c);
+	if (err)
+		goto out;
 
+	err = ubifs_write_master(c);
+
+out:
 	mutex_unlock(&c->log_mutex);
 	return err;
 }
-- 
2.1.3

