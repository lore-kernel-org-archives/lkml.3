Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbaJGJms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:42:48 -0400
Received: from service87.mimecast.com ([91.220.42.44]:37309 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbaJGJmn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:42:43 -0400
Message-ID: <5433B5B9.70006@arm.com>
Date: Tue, 07 Oct 2014 10:43:21 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Daniel Wagner <daniel.wagner@bmw-carit.de>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>
CC: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: Do not try to replenish from a non deadline tasks
References: <1411565056-15577-1-git-send-email-daniel.wagner@bmw-carit.de>
In-Reply-To: <1411565056-15577-1-git-send-email-daniel.wagner@bmw-carit.de>
X-OriginalArrivalTime: 07 Oct 2014 09:42:40.0646 (UTC) FILETIME=[095E3A60:01CFE213]
X-MC-Unique: 114100710424014501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 24/09/14 14:24, Daniel Wagner wrote:
> When a PI mutex is shared between an deadline task and normal task we
> might end up trying to replenish from the normal task. In this case neither
> dl_runtime, dl_period or dl_deadline are set. replenish_dl_entity() can't do
> anything useful.
> 

Is this same bug we have with rt_mutex_setprio or something different?
I'm sorry, but I don't remember anymore :/. It looks like a different
issue, though.

Anyway, the callpath you talked about on IRC seems to make sense, does
what below fix the thing? Could you please point me again to where the
tests you are running are hosted, so that I can easily reproduce the
bug here?

Thanks a lot,

- Juri

>From f39b7668aeca5c48be1d4baed217cdd6c8d61150 Mon Sep 17 00:00:00 2001
From: Juri Lelli <juri.lelli@arm.com>
Date: Tue, 7 Oct 2014 10:29:09 +0100
Subject: [PATCH] sched/deadline: fix double enqueue on dl_task_timer.

Signed-off-by: Juri Lelli <juri.lelli@arm.com>
---
 kernel/sched/deadline.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 255ce13..d0beefa 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -520,10 +520,13 @@ again:
 	/*
 	 * We need to take care of a possible races here. In fact, the
 	 * task might have changed its scheduling policy to something
-	 * different from SCHED_DEADLINE or changed its reservation
-	 * parameters (through sched_setattr()).
+	 * different from SCHED_DEADLINE, changed its reservation
+	 * parameters (through sched_setattr()) or inherited priority
+	 * (and parameters) from someone else (in this last case it is
+	 * also outside of bandwidth enforcement, so we can safely bail
+	 * out).
 	 */
-	if (!dl_task(p) || dl_se->dl_new)
+	if (!dl_task(p) || dl_se->dl_new || dl_se->dl_boosted)
 		goto unlock;
 
 	sched_clock_tick();
-- 
2.1.0

