Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933457AbbAIK6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:58:41 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44503 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757225AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 36/78] isofs: Fix infinite looping over CE entries
Date: Fri,  9 Jan 2015 11:31:45 +0100
Message-Id: <fbce0d7dc8965c9fb8d411862040239d4a768c71.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f54e18f1b831c92f6512d2eedb224cd63d607d3d upstream.

Rock Ridge extensions define so called Continuation Entries (CE) which
define where is further space with Rock Ridge data. Corrupted isofs
image can contain arbitrarily long chain of these, including a one
containing loop and thus causing kernel to end in an infinite loop when
traversing these entries.

Limit the traversal to 32 entries which should be more than enough space
to store all the Rock Ridge data.

Reported-by: P J P <ppandit@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/isofs/rock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/isofs/rock.c b/fs/isofs/rock.c
index f488bbae541a..bb63254ed848 100644
--- a/fs/isofs/rock.c
+++ b/fs/isofs/rock.c
@@ -30,6 +30,7 @@ struct rock_state {
 	int cont_size;
 	int cont_extent;
 	int cont_offset;
+	int cont_loops;
 	struct inode *inode;
 };
 
@@ -73,6 +74,9 @@ static void init_rock_state(struct rock_state *rs, struct inode *inode)
 	rs->inode = inode;
 }
 
+/* Maximum number of Rock Ridge continuation entries */
+#define RR_MAX_CE_ENTRIES 32
+
 /*
  * Returns 0 if the caller should continue scanning, 1 if the scan must end
  * and -ve on error.
@@ -105,6 +109,8 @@ static int rock_continue(struct rock_state *rs)
 			goto out;
 		}
 		ret = -EIO;
+		if (++rs->cont_loops >= RR_MAX_CE_ENTRIES)
+			goto out;
 		bh = sb_bread(rs->inode->i_sb, rs->cont_extent);
 		if (bh) {
 			memcpy(rs->buffer, bh->b_data + rs->cont_offset,
-- 
2.2.1

