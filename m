Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707AbaGWROw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 13:14:52 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:53233 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbaGWROv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 13:14:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140723120654.GF11241@linux.vnet.ibm.com>
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
 <1406092194-13004-3-git-send-email-bobby.prani@gmail.com> <20140723120654.GF11241@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 23 Jul 2014 13:14:19 -0400
Message-ID: <CAJhHMCA_K8qH7pspzfRb15L7=p2rdngmi3XoH35gR9kWjo8EnQ@mail.gmail.com>
Subject: Re: [PATCH 02/16] rcu: Check return value for cpumask allocation
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 8:06 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>> --- a/kernel/rcu/tree_plugin.h
>> +++ b/kernel/rcu/tree_plugin.h
>> @@ -88,7 +88,10 @@ static void __init rcu_bootup_announce_oddness(void)
>>  #ifdef CONFIG_RCU_NOCB_CPU
>>  #ifndef CONFIG_RCU_NOCB_CPU_NONE
>>       if (!have_rcu_nocb_mask) {
>> -             zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);
>> +             if (!zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL)) {
>> +                     pr_info("rcu_nocb_mask allocation failed\n");
>> +                     return;
>
> Good catch, but this "return" is an accident waiting to happen.  The
> accident will happen as soon as another RCU option appears, and the
> person adding it quite naturally adds it at the end of this function.
> The cleanest approach is to make an rcu_bootup_announce_oddness_nocb()
> as one commit that does -only- code motion, and the make this change
> as another commit.
>

Hi Paul,

Looking at this, I think the following is simpler without having to
introduce a new function. What do you think?

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index c31eb28..f2ed342 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -88,8 +88,10 @@ static void __init rcu_bootup_announce_oddness(void)
 #ifdef CONFIG_RCU_NOCB_CPU
 #ifndef CONFIG_RCU_NOCB_CPU_NONE
        if (!have_rcu_nocb_mask) {
-               zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);
-               have_rcu_nocb_mask = true;
+               if (!zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL))
+                       pr_info("rcu_nocb_mask allocation failed");
+               else
+                       have_rcu_nocb_mask = true;
        }
 #ifdef CONFIG_RCU_NOCB_CPU_ZERO
        pr_info("\tOffload RCU callbacks from CPU 0\n");


-- 
Pranith
