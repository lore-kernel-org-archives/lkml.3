Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab3ASAkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 19:40:21 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:61248 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3ASAkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 19:40:17 -0500
Date: Fri, 18 Jan 2013 16:40:13 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Dan Williams <djbw@fb.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] async: use ULLONG_MAX for infinity cookie value
Message-ID: <20130119004013.GJ24579@htj.dyndns.org>
References: <20130119003923.GH24579@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130119003923.GH24579@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 25ad5d23db71cda13511f3c9c07ab0c88ece394c Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 18 Jan 2013 16:34:16 -0800

Currently, next_cookie is used as the infinity value.  In most cases,
this should work fine but it theoretically could bring subtle behavior
difference between async_synchronize_full() and
async_synchronize_full_domain().

async_synchronize_full() keeps waiting until there's no registered
async_entry left regardless of what next_cookie was when the function
was called.  It guarantees that the queue is completely drained at
least once before returning.

However, async_synchronize_full_domain() doesn't.  It synchronizes
upto next_cookie and if further async jobs are queued after the
next_cookie value to synchronize is decided, they won't be waited for.

For unrelated async jobs, the behavior difference doesn't matter;
however, if async jobs which are related (nested or otherwise) to the
executing ones are queued while sychronization is in progress, the
resulting behavior difference could be problematic.

This can be easily fixed by using ULLONG_MAX as the infinity value
instead.  Define ASYNC_COOKIE_MAX as ULLONG_MAX and use it as the
infinity value for synchronization.  This makes
async_synchronize_full_domain() fully drain the domain at least once
before returning, making its behavior match async_synchronize_full().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 kernel/async.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index c082fed..4cb4823 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -59,7 +59,8 @@ asynchronous and synchronous parts of the kernel.
 
 static async_cookie_t next_cookie = 1;
 
-#define MAX_WORK	32768
+#define MAX_WORK		32768
+#define ASYNC_COOKIE_MAX	ULLONG_MAX	/* infinity cookie */
 
 static LIST_HEAD(async_pending);
 static ASYNC_DOMAIN(async_dfl_domain);
@@ -86,8 +87,8 @@ static atomic_t entry_count;
  */
 static async_cookie_t __lowest_in_progress(struct async_domain *domain)
 {
-	async_cookie_t first_running = next_cookie;	/* infinity value */
-	async_cookie_t first_pending = next_cookie;	/* ditto */
+	async_cookie_t first_running = ASYNC_COOKIE_MAX;
+	async_cookie_t first_pending = ASYNC_COOKIE_MAX;
 	struct async_entry *entry;
 
 	/*
@@ -264,7 +265,7 @@ void async_synchronize_full(void)
 			domain = list_first_entry(&async_domains, typeof(*domain), node);
 		spin_unlock_irq(&async_lock);
 
-		async_synchronize_cookie_domain(next_cookie, domain);
+		async_synchronize_cookie_domain(ASYNC_COOKIE_MAX, domain);
 	} while (!list_empty(&async_domains));
 	mutex_unlock(&async_register_mutex);
 }
@@ -300,7 +301,7 @@ EXPORT_SYMBOL_GPL(async_unregister_domain);
  */
 void async_synchronize_full_domain(struct async_domain *domain)
 {
-	async_synchronize_cookie_domain(next_cookie, domain);
+	async_synchronize_cookie_domain(ASYNC_COOKIE_MAX, domain);
 }
 EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
 
-- 
1.8.0.2

