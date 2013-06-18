Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3FRIVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:21:45 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:56773 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab3FRIVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:21:41 -0400
Date: Tue, 18 Jun 2013 12:21:33 +0400
From: Glauber Costa <glommer@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: slab shrinkers: BUG at mm/list_lru.c:92
Message-ID: <20130618082132.GC20528@localhost.localdomain>
References: <20130617141822.GF5018@dhcp22.suse.cz>
 <20130617151403.GA25172@localhost.localdomain>
 <20130617143508.7417f1ac9ecd15d8b2877f76@linux-foundation.org>
 <20130617223004.GB2538@localhost.localdomain>
 <20130618081931.GB13677@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618081931.GB13677@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 10:19:31AM +0200, Michal Hocko wrote:
> On Tue 18-06-13 02:30:05, Glauber Costa wrote:
> > On Mon, Jun 17, 2013 at 02:35:08PM -0700, Andrew Morton wrote:
> [...]
> > > The trace says shrink_slab_node->super_cache_scan->prune_icache_sb.  So
> > > it's inodes?
> > > 
> > Assuming there is no memory corruption of any sort going on , let's
> > check the code. nr_item is only manipulated in 3 places:
> > 
> > 1) list_lru_add, where it is increased
> > 2) list_lru_del, where it is decreased in case the user have voluntarily removed the
> >    element from the list
> > 3) list_lru_walk_node, where an element is removing during shrink.
> > 
> > All three excerpts seem to be correctly locked, so something like this
> > indicates an imbalance.  Either the element was never added to the
> > list, or it was added, removed, and we didn't notice it. (Again, your
> > backing storage is not XFS, is it? If it is , we have another user to
> > look for)
> 
> No this is ext3. But I can try to test with xfs as well if it helps.
> [...]

XFS won't help this, on the contrary. The reason I asked is because XFS
uses list_lru for its internal structures as well. So it is actually preferred
if you are reproducing this without it, so we can at least isolate that part.
