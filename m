Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbaBQAoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 19:44:30 -0500
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:37639 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752327AbaBQAo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 19:44:28 -0500
From: Debabrata Banerjee <dbanerje@akamai.com>
To: linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: dbavatar@gmail.com, johunt@akamai.com,
        Debabrata Banerjee <dbanerje@akamai.com>, stable@vger.kernel.org
Subject: [PATCH v3] printk: Fix discarding of records
Date: Sun, 16 Feb 2014 19:42:26 -0500
Message-Id: <1392597746-28619-1-git-send-email-dbanerje@akamai.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <CA+55aFy7yrNuJaFLcLh5-DVFTzuFYeZ_K9s6CNGtemQDCO90mQ@mail.gmail.com>
References: <CA+55aFy7yrNuJaFLcLh5-DVFTzuFYeZ_K9s6CNGtemQDCO90mQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found another buffer overflow in this code that was introduced by
e3756477aec028427fec767957c0d4b6cfb87208 trying to solve a related overflow.

strace still shows a problem:

	syslog(0x3, 0x7fffd65375d0, 0x1000)     = 4107

The first record output was in the middle of a LOG_CONT line:

	<4>[    2.974999] 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 1 (20130328/utaddress-251)

This happens because when discarding records to be less than size, the first
line may expand due to there being no previous record. So we must use prev = 0
to calculate if it fits or we should continue discarding.

v3: fix whitespace
v2: fix loop properly

CC: stable@vger.kernel.org
Signed-off-by: Debabrata Banerjee <dbanerje@akamai.com>
---
 kernel/printk/printk.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index b1d255f..e95c7b4 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1063,13 +1063,17 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		seq = clear_seq;
 		idx = clear_idx;
 		prev = 0;
-		while (len > size && seq < log_next_seq) {
+		while (seq < log_next_seq) {
 			struct printk_log *msg = log_from_idx(idx);
 
-			len -= msg_print_text(msg, prev, true, NULL, 0);
-			prev = msg->flags;
 			idx = log_next(idx);
 			seq++;
+
+			if (len - msg_print_text(msg, 0, true, NULL, 0) <= size)
+				break;
+
+			len -= msg_print_text(msg, prev, true, NULL, 0);
+			prev = msg->flags;
 		}
 
 		/* last message fitting into this dump */
@@ -2774,12 +2778,16 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	seq = dumper->cur_seq;
 	idx = dumper->cur_idx;
 	prev = 0;
-	while (l > size && seq < dumper->next_seq) {
+	while (seq < dumper->next_seq) {
 		struct printk_log *msg = log_from_idx(idx);
 
-		l -= msg_print_text(msg, prev, true, NULL, 0);
 		idx = log_next(idx);
 		seq++;
+
+		if (l - msg_print_text(msg, 0, true, NULL, 0) <= size)
+			break;
+
+		l -= msg_print_text(msg, prev, true, NULL, 0);
 		prev = msg->flags;
 	}
 
-- 
1.8.3.4

