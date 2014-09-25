Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaIYB3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 21:29:35 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:45995 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaIYB3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 21:29:33 -0400
Date: Wed, 24 Sep 2014 21:29:30 -0400
From: Tejun Heo <tj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2] mm: memcontrol: convert reclaim iterator to simple
 css refcounting
Message-ID: <20140925012930.GA26745@htj.dyndns.org>
References: <1411161059-16552-1-git-send-email-hannes@cmpxchg.org>
 <20140919212843.GA23861@cmpxchg.org>
 <20140924164739.GA15897@dhcp22.suse.cz>
 <20140924171653.GA10082@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924171653.GA10082@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 24, 2014 at 01:16:53PM -0400, Johannes Weiner wrote:
> Tejun, should maybe the iterators not return css before they have
> CSS_ONLINE set?  It seems odd to have memcg reach into cgroup like
> that to check if published objects are actually fully initialized.
> Background is this patch:

So, memcontrol shouldn't be doing that but at the same time cgroup
core can't do it for any controller.  One of the requirements of the
iterations is that it shouldn't miss any css which has been onlined by
its controller; however, because each controller defines its own
locking, cgroup core has no way knowing when a css finishes
initialization.  If it includes after ->css_online() is complete, the
iteration may happen between when the controller considers the css
fully initialized and cgroup core sets CSS_ONLINE.  The only thing
cgroup core can do is including all csses which *could* be considered
online by the controller and let it filter accordingly.

IOW, the precise moment a css becomes online is not known to the
cgroup core as cgroup core locking and controller locking are
completely independent.  The current memcg implementation is broken in
that memcg iterator is testing CSS_ONLINE which is set *after*
->css_online() is complete and iterations can happen inbetween where
the online css may be omitted because it's not marked online by cgroup
core yet.  This may be okay for memcg's use of iterators but for
things like freezer, for example, this can break things horribly.

Anyways, the right thing to do is removing the CSS_ONLINE testing and
implementing memcg's own way of marking an object as fully initialized
according to its synchronization and iteration requirements.  So,
yeah, it's a glaring layering violation which should be removed.

Thanks.

-- 
tejun
