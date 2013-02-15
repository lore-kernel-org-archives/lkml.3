Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab3BOQsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:48:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab3BOQs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:48:29 -0500
Date: Fri, 15 Feb 2013 17:48:28 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Rob van der Heij <rvdheij@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: fadvise: Drain all pagevecs if POSIX_FADV_DONTNEED
 fails to discard all pages
Message-ID: <20130215164828.GC31032@dhcp22.suse.cz>
References: <20130214120349.GD7367@suse.de>
 <20130214123926.599fcef8.akpm@linux-foundation.org>
 <20130215110401.GA31037@dhcp22.suse.cz>
 <CAJCc=ki+_PVT8fH43PoDVN2-5Wq0a1vQfFihJ_6F7==+RSAzYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCc=ki+_PVT8fH43PoDVN2-5Wq0a1vQfFihJ_6F7==+RSAzYQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 15-02-13 17:14:10, Rob van der Heij wrote:
> On 15 February 2013 12:04, Michal Hocko <mhocko@suse.cz> wrote:
> > On Thu 14-02-13 12:39:26, Andrew Morton wrote:
> >> On Thu, 14 Feb 2013 12:03:49 +0000
> >> Mel Gorman <mgorman@suse.de> wrote:
> >>
> >> > Rob van der Heij reported the following (paraphrased) on private mail.
> >> >
> >> >     The scenario is that I want to avoid backups to fill up the page
> >> >     cache and purge stuff that is more likely to be used again (this is
> >> >     with s390x Linux on z/VM, so I don't give it as much memory that
> >> >     we don't care anymore). So I have something with LD_PRELOAD that
> >> >     intercepts the close() call (from tar, in this case) and issues
> >> >     a posix_fadvise() just before closing the file.
> >> >
> >> >     This mostly works, except for small files (less than 14 pages)
> >> >     that remains in page cache after the face.
> >>
> >> Sigh.  We've had the "my backups swamp pagecache" thing for 15 years
> >> and it's still happening.
> >>
> >> It should be possible nowadays to toss your backup application into a
> >> container to constrain its pagecache usage.  So we can type
> >>
> >>       run-in-a-memcg -m 200MB /my/backup/program
> >>
> >> and voila.  Does such a script exist and work?
> >
> > The script would be as simple as:
> > cgcreate -g memory:backups/`whoami`
> > cgset -r memory.limit_in_bytes=200MB backups/`whoami`
> > cgexec -g memory:backups/`whoami` /my/backup/program
> >
> > It just expects that admin sets up backups group which allows the user
> > to create a subgroup (w permission on the directory) and probably set up
> > some reasonable cap for all backups
> 
> Cool. This is promising enough to bridge my skills gap. It appears to
> work as promised, but I would have to understand why it takes
> significantly more CPU than my ugly posix_fadvise() call on close...

I would guess that a lot of reclaim would be an answer. Note that each
memcg has its own LRU and the limit is neforced by the per group
reclaim.
I wouldn't expect the difference to be very big, though. What do you
mean by significantly more?

-- 
Michal Hocko
SUSE Labs
