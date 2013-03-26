Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651Ab3CZIzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 04:55:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757400Ab3CZIzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 04:55:37 -0400
Date: Tue, 26 Mar 2013 09:55:35 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/10] migrate: add hugepage migration code to
 migrate_pages()
Message-ID: <20130326085535.GL2295@dhcp22.suse.cz>
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1363983835-20184-6-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20130325130416.GV2154@dhcp22.suse.cz>
 <1364274790-z44rtlpy-mutt-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364274790-z44rtlpy-mutt-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 26-03-13 01:13:10, Naoya Horiguchi wrote:
> On Mon, Mar 25, 2013 at 02:04:16PM +0100, Michal Hocko wrote:
> > On Fri 22-03-13 16:23:50, Naoya Horiguchi wrote:
[...]
> > > @@ -1012,14 +1040,8 @@ static int migrate_to_node(struct mm_struct *mm, int source, int dest,
> > >  	check_range(mm, mm->mmap->vm_start, mm->task_size, &nmask,
> > >  			flags | MPOL_MF_DISCONTIG_OK, &pagelist);
> > >  
> > > -	if (!list_empty(&pagelist)) {
> > > -		err = migrate_pages(&pagelist, new_node_page, dest,
> > > +	return migrate_movable_pages(&pagelist, new_node_page, dest,
> > >  					MIGRATE_SYNC, MR_SYSCALL);
> > > -		if (err)
> > > -			putback_lru_pages(&pagelist);
> > > -	}
> > > -
> > > -	return err;
> > 
> > This is really confusing. Why migrate_pages doesn't do putback cleanup
> > on its own but migrate_movable_pages does?
> 
> I consider migrate_movable_pages() as a wrapper of migrate_pages(),
> not the variant of migrate_pages().

The naming suggests that this is the same functionality for a "different"
type of pages.

> We can find the same pattern in the callers like
> 
>   if (!list_empty(&pagelist)) {
>         err = migrate_pages(...);
>         if (err)
>                 putback_lru_pages(&pagelist);
>   }
> 
> , so it can be simplified by migrate_movable_pages().

I would rather see the same pattern for both. It could be error prone if

-- 
Michal Hocko
SUSE Labs
