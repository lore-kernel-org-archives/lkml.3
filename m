Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934429Ab3GQXRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:17:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56530 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934393Ab3GQWy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:54:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bryan Schumaker <bjschuma@netapp.com>, David Jeffery <djeffery@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 142/145] lockd: protect nlm_blocked access in nlmsvc_retry_blocked
Date: Wed, 17 Jul 2013 15:47:54 -0700
Message-Id: <1374101277-7915-143-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Jeffery <djeffery@redhat.com>

commit 1c327d962fc420aea046c16215a552710bde8231 upstream.

In nlmsvc_retry_blocked, the check that the list is non-empty and acquiring
the pointer of the first entry is unprotected by any lock.  This allows a rare
race condition when there is only one entry on the list.  A function such as
nlmsvc_grant_callback() can be called, which will temporarily remove the entry
from the list.  Between the list_empty() and list_entry(),the list may become
empty, causing an invalid pointer to be used as an nlm_block, leading to a
possible crash.

This patch adds the nlm_block_lock around these calls to prevent concurrent
use of the nlm_blocked list.

This was a regression introduced by
f904be9cc77f361d37d71468b13ff3d1a1823dea  "lockd: Mostly remove BKL from
the server".

Cc: Bryan Schumaker <bjschuma@netapp.com>
Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/lockd/svclock.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index 8d80c99..57a3922 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -939,6 +939,7 @@ nlmsvc_retry_blocked(void)
 	unsigned long	timeout = MAX_SCHEDULE_TIMEOUT;
 	struct nlm_block *block;
 
+	spin_lock(&nlm_blocked_lock);
 	while (!list_empty(&nlm_blocked) && !kthread_should_stop()) {
 		block = list_entry(nlm_blocked.next, struct nlm_block, b_list);
 
@@ -948,6 +949,7 @@ nlmsvc_retry_blocked(void)
 			timeout = block->b_when - jiffies;
 			break;
 		}
+		spin_unlock(&nlm_blocked_lock);
 
 		dprintk("nlmsvc_retry_blocked(%p, when=%ld)\n",
 			block, block->b_when);
@@ -957,7 +959,9 @@ nlmsvc_retry_blocked(void)
 			retry_deferred_block(block);
 		} else
 			nlmsvc_grant_blocked(block);
+		spin_lock(&nlm_blocked_lock);
 	}
+	spin_unlock(&nlm_blocked_lock);
 
 	return timeout;
 }
-- 
1.8.1.2

