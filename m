Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbaKEQyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:54:35 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:34451 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbaKEQyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:54:33 -0500
Date: Wed, 5 Nov 2014 11:54:28 -0500
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 3/4] OOM, PM: OOM killed task shouldn't escape PM suspend
Message-ID: <20141105165428.GF14386@htj.dyndns.org>
References: <20141021142939.GG9415@dhcp22.suse.cz>
 <20141104192705.GA22163@htj.dyndns.org>
 <20141105124620.GB4527@dhcp22.suse.cz>
 <20141105130247.GA14386@htj.dyndns.org>
 <20141105133100.GC4527@dhcp22.suse.cz>
 <20141105134219.GD4527@dhcp22.suse.cz>
 <20141105154436.GB14386@htj.dyndns.org>
 <20141105160115.GA28226@dhcp22.suse.cz>
 <20141105162929.GD14386@htj.dyndns.org>
 <20141105163956.GD28226@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105163956.GD28226@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 05:39:56PM +0100, Michal Hocko wrote:
> On Wed 05-11-14 11:29:29, Tejun Heo wrote:
> > Hello, Michal.
> > 
> > On Wed, Nov 05, 2014 at 05:01:15PM +0100, Michal Hocko wrote:
> > > I am not sure I am following. With the latest patch OOM path is no
> > > longer blocked by the PM (aka oom_killer_disable()). Allocations simply
> > > fail if the read_trylock fails.
> > > oom_killer_disable is moved before tasks are frozen and it will wait for
> > > all on-going OOM killers on the write lock. OOM killer is enabled again
> > > on the resume path.
> > 
> > Sure, but why are we exposing new interfaces?  Can't we just make
> > oom_killer_disable() first set the disable flag and wait for the
> > on-going ones to finish (and make the function fail if it gets chosen
> > as an OOM victim)?
> 
> Still not following. How do you want to detect an on-going OOM without
> any interface around out_of_memory?

I thought you were using oom_killer_allowed_start() outside OOM path.
Ugh.... why is everything weirdly structured?  oom_killer_disabled
implies that oom killer may fail, right?  Why is
__alloc_pages_slowpath() checking it directly?  If whether oom killing
failed or not is relevant to its users, make out_of_memory() return an
error code.  There's no reason for the exclusion detail to leak out of
the oom killer proper.  The only interface should be disable/enable
and whether oom killing failed or not.

Thanks.

-- 
tejun
