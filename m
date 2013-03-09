Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751112Ab3CISi0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 13:38:26 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:36524 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab3CISiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 13:38:24 -0500
Date: Sat, 9 Mar 2013 07:51:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, ebiederm@xmission.com,
        Eric Dumazet <eric.dumazet@gmail.com>, CAI Qian <caiqian@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: 3.9-rc1 NULL pointer crash at find_pid_ns
Message-ID: <20130309155146.GR3268@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <611667212.10748821.1362649031475.JavaMail.root@redhat.com>
 <513860E8.4080807@huawei.com>
 <876213wmwt.fsf@xmission.com>
 <5138D001.8000409@oracle.com>
 <1362678371.15793.218.camel@edumazet-glaptop>
 <5138D377.6040406@oracle.com>
 <87boavrspd.fsf@xmission.com>
 <5138D8F2.5020900@oracle.com>
 <20130307182934.GY3268@linux.vnet.ibm.com>
 <513AEC65.8000008@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513AEC65.8000008@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030918-5406-0000-0000-0000062694D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 09, 2013 at 04:01:41PM +0800, Li Zefan wrote:

[ . . . ]

> >> hlist_first_rcu() doesn't have any side-effects, it doesn't modify the list whatsoever,
> >> so the only thing that can change is 'head'. Why is it allowed to change if the list
> >> is protected by RCU?
> > 
> > RCU does not prevent the list from changing.  Instead, it prevents anything
> > that was in the list from being freed during a given RCU read-side critical
> > section.  Here is how it is supposed to happen:
> > 
> > 	head---->A
> > 
> > Task 1 picks up the pointer from head to A, and sees that it is non-NULL.
> > 
> > Task 2 removes A from the list, so that the pointer from head is now NULL:
> > 
> > 	head     A
> > 	  |
> > 	  |
> > 	  V
> >         NULL
> > 
> > Now task 1 refetches from head, and is fatally disappointed to get a
> > NULL pointer.
> > 
> > Now, had task 1 avoided the refetch, it would be still working with
> > a pointer to A.  Since A won't be freed until the end of an RCU grace
> > period, all would have been well.  Again, one way to handle this is
> > as follows:
> > 
> > #define hlist_entry_safe(ptr, type, member) \
> > 	({ typeof(ptr) ____ptr = (ptr); \
> > 	   ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
> > 	})
> > 
> > This way, "ptr" is executed exactly once, and the check and the
> > hlist_entry() are both using the same value.
> 
> I just played with trinity, and triggered this bug in just a few mins,
> and I tried Paul's proposed fix and it works.

Thank you for testing this!  Please see below for the patch.

Sasha, will you be pushing this or would you like me to do so?

							Thanx, Paul

------------------------------------------------------------------------

list: Fix double fetch of pointer in hlist_entry_safe()

The current version of hlist_entry_safe() fetches the pointer twice,
once to test for NULL and the other to compute the offset back to the
enclosing structure.  This is OK for normal lock-based use because in
that case, the pointer cannot change.  However, when the pointer is
protected by RCU (as in "rcu_dereference(p)"), then the pointer can
change at any time.  This use case can result in the following sequence
of events:

1.	CPU 0 invokes hlist_entry_safe(), fetches the RCU-protected
	pointer as sees that it is non-NULL.

2.	CPU 1 invokes hlist_del_rcu(), deleting the entry that CPU 0
	just fetched a pointer to.  Because this is the last entry
	in the list, the pointer fetched by CPU 0 is now NULL.

3.	CPU 0 refetches the pointer, obtains NULL, and then gets a
	NULL-pointer crash.

This commit therefore applies gcc's "({ })" statement expression to
create a temporary variable so that the specified pointer is fetched
only once, avoiding the above sequence of events.  Please note that
it is the caller's responsibility to use rcu_dereference() as needed.
This allows RCU-protected uses to work correctly without imposing
any additional overhead on the non-RCU case.

Many thanks to Eric Dumazet for spotting root cause!

Reported-by: CAI Qian <caiqian@redhat.com>
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Li Zefan <lizefan@huawei.com>

diff --git a/include/linux/list.h b/include/linux/list.h
index d991cc1..6a1f8df 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -667,7 +667,9 @@ static inline void hlist_move_list(struct hlist_head *old,
 	     pos = n)
 
 #define hlist_entry_safe(ptr, type, member) \
-	(ptr) ? hlist_entry(ptr, type, member) : NULL
+	({ typeof(ptr) ____ptr = (ptr); \
+	   ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
+	})
 
 /**
  * hlist_for_each_entry	- iterate over list of given type

