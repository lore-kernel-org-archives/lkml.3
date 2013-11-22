Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab3KVKfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 05:35:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755242Ab3KVKfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 05:35:48 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/2] GFS2: fix potential NULL pointer dereference
Date: Fri, 22 Nov 2013 10:35:34 +0000
Message-Id: <1385116535-4564-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1385116535-4564-1-git-send-email-swhiteho@redhat.com>
References: <1385116535-4564-1-git-send-email-swhiteho@redhat.com>
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
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

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
1.8.3.1

