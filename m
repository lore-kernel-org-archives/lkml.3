Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378Ab3AUHpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 02:45:41 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:35906 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab3AUHpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 02:45:39 -0500
Message-ID: <50FCF212.3010504@linux.vnet.ibm.com>
Date: Mon, 21 Jan 2013 15:45:22 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com> <50ED384C.1030301@linux.vnet.ibm.com> <1357977704.6796.47.camel@marge.simpson.net> <1357985943.6796.55.camel@marge.simpson.net> <1358155290.5631.19.camel@marge.simpson.net> <50F79256.1010900@linux.vnet.ibm.com> <1358654997.5743.17.camel@marge.simpson.net> <50FCACE3.5000706@linux.vnet.ibm.com> <1358743128.4994.33.camel@marge.simpson.net> <50FCCCF5.30504@linux.vnet.ibm.com> <1358750523.4994.55.camel@marge.simpson.net> <1358752180.4994.65.camel@marge.simpson.net>
In-Reply-To: <1358752180.4994.65.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012107-1618-0000-0000-00000338B108
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 03:09 PM, Mike Galbraith wrote:
> On Mon, 2013-01-21 at 07:42 +0100, Mike Galbraith wrote: 
>> On Mon, 2013-01-21 at 13:07 +0800, Michael Wang wrote:
> 
>>> May be we could try change this back to the old way later, after the aim
>>> 7 test on my server.
>>
>> Yeah, something funny is going on.
> 
> Never entering balance path kills the collapse.  Asking wake_affine()
> wrt the pull as before, but allowing us to continue should no idle cpu
> be found, still collapsed.  So the source of funny behavior is indeed in
> balance_path.

Below patch based on the patch set could help to avoid enter balance path
if affine_sd could be found, just like the old logical, would you like to
take a try and see whether it could help fix the collapse?

Regards,
Michael Wang

---
 kernel/sched/fair.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d600708..4e95bb0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3297,6 +3297,8 @@ next:
                        sg = sg->next;
                } while (sg != sd->groups);
        }
+
+       return -1;
 done:
        return target;
 }
@@ -3349,7 +3351,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
                 * some cases.
                 */
                new_cpu = select_idle_sibling(p, prev_cpu);
-               if (idle_cpu(new_cpu))
+               if (new_cpu != -1)
                        goto unlock;

                /*
@@ -3363,15 +3365,15 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
                        goto balance_path;

                new_cpu = select_idle_sibling(p, cpu);
-               if (!idle_cpu(new_cpu))
-                       goto balance_path;
-
                /*
                 * Invoke wake_affine() finally since it is no doubt a
                 * performance killer.
                 */
-               if (wake_affine(sbm->affine_map[prev_cpu], p, sync))
-                       goto unlock;
+               if (new_cpu == -1 ||
+                       !wake_affine(sbm->affine_map[prev_cpu], p, sync))
+                       new_cpu = prev_cpu;
+
+               goto unlock;
        }

 balance_path:
-- 
1.7.4.1


> 
> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

