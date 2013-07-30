Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab3G3Jcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:32:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52979 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab3G3Jca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bryan Schumaker <bjschuma@netapp.com>, David Jeffery <djeffery@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 014/106] lockd: protect nlm_blocked access in nlmsvc_retry_blocked
Date: Tue, 30 Jul 2013 10:30:33 +0100
Message-Id: <1375176725-5825-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/lockd/svclock.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index e46353f..aff1c61 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -941,6 +941,7 @@ nlmsvc_retry_blocked(void)
 	unsigned long	timeout = MAX_SCHEDULE_TIMEOUT;
 	struct nlm_block *block;
 
+	spin_lock(&nlm_blocked_lock);
 	while (!list_empty(&nlm_blocked) && !kthread_should_stop()) {
 		block = list_entry(nlm_blocked.next, struct nlm_block, b_list);
 
@@ -950,6 +951,7 @@ nlmsvc_retry_blocked(void)
 			timeout = block->b_when - jiffies;
 			break;
 		}
+		spin_unlock(&nlm_blocked_lock);
 
 		dprintk("nlmsvc_retry_blocked(%p, when=%ld)\n",
 			block, block->b_when);
@@ -959,7 +961,9 @@ nlmsvc_retry_blocked(void)
 			retry_deferred_block(block);
 		} else
 			nlmsvc_grant_blocked(block);
+		spin_lock(&nlm_blocked_lock);
 	}
+	spin_unlock(&nlm_blocked_lock);
 
 	return timeout;
 }
-- 
1.8.3.2

