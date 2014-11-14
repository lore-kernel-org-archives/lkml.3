Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161791AbaKNTTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:19:39 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:38039 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161586AbaKNTTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:19:38 -0500
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: bobby.prani@gmail.com, pmladek@suse.cz, jack@suse.cz, mcgrof@suse.com,
        rostedt@goodmis.org, joe@perches.com, linux-kernel@vger.kernel.org
Subject: [PATCH] printk: drop logbuf_cpu volatile qualifier
Date: Fri, 14 Nov 2014 13:19:31 -0600
Message-Id: <1415992771-9071-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pranith Kumar posted a patch in which removed the "volatile"
qualifier for the "logbuf_cpu" variable in vprintk_emit().
    https://lkml.org/lkml/2014/11/13/894
In his patch, he used ACCESS_ONCE() for all references to
that symbol to provide whatever protection was intended.

There was some discussion that followed, and in the end
Stephen Rostedt concluded that not only was "volatile" not
needed, neither was it required to use ACCESS_ONCE().  I
offered an elaborate description that concluded Stephen
was right, and Pranith asked me to submit an alternative
patch.  And this is it.

The basic reason "volatile" is not needed is that "logbuf_cpu" has
static storage duration, and vprintk_emit() is an exported
interface.  This means that the value of logbuf_cpu must be read
from memory the first time it is used in a particular call of
vprintk_emit().  The variable's value is read only once in that
function, when it's read it'll be the copy from memory (or cache).

In addition, the value of "logbuf_cpu" is only ever written under
protection of a spinlock.  So the value that is read is the "real"
value (and not an out-of-date cached one).  If its value is not
UINT_MAX, it is the current CPU's processor id, and it will have
been last written by the running CPU.

Reported-by: Pranith Kumar <bobby.prani@gmail.com>
Fix-suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Alex Elder <elder@linaro.org>
---
	Note!!!  I am not able to stress test this patch.

 kernel/printk/printk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index ced2b84..fefc8d0 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1627,7 +1627,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	int printed_len = 0;
 	bool in_sched = false;
 	/* cpu currently holding logbuf_lock in this function */
-	static volatile unsigned int logbuf_cpu = UINT_MAX;
+	static unsigned int logbuf_cpu = UINT_MAX;
 
 	if (level == SCHED_MESSAGE_LOGLEVEL) {
 		level = -1;
-- 
1.9.1

