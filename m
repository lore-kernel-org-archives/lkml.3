Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab3LEA6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:58:18 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:41215 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342Ab3LEA6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:58:14 -0500
Date: Wed, 4 Dec 2013 16:58:09 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        "Ma, Xindong" <xindong.ma@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Sameer Nanda <snanda@chromium.org>, Sergey Dyasly <dserrg@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] introduce for_each_thread() to replace the buggy
 while_each_thread()
In-Reply-To: <20131204130409.GA5998@redhat.com>
Message-ID: <alpine.DEB.2.02.1312041657210.13608@chino.kir.corp.google.com>
References: <20131204130409.GA5998@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Dec 2013, Oleg Nesterov wrote:

> while_each_thread() and next_thread() should die, almost every
> lockless usage is wrong.
> 
> 1. Unless g == current, the lockless while_each_thread() is not safe.
> 
>    while_each_thread(g, t) can loop forever if g exits, next_thread()
>    can't reach the unhashed thread in this case. Note that this can
>    happen even if g is the group leader, it can exec.
> 
> 2. Even if while_each_thread() itself was correct, people often use
>    it wrongly.
> 
>    It was never safe to just take rcu_read_lock() and loop unless
>    you verify that pid_alive(g) == T, even the first next_thread()
>    can point to the already freed/reused memory.
> 
> This patch adds signal_struct->thread_head and task->thread_node
> to create the normal rcu-safe list with the stable head. The new
> for_each_thread(g, t) helper is always safe under rcu_read_lock()
> as long as this task_struct can't go away.
> 
> Note: of course it is ugly to have both task_struct->thread_node
> and the old task_struct->thread_group, we will kill it later, after
> we change the users of while_each_thread() to use for_each_thread().
> 
> Perhaps we can kill it even before we convert all users, we can
> reimplement next_thread(t) using the new thread_head/thread_node.
> But we can't do this right now because this will lead to subtle
> behavioural changes. For example, do/while_each_thread() always
> sees at least one task, while for_each_thread() can do nothing if
> the whole thread group has died. Or thread_group_empty(), currently
> its semantics is not clear unless thread_group_leader(p) and we
> need to audit the callers before we can change it.
> 
> So this patch adds the new interface which has to coexist with the
> old one for some time, hopefully the next changes will be more or
> less straightforward and the old one will go away soon.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Reviewed-and-Tested-by: Sergey Dyasly <dserrg@gmail.com>
> Reviewed-by: Sameer Nanda <snanda@chromium.org>

Acked-by: David Rientjes <rientjes@google.com>

Minor: should the definitions of thread_{head,node} be annotated with 
__rcu for users of CONFIG_SPARSE_RCU_POINTER?
