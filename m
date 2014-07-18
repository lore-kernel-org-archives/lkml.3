Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990AbaGRAKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 20:10:39 -0400
Received: from mail-yk0-f179.google.com ([209.85.160.179]:65425 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758763AbaGRAKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 20:10:34 -0400
Message-ID: <53C86615.3040107@gmail.com>
Date: Thu, 17 Jul 2014 20:11:01 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] rcu: Check for have_rcu_nocb_mask instead of rcu_nocb_mask
References: <1405632611-29872-1-git-send-email-bobby.prani@gmail.com> <20140717234920.GD8690@linux.vnet.ibm.com>
In-Reply-To: <20140717234920.GD8690@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2014 07:49 PM, Paul E. McKenney wrote:
> On Thu, Jul 17, 2014 at 05:30:11PM -0400, Pranith Kumar wrote:
>> Hi Paul,
>>
>> This is something similar to what you found yesterday with tick_nohz_full mask.
>>
>> --
>> Pranith
>>
>> If we configure a kernel with CONFIG_NOCB_CPU=y, CONFIG_RCU_NOCB_CPU_NONE=y and
>> CONFIG_CPUMASK_OFFSTACK=n and do not pass in a rcu_nocb= boot parameter, the
>> cpumask rcu_nocb_mask can be garbage instead of NULL.
>>
>> Hence this commit replaces checks for rcu_nocb_mask == NULL with a check for
>> have_rcu_nocb_mask.
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> 
> Good catch!  Could you please forward-port this to current rcu/dev?
> This now includes the fix you mentioned above, which generates conflicts.
> 
> Could you please also fix the use in rcu_is_nocb_cpu()?
> 
> And please see the comment below.
> 

Please find the fixed patch.

--
Pranith


From: Pranith Kumar <bobby.prani@gmail.com>
Date: Thu, 17 Jul 2014 20:02:54 -0400
Subject: [PATCH 1/1] rcu: Feedback comments

If we configure a kernel with CONFIG_NOCB_CPU=y, CONFIG_RCU_NOCB_CPU_NONE=y and
CONFIG_CPUMASK_OFFSTACK=n and do not pass in a rcu_nocb= boot parameter, the
cpumask rcu_nocb_mask can be garbage instead of NULL.

Hence this commit replaces checks for rcu_nocb_mask == NULL with a check for
have_rcu_nocb_mask.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 kernel/rcu/tree_plugin.h | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index ce8c331..8f987c1 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2053,9 +2053,10 @@ static void rcu_init_one_nocb(struct rcu_node *rnp)
 /* Is the specified CPU a no-CBs CPU? */
 bool rcu_is_nocb_cpu(int cpu)
 {
-	if (have_rcu_nocb_mask)
-		return cpumask_test_cpu(cpu, rcu_nocb_mask);
-	return false;
+	if (!have_rcu_nocb_mask)
+		return false;
+
+	return cpumask_test_cpu(cpu, rcu_nocb_mask);
 }
 #endif /* #ifndef CONFIG_RCU_NOCB_CPU_ALL */
 
@@ -2540,7 +2541,7 @@ static void __init rcu_organize_nocb_kthreads(struct rcu_state *rsp)
 	struct rcu_data *rdp_leader = NULL;  /* Suppress misguided gcc warn. */
 	struct rcu_data *rdp_prev = NULL;
 
-	if (rcu_nocb_mask == NULL)
+	if (!have_rcu_nocb_mask)
 		return;
 #if defined(CONFIG_NO_HZ_FULL) && !defined(CONFIG_NO_HZ_FULL_ALL)
 	if (tick_nohz_full_running)
@@ -2574,9 +2575,9 @@ static void __init rcu_organize_nocb_kthreads(struct rcu_state *rsp)
 /* Prevent __call_rcu() from enqueuing callbacks on no-CBs CPUs */
 static bool init_nocb_callback_list(struct rcu_data *rdp)
 {
-	if (rcu_nocb_mask == NULL ||
-	    !cpumask_test_cpu(rdp->cpu, rcu_nocb_mask))
+	if (!rcu_is_nocb_cpu(rdp->cpu))
 		return false;
+
 	rdp->nxttail[RCU_NEXT_TAIL] = NULL;
 	return true;
 }
-- 
1.9.1


