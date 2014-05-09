Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbaEIJPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:15:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbaEIJPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:15:31 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kay Sievers <kay@vrfy.org>, Jiri Kosina <jkosina@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [RFC PATCH 10/11] printk: survive rotation of sequence numbers
Date: Fri,  9 May 2014 11:11:04 +0200
Message-Id: <1399626665-29817-11-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NMI log buffer uses half of "unsigned long" to store the sequence number.
The maximum value might be relatively small, especially on 32-bit systems.
This patch makes the check for free space more strict, so it does give
false results after the rotation.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 874ebab41ba3..9c97b6daccc3 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -540,7 +540,7 @@ static int log_make_free_space(struct printk_log *log, u32 msg_size)
 	int freed = 0;
 	int ret = 0;
 
-	while (get_first_seq(log) < get_next_seq(log)) {
+	while (get_first_seq(log) != get_next_seq(log)) {
 		if (logbuf_has_space(log, msg_size, false))
 			goto out;
 
-- 
1.8.4

