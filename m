Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbaIZKhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:37:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680AbaIZJp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:45:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Liu Bo <bo.li.liu@oracle.com>,
        Chris Mason <clm@fb.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 012/142] Btrfs: fix compressed write corruption on enospc
Date: Fri, 26 Sep 2014 11:43:43 +0200
Message-Id: <28758933a321c0eb053fa6f85c9426882bf7e44c.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Bo <bo.li.liu@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ce62003f690dff38d3164a632ec69efa15c32cbf upstream.

When failing to allocate space for the whole compressed extent, we'll
fallback to uncompressed IO, but we've forgotten to redirty the pages
which belong to this compressed extent, and these 'clean' pages will
simply skip 'submit' part and go to endio directly, at last we got data
corruption as we write nothing.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Tested-By: Martin Steigerwald <martin@lichtvoll.de>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/inode.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index fa8010c1b628..7e6758d075ad 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -683,6 +683,18 @@ retry:
 				unlock_extent(io_tree, async_extent->start,
 					      async_extent->start +
 					      async_extent->ram_size - 1);
+
+				/*
+				 * we need to redirty the pages if we decide to
+				 * fallback to uncompressed IO, otherwise we
+				 * will not submit these pages down to lower
+				 * layers.
+				 */
+				extent_range_redirty_for_io(inode,
+						async_extent->start,
+						async_extent->start +
+						async_extent->ram_size - 1);
+
 				goto retry;
 			}
 			goto out_free;
-- 
2.1.0

