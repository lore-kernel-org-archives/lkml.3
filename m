Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbaIEKas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:30:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46046 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478AbaIEKaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:30:46 -0400
Date: Fri, 5 Sep 2014 11:30:42 +0100
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linuxfoundation.org>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Fengguang Wu <fengguang.wu@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: page_alloc: Default to node-ordering on 64-bit NUMA
 machines
Message-ID: <20140905103041.GH17501@suse.de>
References: <20140901125551.GI12424@suse.de>
 <20140902135120.GC29501@cmpxchg.org>
 <20140902152143.GL12424@suse.de>
 <20140904152915.GB10794@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140904152915.GB10794@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 11:29:29AM -0400, Johannes Weiner wrote:
> On Tue, Sep 02, 2014 at 04:21:43PM +0100, Mel Gorman wrote:
> > On Tue, Sep 02, 2014 at 09:51:20AM -0400, Johannes Weiner wrote:
> > > On Mon, Sep 01, 2014 at 01:55:51PM +0100, Mel Gorman wrote:
> > > > I cannot find a good reason to incur a performance penalty on all 64-bit NUMA
> > > > machines in case someone throws a brain damanged TV or graphics card in there.
> > > > This patch defaults to node-ordering on 64-bit NUMA machines. I was tempted
> > > > to make it default everywhere but I understand that some embedded arches may
> > > > be using 32-bit NUMA where I cannot predict the consequences.
> > > 
> > > This patch is a step in the right direction, but I'm not too fond of
> > > further fragmenting this code and where it applies, while leaving all
> > > the complexity from the heuristics and the zonelist building in, just
> > > on spec.  Could we at least remove the heuristics too?  If anybody is
> > > affected by this, they can always override the default on the cmdline.
> > 
> > I see no problem with deleting the heuristics. Default node for 64-bit
> > and default zone for 32-bit sound ok to you?
> 
> Is there a strong reason against defaulting both to node order?  Zone
> ordering, if anything, is a niche application.  We might even be able
> to remove it in the future.  We still have the backup of allowing the
> user to explicitely request zone ordering on the commandline, should
> someone depend on it unexpectedly.

Low memory depletion is the reason to default to zone order on 32-bit
NUMA. If processes on node 0 deplete the Normal zone from normal
activity then other nodes must keep reclaiming from Normal for all kernel
allocations. The problem is worse if CONFIG_HIGHPTE is not set.

A default of node-ordering on 32-bit NUMA increases low memory pressure
leading to increased reclaim and potentially easier to trigger OOM. I
expect this problem was worse in the past when the normal zone could be
filled with dirty pages under writeback.  However low memory pressure is
still enough of a concern that I'm wary of changing the default of 32-bit
NUMA without knowing who even cares about 32-bit NUMA.

-- 
Mel Gorman
SUSE Labs
