Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaHDQzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:55:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56608 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752184AbaHDQt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Peter Zijlstra" <peterz@infradead.org>,
        "Ingo Molnar" <mingo@kernel.org>, "Mateusz Guzik" <mguzik@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.47580064@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 50/94] sched: Fix possible divide by zero in
 avg_atom() calculation
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Guzik <mguzik@redhat.com>

commit b0ab99e7736af88b8ac1b7ae50ea287fffa2badc upstream.

proc_sched_show_task() does:

  if (nr_switches)
	do_div(avg_atom, nr_switches);

nr_switches is unsigned long and do_div truncates it to 32 bits, which
means it can test non-zero on e.g. x86-64 and be truncated to zero for
division.

Fix the problem by using div64_ul() instead.

As a side effect calculations of avg_atom for big nr_switches are now correct.

Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1402750809-31991-1-git-send-email-mguzik@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/sched_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -467,7 +467,7 @@ void proc_sched_show_task(struct task_st
 
 		avg_atom = p->se.sum_exec_runtime;
 		if (nr_switches)
-			do_div(avg_atom, nr_switches);
+			avg_atom = div64_ul(avg_atom, nr_switches);
 		else
 			avg_atom = -1LL;
 

