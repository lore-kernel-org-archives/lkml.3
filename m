Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab3APQFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:05:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36233 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab3APQFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:05:00 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 118/222] jffs2: hold erase_completion_lock on exit
Date: Wed, 16 Jan 2013 13:55:18 -0200
Message-Id: <1358351822-7675-119-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

commit 2cbba75a56ea78e6876b4e2547a882f10b3fe72b upstream.

Users of jffs2_do_reserve_space() expect they still held
erase_completion_lock after call to it. But there is a path
where jffs2_do_reserve_space() leaves erase_completion_lock unlocked.
The patch fixes it.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/jffs2/nodemgmt.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/jffs2/nodemgmt.c b/fs/jffs2/nodemgmt.c
index 0c96eb5..0331072 100644
--- a/fs/jffs2/nodemgmt.c
+++ b/fs/jffs2/nodemgmt.c
@@ -417,14 +417,16 @@ static int jffs2_do_reserve_space(struct jffs2_sb_info *c, uint32_t minsize,
 			spin_unlock(&c->erase_completion_lock);
 
 			ret = jffs2_prealloc_raw_node_refs(c, jeb, 1);
-			if (ret)
-				return ret;
+
 			/* Just lock it again and continue. Nothing much can change because
 			   we hold c->alloc_sem anyway. In fact, it's not entirely clear why
 			   we hold c->erase_completion_lock in the majority of this function...
 			   but that's a question for another (more caffeine-rich) day. */
 			spin_lock(&c->erase_completion_lock);
 
+			if (ret)
+				return ret;
+
 			waste = jeb->free_size;
 			jffs2_link_node_ref(c, jeb,
 					    (jeb->offset + c->sector_size - waste) | REF_OBSOLETE,
-- 
1.7.9.5

