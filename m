Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab3IKS0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:26:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21702 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259Ab3IKS0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:26:44 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=5BtIMuNg2zEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=usl0TziCTeQA:10 a=20KFwNOVAAAA:8 a=JDjsHSkAAAAA:8 a=VwQbUJbxAAAA:8 a=QpReyVgdzlHooMvH2x8A:9 a=jEp0ucaQiEUA:10 a=Hf6muOzgCGQA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042904.376762940@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bryan Schumaker <bjschuma@netapp.com>, David Jeffery <djeffery@redhat.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [072/251] lockd: protect nlm_blocked access in nlmsvc_retry_blocked
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0072-lockd-protect-nlm_blocked-access-in-nlmsvc_retry_blo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: David Jeffery <djeffery@redhat.com>

[ Upstream commit 1c327d962fc420aea046c16215a552710bde8231 ]

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
Cc: stable@vger.kernel.org
Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/lockd/svclock.c |    4 ++++
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
1.7.10.4


