Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab3LWAhZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 19:37:25 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59636 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501Ab3LWAhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 19:37:23 -0500
X-AuditID: 9c930197-b7c4aae000003d84-71-52b785c0b7e6
Date: Mon, 23 Dec 2013 09:38:10 +0900
From: Minchan Kim <minchan@kernel.org>
To: Chanho Min <chanho.min@lge.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>, linux-kernel@vger.kernel.org,
        =?utf-8?B?7J6E7Zqo7KSA?= <hyojun.im@lge.com>,
        =?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
Subject: Re: Re: Re : Re: [PATCH] Squashfs: add asynchronous read support
Message-ID: <20131223003810.GF19968@bbox>
References: <1387171826-20110-1-git-send-email-chanho.min@lge.com>
 <OF0A0B2022.F34682B9-ON49257C45.0018AF5F-49257C45.0018AF60@lge.com>
 <OFA5BC9264.067973F3-ON49257C48.000B85B4-49257C48.000B85B4@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFA5BC9264.067973F3-ON49257C48.000B85B4-49257C48.000B85B4@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 21, 2013 at 11:05:51AM +0900, Chanho Min wrote:
> 
> > Please don't break thread.
> > You should reply to my mail instead of your original post.
> Sorry, It seems to be my mailer issue. I'm trying to fix it.
> 
> > It's a result which isn't what I want to know.
> > What I wnat to know is why upper layer issues more I/O per second.
> > For example, you read 32K so MM layer will prepare 8 pages to read in but
> > at issuing at a first page, squashfs make 32 pages and fill the page cache
> > if we assume you use 128K compression so MM layer's already prepared 7
> > page
> > would be freed without further I/O and do_generic_file_read will wait for
> > completion by lock_page without further I/O queueing. It's not suprising.
> > One of page freed is a READA marked page so readahead couldn't work.
> > If readahead works, it would be just by luck. Actually, by simulation
> > 64K dd, I found readahead logic would be triggered but it's just by luck
> > and it's not intended, I think.
> MM layer's readahead pages would not be freed immediately.
> Squashfs can use them by grab_cache_page_nowait and READA marked page is available.
> Intentional or not, readahead works pretty well. I checked in experiment.


read_pages
  for(page_idx ...) {
    if (!add_to_page_cache_lru)) { <-- 1)
      mapping->a_ops->readpage(filp, page)
        squashfs_readpage
          for (i ...) {   2)  Here, 31 pages are inserted into page cache
            grab_cahe_page_nowait <------/
              add_to_page_cache_lru 
          }
    }
    /*
     * 1) will be failed with EEXIST by 2) so every pages other than first page
     * in list would be freed
     */
    page_cache_release(page) 
  }
   
If you see ReadAhead works, it is just by luck as I told you.
Please simulate it with 64K dd.

> 
> > If first issued I/O complete, squashfs decompress the I/O with 128K pages
> > so all 4 iteration(128K/32K) would be hit in page cache.
> > If all 128K hit in page cache, mm layer start to issue next I/O and
> > repeat above logic until you ends up reading all file size.
> > So my opition is that upper layer wouldn't issue more I/O logically.
> > If it worked, it's not what we expect but side-effect.
> >
> > That's why I'd like to know what's your thought for increasing IOPS.
> > Please, could you say your thought why IOPS increased, not a result
> > on low level driver?
> It is because readahead can works asynchronously in background.
> Suppose that you read a large file by 128k partially and contiguously
> like "dd bs=128k". Two IOs can be issued per 128k reading,
> First IO is for intended pages, second IO is for readahead.
> If first IO hit in cache thank to previous readahead, no wait for IO completion
> is needed, because intended page is up-to-date already.
> But, current squashfs waits for second IO's completion unnecessarily.
> That is one of reason that we should move page's up-to-date
> to the asynchronous area like my patch.

I understand it but your patch doesn't make it.

> 
> > Anyway, in my opinion, we should take care of MM layer's readahead for
> > enhance sequential I/O. For it, we should use buffer pages passed by MM
> > instead of freeing them and allocating new pages in squashfs.
> > IMHO, it would be better to implement squashfs_readpages but my insight
> > is very weak so I guess Phillip will give more good idea/insight about
> > the issue.
> That's a good point. Also, I think my patch is another way which can be implemented
> without significant impact on current implementation and I wait for Phillip's comment.
> 
> Thanks
> Chanho
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
