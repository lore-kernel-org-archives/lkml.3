Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab3I0Sb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 14:31:56 -0400
Received: from relay2.sgi.com ([192.48.179.30]:36575 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754197Ab3I0Sby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 14:31:54 -0400
Date: Fri, 27 Sep 2013 13:31:50 -0500
From: Ben Myers <bpm@sgi.com>
To: Geyslan =?iso-8859-1?Q?Greg=F3rio?= Bem <geyslan@gmail.com>
Cc: Alex Elder <elder@kernel.org>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org
Subject: Re: [XFS MAINTAINERS] fs/xfs/xfs_dir2_node.c: xfs:
 xfs_dir2_leafn_add: Variables Uninitialized
Message-ID: <20130927183150.GG10553@sgi.com>
References: <CAGG-pURO7QrMcU1btzh_RvQkLB=4QFqrLntW3n6BeMfU4iFdUQ@mail.gmail.com>
 <CAGG-pUQr39G3QiiS=yoDQk+RmVihr59N8Z6Wk5G05QFB=gJF4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGG-pUQr39G3QiiS=yoDQk+RmVihr59N8Z6Wk5G05QFB=gJF4g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geyslan,

On Fri, Sep 27, 2013 at 02:59:12PM -0300, Geyslan Gregório Bem wrote:
> Hi Maintainers,
> 
> I suppose the variables "highstale" and "lowstale" are being used despite
> not having been initialized.
> 
> File: fs/xfs/xfs_dir2_node.c
> Function: xfs_dir2_leafn_add
> 
> L491:
> > /*
> > * Insert the new entry, log everything.
> > */
> > lep = xfs_dir3_leaf_find_entry(&leafhdr, ents, index, compact, lowstale,
> > highstale, &lfloglow, &lfloghigh);
> 
> The only place they are started up is within this condition:
> 
> L480:
> > if (compact)
> > xfs_dir3_leaf_compact_x1(&leafhdr, ents, &index, &lowstale,
> > &highstale, &lfloglow, &lfloghigh);
> 
> So, if it is not compact, both have garbage.

Thanks for the report.  That sounds pretty bad.  Lets see...

421 static int                                      /* error */
422 xfs_dir2_leafn_add(
423         struct xfs_buf          *bp,            /* leaf buffer */
424         xfs_da_args_t           *args,          /* operation arguments */
425         int                     index)          /* insertion pt for new entry */
426 {
...
476         /*
477          * Compact out all but one stale leaf entry.  Leaves behind
478          * the entry closest to index.
479          */
480         if (compact)
481                 xfs_dir3_leaf_compact_x1(&leafhdr, ents, &index, &lowstale,
482                                          &highstale, &lfloglow, &lfloghigh);
483         else if (leafhdr.stale) {
484                 /*
485                  * Set impossible logging indices for this case.
486                  */
487                 lfloglow = leafhdr.count;
488                 lfloghigh = -1;
489         }
490
491         /*
492          * Insert the new entry, log everything.
493          */
494         lep = xfs_dir3_leaf_find_entry(&leafhdr, ents, index, compact, lowstale,
495                                        highstale, &lfloglow, &lfloghigh);

If compact is set at 481 we pass the addresses of highstale and lowstale to
xfs_dir3_leaf_compact_x1, which passes them to xfs_dir3_leaf_find_stale, which
makes assignments to both variables unconditionally.  Later at 494 we pass
compact, lowstale, and highstale to xfs_dir3_leaf_find_entry.

So we're ok if compact is set...

555 struct xfs_dir2_leaf_entry *
556 xfs_dir3_leaf_find_entry(
557         struct xfs_dir3_icleaf_hdr *leafhdr,
558         struct xfs_dir2_leaf_entry *ents,
559         int                     index,          /* leaf table position */
560         int                     compact,        /* need to compact leaves */
561         int                     lowstale,       /* index of prev stale leaf */
562         int                     highstale,      /* index of next stale leaf */
563         int                     *lfloglow,      /* low leaf logging index */
564         int                     *lfloghigh)     /* high leaf logging index */
565 {
...
587         /*
588          * There are stale entries.
589          *
590          * We will use one of them for the new entry.  It's probably not at
591          * the right location, so we'll have to shift some up or down first.
592          *
593          * If we didn't compact before, we need to find the nearest stale
594          * entries before and after our insertion point.
595          */
596         if (compact == 0)
597                 xfs_dir3_leaf_find_stale(leafhdr, ents, index,
598                                          &lowstale, &highstale);

In xfs_dir3_leaf_find_entry, it looks like if compact is not set, we will pass
the addresses of lowstale and highstale to xfs_dir3_leaf_find_stale which
appears to make assignments to them unconditionally.  It looks like
xfs_dir3_leaf_find_entry doesn't read from lowstale and highstale until after
598.  I think this should take care of the !compact case too.  Do you agree?

Thanks much,
Ben
