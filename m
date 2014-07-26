Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbaGZUCy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 16:02:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbaGZTDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:03:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mateusz Guzik <mguzik@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.10 55/56] sched: Fix possible divide by zero in avg_atom() calculation
Date: Sat, 26 Jul 2014 12:02:48 -0700
Message-Id: <20140726190201.875326725@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190200.061512159@linuxfoundation.org>
References: <20140726190200.061512159@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -551,7 +551,7 @@ void proc_sched_show_task(struct task_st
 
 		avg_atom = p->se.sum_exec_runtime;
 		if (nr_switches)
-			do_div(avg_atom, nr_switches);
+			avg_atom = div64_ul(avg_atom, nr_switches);
 		else
 			avg_atom = -1LL;
 


