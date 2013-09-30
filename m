Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab3I3N0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:26:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab3I3N0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:26:40 -0400
Date: Mon, 30 Sep 2013 06:26:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jack Wang <jinpu.wang@profitbricks.com>
Cc: Luis Henriques <luis.henriques@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Khalid Aziz <khalid.aziz@oracle.com>,
        Pravin B Shelar <pshelar@nicira.com>, Christoph Lameter <cl@linux.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 092/104] mm: fix aio performance regression for database
 caused by THP
Message-ID: <20130930132642.GA7510@kroah.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
 <1380535881-9239-93-git-send-email-luis.henriques@canonical.com>
 <5249794C.5050204@profitbricks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5249794C.5050204@profitbricks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 03:14:52PM +0200, Jack Wang wrote:
> On 09/30/2013 12:11 PM, Luis Henriques wrote:
> > 3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Khalid Aziz <khalid.aziz@oracle.com>
> > 
> > commit 7cb2ef56e6a8b7b368b2e883a0a47d02fed66911 upstream.
> > 
> > I am working with a tool that simulates oracle database I/O workload.
> > This tool (orion to be specific -
> > <http://docs.oracle.com/cd/E11882_01/server.112/e16638/iodesign.htm#autoId24>)
> > allocates hugetlbfs pages using shmget() with SHM_HUGETLB flag.  It then
> > does aio into these pages from flash disks using various common block
> > sizes used by database.  I am looking at performance with two of the most
> > common block sizes - 1M and 64K.  aio performance with these two block
> > sizes plunged after Transparent HugePages was introduced in the kernel.
> > Here are performance numbers:
> > 
> > 		pre-THP		2.6.39		3.11-rc5
> > 1M read		8384 MB/s	5629 MB/s	6501 MB/s
> > 64K read	7867 MB/s	4576 MB/s	4251 MB/s
> > 
> > I have narrowed the performance impact down to the overheads introduced by
> > THP in __get_page_tail() and put_compound_page() routines.  perf top shows
> >> 40% of cycles being spent in these two routines.  Every time direct I/O
> > to hugetlbfs pages starts, kernel calls get_page() to grab a reference to
> > the pages and calls put_page() when I/O completes to put the reference
> > away.  THP introduced significant amount of locking overhead to get_page()
> > and put_page() when dealing with compound pages because hugepages can be
> > split underneath get_page() and put_page().  It added this overhead
> > irrespective of whether it is dealing with hugetlbfs pages or transparent
> > hugepages.  This resulted in 20%-45% drop in aio performance when using
> > hugetlbfs pages.
> > 
> > Since hugetlbfs pages can not be split, there is no reason to go through
> > all the locking overhead for these pages from what I can see.  I added
> > code to __get_page_tail() and put_compound_page() to bypass all the
> > locking code when working with hugetlbfs pages.  This improved performance
> > significantly.  Performance numbers with this patch:
> > 
> > 		pre-THP		3.11-rc5	3.11-rc5 + Patch
> > 1M read		8384 MB/s	6501 MB/s	8371 MB/s
> > 64K read	7867 MB/s	4251 MB/s	6510 MB/s
> > 
> > Performance with 64K read is still lower than what it was before THP, but
> > still a 53% improvement.  It does mean there is more work to be done but I
> > will take a 53% improvement for now.
> > 
> > Please take a look at the following patch and let me know if it looks
> > reasonable.
> > 
> > [akpm@linux-foundation.org: tweak comments]
> > Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
> > Cc: Pravin B Shelar <pshelar@nicira.com>
> > Cc: Christoph Lameter <cl@linux.com>
> > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Mel Gorman <mel@csn.ul.ie>
> > Cc: Rik van Riel <riel@redhat.com>
> > Cc: Minchan Kim <minchan@kernel.org>
> > Cc: Andi Kleen <andi@firstfloor.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > [ luis: backported to 3.5: adjusted context ]
> > Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> Hi Greg,
> 
> I suppose this patch also needed for 3.4, right?

As it didn't originally apply there, I didn't apply it.

If people think it should be applicable for 3.4, I'll take it.

thanks,

greg k-h
