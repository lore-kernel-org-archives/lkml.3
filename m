Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbaHaJEB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 05:04:01 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61880 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaHaJDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 05:03:47 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, falcon@meizu.com,
        tiwai@suse.de, tj@kernel.org, arjan@linux.intel.com
Cc: linux-kernel@vger.kernel.org, oleg@redhat.com, akpm@linux-foundation.org,
        penguin-kernel@i-love.sakura.ne.jp, joseph.salisbury@canonical.com,
        bpoirier@suse.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v1 2/3] async: move synchronous caller into a helper
Date: Sun, 31 Aug 2014 02:03:19 -0700
Message-Id: <1409475800-17573-3-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com>
References: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This will be reused later.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 kernel/async.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index 61f023c..362b3d6 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -145,6 +145,20 @@ static void async_run_entry_fn(struct work_struct *work)
 	wake_up(&async_done);
 }
 
+/* run synchronously when low on memory or when an invalid domain was used */
+static async_cookie_t __async_schedule_sync(async_func_t func, void *data)
+{
+	unsigned long flags;
+	async_cookie_t newcookie;
+
+	spin_lock_irqsave(&async_lock, flags);
+	newcookie = next_cookie++;
+	spin_unlock_irqrestore(&async_lock, flags);
+
+	func(data, newcookie);
+	return newcookie;
+}
+
 static async_cookie_t __async_schedule(async_func_t func, void *data, struct async_domain *domain)
 {
 	struct async_entry *entry;
@@ -160,13 +174,7 @@ static async_cookie_t __async_schedule(async_func_t func, void *data, struct asy
 	 */
 	if (!entry || atomic_read(&entry_count) > MAX_WORK) {
 		kfree(entry);
-		spin_lock_irqsave(&async_lock, flags);
-		newcookie = next_cookie++;
-		spin_unlock_irqrestore(&async_lock, flags);
-
-		/* low on memory.. run synchronously */
-		func(data, newcookie);
-		return newcookie;
+		return __async_schedule_sync(func, data);
 	}
 	INIT_LIST_HEAD(&entry->domain_list);
 	INIT_LIST_HEAD(&entry->global_list);
-- 
2.0.3

