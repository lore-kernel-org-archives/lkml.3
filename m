Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbaAMQ6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:58:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53046 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbaAMQCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kent Overstreet <kmo@daterainc.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 054/208] bcache: Fix dirty_data accounting
Date: Mon, 13 Jan 2014 15:58:15 +0000
Message-Id: <1389628849-1614-55-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kmo@daterainc.com>

commit d24a6e1087030b6da286df9433add5fa2f21b83b upstream.

Dirty data accounting wasn't quite right - firstly, we were adding the key we're
inserting after it could have merged with another dirty key already in the
btree, and secondly we could sometimes pass the wrong offset to
bcache_dev_sectors_dirty_add() for dirty data we were overwriting - which is
important when tracking dirty data by stripe.

NOTE FOR BACKPORTERS: For 3.10 (and 3.11?) there's other accounting fixes
necessary that got squashed in with other patches; the full patch against 3.10
is 408cc2f47eeac93a, available at:
  git://evilpiepirate.org/~kent/linux-bcache.git bcache-3.10-writeback-fixes

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
[ luis: backported to 3.11:
  - replaced usage of 'replace_key' by '&op->replace'
    (all the additional bits required for 3.10 are already included ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/bcache/btree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 9e6c9f5..230d81e 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1673,7 +1673,8 @@ static bool fix_overlapping_extents(struct btree *b,
 			if (KEY_START(k) > KEY_START(insert) + sectors_found)
 				goto check_failed;
 
-			if (KEY_PTRS(&op->replace) != KEY_PTRS(k))
+			if (KEY_PTRS(k) != KEY_PTRS(&op->replace) ||
+			    KEY_DIRTY(k) != KEY_DIRTY(&op->replace))
 				goto check_failed;
 
 			/* skip past gen */
-- 
1.8.3.2

