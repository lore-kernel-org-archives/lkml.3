Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbaEHVk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 17:40:26 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:65397 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbaEHVkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 17:40:25 -0400
Subject: Re: [BUG] kmemleak on __radix_tree_preload
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset=windows-1252
From: Catalin Marinas <catalin.marinas@arm.com>
In-Reply-To: <20140508175222.GM19914@cmpxchg.org>
Date: Thu, 8 May 2014 22:40:22 +0100
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <C810FC85-01F4-4301-A4AA-B85380D4F2FB@arm.com>
References: <20140501184112.GH23420@cmpxchg.org> <1399431488.13268.29.camel@kjgkr> <20140507113928.GB17253@arm.com> <1399540611.13268.45.camel@kjgkr> <20140508092646.GA17349@arm.com> <1399541860.13268.48.camel@kjgkr> <20140508102436.GC17344@arm.com> <20140508150026.GA8754@linux.vnet.ibm.com> <20140508152946.GA10470@localhost> <20140508155330.GE8754@linux.vnet.ibm.com> <20140508175222.GM19914@cmpxchg.org>
To: Johannes Weiner <hannes@cmpxchg.org>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 May 2014, at 18:52, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Thu, May 08, 2014 at 08:53:30AM -0700, Paul E. McKenney wrote:
>> On Thu, May 08, 2014 at 04:29:48PM +0100, Catalin Marinas wrote:
>>> On Thu, May 08, 2014 at 04:00:27PM +0100, Paul E. McKenney wrote:
>>>> On Thu, May 08, 2014 at 11:24:36AM +0100, Catalin Marinas wrote:
>>>>> My summary so far:
>>>>> 
>>>>> - radix_tree_node reported by kmemleak as it cannot find any trace of it
>>>>>  when scanning the memory
>>>>> - at allocation time, radix_tree_node is memzero'ed by
>>>>>  radix_tree_node_ctor(). Given that node->rcu_head.func ==
>>>>>  radix_tree_node_rcu_free, my guess is that radix_tree_node_free() has
>>>>>  been called
> 
> The constructor is called once when the slab is initially allocated,
> not on every object allocation.  The user is expected to return
> objects in a pristine form or overwrite fields on reallocation, so
> it's possible that the RCU values are left over from the previous
> allocation.

You are right, I missed this one.

>>>>> - some time later, kmemleak still hasn't received any callback for
>>>>>  kmem_cache_free(node). Possibly radix_tree_node_rcu_free() hasn't been
>>>>>  called either since node->count is not NULL.
>>>>> 
>>>>> For RCU queued objects, kmemleak should still track references to them
>>>>> via rcu_sched_state and rcu_head members. But even if this went wrong, I
>>>>> would expect the object to be freed eventually and kmemleak notified (so
>>>>> just a temporary leak report which doesn't seem to be the case here).

[…]

>>>> Of course, if the value of node->count is preventing call_rcu() from
>>>> being invoked in the first place, then the needed grace period won't
>>>> start, much less finish.  ;-)
>>> 
>>> Given the rcu_head.func value, my assumption is that call_rcu() has
>>> already been called.
>> 
>> Fair point -- given that it is a union, you would expect this field to
>> be overwritten upon reuse.
> 
> .parent is overwritten immediately on reuse, but .private_data is
> actually unlikely to be used during the lifetime of the node.
> 
> This could explain why .rcu.head.next is NULL like parent, and
> .private_data/.rcu.head.func is untouched and retains RCU stuff: to me
> it doesn't look like the node is lost in RCU-freeing, rather it was
> previously RCU freed and then lost somewhere after reallocation.

This would be a simpler explanation, and even simpler to test, just
reset rcu_head.func in radix_tree_node_rcu_free() before being returned
to the slab allocator.

Does the negative count give us any clue? This one is reset before
freeing the object.

Thanks,

Catalin