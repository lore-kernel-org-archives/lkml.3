Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaGIBNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 21:13:20 -0400
Received: from ozlabs.org ([103.22.144.67]:37463 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbaGIBNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 21:13:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu accessors and operations
In-Reply-To: <20140617152752.GC31819@htj.dyndns.org>
References: <20140612135630.GA23606@htj.dyndns.org> <20140612153426.GV4581@linux.vnet.ibm.com> <20140612155227.GB23606@htj.dyndns.org> <20140617144151.GD4669@linux.vnet.ibm.com> <20140617152752.GC31819@htj.dyndns.org>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 09 Jul 2014 10:25:44 +0930
Message-ID: <87lhs35p0v.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:
> Hello, Paul.

Rusty wakes up...

>> Good point.  How about per-CPU variables that are introduced by
>> loadable modules?  (I would guess that there are plenty of memory
>> barriers in the load process, given that text and data also needs
>> to be visible to other CPUs.)
>
> (cc'ing Rusty, hi!)
>
> Percpu initialization happens in post_relocation() before
> module_finalize().  There seem to be enough operations which can act
> as write barrier afterwards but nothing seems explicit.
>
> I have no idea how we're guaranteeing that .data is visible to all
> cpus without barrier from reader side.  Maybe we don't allow something
> like the following?
>
>   module init				built-in code
>
>   static int mod_static_var = X;	if (builtin_ptr)
>   builtin_ptr = &mod_static_var;		WARN_ON(*builtin_ptr != X);
>
> Rusty, can you please enlighten me?

Subtle, but I think in theory (though not in practice) this can happen.

Making this this assigner's responsibility is nasty, since we reasonably
assume that .data is consistent across CPUs once code is executing
(similarly on boot).

>> Again, it won't help for the allocator to strongly order the
>> initialization to zero if there are additional initializations of some
>> fields to non-zero values.  And again, it should be a lot easier to
>> require the smp_store_release() or whatever uniformly than only in cases
>> where additional initialization occurred.
>
> This one is less murky as we can say that the cpu which allocated owns
> the zeroing; however, it still deviates from requiring the one which
> makes changes to take care of barriering for those changes, which is
> what makes me feel a bit uneasy.  IOW, it's the allocator which
> cleared the memory, why should its users worry about in-flight
> operations from it?  That said, this poses a lot less issues compared
> to percpu ones as passing normal pointers to other cpus w/o going
> through proper set of barriers is a special thing to do anyway.

I think that the implicit per-cpu allocations done by modules need to
be consistent once the module is running.

I'm deeply reluctant to advocate it in the other per-cpu cases though.
Once we add a barrier, it's impossible to remove: callers may subtly
rely on the behavior.

"Magic barrier sprinkles" is a bad path to start down, IMHO.

Cheers,
Rusty.
