Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab3JVPwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:52:55 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:36968 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab3JVPwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:52:53 -0400
Message-ID: <52669F51.8030003@6wind.com>
Date: Tue, 22 Oct 2013 17:52:49 +0200
From: Guillaume Gaudonville <guillaume.gaudonville@6wind.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org, serge.hallyn@canonical.com,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        davem@davemloft.net, cmetcalf@tilera.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH linux-next v2] ns: do not allocate a new nsproxy at
 each call
References: <8738o1ovdi.fsf@xmission.com>	<1382107599-1028-1-git-send-email-guillaume.gaudonville@6wind.com> <87y55qqkck.fsf@xmission.com>
In-Reply-To: <87y55qqkck.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2013 12:34 AM, Eric W. Biederman wrote:
> "Guillaume Gaudonville" <gaudonville@6wind.com> writes:
>
>> Currently, at each call of setns system call a new nsproxy is allocated,
>> the old nsproxy namespaces are copied into the new one and the old nsproxy
>> is freed if the task was the only one to use it.
> In principle this looks ok.  However you are not using rcu properly.
>
> What you are doing is just far enough outside of normal rcu usage my
> brain refuses to think it through today.
Understood, since they are not dereferenced under rcu_read_lock()
and not freed under rcu protection.
> Paul can you give us a hand?
>
> Specific code comments below.
>
> It looks like what we really want for the pointer variables in nsproxy
> is an atomic pointer type.  We have something like that with
> ACCESS_ONCE.    Without a prebuilt idiom I am not thinking through this
> issue clearly right now.
We also want to avoid taking a reference on the old namespace just after 
the
install() function do the put. So we want to read the pointer  and 
increment the
refcount in an atomic way to avoid incrementing a refcount that has 
already gone
to zero.

However, I think this is not needed if we accept to fail to get a 
reference on the
namespace and use the maybe_get_net() (and equivalent for other 
namespaces) in functions
accessing the namespace from the nsproxy. Then we can use the 
ACCESS_ONCE to read the
pointer before giving it to maybe_get_net().
Finally I think a memory barrier is needed to ensure that no compiler 
reordering is done
between the pointer assignment and the put and that the new pointer is 
visible to other
cores before the put.
> Maybe you are right that we need to push the rcu protection down a
> level.  So we can have free reads and inexpensive writes.
>
>> It can creates large delays on hardware with large number of cpus since
>> to free a nsproxy a synchronize_rcu() call is done.
>>
>> When a task is the only one to use a nsproxy, only the task can do an action
>> that will make this nsproxy to be shared by another task or thread (fork,...).
>> So when the refcount of the nsproxy is equal to 1, we can simply update the
>> current nsproxy field without allocating a new one and freeing the old one.
>>
>> The install operations of each kind of namespace cannot fails, so there's no
>> need to check for an error and calling ops->install().
>>
>> However since we can have readers of the nsproxy that are not the current task,
>> we need to protect access to each namespace pointer in the nsproxy. This is
>> done by assigning it using rcu_assign_pointer() and when it is possible
>> that the reader is not the current task, read the pointer using
>> rcu_dereference().
>>
>> Finally the install function of each namespace type must be modified to ensure
>> that the refcount of the old namespace is released after the assignment in
>> nsproxy.
>>
>> On kernel 3.12-rc1, using a small application that does:
>>
>> - call setns on a first net namespace and open a socket,
>> - call setns on a second net namespace and open a socket,
>> - switch back to the first namespace and close the socket,
>> - switch back to the second namespace and close the socket,
> Note.  You don't need to switch namespaces for any operation except
> opening the socket.  Sockets are always fixed in a single network
> namespace.
>
> Part of me wonders if this is the time to introduce the socketat system
> call I threatend people with a while ago that takes a netns file
> descriptor and gives you a socket in the specified namespace.
>
>> On an Intel Westmere with 24 logical cores at 3.33 GHz, it gives the
>> following results using the time command:
>>
>> - without the proposed patch:
>>
>>    root@blackcloudy:~# time ./test_x86
>>
>>    real    0m0.130s
>>    user    0m0.000s
>>    sys     0m0.000s
>>
>> - with the proposed patch:
>>
>>    root@blackcloudy:~# time ./test_x86
>>
>>    real    0m0.020s
>>    user    0m0.000s
>>    sys     0m0.000s
>>
>> Reported-by: Chris Metcalf <cmetcalf@tilera.com>
>> Signed-off-by: Guillaume Gaudonville <guillaume.gaudonville@6wind.com>
>> ---
>>
>> v2:
>>    - protect readers, by releasing namespaces refcount after updating the
>>      nsproxy pointer,
>>    - protect readers, by using rcu_assign_pointer() to affect nsproxy
>>      pointers,
>>    - readers need to use rcu_dereference() to access the namespace and
>>      must take a reference on it before leaving the rcu_read_lock section
>>      (this last part was already present),
>>    - do not add additional exit point in setns syscall.
>>
>> There are still 2 suspicious functions, nfs_server_list_open() and
>> nfs_volume_list_open(). They are accessing directly to the net_ns
>> like below:
>>
>> struct net *net = pid_ns->child_reaper->nsproxy->net_ns;
>>
>> It seems to me that currently they should access it under rcu_read_lock()
>> and using task_nsproxy(pid_ns->child_reaper). It looks like a bug, no?
Do you agree there's also an issue around there?
>>
>> And then with this proposed patch they should access the netns through
>> a rcu_dereference and take a reference on the netns. I didn't
>> modify them for now, but if it is confirmed I can send a patch
>> fixing the first issue and then send a v3 of this proposed patch.
>>
>>   fs/namespace.c           |    9 +++++----
>>   fs/proc/proc_net.c       |    2 +-
>>   fs/proc_namespace.c      |    2 +-
>>   ipc/namespace.c          |    9 +++++----
>>   kernel/nsproxy.c         |   11 +++++++++++
>>   kernel/pid_namespace.c   |    7 ++++---
>>   kernel/utsname.c         |    9 +++++----
>>   net/core/net_namespace.c |   11 ++++++-----
>>   8 files changed, 38 insertions(+), 22 deletions(-)
>>
> [snip]
>
>> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
>> index afc0456..4ad9f9f 100644
>> --- a/kernel/nsproxy.c
>> +++ b/kernel/nsproxy.c
>> @@ -255,6 +255,17 @@ SYSCALL_DEFINE2(setns, int, fd, int, nstype)
>>   	if (nstype && (ops->type != nstype))
>>   		goto out;
>>   
>> +	/*
>> +	 * If count == 1, only the current task can increment it,
>> +	 * by doing a fork for example so we can safely update the
>> +	 * current nsproxy pointers without allocate a new one,
>> +	 * update it and destroy the old one
>> +	 */
>> +	if (atomic_read(&tsk->nsproxy->count) == 1) {
>> +		err = ops->install(tsk->nsproxy, ei->ns);
>> +		goto out;
>> +	}
> Typically to modify something you would need a lock, and the barriers
> that implies.  We don't need a lock but I don't know if missing the
> barriers is a problem.
>
>> +
>>   	new_nsproxy = create_new_namespaces(0, tsk, current_user_ns(), tsk->fs);
>>   	if (IS_ERR(new_nsproxy)) {
>>   		err = PTR_ERR(new_nsproxy);
> [snip]
>> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
>> index 80e271d..966d435 100644
>> --- a/net/core/net_namespace.c
>> +++ b/net/core/net_namespace.c
>> @@ -374,7 +374,7 @@ struct net *get_net_ns_by_pid(pid_t pid)
>>   		struct nsproxy *nsproxy;
>>   		nsproxy = task_nsproxy(tsk);
>>   		if (nsproxy)
>> -			net = get_net(nsproxy->net_ns);
>> +			net = get_net(rcu_dereference(nsproxy->net_ns));
> net_ns is not rcu protected so rcu_derference is misleading and wrong.
> Perhaps ACCESS_ONCE is what we want here.
Agreed. Following above comments it would become something like:
- net = get_net(nsproxy->net_ns);
+ net = maybe_get_net(ACCESS_ONCE(nsproxy->net_ns));
>
>>   	}
>>   	rcu_read_unlock();
>>   	return net;
> [snip]
>
>> @@ -647,14 +647,15 @@ static void netns_put(void *ns)
>>   
>>   static int netns_install(struct nsproxy *nsproxy, void *ns)
>>   {
>> -	struct net *net = ns;
>> +	struct net *old_net, *net = ns;
>>   
>>   	if (!ns_capable(net->user_ns, CAP_SYS_ADMIN) ||
>>   	    !nsown_capable(CAP_SYS_ADMIN))
>>   		return -EPERM;
>>   
>> -	put_net(nsproxy->net_ns);
>> -	nsproxy->net_ns = get_net(net);
>> +	old_net = nsproxy->net_ns;
>> +	rcu_assign_pointer(nsproxy->net_ns, get_net(net));
>> +	put_net(old_net);
> The ordering of operations is correct.  rcu_assign_pointer
> is not correct because net_ns is not rcu protected.
Agreed, I think we need a barrier between the pointer assignment and
the put, something like:

nsproxy->net_ns = get_net(net);
smp_wmb();
put_net(old_net);
>>   	return 0;
>>   }


