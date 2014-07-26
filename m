Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbaGZTh6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:37:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbaGZTNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Niu Yawei <yawei.niu@intel.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 3.15 026/109] quota: missing lock in dqcache_shrink_scan()
Date: Sat, 26 Jul 2014 12:01:48 -0700
Message-Id: <20140726190224.618930283@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niu Yawei <yawei.niu@gmail.com>

commit d68aab6b8f572406aa93b45ef6483934dd3b54a6 upstream.

Commit 1ab6c4997e04 (fs: convert fs shrinkers to new scan/count API)
accidentally removed locking from quota shrinker. Fix it -
dqcache_shrink_scan() should use dq_list_lock to protect the
scan on free_dquots list.

Fixes: 1ab6c4997e04a00c50c6d786c2f046adc0d1f5de
Signed-off-by: Niu Yawei <yawei.niu@intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/quota/dquot.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -702,6 +702,7 @@ dqcache_shrink_scan(struct shrinker *shr
 	struct dquot *dquot;
 	unsigned long freed = 0;
 
+	spin_lock(&dq_list_lock);
 	head = free_dquots.prev;
 	while (head != &free_dquots && sc->nr_to_scan) {
 		dquot = list_entry(head, struct dquot, dq_free);
@@ -713,6 +714,7 @@ dqcache_shrink_scan(struct shrinker *shr
 		freed++;
 		head = free_dquots.prev;
 	}
+	spin_unlock(&dq_list_lock);
 	return freed;
 }
 


