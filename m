Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab3IMIMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 04:12:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43440 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979Ab3IMIMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 04:12:00 -0400
Date: Fri, 13 Sep 2013 09:11:57 +0100
From: Mel Gorman <mgorman@suse.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 27/50] mm: numa: Scan pages with elevated page_mapcount
Message-ID: <20130913081157.GW22421@suse.de>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
 <1378805550-29949-28-git-send-email-mgorman@suse.de>
 <CAJd=RBCoJNPi0PPg3DQyRtuoKNvU42bpy9GPiNpzf5byMVQNOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAJd=RBCoJNPi0PPg3DQyRtuoKNvU42bpy9GPiNpzf5byMVQNOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 10:10:13AM +0800, Hillf Danton wrote:
> Hillo Mel
> 
> On Tue, Sep 10, 2013 at 5:32 PM, Mel Gorman <mgorman@suse.de> wrote:
> > Currently automatic NUMA balancing is unable to distinguish between false
> > shared versus private pages except by ignoring pages with an elevated
> > page_mapcount entirely. This avoids shared pages bouncing between the
> > nodes whose task is using them but that is ignored quite a lot of data.
> >
> > This patch kicks away the training wheels in preparation for adding support
> > for identifying shared/private pages is now in place. The ordering is so
> > that the impact of the shared/private detection can be easily measured. Note
> > that the patch does not migrate shared, file-backed within vmas marked
> > VM_EXEC as these are generally shared library pages. Migrating such pages
> > is not beneficial as there is an expectation they are read-shared between
> > caches and iTLB and iCache pressure is generally low.
> >
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> > ---
> [...]
> > @@ -1658,13 +1660,6 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
> >         int page_lru = page_is_file_cache(page);
> >
> >         /*
> > -        * Don't migrate pages that are mapped in multiple processes.
> > -        * TODO: Handle false sharing detection instead of this hammer
> > -        */
> > -       if (page_mapcount(page) != 1)
> > -               goto out_dropref;
> > -
> Is there rmap walk when migrating THP?
> 

Should not be necessary for THP.

-- 
Mel Gorman
SUSE Labs
