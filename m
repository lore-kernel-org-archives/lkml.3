Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaCQFBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 01:01:15 -0400
Received: from mail.cs.hku.hk ([147.8.176.10]:33020 "EHLO mail.cs.hku.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbaCQFBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 01:01:13 -0400
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Mar 2014 01:01:12 EDT
Message-ID: <20140317125541.17043cxzmlnxa0ys@intranet.cs.hku.hk>
Date: Mon, 17 Mar 2014 12:55:41 +0800
From: lwcheng@cs.hku.hk
To: linux-kernel@vger.kernel.org
Subject: [Question] Linux CFS sched_entity
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1.4)
X-cs-MailScanner-Information: Please contact the ISP for more information
X-cs-MailScanner-ID: s2H4tfxv005118
X-cs-MailScanner: Found to be clean
X-cs-MailScanner-SpamCheck: not spam, SpamAssassin (not cached, score=-1.01,
	required 6, autolearn=disabled, ALL_TRUSTED -1.00,
	T_RP_MATCHES_RCVD -0.01)
X-cs-MailScanner-From: lwcheng@cs.hku.hk
X-cs-MailScanner-Watermark: 1395636942.4915@OXSEsz/4xEapy1UcTf1aBw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am studying Linux CFS recently. After numerous searches, I am still
unable to get rid of the following question. Finally I decide to bother
this group for the answer.

In group scheduling, sched_entity can represent both "task group" and "task",
indicated by "se->my_q".
When CFS tries to pick a new task, it first selects a "task group" and then
selects a "task" from that "task group":
--------------
static struct task_struct *pick_next_task_fair(struct rq *rq)
{
     struct task_struct *p;
     struct cfs_rq *cfs_rq = &rq->cfs;
     struct sched_entity *se;

     ... ...
     do {
         se = pick_next_entity(cfs_rq);
         set_next_entity(cfs_rq, se);
         cfs_rq = group_cfs_rq(se);
     } while (cfs_rq);

     p = task_of(se);
     ... ...
}
--------------
Therefore, cfs_rq->curr should *always* represent a "task" here, right?

However, cfs_rq->curr seems *not* to be a "task" sometimes:
--------------
static void update_curr(struct cfs_rq *cfs_rq)
{
     struct sched_entity *curr = cfs_rq->curr;

     ... ...
     if (entity_is_task(curr)) {              /* WHY? */
         struct task_struct *curtask = task_of(curr);

         trace_sched_stat_runtime(curtask, delta_exec, curr->vruntime);
         cpuacct_charge(curtask, delta_exec);
         account_group_exec_runtime(curtask, delta_exec);
     }
     ... ...
}
--------------

My question is:
In what situations does cfs_rq->curr point to a task_group?
What's the sense? I thought it should always contain a "real" task.

Appreciated for anyone who is able to help. Thanks in advance!

Regards,
Luwei Cheng
--
CS Student
The University of Hong Kong
