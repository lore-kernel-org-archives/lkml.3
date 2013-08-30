Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab3H3UhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 16:37:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52447 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab3H3UhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 16:37:18 -0400
Message-ID: <52210275.8040601@canonical.com>
Date: Fri, 30 Aug 2013 13:37:09 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Richard Guy Briggs <rgb@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 03/12] pid: get ppid pid_t of task in init_pid_ns safely
References: <cover.1377032086.git.rgb@redhat.com> <a411b87ba4c4af251166ee5877cb8c646cf7826c.1377032086.git.rgb@redhat.com> <20130827172155.GC29147@redhat.com> <20130830195646.GJ21110@madcap2.tricolour.ca>
In-Reply-To: <20130830195646.GJ21110@madcap2.tricolour.ca>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2013 12:56 PM, Richard Guy Briggs wrote:
> On Tue, Aug 27, 2013 at 07:21:55PM +0200, Oleg Nesterov wrote:
>> On 08/20, Richard Guy Briggs wrote:
>>>
>>> Added the functions
>>>         task_ppid()
>>>         task_ppid_nr_ns()
>>>         task_ppid_nr_init_ns()
>>> to safely abstract the lookup of the PPID
>>
>> but it is not safe.
>>
>>> +static inline struct pid *task_ppid(struct task_struct *task)
>>> +{
>>> +	return task_tgid(rcu_dereference(current->real_parent));
>>                                          ^^^^^^^
>> task?
> 
> Yup, thanks for those two catches.
> 
>>> +	rcu_read_unlock();
>>
>> And why this is safe?
>>
>> rcu_read_lock() can't help if tsk was already dead _before_ it takes
>> the rcu lock. ->real_parent can point the already freed/reused/unmapped
>> memory.
> 
> Does it not bump a refcount if it is holding a pointer to it?  So the
> parent task might be dead, but it won't cause a pointer dereference
> issue.
> 
>> This is safe if, for example, the caller alredy holds rcu_read_lock()
>> and tsk was found by find_task_by*(), or tsk is current.
> 
> Fair enough, I'll have a more careful look at this.  Thanks.
> 
> Most of the instances are current, but the one called from apparmour is
> stored.  I've just learned that this is bad and someone else just chimed
> in that they have a patch to remove it...

the apparmor case isn't actually stored long term. The stored task will be
a parameter that was passed into an lsm hook and the buffer that it is
stored in dies before the hook is done. Its temporarily stored in the
struct so that it can be passed into the lsm_audit fn, and printed into an
allocated audit buffer. The text version in the audit buffer is what will
exist beyond the hook.

There are three patches, I'll reply them below once I have finished rebasing
them to apply to the current tree instead of my dev tree.

