Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab3KLMaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 07:30:20 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:35715 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab3KLMaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 07:30:10 -0500
From: Michal Nazarewicz <mpn@google.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH] gfs2: fix potential NULL pointer dereference
Date: Tue, 12 Nov 2013 13:30:05 +0100
Message-Id: <1384259405-7913-1-git-send-email-mpn@google.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

Commit [e66cf1610: GFS2: Use lockref for glocks] replaced call:
    atomic_read(&gi->gl->gl_ref) == 0
with:
    __lockref_is_dead(&gl->gl_lockref)
therefore changing how gl is accessed, from gi->gl to plan gl.
However, gl can be a NULL pointer, and so gi->gl needs to be
used instead (which is guaranteed not to be NULL because fo
the while loop checking that condition).

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 fs/gfs2/glock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index e66a800..c8420f7 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1899,7 +1899,8 @@ static int gfs2_glock_iter_next(struct gfs2_glock_iter *gi)
 			gi->nhash = 0;
 		}
 	/* Skip entries for other sb and dead entries */
-	} while (gi->sdp != gi->gl->gl_sbd || __lockref_is_dead(&gl->gl_lockref));
+	} while (gi->sdp != gi->gl->gl_sbd ||
+		 __lockref_is_dead(&gi->gl->gl_lockref));
 
 	return 0;
 }
-- 
1.8.4.1

