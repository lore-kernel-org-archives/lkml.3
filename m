Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaBNEuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:50:04 -0500
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:50578 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492AbaBNEuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 23:50:02 -0500
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Feb 2014 23:50:02 EST
From: Debabrata Banerjee <dbanerje@akamai.com>
To: linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: dbavatar@gmail.com, johunt@akamai.com,
        Debabrata Banerjee <dbanerje@akamai.com>, stable@vger.kernel.org
Subject: [PATCH] printk: Fix discarding of records
Date: Thu, 13 Feb 2014 23:42:34 -0500
Message-Id: <1392352954-29905-1-git-send-email-dbanerje@akamai.com>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found another buffer overflow in this code that was introduced by
e3756477aec028427fec767957c0d4b6cfb87208 trying to solve a related overflow.

strace still shows a problem:

	syslog(0x3, 0x7fffd65375d0, 0x1000)     = 4107

The first record output was in the middle of a LOG_CONT line:

	<4>[    2.974999] 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 1 (20130328/utaddress-251)

This happens because when discarding records to be less than len, every line it
subtracts should be the first line which means prev should be 0. Otherwise for
example it won't include the prefix len if the last line was a LOG_CONT
record, which however will be printed because there won't be a previous line.
This patch makes sure enough records are discarded to be under len.

CC: stable@vger.kernel.org
Signed-off-by: Debabrata Banerjee <dbanerje@akamai.com>
---
 kernel/printk/printk.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index b1d255f..c1722d5 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1067,7 +1067,6 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 			struct printk_log *msg = log_from_idx(idx);
 
 			len -= msg_print_text(msg, prev, true, NULL, 0);
-			prev = msg->flags;
 			idx = log_next(idx);
 			seq++;
 		}
@@ -2780,7 +2779,6 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 		l -= msg_print_text(msg, prev, true, NULL, 0);
 		idx = log_next(idx);
 		seq++;
-		prev = msg->flags;
 	}
 
 	/* last message in next interation */
-- 
1.8.3.4

