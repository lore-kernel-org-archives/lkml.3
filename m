Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934893AbaFIXPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:15:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56732 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933138AbaFIWpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.14 01/78] sched: Use CPUPRI_NR_PRIORITIES instead of MAX_RT_PRIO in cpupri check
Date: Mon,  9 Jun 2014 15:47:41 -0700
Message-Id: <20140609224813.403895349@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 6227cb00cc120f9a43ce8313bb0475ddabcb7d01 upstream.

The check at the beginning of cpupri_find() makes sure that the task_pri
variable does not exceed the cp->pri_to_cpu array length. But that length
is CPUPRI_NR_PRIORITIES not MAX_RT_PRIO, where it will miss the last two
priorities in that array.

As task_pri is computed from convert_prio() which should never be bigger
than CPUPRI_NR_PRIORITIES, if the check should cause a panic if it is
hit.

Reported-by: Mike Galbraith <umgwanakikbuti@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1397015410.5212.13.camel@marge.simpson.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/cpupri.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/sched/cpupri.c
+++ b/kernel/sched/cpupri.c
@@ -70,8 +70,7 @@ int cpupri_find(struct cpupri *cp, struc
 	int idx = 0;
 	int task_pri = convert_prio(p->prio);
 
-	if (task_pri >= MAX_RT_PRIO)
-		return 0;
+	BUG_ON(task_pri >= CPUPRI_NR_PRIORITIES);
 
 	for (idx = 0; idx < task_pri; idx++) {
 		struct cpupri_vec *vec  = &cp->pri_to_cpu[idx];


