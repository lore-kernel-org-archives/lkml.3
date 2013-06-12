Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab3FLXb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 19:31:56 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:35219 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758117Ab3FLXby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 19:31:54 -0400
Date: Wed, 12 Jun 2013 16:31:51 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Tejun Heo <theo@redhat.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 2/2] percpu-refcount: implement percpu_tryget() along
 with percpu_ref_kill_and_confirm()
Message-ID: <20130612233151.GA32700@mtj.dyndns.org>
References: <20130612204532.GB15092@htj.dyndns.org>
 <20130612204627.GC15092@htj.dyndns.org>
 <20130612210824.GG6151@google.com>
 <20130612211747.GA2866@htj.dyndns.org>
 <20130612214630.GH6151@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130612214630.GH6151@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, Jun 12, 2013 at 02:46:30PM -0700, Kent Overstreet wrote:
> I'm reading through the cgroup patch/code now - this refcounting is
> _hairy_ so I could certainly believe the way you've done it is the
> sanest way that'll work.

There are several different entities involved in the refcnting.  It's
hairy.

> But it does feel like some of the ordering/ownership is backwards here,
> and that's where the need for confirm_kill is coming from - also, the
> fact that css_tryget() is used more than css_get() is... suspicious.
> 
> Basically, you're wanting the lifetime of the subsystems to be
> controlled by the lifetime of the cgroup. If that's the case, then
> nothing should be taking refs on them (i'm not sure if that's actually
> the case) and they shouldn't be taking refs on the cgroup - the cgroup
> should kill them directly when its ref goes to 0.

The cgroup initiates destruction but controllers are free to hold on
to their part of cgroup (each css) which in turn should pin the cgroup
itself.  Each css proxies cgroup for each controller.  The reference
counting becomes nested but it doesn't change the overall mechanism.

> Of course, if they can't just be killed and they really do need
> independent lifetimes,  then that's a problem - though embedding two
> refcounts in the cgroup might solve that (one for the subsystems, one
> for everything else).

The original intention of the nested refcnting probably is allowing
draining css's separately so that subsystems can be added and removed
from an existing hierarchy.  That never worked out, so it could be
that we can collapse all the css refcnts into cgroup refcnt, which BTW
is currently using the dentry reference count.  I'm fairly certain
that we can collapse it but that's a separate issue we can deal with
later.

Being collapsed or not doesn't really change the necessity for kill
confirming tho.  More on the subject below.

> Uhm, cgroup_offline_fn() seems weird. First it's telling the subsystems
> to go away - but all we know is that tryget() is failing, there could
> still be outstanding refs. What am I missing? offline_css() doesn't
> appear to wait for any refs to hit 0.

offline_css() tells the controllers that the cgroup is being removed
and they should release whatever resources which could be pinning the
css and stop creating such new references, so that whatever in flight
finishes the reference could hit zero.

Some controllers depend on tryget reliably failing for not creating
lasting references, so that's where the requirement for guaranteeing
tryget failure comes in.  Note that it has nothing to do with whether
the refcnts are collapsed into one or not.  It's still the same deal.
You need to confirm that the one refcnt is visible as killed on all
CPUs before starting offlining.

> Then it says it's putting base refs... but base refs should be put with
> percpu_ref_kill(), so what refs are those really?

Ah, that's me forgetting that the base refs are already put and slab
poisoning missing it probably because the css object tends to still be
in RCU purgatory when the last extra put happens.  Will fix.

> Then there's a list_del_rcu() - but that should probably happen _before_
> the call_rcu that percpu_ref_kill() does (in the absense of the bizzare
> cgroup stuff you need the list_del_rcu() or whatever to happen first, so
> that you know no new gets() can happen, then then after the call_rcu()
> it's safe to drop the base ref... if you drop it before the rcu barrier
> you can have a get happen after the ref already hit 0.)

No, there are two separate stages of RCU'ing going on here.  One to
disable tryget for ->css_offline.  The other to actually free the css
as css is expected to be RCU-read accessible during and after
->css_offline().  The percpu ref is adding an extra RCU stage.

> So maybe those lists just aren't used by anything that would take a ref?
> Or is there a barrier or something somewhere else that makes it safe?

The two RCU grace periods are just protecting different things and
they can't be combined.

Thanks.

-- 
tejun
