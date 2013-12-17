Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315Ab3LQMmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:42:53 -0500
Received: from www.linutronix.de ([62.245.132.108]:37902 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab3LQMmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:42:51 -0500
Date: Tue, 17 Dec 2013 13:42:48 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <bitbucket@online.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.5-rt6
Message-ID: <20131217124248.GA21694@linutronix.de>
References: <20131216091431.GA13796@linutronix.de>
 <1387264591.5340.23.camel@marge.simpson.net>
 <20131217063156.6ac3bfed@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131217063156.6ac3bfed@gandalf.local.home>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt | 2013-12-17 06:31:56 [-0500]:

>On Tue, 17 Dec 2013 08:16:31 +0100
>Mike Galbraith <bitbucket@online.de> wrote:
>
>> Hi Sebastian,
>> 
>> Looks like there's a booboo here:
>> 
>> On Mon, 2013-12-16 at 10:14 +0100, Sebastian Andrzej Siewior wrote:
> 
>> "ptrace: fix ptrace vs tasklist_lock race" added.. 
>> 
>> @@ -1068,8 +1082,11 @@ unsigned long wait_task_inactive(struct
>>  		 * is actually now running somewhere else!
>>  		 */
>>  		while (task_running(rq, p)) {
>> -			if (match_state && unlikely(p->state != match_state))
>> +			if (match_state) {
>> +				if (!unlikely(check_task_state(p, match_state)))
>> +					return 0;
>>  				return 0;
>> +			}
>
>Ouch! 

Not exactly sure how I managed this since I had this [0] to test this.
Which I used to come up with the patch. And now I see that the code as
it is here fails the testcase.

[0] http://breakpoint.cc/ptrace-test.c

>>  			cpu_relax();
>>  		}
>>  
>> ..which is how it stays with the whole series applied.
>> 
>> The patch contains hunk 2 from
>> 
>>    "sched/rt: Fix wait_task_interactive() to test rt_spin_lock state",
>> 
>> which went away in -rt6, so it seems the busted hunk should be as below
>> if the two are to be merged.
>> 
>> @@ -1068,8 +1082,10 @@ unsigned long wait_task_inactive(struct
>>  		 * is actually now running somewhere else!
>>  		 */
>>  		while (task_running(rq, p)) {
>> -			if (match_state && unlikely(p->state != match_state))
>> +			if (match_state && unlikely(p->state != match_state)
>> +			    && unlikely(p->saved_state != match_state))
>>  				return 0;
>> +			}
>
>Yeah, it should just be:
>
>		if (match_state && check_task_state(p, match_state))
>			return 0;

Are you sure? If the state matches we should continue as long as it runs
therefore I would go for !check_task_state(). The problem here was that
I return 0 in both cases.

>Also, looking at check_task_state():
>
>+static bool check_task_state(struct task_struct *p, long match_state)
>+{
>+       bool match = false;
>+
>+       raw_spin_lock_irq(&p->pi_lock);
>+       if (p->state == match_state)
>+               match = true;
>+       else if (p->saved_state == match_state)
>+               match = true;
>
>Why the if () else if()? and not just:
>
>	if (p->state == match_state || p->save_state == match_state)
>		match = true;
>?
>
>The else if makes me think there's something missing.

Okay I can do this. But regarding the check_task_state part, I think I
should go with:

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1076,9 +1076,7 @@ static bool check_task_state(struct task_struct *p, long match_state)
 	bool match = false;
 
 	raw_spin_lock_irq(&p->pi_lock);
-	if (p->state == match_state)
-		match = true;
-	else if (p->saved_state == match_state)
+	if (p->state == match_state || p->saved_state == match_state)
 		match = true;
 	raw_spin_unlock_irq(&p->pi_lock);
 
@@ -1129,11 +1127,8 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		 * is actually now running somewhere else!
 		 */
 		while (task_running(rq, p)) {
-			if (match_state) {
-				if (!unlikely(check_task_state(p, match_state)))
-					return 0;
+			if (match_state && !check_task_state(p, match_state))
 				return 0;
-			}
 			cpu_relax();
 		}
 

 Any objections?

>
>-- Steve
>

Sebastian
