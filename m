Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965100AbaFCXl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 19:41:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932164AbaFCXlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 19:41:25 -0400
Date: Tue, 3 Jun 2014 19:41:11 -0400
From: Dave Jones <davej@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: 3.15-rc8 mm/filemap.c:202 BUG
Message-ID: <20140603234111.GA21091@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Konstantin Khlebnikov <koct9i@gmail.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sasha.levin@oracle.com>
References: <20140603042121.GA27177@redhat.com>
 <CALYGNiNV951SnBKdr0PEkgLbLCxy+YB6HJpafRr6CynO+a1sdQ@mail.gmail.com>
 <alpine.LSU.2.11.1406031524470.7878@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LSU.2.11.1406031524470.7878@eggly.anvils>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 04:11:43PM -0700, Hugh Dickins wrote:
 
 > > -       BUG_ON(page_mapped(page));
 > > +       VM_BUG_ON_PAGE(page_mapped(page), page);
 > > 
 > >         /*
 > >          * Some filesystems seem to re-dirty the page even after
 > 
 > Yes, there's a chance that will tell us more (but I don't have high
 > hopes of it).  I'm still stumped by this issue, just as before.

running with that applied now.

 > Sasha (or Dave), any update on whether you see this without THP?
 > and whether you see the remove_migration_pte oops without THP?

haven't tried yet. I wish I had a better reproducer, because it can
take up to a day to show up, and if disabling THP makes it go away,
it's hard to judge if that's the case, or if I haven't been running
long enough.. Sort of a Schrödinger's BUG_ON.

After I get a trace with the above patch applied, I'll give it a shot
though, just to see what happens.

 > Mind you, I've probably given too little weight to the fact that every
 > stacktrace shown has been a shmem one: originally I assumed that just
 > reflected trinity running its tests on a tmpfs, now I wonder: Dave,
 > Sasha, are you running similar tests on tmpfs and other filesystems,
 > and find this only in the tmpfs case?

In my case, there's a tmpfs mounted, but it's extremely unlikely that
trinity walked into it. Perhaps I should try that, to see if it happens
faster.


 > > I don't like the way in which truncate silently skips page entries
 > > when they are changing under it.
 > > Completely untested patch follows.
 > > 
 > > --- a/mm/shmem.c
 > > +++ b/mm/shmem.c
 > > @@ -495,8 +495,9 @@ static void shmem_undo_range(struct inode *inode,
 > > loff_t lstart, loff_t lend,
 > >                         if (radix_tree_exceptional_entry(page)) {
 > >                                 if (unfalloc)
 > >                                         continue;
 > > -                               nr_swaps_freed += !shmem_free_swap(mapping,
 > > -                                                               index, page);
 > > +                               if (shmem_free_swap(mapping, index, page))
 > > +                                       goto retry;
 > > +                               nr_swaps_freed++;
 > >                                 continue;
 > >                         }
 > > 
 > > @@ -509,10 +510,11 @@ static void shmem_undo_range(struct inode
 > > *inode, loff_t lstart, loff_t lend,
 > >                         }
 > >                         unlock_page(page);
 > >                 }
 > > +               index++;
 > > +retry:
 > >                 pagevec_remove_exceptionals(&pvec);
 > >                 pagevec_release(&pvec);
 > >                 mem_cgroup_uncharge_end();
 > > -               index++;
 > >         }

I'll add this to the queue of things to test, but that queue is now
about two days deep already :)

	Dave

