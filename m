Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab3FDWmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:42:35 -0400
Received: from 1wt.eu ([62.212.114.60]:35466 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab3FDWmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:23 -0400
Message-Id: <20130604172131.637553911@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:02 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Li Zhong <zhong@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@gmail.com>,
        Christian Kujau <lists@nerdbynature.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 032/184] Fix a dead loop in async_synchronize_full()
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zhong <zhong@linux.vnet.ibm.com>

[Fixed upstream by commits 2955b47d2c1983998a8c5915cb96884e67f7cb53 and
a4683487f90bfe3049686fc5c566bdc1ad03ace6 from Dan Williams, but they are much
more intrusive than this tiny fix, according to Andrew - gregkh]

This patch tries to fix a dead loop in  async_synchronize_full(), which
could be seen when preemption is disabled on a single cpu machine.

void async_synchronize_full(void)
{
        do {
                async_synchronize_cookie(next_cookie);
        } while (!list_empty(&async_running) || !
list_empty(&async_pending));
}

async_synchronize_cookie() calls async_synchronize_cookie_domain() with
&async_running as the default domain to synchronize.

However, there might be some works in the async_pending list from other
domains. On a single cpu system, without preemption, there is no chance
for the other works to finish, so async_synchronize_full() enters a dead
loop.

It seems async_synchronize_full() wants to synchronize all entries in
all running lists(domains), so maybe we could just check the entry_count
to know whether all works are finished.

Currently, async_synchronize_cookie_domain() expects a non-NULL running
list ( if NULL, there would be NULL pointer dereference ), so maybe a
NULL pointer could be used as an indication for the functions to
synchronize all works in all domains.

Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Christian Kujau <lists@nerdbynature.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/async.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index 27235f5..397a7c7 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -93,6 +93,13 @@ static async_cookie_t  __lowest_in_progress(struct list_head *running)
 {
 	struct async_entry *entry;
 
+	if (!running) { /* just check the entry count */
+		if (atomic_read(&entry_count))
+			return 0; /* smaller than any cookie */
+		else
+			return next_cookie;
+	}
+
 	if (!list_empty(running)) {
 		entry = list_first_entry(running,
 			struct async_entry, list);
@@ -248,9 +255,7 @@ EXPORT_SYMBOL_GPL(async_schedule_domain);
  */
 void async_synchronize_full(void)
 {
-	do {
-		async_synchronize_cookie(next_cookie);
-	} while (!list_empty(&async_running) || !list_empty(&async_pending));
+	async_synchronize_cookie_domain(next_cookie, NULL);
 }
 EXPORT_SYMBOL_GPL(async_synchronize_full);
 
@@ -270,7 +275,7 @@ EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
 /**
  * async_synchronize_cookie_domain - synchronize asynchronous function calls within a certain domain with cookie checkpointing
  * @cookie: async_cookie_t to use as checkpoint
- * @running: running list to synchronize on
+ * @running: running list to synchronize on, NULL indicates all lists
  *
  * This function waits until all asynchronous function calls for the
  * synchronization domain specified by the running list @list submitted
-- 
1.7.12.2.21.g234cd45.dirty



