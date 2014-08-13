Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaHMPvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 11:51:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbaHMPvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 11:51:36 -0400
Date: Wed, 13 Aug 2014 11:50:00 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, peterz@infradead.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com
Subject: [PATCH] fix sighand use after free
Message-ID: <20140813115000.73da6136@cuia.bos.redhat.com>
Organization: Red Hat, Inc
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: fix sighand use after free

__lock_task_sighand carefully takes the rcu_read_lock, gets
tsk->sighand with rcu_dereference, and verifies that the task
is still using the sighand_struct after taking the spinlock.

This works much better if the sighand struct is actually rcu
freed.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/fork.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 1380d8a..754a7c6 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1017,7 +1017,7 @@ void __cleanup_sighand(struct sighand_struct *sighand)
 {
 	if (atomic_dec_and_test(&sighand->count)) {
 		signalfd_cleanup(sighand);
-		kmem_cache_free(sighand_cachep, sighand);
+		rcu_free(sighand_cachep, sighand);
 	}
 }
 

