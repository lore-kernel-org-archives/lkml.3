Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbaKNKdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 05:33:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57131 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754988AbaKNKdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:33:08 -0500
Date: Fri, 14 Nov 2014 10:33:01 +0000
From: Mel Gorman <mgorman@suse.de>
To: Weijie Yang <weijie.yang.kh@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, t.stanislaws@samsung.com,
        Gioh Kim <gioh.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v5 1/4] mm/page_alloc: fix incorrect isolation behavior
 by rechecking migratetype
Message-ID: <20141114103301.GD21422@suse.de>
References: <1414740330-4086-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1414740330-4086-2-git-send-email-iamjoonsoo.kim@lge.com>
 <CAL1ERfMxR0BPQ-1hsD+Z-Oizkt4WHzL_rwYmKd2n70R=H0X22Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAL1ERfMxR0BPQ-1hsD+Z-Oizkt4WHzL_rwYmKd2n70R=H0X22Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 4593567..3d090af 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -431,6 +431,15 @@ struct zone {
> >          */
> >         int                     nr_migrate_reserve_block;
> >
> > +#ifdef CONFIG_MEMORY_ISOLATION
> > +       /*
> > +        * Number of isolated pageblock. It is used to solve incorrect
> > +        * freepage counting problem due to racy retrieving migratetype
> > +        * of pageblock. Protected by zone->lock.
> > +        */
> > +       unsigned long           nr_isolate_pageblock;
> > +#endif
> > +
> 
> First sorry for this deferred reply, I see these patches have been merged
> into the mainline.
> However, I still have a tiny question:
> Why use ZONE_PADDING(_pad1_)  seperate it and zone->lock?
> How about move it to the same cacheline with zone->lock, because it is
> accessed under zone->lock?
> 

zone->lock is currently sharing lines with the data that is frequently
updated under zone lock and some of the dirty data cache line bouncing has
completed when the lock is acquired. nr_isolate_pageblock is a read-mostly
field and in some cases will never be used. It's fine where it is beside
other read-mostly fields.

-- 
Mel Gorman
SUSE Labs
