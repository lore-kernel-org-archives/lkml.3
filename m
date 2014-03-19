Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518AbaCSJmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 05:42:33 -0400
Received: from mail.cs.hku.hk ([147.8.176.10]:58117 "EHLO mail.cs.hku.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932191AbaCSJmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 05:42:32 -0400
Message-ID: <20140319174222.213976eu8b54ujk0@intranet.cs.hku.hk>
Date: Wed, 19 Mar 2014 17:42:22 +0800
From: lwcheng@cs.hku.hk
To: linux-kernel@vger.kernel.org
Cc: glommer@gmail.com
Subject: [BUG] Paravirtual time accounting / IRQ time accounting
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1.4)
X-cs-MailScanner-Information: Please contact the ISP for more information
X-cs-MailScanner-ID: s2J9gNG5017889
X-cs-MailScanner: Found to be clean
X-cs-MailScanner-SpamCheck: not spam, SpamAssassin (not cached, score=-1.01,
	required 6, autolearn=disabled, ALL_TRUSTED -1.00,
	T_RP_MATCHES_RCVD -0.01)
X-cs-MailScanner-From: lwcheng@cs.hku.hk
X-cs-MailScanner-Watermark: 1395826944.05029@/poInFt4JBACJ1K7tY3JOg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In consolidated environments, when there are multiple virtual machines (VMs)
running on one CPU core, timekeeping will be a problem to the guest OS.
Here, I report my findings about Linux process scheduler.


Description
------------
Linux CFS relies on rq->clock_task to charge each task, determine  
vruntime, etc.

When CONFIG_IRQ_TIME_ACCOUNTING is enabled, the time spent on serving IRQ
will be excluded from updating rq->clock_task.
When CONFIG_PARAVIRT_TIME_ACCOUNTING is enabled, the time stolen by  
the hypervisor
will also be excluded from updating rq->clock_task.

With "both" CONFIG_IRQ_TIME_ACCOUNTING and  
CONFIG_PARAVIRT_TIME_ACCOUNTING enabled,
I put three KVM guests on one core and run hackbench in each guest. I  
find that
in the guests, rq->clock_task stays *unchanged*. The malfunction  
embarrasses CFS.
------------


Analysis
------------
[src/kernel/sched/core.c]
static void update_rq_clock_task(struct rq *rq, s64 delta)
{
     ... ...
#ifdef CONFIG_IRQ_TIME_ACCOUNTING
     irq_delta = irq_time_read(cpu_of(rq)) - rq->prev_irq_time;
     ... ...
     rq->prev_irq_time += irq_delta;
     delta -= irq_delta;
#endif

#ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
     if (static_key_false((&paravirt_steal_rq_enabled))) {
         steal = paravirt_steal_clock(cpu_of(rq));
         steal -= rq->prev_steal_time_rq;
         ... ...
         rq->prev_steal_time_rq += steal;
         delta -= steal;
     }
#endif

     rq->clock_task += delta;
     ... ...
}
--
"delta" -> the intended increment to rq->clock_task
"irq_delta" -> the time spent on serving IRQ (hard + soft)
"steal" -> the time stolen by the underlying hypervisor
--
"irq_delta" is calculated based on sched_clock_cpu(), which is vulnerable
to VM scheduling delays. "irq_delta" can include part or whole of "steal".
I observe that [irq_delta + steal >> delta].
As a result, "delta" becomes zero. That is why rq->clock_task stops.
------------

Please confirm this bug. Thanks.


Luwei Cheng
--
CS student
The University of Hong Kong
