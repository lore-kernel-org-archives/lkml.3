Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab3JZL43 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 07:56:29 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:56091 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab3JZL42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 07:56:28 -0400
From: Michal Nazarewicz <mpn@google.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH] drivers: w1: make w1_slave::flags long to avoid casts
Date: Sat, 26 Oct 2013 12:56:11 +0100
Message-Id: <5083d6c8452b765cb33acdf03fa9b20b1d15c452.1382788496.git.mina86@mina86.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

Changing flags field of the w1_slave to unsigned long may on
some architectures increase the size of the structure, but
otherwise makes the code more kosher as casting is avoided
and *_bit family of calls do not attempt to operate on an
entity of bigger size than realy is available.

The current behaviour does not introduce any bugs (since any
bytes past flags field are preserved) but make the code
slightly more confusing then it needs to be.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/w1/w1.c | 10 +++++-----
 drivers/w1/w1.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index fa932c2..66efa96 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -709,7 +709,7 @@ static int w1_attach_slave_device(struct w1_master *dev, struct w1_reg_num *rn)
 
 	sl->owner = THIS_MODULE;
 	sl->master = dev;
-	set_bit(W1_SLAVE_ACTIVE, (long *)&sl->flags);
+	set_bit(W1_SLAVE_ACTIVE, &sl->flags);
 
 	memset(&msg, 0, sizeof(msg));
 	memcpy(&sl->reg_num, rn, sizeof(sl->reg_num));
@@ -866,7 +866,7 @@ void w1_slave_found(struct w1_master *dev, u64 rn)
 
 	sl = w1_slave_search_device(dev, tmp);
 	if (sl) {
-		set_bit(W1_SLAVE_ACTIVE, (long *)&sl->flags);
+		set_bit(W1_SLAVE_ACTIVE, &sl->flags);
 	} else {
 		if (rn && tmp->crc == w1_calc_crc8((u8 *)&rn_le, 7))
 			w1_attach_slave_device(dev, tmp);
@@ -984,14 +984,14 @@ void w1_search_process_cb(struct w1_master *dev, u8 search_type,
 	struct w1_slave *sl, *sln;
 
 	list_for_each_entry(sl, &dev->slist, w1_slave_entry)
-		clear_bit(W1_SLAVE_ACTIVE, (long *)&sl->flags);
+		clear_bit(W1_SLAVE_ACTIVE, &sl->flags);
 
 	w1_search_devices(dev, search_type, cb);
 
 	list_for_each_entry_safe(sl, sln, &dev->slist, w1_slave_entry) {
-		if (!test_bit(W1_SLAVE_ACTIVE, (unsigned long *)&sl->flags) && !--sl->ttl)
+		if (!test_bit(W1_SLAVE_ACTIVE, &sl->flags) && !--sl->ttl)
 			w1_slave_detach(sl);
-		else if (test_bit(W1_SLAVE_ACTIVE, (unsigned long *)&sl->flags))
+		else if (test_bit(W1_SLAVE_ACTIVE, &sl->flags))
 			sl->ttl = dev->slave_ttl;
 	}
 
diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index 45908e5..ca8081a 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -67,8 +67,8 @@ struct w1_slave
 	struct w1_reg_num	reg_num;
 	atomic_t		refcnt;
 	u8			rom[9];
-	u32			flags;
 	int			ttl;
+	unsigned long		flags;
 
 	struct w1_master	*master;
 	struct w1_family	*family;
-- 
1.8.4

