Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab3JGVzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 17:55:00 -0400
Received: from intranet.asianux.com ([58.214.24.6]:41211 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3JGVzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 17:55:00 -0400
X-Spam-Score: -100.9
Message-ID: <52532D74.1060408@asianux.com>
Date: Tue, 08 Oct 2013 05:53:56 +0800
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
References: <52528CF7.8050405@asianux.com> <20131007124319.GA24450@redhat.com>
In-Reply-To: <20131007124319.GA24450@redhat.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 08:43 PM, Oleg Nesterov wrote:
> On 10/07, Chen Gang wrote:
>>
>> Within __change_pid(), 'new' may be NULL if it comes from detach_pid(),
>> and 'link->pid' also may be NULL ("link->pid = new"), so theoretically,\
>> the original 'link->pid' may be NULL, too.
> 
> I don't really understand this "theoretically",
> 
>> In real world, at least now, all callers which will call detach_pid()
>> or change_pid() will not cause issue,
> 
> Yes,
> 
>> but still recommend to check it
>> in __change_pid() to let itself consistency.
> 
> Why?
> 
> Contrary, I think we should not hide the problem. If __change_pid() is
> called when task->pids[type].pid is already NULL there is something
> seriously wrong.
> 

Hmm... In my opinion, it means need BUG_ON() for original 'link->pid'.

--------------------------------patch begin-----------------------------

[PATCH] kernel/pid.c: add BUG_ON() for "!pid" in __change_pid()

  Within __change_pid(), 'new' may be NULL if it comes from detach_pid(),
  and 'link->pid' also may be NULL ("link->pid = new"), so theoretically,
  the original 'link->pid' may be NULL, too.

  But in real world, all related extern functions always assume "if
  'link->pid' is already NULL, there must be something seriously wrong",
  although __change_pid() can accept parameter 'new' as NULL.

  So in __change_pid(), need add BUG_ON() for it: "it should not happen,
  when it really happen, OS must be continuing blindly, and next will
  cause serious issue".

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/pid.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 9b9a266..8fc87f1 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -396,6 +396,12 @@ static void __change_pid(struct task_struct *task, enum pid_type type,
 	link = &task->pids[type];
 	pid = link->pid;
 
+	/*
+	 * If task->pids[type].pid is already NULL, there must be something
+	 * seriously wrong
+	 */
+	BUG_ON(!pid);
+
 	hlist_del_rcu(&link->node);
 	link->pid = new;
 
-- 
1.7.7.6

--------------------------------patch end-------------------------------

> Oleg.
> 
> 
> 


-- 
Chen Gang
