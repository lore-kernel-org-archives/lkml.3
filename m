Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbaBJUNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:13:43 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:51780 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbaBJUNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:13:36 -0500
Date: Mon, 10 Feb 2014 12:12:42 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/8] memcg: update comment about charge reparenting on
 cgroup exit
In-Reply-To: <20140210142344.GI7117@dhcp22.suse.cz>
Message-ID: <alpine.LSU.2.11.1402101208290.1516@eggly.anvils>
References: <1391792665-21678-1-git-send-email-hannes@cmpxchg.org> <1391792665-21678-4-git-send-email-hannes@cmpxchg.org> <20140210142344.GI7117@dhcp22.suse.cz>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014, Michal Hocko wrote:
> On Fri 07-02-14 12:04:20, Johannes Weiner wrote:
> > Reparenting memory charges in the css_free() callback was meant as a
> > temporary fix for charges that race with offlining, but after some
> > follow-up discussion, it turns out that this is really the right place
> > to reparent charges because it guarantees none are in-flight.

Perhaps: I'm not as gung-ho for this new orthodoxy as you are.

> > 
> > Make clear that the reparenting in css_offline() is an optimistic
> > sweep of established charges because swapout records might hold up
> > css_free() indefinitely, but that in fact the css_free() reparenting
> > is the properly synchronized one.

It worries me that you keep referring to the memsw usage, but
forget the kmem usage, which also delays css_free() indefinitely.

Or am I out-of-date?  Seems not, mem_cgroup_reparent_chages() still
waits for memcg->res - memcg->kmem to reach 0, knowing there's not
much certainty that kmem will reach 0 any time soon.

I think you need a plan for what to do with the kmem pinning,
before going much further in reworking the memsw pinning.

Or at the least, please mention it in this patch's comment.

Hugh

> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> OK, I am still thinking about 2 stage reparenting. LRU drain part called
> from css_offline and charge drain from css_free. But this is a
> sufficient for now.
> 
> Acked-by: Michal Hocko <mhocko@suse.cz>
