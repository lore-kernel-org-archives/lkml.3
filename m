Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759679Ab3CGS3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 13:29:54 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:52931 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759218Ab3CGS3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 13:29:53 -0500
Date: Thu, 7 Mar 2013 10:29:34 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: ebiederm@xmission.com, Eric Dumazet <eric.dumazet@gmail.com>,
        Li Zefan <lizefan@huawei.com>, CAI Qian <caiqian@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: 3.9-rc1 NULL pointer crash at find_pid_ns
Message-ID: <20130307182934.GY3268@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <611667212.10748821.1362649031475.JavaMail.root@redhat.com>
 <513860E8.4080807@huawei.com>
 <876213wmwt.fsf@xmission.com>
 <5138D001.8000409@oracle.com>
 <1362678371.15793.218.camel@edumazet-glaptop>
 <5138D377.6040406@oracle.com>
 <87boavrspd.fsf@xmission.com>
 <5138D8F2.5020900@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5138D8F2.5020900@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030718-3620-0000-0000-000001874B64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 01:14:10PM -0500, Sasha Levin wrote:
> On 03/07/2013 01:05 PM, ebiederm@xmission.com wrote:
> > Sasha Levin <sasha.levin@oracle.com> writes:
> > 
> >> On 03/07/2013 12:46 PM, Eric Dumazet wrote:
> >>> On Thu, 2013-03-07 at 12:36 -0500, Sasha Levin wrote:
> >>>
> >>>> Looks like the hlist change is probably the issue, though it specifically
> >>>> uses:
> >>>>
> >>>> 	#define hlist_entry_safe(ptr, type, member) \
> >>>>         	(ptr) ? hlist_entry(ptr, type, member) : NULL
> >>>>
> >>>> I'm still looking at the code in question and it's assembly, but I can't
> >>>> figure out what's going wrong. I was also trying to see what's so special
> >>>> about this loop in find_pid_ns as opposed to the rest of the kernel code
> >>>> that uses hlist_for_each_entry_rcu() but couldn't find out why.
> >>>>
> >>>> Is it somehow possible that if we rcu_dereference_raw() the same thing twice
> >>>> inside the same rcu_read_lock() section we'll get different results? That's
> >>>> really the only reason for this crash that comes to mind at the moment, very
> >>>> unlikely - but that's all I have right now.
> >>>>
> >>>
> >>> Yep
> >>>
> >>> #define hlist_entry_safe(ptr, type, member) \
> >>> 	(ptr) ? hlist_entry(ptr, type, member) : NULL
> >>>
> >>> Is not safe, as ptr can be evaluated twice, and thats not good at all...
> >>
> >> ptr is being evaluated twice, but in this case this is an
> >> rcu_dereference_raw() value within the same rcu_read_lock() section.
> >>
> >> Is it still problematic?
> > 
> > Definitely.
> > 
> > Head in this instance the expression: &pid_hash[pid_hashfn(nr, ns)]
> > 
> > And the crash clearly shows that when hilst_entry is being evaluated the
> > HEAD is NULL.
> 
> Okay, I'm even more confused now.
> 
> The expression in question is:
> 
> 	hlist_entry_safe(rcu_dereference_bh(hlist_first_rcu(head)))
> 
> You're saying that "rcu_dereference_bh(hlist_first_rcu(head))" can change between
> the two evaluations we do. That would mean that 'head' has changed in between, right?
> 
> In that case, the list itself has changed - which means that RCU has changed the
> list underneath us.
> 
> hlist_first_rcu() doesn't have any side-effects, it doesn't modify the list whatsoever,
> so the only thing that can change is 'head'. Why is it allowed to change if the list
> is protected by RCU?

RCU does not prevent the list from changing.  Instead, it prevents anything
that was in the list from being freed during a given RCU read-side critical
section.  Here is how it is supposed to happen:

	head---->A

Task 1 picks up the pointer from head to A, and sees that it is non-NULL.

Task 2 removes A from the list, so that the pointer from head is now NULL:

	head     A
	  |
	  |
	  V
        NULL

Now task 1 refetches from head, and is fatally disappointed to get a
NULL pointer.

Now, had task 1 avoided the refetch, it would be still working with
a pointer to A.  Since A won't be freed until the end of an RCU grace
period, all would have been well.  Again, one way to handle this is
as follows:

#define hlist_entry_safe(ptr, type, member) \
	({ typeof(ptr) ____ptr = (ptr); \
	   ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
	})

This way, "ptr" is executed exactly once, and the check and the
hlist_entry() are both using the same value.

							Thanx, Paul

