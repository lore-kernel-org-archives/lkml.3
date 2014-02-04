Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaBDDsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 22:48:09 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55238 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbaBDDsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 22:48:07 -0500
Date: Mon, 3 Feb 2014 19:47:21 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: David Rientjes <rientjes@google.com>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, compaction: avoid isolating pinned pages fix
In-Reply-To: <alpine.DEB.2.02.1402031848290.15032@chino.kir.corp.google.com>
Message-ID: <alpine.LSU.2.11.1402031933400.29601@eggly.anvils>
References: <alpine.DEB.2.02.1402012145510.2593@chino.kir.corp.google.com> <20140203095329.GH6732@suse.de> <alpine.DEB.2.02.1402030231590.31061@chino.kir.corp.google.com> <20140204000237.GA17331@lge.com> <alpine.DEB.2.02.1402031610090.10778@chino.kir.corp.google.com>
 <20140204015332.GA14779@lge.com> <alpine.DEB.2.02.1402031755440.26347@chino.kir.corp.google.com> <20140204021533.GA14924@lge.com> <alpine.DEB.2.02.1402031848290.15032@chino.kir.corp.google.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Feb 2014, David Rientjes wrote:
> On Tue, 4 Feb 2014, Joonsoo Kim wrote:
> 
> > > > Okay. It can't fix your situation. Anyway, *normal* anon pages may be mapped
> > > > and have positive page_count(), so your code such as
> > > > '!page_mapping(page) && page_count(page)' makes compaction skip these *normal*
> > > > anon pages and this is incorrect behaviour.
> > > > 
> > > 
> > > So how does that work with migrate_page_move_mapping() which demands 
> > > page_count(page) == 1 and the get_page_unless_zero() in 
> > > __isolate_lru_page()?
> > 
> > Before doing migrate_page_move_mapping(), try_to_unmap() is called so that all
> > mapping is unmapped. Then, remained page_count() is 1 which is grabbed by
> > __isolate_lru_page(). Am I missing something?
> > 
> 
> Ah, good point.  I wonder if we can get away with 
> page_count(page) - page_mapcount(page) > 1 to avoid the get_user_pages() 
> pin?

Something like that.  But please go back to migrate_page_move_mapping()
to factor in what it's additionally considering.  Whether you can share
code with it, I don't know - it has to do some things under a lock you
cannot take at the preliminary stage - you haven't isolated or locked
the page yet.

There is a separate issue, that a mapping may supply its own non-default
mapping->a_ops->migratepage(): can we assume that the page_counting is
the same whatever migratepage() is in use?  I'm not sure.

If you stick to special-casing PageAnon pages, you won't face that
issue; but your proposed change would be a lot more satisfying if we
can convince ourselves that it's good for !PageAnon too.  May need a
trawl through the different migratepage() methods that exist in tree.

Hugh
