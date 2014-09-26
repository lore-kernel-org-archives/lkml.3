Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaIZJp7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:45:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616AbaIZJpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:45:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Chris Mason <clm@fb.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 011/142] Btrfs: read lock extent buffer while walking backrefs
Date: Fri, 26 Sep 2014 11:43:42 +0200
Message-Id: <308d30d163995b77b264982dd463ae05aedeb0f9.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6f7ff6d7832c6be13e8c95598884dbc40ad69fb7 upstream.

Before processing the extent buffer, acquire a read lock on it, so
that we're safe against concurrent updates on the extent buffer.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/backref.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 715cfa42e182..53039de1495d 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -954,8 +954,11 @@ again:
 					ret = -EIO;
 					goto out;
 				}
+				btrfs_tree_read_lock(eb);
+				btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
 				ret = find_extent_in_eb(eb, bytenr,
 							*extent_item_pos, &eie);
+				btrfs_tree_read_unlock_blocking(eb);
 				free_extent_buffer(eb);
 				if (ret < 0)
 					goto out;
-- 
2.1.0

