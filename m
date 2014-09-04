Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbaIDQhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:37:35 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:52258 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754442AbaIDQhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:37:33 -0400
X-Yandex-Uniq: 38ca27a0-2fef-4b5d-bb31-662da3d9d305
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: klamm@yandex-team.ru
To: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Cc: stfomichev@yandex-team.ru, Roman Gushchin <klamm@yandex-team.ru>
Subject: [PATCH 19/19] smart: add description to the README file
Date: Thu,  4 Sep 2014 20:31:05 +0400
Message-Id: <1409848265-17150-19-git-send-email-klamm@yandex-team.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
References: <77161409833206@webcorp01h.yandex-team.ru>
 <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Gushchin <klamm@yandex-team.ru>

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
---
 README | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/README b/README
index a24ec89..c8af02d 100644
--- a/README
+++ b/README
@@ -1,3 +1,59 @@
+        SMART (Simultaneous Multithreading-Aware Real-Time)
+
+This commit series adds SMT awareness to Linux RT scheduler.
+
+SMART is aimed at realtime CPU-bound applications which run for a
+short period of time (tens of milliseconds) and expect no interruption
+(basically anything that is facing user and should finish execution as
+quickly as possible).
+
+On our memory-hot search clusters with thousands of machines we see
+10-15% more RPS compared to CFS. Most profit is gained when machine
+load is around 50%.
+
+While we aim for full CPU utilization with SMART, some care is still
+taken about CFS tasks, because it's crucial to be able to ssh on a fully
+loaded machine.
+
+Linux realtime scheduler uses cpupri structure to distribute tasks
+among CPU cores which doesn't take topology into account and thus can
+make very poor scheduling decisions. SMART scheduler completely abandons
+cpupri mechanism and tries to balance RT load between NUMA nodes and
+doesn't place (if possible) tasks on adjacent SMT threads of a single core.
+
+Among other features are:
+- SMART pull: if all SMT threads of a single core execute RT tasks we
+  migrate them whenever free core becomes available
+- CFS throttling: if some core has RT tasks running, we don't enqueue
+  CFS tasks on the other SMT threads of this core
+- SMART gathering: we migrate running CFS tasks from all SMT threads
+  of a core that don't have RT tasks, to the thread that has
+
+Usage:
+
+SMART is just an improvement on classic Linux realtime scheduler, thus
+all tasks that have SCHED_FIFO or SCHED_RR policy use SMART. From the
+command line it's possible to manipulate scheduler's policy using chrt
+command.
+
+Also, we provide cpu.smart knob to the cpu cgroup which sets scheduler
+policy of all tasks in the cgroup to SCHED_RR.
+
+
+When not to use SMART (you still can use it, but don't expect any profit):
+- target application is not bursty and its execution takes second(s)
+- CPU utilization of target machine approaches 100%
+- target application is true real-time application and you do care
+  about latency measured in microseconds
+
+
+Copyright (c) 2013-2014, Yandex LLC
+
+Authors: Roman Gushchin (klamm@yandex-team.ru),
+	 Stanislav Fomichev (stfomichev@yandex-team.ru)
+
+--------------------------------------------------------------------------------
+
         Linux kernel release 3.x <http://kernel.org/>
 
 These are the release notes for Linux version 3.  Read them carefully,
-- 
1.9.3

