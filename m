Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaBXPk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:40:27 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41757 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbaBXPkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:40:22 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@fb.com>, Michal Hocko <mhocko@suse.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 09/11] watchdog: Simplify a little the IPI call
Date: Mon, 24 Feb 2014 16:40:00 +0100
Message-Id: <1393256402-16907-10-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
References: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to remotely restart the watchdog hrtimer, update_timers()
allocates a csd on the stack and pass it to __smp_call_function_single().

There is no partcular need, however, for a specific csd here. Lets
simplify that a little by calling smp_call_function_single()
which can already take care of the csd allocation by itself.

Acked-by: Don Zickus <dzickus@redhat.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@fb.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/watchdog.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 4431610..01c6f97 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -505,7 +505,6 @@ static void restart_watchdog_hrtimer(void *info)
 
 static void update_timers(int cpu)
 {
-	struct call_single_data data = {.func = restart_watchdog_hrtimer};
 	/*
 	 * Make sure that perf event counter will adopt to a new
 	 * sampling period. Updating the sampling period directly would
@@ -515,7 +514,7 @@ static void update_timers(int cpu)
 	 * might be late already so we have to restart the timer as well.
 	 */
 	watchdog_nmi_disable(cpu);
-	__smp_call_function_single(cpu, &data, 1);
+	smp_call_function_single(cpu, restart_watchdog_hrtimer, NULL, 1);
 	watchdog_nmi_enable(cpu);
 }
 
-- 
1.8.3.1

