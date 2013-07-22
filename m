Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117Ab3GVVSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:18:41 -0400
Received: from relay3.sgi.com ([192.48.152.1]:58888 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932585Ab3GVVSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:18:39 -0400
From: Nathan Zimmer <nzimmer@sgi.com>
To: linux-kernel@vger.kernel.org, holger@freyther.de
Cc: Nathan Zimmer <nzimmer@sgi.com>, <stable@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] timer_list: Correct the show function for timer_list by using iter->now
Date: Mon, 22 Jul 2013 16:18:31 -0500
Message-Id: <1374527911-43084-1-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <20130720054300.GA29718@xiaoyu.lan>
References: <20130720054300.GA29718@xiaoyu.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects the issue with /proc/timer_list reported by Holger.
When reading from the proc file with a sufficently small buffer, 2k so not
really that small, there was one could get hung trying to read the file a
chunk at a time.

Signed-off-by Nathan Zimmer <nzimmer@sgi.com>
Reported-by: Holger Hans Peter Freyther <holger@freyther.de>
Cc: <stable@vger.kernel.org> # 3.10.x
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timer_list.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 3bdf283..08d7fbd 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -265,10 +265,9 @@ static inline void timer_list_header(struct seq_file *m, u64 now)
 static int timer_list_show(struct seq_file *m, void *v)
 {
 	struct timer_list_iter *iter = v;
-	u64 now = ktime_to_ns(ktime_get());

 	if (iter->cpu == -1 && !iter->second_pass)
-		timer_list_header(m, now);
+		timer_list_header(m, iter->now);
 	else if (!iter->second_pass)
 		print_cpu(m, iter->cpu, iter->now);
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
-- 
1.8.2.1

