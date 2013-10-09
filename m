Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab3JIBE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 21:04:59 -0400
Received: from intranet.asianux.com ([58.214.24.6]:7827 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab3JIBE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 21:04:57 -0400
X-Spam-Score: -100.8
Message-ID: <5254AB7A.4030204@asianux.com>
Date: Wed, 09 Oct 2013 09:03:54 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/pid.c: check pid whether be NULL in __change_pid()
References: <52528CF7.8050405@asianux.com> <20131007124319.GA24450@redhat.com> <52532D74.1060408@asianux.com> <20131008175625.GA32220@redhat.com>
In-Reply-To: <20131008175625.GA32220@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2013 01:56 AM, Oleg Nesterov wrote:
> On 10/08, Chen Gang wrote:
>>
>> On 10/07/2013 08:43 PM, Oleg Nesterov wrote:
>>>
>>>> but still recommend to check it
>>>> in __change_pid() to let itself consistency.
>>>
>>> Why?
>>>
>>> Contrary, I think we should not hide the problem. If __change_pid() is
>>> called when task->pids[type].pid is already NULL there is something
>>> seriously wrong.
>>>
>>
>> Hmm... In my opinion, it means need BUG_ON() for original 'link->pid'.
>>
>> --------------------------------patch begin-----------------------------
>>
>> [PATCH] kernel/pid.c: add BUG_ON() for "!pid" in __change_pid()
>>
>>   Within __change_pid(), 'new' may be NULL if it comes from detach_pid(),
> 
> Yes, this is fine,
> 
>>   and 'link->pid' also may be NULL ("link->pid = new"),
>> ...
>>   the original 'link->pid' may be NULL, too.
> 
> Too? You mean, it becomes NULL after detach_pid().
> 
>>   But in real world, all related extern functions always assume "if
>>   'link->pid' is already NULL, there must be something seriously wrong",
>>   although __change_pid() can accept parameter 'new' as NULL.
> 
> I simply can't understand why you mix "new == NULL" and "link->pid == NULL".
> 
>>   So in __change_pid(), need add BUG_ON() for it: "it should not happen,
>>   when it really happen, OS must be continuing blindly,
> 
> OS will crash a couple of lines below trying to dereference this pointer.
> 
>> --- a/kernel/pid.c
>> +++ b/kernel/pid.c
>> @@ -396,6 +396,12 @@ static void __change_pid(struct task_struct *task, enum pid_type type,
>>  	link = &task->pids[type];
>>  	pid = link->pid;
>>
>> +	/*
>> +	 * If task->pids[type].pid is already NULL, there must be something
>> +	 * seriously wrong
>> +	 */
>> +	BUG_ON(!pid);
> 
> Following this logic you should also add
> 
> 	BUG_ON(!task);
> 	BUG_ON(!link->node.next);
> 	BUG_ON(!link->node.prev || link->node.prev == LIST_POISON2);
> 	...
> 
> Seriously, I do not understand the point. Yes, detach_pid() should not
> be called twice. And it has a single caller. And this caller will crash
> too if it is called twice. So you can also add BUG_ON() into
> __unhash_process(). And so on.
> 

In my opinion, for using BUG_ON(), it has 3 requirements:

 - OS is just continuing blindly.

 - next, will cause real issue (or need use WARN_ON instead of).

 - Can let the related code self consitency (or will add many wastes).


Your demo are match 2 requrements, but not match the 3rd one: "it is
reasonable to assume 'task', 'link', and 'link->node' are valid in
__change_pid()".

But for link->pid, the function name '__change_pid' tells us it is only
for changing pid, if 'new' can be NULL, 'link->pid' also can be NULL,
so the original 'link-pid' can be NULL, too.

So for self consistency, we also can change the function name from
'__change_pid' to another one (e.g. 'change_orig_valid_pid'), to let
itself consistency (so don't need BUG_ON)


The related patch is below, please check, thanks.

--------------------------------patch begin-----------------------------

kernel/pid.c: use 'change_orig_valid_pid' instead of '__change_pid' for function name

  For function name '__change_pid' is only for changing pid. In fact, it
  always assumes the original pid is valid, but new pid can be NULL, so
  recommend to use 'change_orig_valid_pid' instead of.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/pid.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 9b9a266..408a3b5 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -386,7 +386,7 @@ void attach_pid(struct task_struct *task, enum pid_type type)
 	hlist_add_head_rcu(&link->node, &link->pid->tasks[type]);
 }
 
-static void __change_pid(struct task_struct *task, enum pid_type type,
+static void change_orig_valid_pid(struct task_struct *task, enum pid_type type,
 			struct pid *new)
 {
 	struct pid_link *link;
@@ -408,13 +408,13 @@ static void __change_pid(struct task_struct *task, enum pid_type type,
 
 void detach_pid(struct task_struct *task, enum pid_type type)
 {
-	__change_pid(task, type, NULL);
+	change_orig_valid_pid(task, type, NULL);
 }
 
 void change_pid(struct task_struct *task, enum pid_type type,
 		struct pid *pid)
 {
-	__change_pid(task, type, pid);
+	change_orig_valid_pid(task, type, pid);
 	attach_pid(task, type);
 }
 
-- 
1.7.7.6

--------------------------------patch end-------------------------------

Thanks.
-- 
Chen Gang
