Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaJ0TFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:05:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52906 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbaJ0TFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:05:00 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Al Viro <viro@zeniv.linux.org.uk>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 084/105] fs: Fix theoretical division by 0 in super_cache_scan().
Date: Mon, 27 Oct 2014 11:56:59 -0700
Message-Id: <1414436240-13879-85-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/super.c b/fs/super.c
index e5f6c2c..97edaa93 100644
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
1.9.1

