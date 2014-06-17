Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbaFQS4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 14:56:11 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:52036 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbaFQS4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 14:56:09 -0400
Date: Tue, 17 Jun 2014 14:56:05 -0400
From: Tejun Heo <tj@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
Message-ID: <20140617185605.GL31819@htj.dyndns.org>
References: <20140612135630.GA23606@htj.dyndns.org>
 <20140612153426.GV4581@linux.vnet.ibm.com>
 <20140612155227.GB23606@htj.dyndns.org>
 <20140617144151.GD4669@linux.vnet.ibm.com>
 <20140617152752.GC31819@htj.dyndns.org>
 <20140617165702.GF4669@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140617165702.GF4669@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paul.

On Tue, Jun 17, 2014 at 09:57:02AM -0700, Paul E. McKenney wrote:
> I am not sure that this is actually better than having the allocating
> CPU do the initialization, though, even given a large number of CPUs.
> Or maybe even especially given a large number of CPUs.  The bit about
> asking all the other CPUs to do their allocations and initializations
> and then waiting for them to respond might not be pretty.

If it ever happens, it'd probably be the allocator trying to keep
certain amount ready as allocation buffer with buffer refill
synchronization happening lazily in large chunks.  We don't need
anything like that at this point.  I was trying to point out that the
semantics isn't immediately clear.

> > * Add data dependency barrier to percpu accessors and write barrier to
> >   the allocator with the comment that this will be replaced with
> >   proper assignment macros and mark this change w/ -stable.
> > 
> > * Later, introduce percpu pointer assignment macros and convert all
> >   users and remove the wmb added above.
> 
> This longer-term approach seems like a good one to me.

Alright, going that way then.  This will bring percpu usages very
close to RCU, which I like.

> I much prefer the model where the thing that -published- the pointer is
> responsible for memory ordering.  After all, if a task allocates some
> zeroed memory, uses it locally, then frees it, there is no ordering
> to worry about in the first place.  The memory allocator doing the
> initialization cannot tell how the memory is to be used, after all.

Yeah, "publish" is a nice verb to put on it.  No objection.

Thanks.

-- 
tejun
