Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266Ab3GZVBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:01:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51443 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760175Ab3GZU6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:58:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Jeffery <djeffery@redhat.com>,
        Bryan Schumaker <bjschuma@netapp.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 41/45] lockd: protect nlm_blocked access in nlmsvc_retry_blocked
Date: Fri, 26 Jul 2013 13:58:01 -0700
Message-Id: <20130726205659.457386118@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726205654.896050165@linuxfoundation.org>
References: <20130726205654.896050165@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: David Jeffery <djeffery@redhat.com>
Cc: Bryan Schumaker <bjschuma@netapp.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/lockd/svclock.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -913,6 +913,7 @@ nlmsvc_retry_blocked(void)
 	unsigned long	timeout = MAX_SCHEDULE_TIMEOUT;
 	struct nlm_block *block;
 
+	spin_lock(&nlm_blocked_lock);
 	while (!list_empty(&nlm_blocked) && !kthread_should_stop()) {
 		block = list_entry(nlm_blocked.next, struct nlm_block, b_list);
 
@@ -922,6 +923,7 @@ nlmsvc_retry_blocked(void)
 			timeout = block->b_when - jiffies;
 			break;
 		}
+		spin_unlock(&nlm_blocked_lock);
 
 		dprintk("nlmsvc_retry_blocked(%p, when=%ld)\n",
 			block, block->b_when);
@@ -931,7 +933,9 @@ nlmsvc_retry_blocked(void)
 			retry_deferred_block(block);
 		} else
 			nlmsvc_grant_blocked(block);
+		spin_lock(&nlm_blocked_lock);
 	}
+	spin_unlock(&nlm_blocked_lock);
 
 	return timeout;
 }


