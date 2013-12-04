Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab3LDN2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:28:36 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33083 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab3LDN2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:28:34 -0500
Date: Wed, 4 Dec 2013 14:28:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        "Ma, Xindong" <xindong.ma@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Sameer Nanda <snanda@chromium.org>, Sergey Dyasly <dserrg@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] introduce for_each_thread() to replace the buggy
 while_each_thread()
Message-ID: <20131204132828.GC4530@localhost.localdomain>
References: <20131204130351.GA5984@redhat.com>
 <20131204130409.GA5998@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204130409.GA5998@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 02:04:09PM +0100, Oleg Nesterov wrote:
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

Thanks, it looks indeed much saner to put the head in the signal struct!

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
> the whole thread group has died.

Would it be safe to have for_each_thread_continue() instead?

> Or thread_group_empty(), currently
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
> ---

Yeah if the conversion needs careful audit, it makes sense to switch incrementally.
