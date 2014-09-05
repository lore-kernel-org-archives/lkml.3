Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706AbaIEOOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:14:43 -0400
Received: from imap.thunk.org ([74.207.234.97]:40075 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305AbaIEOOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:14:41 -0400
Date: Fri, 5 Sep 2014 10:14:16 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Gioh Kim <gioh.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>,
        jack@suse.cz, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, adilger.kernel@dilger.ca, minchan@kernel.org,
        gunho.lee@lge.com
Subject: Re: [PATCHv4 0/3] new APIs to allocate buffer-cache with user
 specific flag
Message-ID: <20140905141416.GA1510@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Gioh Kim <gioh.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
	paulmck@linux.vnet.ibm.com, peterz@infradead.org,
	adilger.kernel@dilger.ca, minchan@kernel.org, gunho.lee@lge.com
References: <1409815781-28011-1-git-send-email-gioh.kim@lge.com>
 <20140904151612.7bf5b813069ff78973e01571@linux-foundation.org>
 <540905B1.1050200@lge.com>
 <20140905011419.GE4364@thunk.org>
 <20140905014808.GA26070@js1304-P5Q-DELUXE>
 <20140905031735.GD1971@thunk.org>
 <20140905073247.GA31827@js1304-P5Q-DELUXE>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905073247.GA31827@js1304-P5Q-DELUXE>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 04:32:48PM +0900, Joonsoo Kim wrote:
> I also test another approach, such as allocate freepage in CMA
> reserved region as late as possible, which is also similar to your
> suggestion and this doesn't works well. When reclaim is started,
> too many pages reclaim at once, because lru list has successive pages
> in CMA region and these doesn't help kswapd's reclaim. kswapd stop
> reclaiming when freepage count is recovered. But, CMA pages isn't
> counted for freepage for kswapd because they can't be usable for
> unmovable, reclaimable allocation. So kswap reclaim too many pages
> at once unnecessarilly.

Have you considered putting the pages in a CMA region in a separate
zone?  After all, that's what we originally did with brain-damaged
hardware that could only DMA into the low 16M of memory.  We just
reserved a separate zone for that?  That way, we could do
zone-directed reclaim and free pages in that zone, if that was what
was actually needed.

But if we would also preferentially avoid using pages from that zone
unless there was no choice, in order to avoid needing to do that
zone-directed reclaim.  Perhaps a similar solution could do done here?

	      			  	  - Ted
