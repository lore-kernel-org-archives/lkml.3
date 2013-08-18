Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab3HRI10 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 04:27:26 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:56895 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755370Ab3HRI1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 04:27:24 -0400
From: Lei Wen <leiwen@marvell.com>
To: Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, <mingo@redhat.com>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/8] sched: change active_load_balance_cpu_stop to use h_nr_running
Date: Sun, 18 Aug 2013 16:25:21 +0800
Message-ID: <1376814322-7320-8-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376814322-7320-1-git-send-email-leiwen@marvell.com>
References: <1376814322-7320-1-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should only avoid do the active load balance when there is no
cfs type task. If just use rq->nr_running, it is possible for the
source cpu has multiple rt task, while zero cfs task, so that it
would confuse the active load balance function that try to move,
but find no task it could move.

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 kernel/sched/fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3656603..4c96124 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5349,7 +5349,7 @@ static int active_load_balance_cpu_stop(void *data)
 		goto out_unlock;
 
 	/* Is there any task to move? */
-	if (busiest_rq->nr_running <= 1)
+	if (busiest_rq->cfs.h_nr_running == 0)
 		goto out_unlock;
 
 	/*
-- 
1.7.5.4

