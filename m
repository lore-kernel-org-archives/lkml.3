Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3JVSsH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 14:48:07 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:46007 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab3JVSsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 14:48:05 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: paulmck@linux.vnet.ibm.com
Cc: Guillaume Gaudonville <guillaume.gaudonville@6wind.com>,
        linux-kernel@vger.kernel.org, serge.hallyn@canonical.com,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        davem@davemloft.net, cmetcalf@tilera.com
References: <8738o1ovdi.fsf@xmission.com>
	<1382107599-1028-1-git-send-email-guillaume.gaudonville@6wind.com>
	<87y55qqkck.fsf@xmission.com> <52669F51.8030003@6wind.com>
	<20131022165331.GA4118@linux.vnet.ibm.com>
Date: Tue, 22 Oct 2013 11:47:44 -0700
In-Reply-To: <20131022165331.GA4118@linux.vnet.ibm.com> (Paul E. McKenney's
	message of "Tue, 22 Oct 2013 09:53:32 -0700")
Message-ID: <8761spw3an.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18IF7WytdfhtQfJkqGL717bDjFh3/LCXl8=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3832]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;paulmck@linux.vnet.ibm.com
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH linux-next v2] ns: do not allocate a new nsproxy at each call
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:

> On Tue, Oct 22, 2013 at 05:52:49PM +0200, Guillaume Gaudonville wrote:
>> On 10/19/2013 12:34 AM, Eric W. Biederman wrote:
>> >"Guillaume Gaudonville" <gaudonville@6wind.com> writes:
>> >
>> >>Currently, at each call of setns system call a new nsproxy is allocated,
>> >>the old nsproxy namespaces are copied into the new one and the old nsproxy
>> >>is freed if the task was the only one to use it.
>> >In principle this looks ok.  However you are not using rcu properly.
>> >
>> >What you are doing is just far enough outside of normal rcu usage my
>> >brain refuses to think it through today.
>> Understood, since they are not dereferenced under rcu_read_lock()
>> and not freed under rcu protection.
>> >Paul can you give us a hand?
>
> Maybe...
>
> First let me see if I understand what you are trying to do...
>
> The pattern of code is consistent with a situation where you add data
> elements to a linked structure, but restrict removals in one of the
> following ways:
>
> 1.	Never do removals.
>
> 2.	Any data elements removed are leaked, so that they are never
> 	reused.
>
> 3.	Any data elements removed are added elsewhere in the overall
> 	linked structure, and the possibility of readers being carried
> 	along with a given data element is correctly dealt with.  This
> 	is actually useful in some cases, but it is harder to get right
> 	than it might initially appear.
>
> In this case, insertions can use rcu_assign_pointer() or one of
> the higher-level primitives based on rcu_assign_pointer(), such as
> list_add_rcu().  Traversals can use rcu_dereference().
>
> If for some reason rcu_assign_pointer() is considered bad, you would
> need to do something like the following:
>
> 	q = kmalloc(...);
> 	initialize(q);
> 	smp_wmb();
> 	ACCESS_ONCE(global_q) = q;
>
> Similarly, if for some reason rcu_dereference() is considered bad, you
> would need to do something like the following:
>
> 	q = ACCESS_ONCE(global_q);
> 	smp_read_barrier_depends();
> 	do_something_with(q);
>
> But I would recommend sticking with rcu_assign_pointer() and
> rcu_dereference().  They encapsulate the needed operations nicely
> and their action is well understood.
>
> Of course, if you don't have RCU read-side critical sections, then
> rcu_dereference() will complain given CONFIG_PROVE_RCU=y.  One way
> to avoid this is to use rcu_dereference_raw() instead of
> rcu_dereference(), but in this case please add a comment saying
> what you are doing.
>
> Does this make sense, or am I confused about what you are trying to
> do?

Roughly I think it makes sense.  I am still not certain if
rcu_assign_pointer without the barriers that come with a lock is safe.

My brain has processes this enough to say that we need to mark the
pointer in nsproxy as rcu pointers and use normal rcu discipline on them
regardless of the outcome of this patch.

Unfortunately there is a moderately deep problem with this approach.

Today we have normal refcounting and no rcu on the namespaces as seen by
nsproxy.  And we get our rcu liveness guarantees by calling
synchronize_rcu before putting the nsproxy.  Generally that is not a
problem.

There are cases where the synchronize_rcu makes the setns syscall take
more time than people would like to pay.  Guillaume was attempting to
optimize that out.

Howevever fundamentally without chaning the namespace reference counting
we can not optimize out the synchronize_rcu, or else things like put_net
will execute too soon and we may point at a trashed data structure
inside of the rcu critical section.

This review has pointed out quite a bit of bit rot in the code that
needs to be cleaned up.  Unfortunately the optimization is invalid.

The best I can see happening is adding a rcu head into nsproxy and
using call_rcu to delay the dropping of the reference counts, and I
don't think that is worth it.

>> >>There are still 2 suspicious functions, nfs_server_list_open() and
>> >>nfs_volume_list_open(). They are accessing directly to the net_ns
>> >>like below:
>> >>
>> >>struct net *net = pid_ns->child_reaper->nsproxy->net_ns;

Ick.

>> >>
>> >>It seems to me that currently they should access it under rcu_read_lock()
>> >>and using task_nsproxy(pid_ns->child_reaper). It looks like a bug, no?
>> Do you agree there's also an issue around there?

Yes.  That pid_ns->child_reaper access is ugly.   The child_reaper in
protected by the task_list_lock which is not held there.

Then once you have safely read child_reaper than you need task_nsproxy
and all of the rcu fun.

>> >>@@ -647,14 +647,15 @@ static void netns_put(void *ns)
>> >>  static int netns_install(struct nsproxy *nsproxy, void *ns)
>> >>  {
>> >>-	struct net *net = ns;
>> >>+	struct net *old_net, *net = ns;
>> >>  	if (!ns_capable(net->user_ns, CAP_SYS_ADMIN) ||
>> >>  	    !nsown_capable(CAP_SYS_ADMIN))
>> >>  		return -EPERM;
>> >>-	put_net(nsproxy->net_ns);
>> >>-	nsproxy->net_ns = get_net(net);
>> >>+	old_net = nsproxy->net_ns;
>> >>+	rcu_assign_pointer(nsproxy->net_ns, get_net(net));
>> >>+	put_net(old_net);
>> >The ordering of operations is correct.  rcu_assign_pointer
>> >is not correct because net_ns is not rcu protected.
>> Agreed, I think we need a barrier between the pointer assignment and
>> the put, something like:
>> 
>> nsproxy->net_ns = get_net(net);
>> smp_wmb();
>> put_net(old_net);


There is a deep problem here.  From Paul's comments and thinking about it
this line seems fine.

	rcu_assign_pointer(nsproxy->net_ns, get_net(net));

However to be safe with the current guarantees the code needs to be:
	synchronize_rcu();
	put_net(old_net);

I am pretty certain we want to apply a patch that does some rcu things
with nsproxy for documentation purposes.  Plus the rcu_dereferences you
added.  Something like the patch below.

I don't know if that will make using current->nsproxy->foo_ns warn but
shrug.

Eric

diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index b4ec59d159ac..63c19cdfdbfd 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -28,11 +28,11 @@ struct fs_struct;
  */
 struct nsproxy {
        atomic_t count;
-       struct uts_namespace *uts_ns;
-       struct ipc_namespace *ipc_ns;
-       struct mnt_namespace *mnt_ns;
-       struct pid_namespace *pid_ns_for_children;
-       struct net           *net_ns;
+       struct uts_namespace __rcu *uts_ns;
+       struct ipc_namespace __rcu *ipc_ns;
+       struct mnt_namespace __rcu *mnt_ns;
+       struct pid_namespace __rcu *pid_ns_for_children;
+       struct net           __rcu *net_ns;
 };
 extern struct nsproxy init_nsproxy;
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 373f3abac94e..70c88d96053f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1200,7 +1200,7 @@ struct task_struct {
 /* open file information */
        struct files_struct *files;
 /* namespaces */
-       struct nsproxy *nsproxy;
+       struct nsproxy __rcu *nsproxy;
 /* signal handlers */
        struct signal_struct *signal;
        struct sighand_struct *sighand;




