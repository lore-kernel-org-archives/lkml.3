Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaAPEaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:30:19 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:45754 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbaAPEaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:30:13 -0500
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>, GregKH <greg@kroah.com>
Subject: [PATCH 02/15] w1: fixup search to support abort from netlink
Date: Wed, 15 Jan 2014 22:29:13 -0600
Message-Id: <1389846566-28862-3-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389846566-28862-1-git-send-email-David@Fries.net>
References: <1389846566-28862-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Wed, 15 Jan 2014 22:30:04 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before 63706172f33 "rework kthread_stop()" kthread_should_stop()
always returned false when called from a non-kthread task, after it
would oops as a non-kthread didn't have that structure and netlink was
calling search from a thread which wasn't a kthread.  9d1817cab2f030
"w1: fix oops when w1_search is called from netlink connector",
modified the code to avoid calling kthread_stop from a netlink thread.

Introduce a w1_master flag and bit W1_ABORT_SEARCH to identify abort
to cleanly support both kthread and netlink search abort.  A search
can take seconds to run, so it is important to abort early if the
hardware is removed in the middle of a search.

Signed-off-by: David Fries <David@Fries.net>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Marcin Jurkowski <marcin1j@gmail.com>
Cc: Josh Boyer <jwboyer@gmail.com>
Cc: Sven Geggus <lists@fuchsschwanzdomain.de>
---
 drivers/w1/w1.c     |    3 +--
 drivers/w1/w1.h     |   10 ++++++++++
 drivers/w1/w1_int.c |    2 ++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 66efa96..67b6d5f 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -960,8 +960,7 @@ void w1_search(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb
 			tmp64 = (triplet_ret >> 2);
 			rn |= (tmp64 << i);
 
-			/* ensure we're called from kthread and not by netlink callback */
-			if (!dev->priv && kthread_should_stop()) {
+			if (test_bit(W1_ABORT_SEARCH, &dev->flags)) {
 				mutex_unlock(&dev->bus_mutex);
 				dev_dbg(&dev->dev, "Abort w1_search\n");
 				return;
diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index ca8081a..bc329d2 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -155,6 +155,14 @@ struct w1_bus_master
 		u8, w1_slave_found_callback);
 };
 
+/**
+ * enum w1_master_flags - bitfields used in w1_master.flags
+ * @W1_ABORT_SEARCH: abort searching early on shutdown
+ */
+enum w1_master_flags {
+	W1_ABORT_SEARCH = 0,
+};
+
 struct w1_master
 {
 	struct list_head	w1_master_entry;
@@ -178,6 +186,8 @@ struct w1_master
 	/** 5V strong pullup duration in milliseconds, zero disabled. */
 	int			pullup_duration;
 
+	long			flags;
+
 	struct task_struct	*thread;
 	struct mutex		mutex;
 	struct mutex		bus_mutex;
diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index 5a98649..f84e48b 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -184,6 +184,7 @@ int w1_add_master_device(struct w1_bus_master *master)
 
 #if 0 /* Thread cleanup code, not required currently. */
 err_out_kill_thread:
+	set_bit(W1_ABORT_SEARCH, &dev->flags);
 	kthread_stop(dev->thread);
 #endif
 err_out_rm_attr:
@@ -199,6 +200,7 @@ void __w1_remove_master_device(struct w1_master *dev)
 	struct w1_netlink_msg msg;
 	struct w1_slave *sl, *sln;
 
+	set_bit(W1_ABORT_SEARCH, &dev->flags);
 	kthread_stop(dev->thread);
 
 	mutex_lock(&w1_mlock);
-- 
1.7.10.4

