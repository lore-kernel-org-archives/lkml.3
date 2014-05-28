Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbaE1P3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:29:18 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33458 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831AbaE1P3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:29:17 -0400
Date: Wed, 28 May 2014 11:28:54 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Roman Gushchin <klamm@yandex-team.ru>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2 0/4] memcg: Low-limit reclaim
Message-ID: <20140528152854.GG2878@cmpxchg.org>
References: <1398688005-26207-1-git-send-email-mhocko@suse.cz>
 <20140528121023.GA10735@dhcp22.suse.cz>
 <20140528134905.GF2878@cmpxchg.org>
 <20140528142144.GL9895@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528142144.GL9895@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 04:21:44PM +0200, Michal Hocko wrote:
> On Wed 28-05-14 09:49:05, Johannes Weiner wrote:
> > On Wed, May 28, 2014 at 02:10:23PM +0200, Michal Hocko wrote:
> > > Hi Andrew, Johannes,
> > > 
> > > On Mon 28-04-14 14:26:41, Michal Hocko wrote:
> > > > This patchset introduces such low limit that is functionally similar
> > > > to a minimum guarantee. Memcgs which are under their lowlimit are not
> > > > considered eligible for the reclaim (both global and hardlimit) unless
> > > > all groups under the reclaimed hierarchy are below the low limit when
> > > > all of them are considered eligible.
> > > > 
> > > > The previous version of the patchset posted as a RFC
> > > > (http://marc.info/?l=linux-mm&m=138677140628677&w=2) suggested a
> > > > hard guarantee without any fallback. More discussions led me to
> > > > reconsidering the default behavior and come up a more relaxed one. The
> > > > hard requirement can be added later based on a use case which really
> > > > requires. It would be controlled by memory.reclaim_flags knob which
> > > > would specify whether to OOM or fallback (default) when all groups are
> > > > bellow low limit.
> > > 
> > > It seems that we are not in a full agreement about the default behavior
> > > yet. Johannes seems to be more for hard guarantee while I would like to
> > > see the weaker approach first and move to the stronger model later.
> > > Johannes, is this absolutely no-go for you? Do you think it is seriously
> > > handicapping the semantic of the new knob?
> > 
> > Well we certainly can't start OOMing where we previously didn't,
> > that's called a regression and automatically limits our options.
> > 
> > Any unexpected OOMs will be much more acceptable from a new feature
> > than from configuration that previously "worked" and then stopped.
> 
> Yes and we are not talking about regressions, are we?
> 
> > > My main motivation for the weaker model is that it is hard to see all
> > > the corner case right now and once we hit them I would like to see a
> > > graceful fallback rather than fatal action like OOM killer. Besides that
> > > the usaceses I am mostly interested in are OK with fallback when the
> > > alternative would be OOM killer. I also feel that introducing a knob
> > > with a weaker semantic which can be made stronger later is a sensible
> > > way to go.
> > 
> > We can't make it stronger, but we can make it weaker. 
> 
> Why cannot we make it stronger by a knob/configuration option?

Why can't we make it weaker by a knob?  Why should we design the
default for unforeseeable cornercases rather than make the default
make sense for existing cases and give cornercases a fallback once
they show up?

> > Stronger is the simpler definition, it's simpler code,
> 
> The code is not really that much simpler. The one you have posted will
> not work I am afraid. I haven't tested it yet but I remember I had to do
> some tweaks to the reclaim path to not end up in an endless loop in the
> direct reclaim (http://marc.info/?l=linux-mm&m=138677140828678&w=2 and
> http://marc.info/?l=linux-mm&m=138677141328682&w=2).

That's just a result of do_try_to_free_pages being stupid and using
its own zonelist loop to check reclaimability by duplicating all the
checks instead of properly using returned state of shrink_zones().
Something that would be worth fixing regardless of memcg guarantees.

Or maybe we could add the guaranteed lru pages to sc->nr_scanned.

> > your usecases are fine with it,
> 
> my usecases do not overcommit low_limit on the available memory, so far
> so good, but once we hit a corner cases when limits are set properly but
> we end up not being able to reclaim anybody in a zone then OOM sounds
> too brutal.

What cornercases?
