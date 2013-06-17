Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174Ab3FQEDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 00:03:10 -0400
Received: from ozlabs.org ([203.10.76.45]:39846 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab3FQEDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 00:03:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 9/9] mm/oom_kill: remove weird use of ERR_PTR()/PTR_ERR().
In-Reply-To: <alpine.DEB.2.02.1306161111180.22688@chino.kir.corp.google.com>
References: <87ehc2rczo.fsf@rustcorp.com.au> <1371357768-4968-1-git-send-email-rusty@rustcorp.com.au> <1371357768-4968-9-git-send-email-rusty@rustcorp.com.au> <alpine.DEB.2.02.1306161111180.22688@chino.kir.corp.google.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 17 Jun 2013 13:20:59 +0930
Message-ID: <87fvwhpf8c.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes <rientjes@google.com> writes:
> On Sun, 16 Jun 2013, Rusty Russell wrote:
>
>> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
>> index 79e451a..f9b9cd7 100644
>> --- a/mm/oom_kill.c
>> +++ b/mm/oom_kill.c
>> @@ -288,7 +288,7 @@ enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
>>  
>>  /*
>>   * Simple selection loop. We chose the process with the highest
>> - * number of 'points'.
>> + * number of 'points'.  Returns -1 on scan abort.
>>   *
>>   * (not docbooked, we don't want this one cluttering up the manual)
>>   */
>> @@ -314,7 +314,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
>>  			continue;
>>  		case OOM_SCAN_ABORT:
>>  			rcu_read_unlock();
>> -			return ERR_PTR(-1UL);
>> +			return (void *)(-1UL);
>>  		case OOM_SCAN_OK:
>>  			break;
>>  		};
>
> Any reason it's not struct task_struct *?

No good one.  Changed.

Cheers,
Rusty.

Subject: mm/oom_kill: remove weird use of ERR_PTR()/PTR_ERR().

The normal expectation for ERR_PTR() is to put a negative errno into a
pointer.  oom_kill puts the magic -1 in the result (and has since
pre-git), which is probably clearer with an explicit cast.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 79e451a..f9b9cd7 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -288,7 +288,7 @@ enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
 
 /*
  * Simple selection loop. We chose the process with the highest
- * number of 'points'.
+ * number of 'points'.  Returns -1 on scan abort.
  *
  * (not docbooked, we don't want this one cluttering up the manual)
  */
@@ -314,7 +314,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
 			continue;
 		case OOM_SCAN_ABORT:
 			rcu_read_unlock();
-			return ERR_PTR(-1UL);
+			return (struct task_struct *)(-1UL);
 		case OOM_SCAN_OK:
 			break;
 		};
@@ -657,7 +657,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 		dump_header(NULL, gfp_mask, order, NULL, mpol_mask);
 		panic("Out of memory and no killable processes...\n");
 	}
-	if (PTR_ERR(p) != -1UL) {
+	if (p != (void *)-1UL) {
 		oom_kill_process(p, gfp_mask, order, points, totalpages, NULL,
 				 nodemask, "Out of memory");
 		killed = 1;
