Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab3HUCSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 22:18:53 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:54554 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab3HUCSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 22:18:52 -0400
Date: Tue, 20 Aug 2013 19:19:00 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, Christoph Hellwig <hch@infradead.org>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        akpm@linux-foundation.org
Subject: Re: [PATCH] bcache: Remove use of down/up_read_non_owner()
Message-ID: <20130821021900.GB4051@kmo-pixel>
References: <20130820111602.3cea203c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820111602.3cea203c@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 11:16:02AM -0400, Steven Rostedt wrote:
> 
> The down/up_read_non_owner() is a nasty hack in the API of the rwsem
> operations. It was once removed, but then resurrected for use with
> bcache. Not only is the API an abomination to the rwsem API, it also
> prevents bcache from ever being compiled with PREEMPT_RT, as the RT
> kernel requires all rwsems to have an owner.
> 
> Instead of keeping the down/up_read_non_owner() around, it is better to
> modify the one user of it and have it do something a bit differently.
> 
> From reading the bcache code, the reason for the non_owner usage is
> that a request is made, and writers must wait for that request to
> finish before they can continue. But because the request is completed
> by another task, the rwsem can not be held for read and then released
> on completion.
> 
> Instead of abusing the rwsem code for this, I added a refcount
> "nr_requests" to the cached_dev structure as well as a "write_waiters"
> wait queue. When a request is to be made, the rwsem is still taken for
> read, but this time with an owner. The refcount is incremented and
> before exiting the function, the rwsem is released.
> 
> The writer will then take the rwsem for write, check the refcount, if
> it is not zero, it will release the rwsem, add itself to a wait_event()
> waiting for refcount to become zero, and then try again.

I _really_ disagree with this approach.

I get that there's a problem, but the bcache code REALLY IS USING THE
RWSEM AS A LOCK; the answer isn't to open code the lock!

Apologies to Christoph for getting distracted and not responding when
you started to explain what the issues were for RT. I'm not really
convinced they're that insurmountable (one of the issues was debugging,
which the _non_owner() stuff always handled just fine), but I'll take it
on faith that this usage is incompatible with rwsems + the RT
functionality since I haven't actually had time to dig into it.

So assuming that's the case, IMO the sanest thing to do is make a new
type of lock - "rwsem_non_process" or somesuch - and use _that_ in
bcache. Not open coding the lock.

It can even live in the bcache code if we want since there currently
wouldn't be any other users, I don't really care. But open coding it?
Come on... makes me wonder what other code in the kernel is open coding
locks because it couldn't release it in the same process context that
took the lock for whatever reason.

Also, nack this patch because increasing the number of atomic ops to
shared cachelines in our fast path. If it does end up being open coded,
I'll make a more efficient version.
