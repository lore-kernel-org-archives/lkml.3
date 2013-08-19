Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab3HSCFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 22:05:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:13806 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab3HSCFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 22:05:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,909,1367996400"; 
   d="scan'208";a="382838198"
Date: Mon, 19 Aug 2013 10:05:47 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tao Ma <tm@tao.ma>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: readahead: make context readahead more conservative
Message-ID: <20130819020547.GA11775@localhost>
References: <20130808085418.GA23970@localhost>
 <52117BED.7000909@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52117BED.7000909@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 09:59:09AM +0800, Miao Xie wrote:
> Hi, everyone
> 
> On Thu, 8 Aug 2013 16:54:18 +0800, Fengguang Wu wrote:
> > This helps performance on moderately dense random reads on SSD.
> > 
> > Transaction-Per-Second numbers provided by Taobao:
> > 
> > 		QPS	case
> > 		-------------------------------------------------------
> > 		7536	disable context readahead totally
> > w/ patch:	7129	slower size rampup and start RA on the 3rd read
> > 		6717	slower size rampup
> > w/o patch:	5581	unmodified context readahead
> > 
> > Before, readahead will be started whenever reading page N+1 when it
> > happen to read N recently. After patch, we'll only start readahead
> > when *three* random reads happen to access pages N, N+1, N+2. The
> > probability of this happening is extremely low for pure random reads,
> > unless they are very dense, which actually deserves some readahead.
> > 
> > Also start with a smaller readahead window. The impact to interleaved
> > sequential reads should be small, because for a long run stream, the
> > the small readahead window rampup phase is negletable.
> > 
> > The context readahead actually benefits clustered random reads on HDD
> > whose seek cost is pretty high. However as SSD is increasingly used
> > for random read workloads it's better for the context readahead to
> > concentrate on interleaved sequential reads.
> > 
> > Another SSD rand read test from Miao
> > 
> >         # file size:        2GB
> >         # read IO amount: 625MB
> >         sysbench --test=fileio          \
> >                 --max-requests=10000    \
> >                 --num-threads=1         \
> >                 --file-num=1            \
> >                 --file-block-size=64K   \
> >                 --file-test-mode=rndrd  \
> >                 --file-fsync-freq=0     \
> >                 --file-fsync-end=off    run
> > 
> > shows the performance of btrfs grows up from 69MB/s to 121MB/s,
> > ext4 from 104MB/s to 121MB/s.
> 
> I did the same test on the hard disk recently,
> for btrfs, there is ~5% regression(10.65MB/s -> 10.09MB/s),
> for ext4, the performance grows up a bit.(9.98MB/s -> 10.04MB/s).
> (I run the test for 4 times, and the above result is the average of the test.)
> 
> Any comment?

Thanks for the tests! Minor regressions on the HDD cases are expected.

Since random read workloads are migrating to SSD as it becomes cheaper
and larger, it seems a good tradeoff to optimize for random read
performance on SSD.

Thanks,
Fengguang
