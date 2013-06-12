Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab3FLVRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 17:17:54 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:36266 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711Ab3FLVRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 17:17:53 -0400
Date: Wed, 12 Jun 2013 14:17:47 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Tejun Heo <theo@redhat.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/2] percpu-refcount: implement percpu_tryget() along
 with percpu_ref_kill_and_confirm()
Message-ID: <20130612211747.GA2866@htj.dyndns.org>
References: <20130612204532.GB15092@htj.dyndns.org>
 <20130612204627.GC15092@htj.dyndns.org>
 <20130612210824.GG6151@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130612210824.GG6151@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Kent.

On Wed, Jun 12, 2013 at 02:08:24PM -0700, Kent Overstreet wrote:
> On Wed, Jun 12, 2013 at 01:46:27PM -0700, Tejun Heo wrote:
> > From de3c0749e2c1960afcc433fc5da136b85c8bd896 Mon Sep 17 00:00:00 2001
> > From: Tejun Heo <tj@kernel.org>
> > Date: Wed, 12 Jun 2013 13:37:42 -0700
> > 
> > Implement percpu_tryget() which succeeds iff the refcount hasn't been
> > killed yet.  Because the refcnt is per-cpu, different CPUs may have
> > different perceptions on when the counter has been killed and tryget()
> > may continue to succeed for a while after percpu_ref_kill() returns.
> 
> I don't feel very comfortable with saying percpu_ref_tryget() succeeds
> "iff the refcount hasn't been killed yet".  That's something I would say

Yeah, the phrasing of the first sentence could be a bit misleading.
It probably should emphasize that there's no synchronization by
default from the beginning.

> about e.g. atomic_inc_not_zero(), but percpu_ref_tryget() doesn't do
> that sort of synchronization which is what iff implies to me.
> 
> If the user does need some kind of strict ordering between
> percpu_ref_kill() and percpu_ref_tryget(), they'd have to insert some
> memory barriers - tryget() certainly doesn't have any.

which is why percpu_ref_kill_and_confirm() has been added.

> > While this isn't the prettiest interface, it doesn't force synchronous
> > wait and is much safer than requiring the caller to do its own
> > call_rcu().
> 
> Yeah, this seems... icky to me. I'm going to withhold judgement until I
> see how it's used, maybe there isn't any other way but I'd like to try
> and find something prettier.

Yeap, this is icky.  If you have any better ideas, I'm all ears.

> > -void percpu_ref_kill(struct percpu_ref *ref)
> > +void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
> > +				 percpu_ref_func_t *confirm_kill)
> 
> Passing release to percpu_ref_init() and confirm_kill to
> percpu_ref_kill() is inconsistent. Can we pass them both to
> percpu_ref_init()?

I don't know.  Maybe.  While they're stored in the same place,
@confirm_kill is really an optional part of killing itself, so
specifying it to kill *seems* like the better place and it also marks
it clearly that something funky is going on during while killing the
reference count.

> Also, given that confirm_kill is an optional thing I don't see why
> you're renaming percpu_ref_kill() -> percpu_ref_kill_and_confirm(). Most
> users (certainly aio, I think the module code too) don't have any use
> for confirm kill, I don't want to rename it for an ugly optional thing.

Hmm?  percpu_ref_kill() is still there.  It now just calls the ugly
thing with %NULL @confirm_kill.

Thanks.

-- 
tejun
