Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933643Ab3FRS0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 14:26:46 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:58919 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908Ab3FRS0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 14:26:44 -0400
Date: Tue, 18 Jun 2013 11:27:08 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tj@kernel.org,
        axboe@kernel.dk, nab@linux-iscsi.org, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 4/4] idr: Percpu ida
Message-ID: <20130618182708.GA30262@moria.home.lan>
References: <1371532754-14357-1-git-send-email-koverstreet@google.com>
 <1371532754-14357-4-git-send-email-koverstreet@google.com>
 <0000013f57a3643b-beb6be35-adb0-436e-837a-db93c19b445e-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013f57a3643b-beb6be35-adb0-436e-837a-db93c19b445e-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 02:14:53PM +0000, Christoph Lameter wrote:
> On Mon, 17 Jun 2013, Kent Overstreet wrote:
> 
> > +static inline unsigned alloc_local_tag(struct percpu_ida *pool,
> > +				       struct percpu_ida_cpu *tags)
> > +{
> > +	int tag = -ENOSPC;
> > +
> > +	spin_lock(&tags->lock);
> > +	if (tags->nr_free)
> > +			tag = tags->freelist[--tags->nr_free];
> > +	spin_unlock(&tags->lock);
> > +
> > +	return tag;
> > +}
> 
> This could be made much faster by avoiding real atomics (coming with
> spinlocks) and using per cpu atomics instead. Slub f.e. uses a single
> linked per cpu list managed via this_cpu_cmpxchg.

Actually, we do need the atomic ops - they're protecting against a
different cpu grabbing our freelist with steal_tags().

The alternative (which Andrew Morton suggested and Jens implemented in
his fork of an earlier version of this code) would be to use IPIs, but
there are reasonable use cases (high ratio of cpus:nr_tags) where tag
stealing is going to be reasonably common so we don't want it to suck
too much. Plus, steal_tags() needs to try different cpu's freelists
until it finds one with tags, IPIs would make that loop... problematic.

I actually originally used cmpxchg(), but then later in review I
realized I had an ABA and couldn't figure out how to solve it, so that's
when I switched to spinlocks (which Andrew Morton preferred anyways).

But I just realized a few minutes ago I've seen your solution to ABA
with a stack, in the slub code - double word cmpxchg() with a
transaction id :) I may try that again just to see how the code looks,
but I'm not sure the difference in performance will be big enough to
matter, give that this lock should basically never be contended.
