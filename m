Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbaG3Mim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:38:42 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36661 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752805AbaG3MP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Niu Yawei <yawei.niu@gmail.com>,
        Niu Yawei <yawei.niu@intel.com>, Jan Kara <jack@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 28/94] quota: missing lock in dqcache_shrink_scan()
Date: Wed, 30 Jul 2014 14:14:17 +0200
Message-Id: <51a009349eb711296f6719cc4e5bfbf3bcd69999.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Niu Yawei <yawei.niu@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d68aab6b8f572406aa93b45ef6483934dd3b54a6 upstream.

Commit 1ab6c4997e04 (fs: convert fs shrinkers to new scan/count API)
accidentally removed locking from quota shrinker. Fix it -
dqcache_shrink_scan() should use dq_list_lock to protect the
scan on free_dquots list.

Fixes: 1ab6c4997e04a00c50c6d786c2f046adc0d1f5de
Signed-off-by: Niu Yawei <yawei.niu@intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/quota/dquot.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 9cd5f63715c0..7f30bdc57d13 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -702,6 +702,7 @@ dqcache_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 	struct dquot *dquot;
 	unsigned long freed = 0;
 
+	spin_lock(&dq_list_lock);
 	head = free_dquots.prev;
 	while (head != &free_dquots && sc->nr_to_scan) {
 		dquot = list_entry(head, struct dquot, dq_free);
@@ -713,6 +714,7 @@ dqcache_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 		freed++;
 		head = free_dquots.prev;
 	}
+	spin_unlock(&dq_list_lock);
 	return freed;
 }
 
-- 
2.0.1

