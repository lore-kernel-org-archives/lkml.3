Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaHQMen (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 08:34:43 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37132 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbaHQMem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 08:34:42 -0400
Date: Sun, 17 Aug 2014 15:34:31 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] kernel/events/core.c: Replace rcu_dereference() with
 rcu_access_pointer()
Message-ID: <20140817123431.GA3571@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "rcu_dereference()" call is used directly in a condition.
Since its return value is never dereferenced it is recommended to use
"rcu_access_pointer()" instead of "rcu_dereference()".
Therefore, this patch makes the replacement.

The following Coccinelle semantic patch was used:
@@
@@

(
 if(
 (<+...
- rcu_dereference
+ rcu_access_pointer
  (...)
  ...+>)) {...}
|
 while(
 (<+...
- rcu_dereference
+ rcu_access_pointer
  (...)
  ...+>)) {...}
)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5fa58e4..0d735be 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -980,7 +980,7 @@ retry:
 		 * can't get swapped on us any more.
 		 */
 		raw_spin_lock_irqsave(&ctx->lock, *flags);
-		if (ctx != rcu_dereference(task->perf_event_ctxp[ctxn])) {
+		if (ctx != rcu_access_pointer(task->perf_event_ctxp[ctxn])) {
 			raw_spin_unlock_irqrestore(&ctx->lock, *flags);
 			rcu_read_unlock();
 			preempt_enable();
-- 
1.9.1

