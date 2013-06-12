Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab3FLVqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 17:46:35 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35953 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab3FLVqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 17:46:34 -0400
Date: Wed, 12 Jun 2013 14:46:30 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Tejun Heo <theo@redhat.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/2] percpu-refcount: implement percpu_tryget() along
 with percpu_ref_kill_and_confirm()
Message-ID: <20130612214630.GH6151@google.com>
References: <20130612204532.GB15092@htj.dyndns.org>
 <20130612204627.GC15092@htj.dyndns.org>
 <20130612210824.GG6151@google.com>
 <20130612211747.GA2866@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130612211747.GA2866@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 02:17:47PM -0700, Tejun Heo wrote:
> Yeap, this is icky.  If you have any better ideas, I'm all ears.

I'm reading through the cgroup patch/code now - this refcounting is
_hairy_ so I could certainly believe the way you've done it is the
sanest way that'll work.

But it does feel like some of the ordering/ownership is backwards here,
and that's where the need for confirm_kill is coming from - also, the
fact that css_tryget() is used more than css_get() is... suspicious.

Basically, you're wanting the lifetime of the subsystems to be
controlled by the lifetime of the cgroup. If that's the case, then
nothing should be taking refs on them (i'm not sure if that's actually
the case) and they shouldn't be taking refs on the cgroup - the cgroup
should kill them directly when its ref goes to 0.

Of course, if they can't just be killed and they really do need
independent lifetimes,  then that's a problem - though embedding two
refcounts in the cgroup might solve that (one for the subsystems, one
for everything else).

Uhm, cgroup_offline_fn() seems weird. First it's telling the subsystems
to go away - but all we know is that tryget() is failing, there could
still be outstanding refs. What am I missing? offline_css() doesn't
appear to wait for any refs to hit 0.

Then it says it's putting base refs... but base refs should be put with
percpu_ref_kill(), so what refs are those really?

Then there's a list_del_rcu() - but that should probably happen _before_
the call_rcu that percpu_ref_kill() does (in the absense of the bizzare
cgroup stuff you need the list_del_rcu() or whatever to happen first, so
that you know no new gets() can happen, then then after the call_rcu()
it's safe to drop the base ref... if you drop it before the rcu barrier
you can have a get happen after the ref already hit 0.)

So maybe those lists just aren't used by anything that would take a ref?
Or is there a barrier or something somewhere else that makes it safe?

> 
> > > -void percpu_ref_kill(struct percpu_ref *ref)
> > > +void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
> > > +				 percpu_ref_func_t *confirm_kill)
> > 
> > Passing release to percpu_ref_init() and confirm_kill to
> > percpu_ref_kill() is inconsistent. Can we pass them both to
> > percpu_ref_init()?
> 
> I don't know.  Maybe.  While they're stored in the same place,
> @confirm_kill is really an optional part of killing itself, so
> specifying it to kill *seems* like the better place and it also marks
> it clearly that something funky is going on during while killing the
> reference count.

I missed the part where you kept percpu_ref_kill() as a wrapper - the
way you did it makes more sense now.
