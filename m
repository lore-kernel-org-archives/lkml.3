Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933998Ab3FSBby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:31:54 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:59589 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab3FSBbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:31:52 -0400
Date: Tue, 18 Jun 2013 18:32:18 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Jeff Layton <jlayton@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] Percpu tag allocator
Message-ID: <20130619013218.GB30262@moria.home.lan>
References: <1371009804-11596-1-git-send-email-koverstreet@google.com>
 <20130612163854.91da28042ab7a943b69a5970@linux-foundation.org>
 <20130613020536.GA10979@localhost>
 <20130612200311.7f9d938a.akpm@linux-foundation.org>
 <20130613185318.GB12075@mtj.dyndns.org>
 <20130613120439.fe56d178a1143089136fdacc@linux-foundation.org>
 <20130613191507.GB13970@mtj.dyndns.org>
 <20130613122339.239a721d097a64435817a780@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613122339.239a721d097a64435817a780@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 12:23:39PM -0700, Andrew Morton wrote:
> On Thu, 13 Jun 2013 12:15:07 -0700 Tejun Heo <tj@kernel.org> wrote:
> > Oh, I'm sure the current id[r|a] can be improved upon a lot but I'm
> > very skeptical one can reach the level of scalability necessary for,
> > say, pci-e attached extremely high-iops devices while still keeping
> > the lowest number allocation, which can't be achieved without strong
> > synchronization on each alloc/free.
> > 
> > Maybe we can layer things so that we have percpu layer on top of
> > id[r|a] and, say, mapping id to point is still done by idr, or the
> > percpu tag allocator uses ida for tag chunk allocations, but it's
> > still gonna be something extra on top.
> 
> It's not obvious that explicit per-cpu is needed.  Get an ID from
> ida_get_new_above(), multiply it by 16 and store that in device-local
> storage, along with a 16-bit bitmap.  Blam, 30 lines of code and the
> ida_get_new_above() cost is reduced 16x and it's off the map.

I was just rereading emails and realized I should've replied to this.

So, I started out aiming for something simpler. I don't quite follow
what the approach you're suggesting is, but it ends up you really do
need the percpu freelists (buffering batching/freeing from the main
freelist) because ids/tags may not be freed on the cpu they were
allocated on.

In particular, if this is for a driver and the device doesn't implement
per cpu queues, tags are almost always going to be freed on a different
cpu. If you just give each cpu a fraction of the tag space they always
allocate out of (with ida_get_new_above() or similar) - that only helps
allocation, half the cacheline contention is freeing.

I originally wrote this tag allocator to use in a driver for a device
that didn't support multiple hardware queues at all, but it was fast
enough that any cacheline bouncing really hurt.

So that right there gets you to the basic design where you've got a
global freelist and percpu freelists, and you just use the percpu
freelists to batch up allocation/freeing to the global freelist.

The tag allocator I was going to submit for the aio code was pretty much
just that, nothing more. It was simple. It worked. I was happy with it.

The one concern with this approach is what happens when all the percpu
freelists except your are full of free tags. Originally, I had an easy
solution - we calculate the size of the percpu freelists based on
nr_tags and num_possible_cpus, so that there can't be more than half of
the tag space stranded like this.

(Keep in mind the main use case is drivers where the tag/id is used to
talk to the device, so you're limited by whatever the hardware people
thought was enough - 16 bits if you're lucky).

But then Tejun went and pointed out, just as I was about to mail it off
- "Hey, what happens if you've got 4096 cpus and not all that many tags?
Youv'e got a nice divice by zero in there".

After which I proceeded to swear at him a bit, but - well, it's a real
problem. And that is what led to the tag stealing stuff and all the
cmpxchg() shenanigans. And I'm pretty happy with the solution - there's
an elegance to it and I bet if I cared I could come up with a proof that
it's more or less optimal w.r.t. cacheline bounces for some decent
fraction of workloads we might care about. But yeah, it's not as simple
as I would've liked.

Anyways, now you've got an ida/idr api cleanup/rewrite to go along with
it, and it's all nicely integrated. Integrating the percpu tag allocator
with regular ida really doesn't save us any code - the original global
freelist was a stack and like 10 lines of code total.

But having the apis be consistent and having it all be organized and
pretty is nice. I think it is now, anyways :)
