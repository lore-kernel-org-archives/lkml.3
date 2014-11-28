Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaK1SYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:24:40 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63027 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaK1SYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:38 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC PATCH 15/30] isdn: Convert obsolete cputime type to nsecs
Date: Fri, 28 Nov 2014 19:23:45 +0100
Message-Id: <1417199040-21044-16-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if MISDN stats are ABI but it displays task cputime in cputime_t
raw value regardless of what type cputime_t wraps which could be either
jiffies, nsecs, usecs, or whatever random time unit. Plus it wrongly
assumes that cputime_t is long.

Given that this dump is broken anyway, lets just display the nanosec
value and stick with that.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 drivers/isdn/mISDN/stack.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/mISDN/stack.c b/drivers/isdn/mISDN/stack.c
index 0a36617..b324474 100644
--- a/drivers/isdn/mISDN/stack.c
+++ b/drivers/isdn/mISDN/stack.c
@@ -203,7 +203,7 @@ mISDNStackd(void *data)
 {
 	struct mISDNstack *st = data;
 #ifdef MISDN_MSG_STATS
-	cputime_t utime, stime;
+	u64 utime, stime;
 #endif
 	int err = 0;
 
@@ -306,9 +306,9 @@ mISDNStackd(void *data)
 	       "msg %d sleep %d stopped\n",
 	       dev_name(&st->dev->dev), st->msg_cnt, st->sleep_cnt,
 	       st->stopped_cnt);
-	task_cputime_t(st->thread, &utime, &stime);
+	task_cputime(st->thread, &utime, &stime);
 	printk(KERN_DEBUG
-	       "mISDNStackd daemon for %s utime(%ld) stime(%ld)\n",
+	       "mISDNStackd daemon for %s utime(%llu) stime(%llu)\n",
 	       dev_name(&st->dev->dev), utime, stime);
 	printk(KERN_DEBUG
 	       "mISDNStackd daemon for %s nvcsw(%ld) nivcsw(%ld)\n",
-- 
2.1.3

