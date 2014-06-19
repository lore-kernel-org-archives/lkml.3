Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaFSBCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 21:02:07 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:40731 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbaFSBCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 21:02:06 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
Date: Thu, 19 Jun 2014 10:02:39 +0900
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chen Yucong <slaoub@gmail.com>, mgorman@suse.de, hannes@cmpxchg.org,
        mhocko@suse.cz, riel@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan.c: fix an implementation flaw in proportional
 scanning
Message-ID: <20140619010239.GA2071@bbox>
References: <1402980902-6345-1-git-send-email-slaoub@gmail.com>
 <20140618152751.283deda95257cc32ccea8f20@linux-foundation.org>
 <1403136272.12954.4.camel@debian>
 <20140618174001.a5de7668.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618174001.a5de7668.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

On Wed, Jun 18, 2014 at 05:40:01PM -0700, Andrew Morton wrote:
> On Thu, 19 Jun 2014 08:04:32 +0800 Chen Yucong <slaoub@gmail.com> wrote:
> 
> > On Wed, 2014-06-18 at 15:27 -0700, Andrew Morton wrote:
> > > On Tue, 17 Jun 2014 12:55:02 +0800 Chen Yucong <slaoub@gmail.com> wrote:
> > > 
> > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > index a8ffe4e..2c35e34 100644
> > > > --- a/mm/vmscan.c
> > > > +++ b/mm/vmscan.c
> > > > @@ -2087,8 +2086,8 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
> > > >  	blk_start_plug(&plug);
> > > >  	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
> > > >  					nr[LRU_INACTIVE_FILE]) {
> > > > -		unsigned long nr_anon, nr_file, percentage;
> > > > -		unsigned long nr_scanned;
> > > > +		unsigned long nr_anon, nr_file, file_percent, anon_percent;
> > > > +		unsigned long nr_to_scan, nr_scanned, percentage;
> > > >  
> > > >  		for_each_evictable_lru(lru) {
> > > >  			if (nr[lru]) {
> > > 
> > > The increased stack use is a slight concern - we can be very deep here.
> > > I suspect the "percent" locals are more for convenience/clarity, and
> > > they could be eliminated (in a separate patch) at some cost of clarity?
> > > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index a8ffe4e..2c35e34 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2057,8 +2057,7 @@ out:
> >  static void shrink_lruvec(struct lruvec *lruvec, struct scan_control
> > *sc)
> >  {
> >         unsigned long nr[NR_LRU_LISTS];
> > -       unsigned long targets[NR_LRU_LISTS];
> > -       unsigned long nr_to_scan;
> > +       unsigned long file_target, anon_target;
> > 
> > >From the above snippet, we can know that the "percent" locals come from
> > targets[NR_LRU_LISTS]. So this fix does not increase the stack.
> 
> OK.  But I expect the stack use could be decreased by using more
> complex expressions.

I didn't look at this patch yet but want to say.

The expression is not easy to follow since several people already
confused/discuss/fixed a bit so I'd like to put more concern to clarity
rather than stack footprint. I'm not saying stack footprint is not
important but I'd like to remain it last resort.
That's why I posted below for clarity.
https://lkml.org/lkml/2014/6/16/750

If we really want to reduce stack, we could do a little bit by below.

My 2 cents

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 9b61b9bf81ac..ddae227fd1ec 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -164,13 +164,15 @@ enum lru_list {
 	LRU_ACTIVE_ANON = LRU_BASE + LRU_ACTIVE,
 	LRU_INACTIVE_FILE = LRU_BASE + LRU_FILE,
 	LRU_ACTIVE_FILE = LRU_BASE + LRU_FILE + LRU_ACTIVE,
+	NR_EVICTABLE_LRU_LISTS = LRU_UNEVICTABLE,
 	LRU_UNEVICTABLE,
 	NR_LRU_LISTS
 };
 
 #define for_each_lru(lru) for (lru = 0; lru < NR_LRU_LISTS; lru++)
 
-#define for_each_evictable_lru(lru) for (lru = 0; lru <= LRU_ACTIVE_FILE; lru++)
+#define for_each_evictable_lru(lru) for (lru = 0; \
+		lru <= NR_EVICTABLE_LRU_LISTS; lru++)
 
 static inline int is_file_lru(enum lru_list lru)
 {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index a9c74b409681..11f57a017131 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2012,8 +2012,8 @@ out:
  */
 static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
-	unsigned long nr[NR_LRU_LISTS];
-	unsigned long targets[NR_LRU_LISTS];
+	unsigned long nr[NR_EVICTABLE_LRU_LISTS];
+	unsigned long targets[NR_EVICTABLE_LRU_LISTS];
 	unsigned long nr_to_scan;
 	enum lru_list lru;
 	unsigned long nr_reclaimed = 0;
-- 
Kind regards,
Minchan Kim
