Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbbAOWOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 17:14:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50455 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbbAOWKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 17:10:11 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 10/19] isofs: Fix infinite looping over CE entries
Date: Thu, 15 Jan 2015 14:09:46 -0800
Message-Id: <1421359795-11155-11-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421359795-11155-1-git-send-email-kamal@canonical.com>
References: <1421359795-11155-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/isofs/rock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/isofs/rock.c b/fs/isofs/rock.c
index f488bba..bb63254 100644
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
1.9.1

