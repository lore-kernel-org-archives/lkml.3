Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761204AbbA1ERq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:17:46 -0500
Received: from mail.kernel.org ([198.145.29.136]:38204 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761174AbbA1ERn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:17:43 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Al Viro <viro@zeniv.linux.org.uk>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 045/177] fs: Fix theoretical division by 0 in super_cache_scan().
Date: Wed, 28 Jan 2015 12:07:37 +0800
Message-Id: <1422418236-12852-90-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/super.c b/fs/super.c
index 3c520a5..d0154e5 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -69,6 +69,8 @@ static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
 
 	total_objects = sb->s_nr_dentry_unused +
 			sb->s_nr_inodes_unused + fs_objects + 1;
+	if (!total_objects)
+		total_objects = 1;
 
 	if (sc->nr_to_scan) {
 		int	dentries;
-- 
1.9.1

