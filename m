Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaFPAsk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 20:48:40 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:44129 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbaFPAsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 20:48:37 -0400
Date: Sun, 15 Jun 2014 17:47:16 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Chen Yucong <slaoub@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, mgorman@suse.de, mhocko@suse.cz,
        hannes@cmpxchg.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan.c: avoid recording the original scan targets
 in shrink_lruvec()
In-Reply-To: <1402456897.28433.46.camel@debian>
Message-ID: <alpine.LSU.2.11.1406151742290.26073@eggly.anvils>
References: <1402320436-22270-1-git-send-email-slaoub@gmail.com> <20140610163338.5b463c5884c4c7e3f1b948e2@linux-foundation.org> <1402456897.28433.46.camel@debian>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2014, Chen Yucong wrote:
> On Tue, 2014-06-10 at 16:33 -0700, Andrew Morton wrote:
> > >                       break;
> > >  
> > >               if (nr_file > nr_anon) {
> > > -                     unsigned long scan_target =
> > targets[LRU_INACTIVE_ANON] +
> > >
> > -                                             targets[LRU_ACTIVE_ANON]
> > + 1;
> > > +                     nr_to_scan = nr_file - ratio * nr_anon;
> > > +                     percentage = nr[LRU_FILE] * 100 / nr_file;
> > 
> > here, nr_file and nr_anon are derived from the contents of nr[].  But
> > nr[] was modified in the for_each_evictable_lru() loop, so its
> > contents
> > now may differ from what was in targets[]? 
> 
> nr_to_scan is used for recording the number of pages that should be
> scanned to keep original *ratio*.
> 
> We can assume that the value of (nr_file > nr_anon) is true, nr_to_scan
> should be distribute to nr[LRU_ACTIVE_FILE] and nr[LRU_INACTIVE_FILE] in
> proportion.
> 
>     nr_file = nr[LRU_ACTIVE_FILE] + nr[LRU_INACTIVE_FILE];
>     percentage = nr[LRU_FILE] / nr_file;
> 
> Note that in comparison with *old* percentage, the "new" percentage has
> the different meaning. It is just used to divide nr_so_scan pages
> appropriately.

[PATCH] mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec-fix.patch

I have not reviewed your logic at all, but soon hit a divide-by-zero
crash on mmotm: it needs some such fix as below.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/vmscan.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- mmotm/mm/vmscan.c	2014-06-12 17:46:36.632008452 -0700
+++ linux/mm/vmscan.c	2014-06-12 18:55:18.832425713 -0700
@@ -2122,11 +2122,12 @@ static void shrink_lruvec(struct lruvec
 			nr_to_scan = nr_file - ratio * nr_anon;
 			percentage = nr[LRU_FILE] * 100 / nr_file;
 			lru = LRU_BASE;
-		} else {
+		} else if (ratio) {
 			nr_to_scan = nr_anon - nr_file / ratio;
 			percentage = nr[LRU_BASE] * 100 / nr_anon;
 			lru = LRU_FILE;
-		}
+		} else
+			break;
 
 		/* Stop scanning the smaller of the LRU */
 		nr[lru] = 0;
