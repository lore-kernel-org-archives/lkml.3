Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933595AbaKRPCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:02:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57191 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131AbaKROJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:47 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Al Viro <viro@zeniv.linux.org.uk>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 060/206] fs: Fix theoretical division by 0 in super_cache_scan().
Date: Tue, 18 Nov 2014 15:06:55 +0100
Message-Id: <b44a6e3363bd7f61502207c53537ce98c2818070.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 475d0db742e3755c6b267f48577ff7cbb7dfda0d upstream.

total_objects could be 0 and is used as a denom.

While total_objects is a "long", total_objects == 0 unlikely happens for
3.12 and later kernels because 32-bit architectures would not be able to
hold (1 << 32) objects. However, total_objects == 0 may happen for kernels
between 3.1 and 3.11 because total_objects in prune_super() was an "int"
and (e.g.) x86_64 architecture might be able to hold (1 << 32) objects.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/super.c b/fs/super.c
index fb68a4c90c98..3e39572b2f51 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -81,6 +81,8 @@ static unsigned long super_cache_scan(struct shrinker *shrink,
 	inodes = list_lru_count_node(&sb->s_inode_lru, sc->nid);
 	dentries = list_lru_count_node(&sb->s_dentry_lru, sc->nid);
 	total_objects = dentries + inodes + fs_objects + 1;
+	if (!total_objects)
+		total_objects = 1;
 
 	/* proportion the scan between the caches */
 	dentries = mult_frac(sc->nr_to_scan, dentries, total_objects);
-- 
2.1.3

