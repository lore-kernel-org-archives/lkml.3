Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811AbaC1Rl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:41:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbaC1RbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:31:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Prarit Bhargava <prarit@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.13 17/46] stop_machine: Fix^2 race between stop_two_cpus() and stop_cpus()
Date: Fri, 28 Mar 2014 10:32:01 -0700
Message-Id: <20140328173136.990894110@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173134.630198216@linuxfoundation.org>
References: <20140328173134.630198216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 177c53d943368fc97644ebc0a250dc8e2d124250 upstream.

We must use smp_call_function_single(.wait=1) for the
irq_cpu_stop_queue_work() to ensure the queueing is actually done under
stop_cpus_lock. Without this we could have dropped the lock by the time
we do the queueing and get the race we tried to fix.

Fixes: 7053ea1a34fa ("stop_machine: Fix race between stop_two_cpus() and stop_cpus()")

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140228123905.GK3104@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/stop_machine.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -293,7 +293,7 @@ int stop_two_cpus(unsigned int cpu1, uns
 	 */
 	smp_call_function_single(min(cpu1, cpu2),
 				 &irq_cpu_stop_queue_work,
-				 &call_args, 0);
+				 &call_args, 1);
 	lg_local_unlock(&stop_cpus_lock);
 	preempt_enable();
 


