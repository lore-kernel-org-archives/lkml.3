Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbaA1TEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:04:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:12933 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321AbaA1TEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:04:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,737,1384329600"; 
   d="scan'208";a="473919988"
Subject: Re: [numa shrinker] 9b17c62382: -36.6% regression on sparse file
 copy
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dave Chinner <david@fromorbit.com>, Glauber Costa <glommer@parallels.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        lkp@linux.intel.com, "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <20140127120943.GA17055@localhost>
References: <20140106082048.GA567@localhost>
	 <20140106131042.GA5145@destitution> <20140109025715.GA11984@localhost>
	 <20140115001827.GO3469@dastard>  <20140127120943.GA17055@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Jan 2014 11:03:30 -0800
Message-ID: <1390935810.3138.80.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-27 at 20:09 +0800, Fengguang Wu wrote:
> Hi Dave,
> 
> On Wed, Jan 15, 2014 at 11:18:27AM +1100, Dave Chinner wrote:
> > On Thu, Jan 09, 2014 at 10:57:15AM +0800, Fengguang Wu wrote:
> > > Hi Dave,
> > > 
> > > As you suggested, I added tests for ext4 and btrfs, the results are
> > > the same.
> > > 
> > > Then I tried running perf record for 10 seconds starting from 200s.
> > > (The test runs for 410s). I see several warning messages and hope
> > > they do not impact the accuracy too much:
> > > 
> > > [  252.608069] perf samples too long (2532 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
> > > [  252.608863] perf samples too long (2507 > 2500), lowering kernel.perf_event_max_sample_rate to 25000
> > > [  252.609422] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 1.389 msecs
> > > 
> > > Anyway the noticeable perf change are:
> > > 
> > > 1d3d4437eae1bb2  9b17c62382dd2e7507984b989  
> > > ---------------  -------------------------  
> > >      12.15 ~10%    +209.8%      37.63 ~ 2%  brickland2/debug2/vm-scalability/300s-btrfs-lru-file-readtwice
> > >      12.88 ~16%    +189.4%      37.27 ~ 0%  brickland2/debug2/vm-scalability/300s-ext4-lru-file-readtwice
> > >      15.24 ~ 9%    +146.0%      37.50 ~ 1%  brickland2/debug2/vm-scalability/300s-xfs-lru-file-readtwice
> > >      40.27         +179.1%     112.40       TOTAL perf-profile.cpu-cycles._raw_spin_lock.grab_super_passive.super_cache_count.shrink_slab.do_try_to_free_pages
> > > 
> > > 1d3d4437eae1bb2  9b17c62382dd2e7507984b989  
> > > ---------------  -------------------------  
> > >      11.91 ~12%    +218.2%      37.89 ~ 2%  brickland2/debug2/vm-scalability/300s-btrfs-lru-file-readtwice
> > >      12.47 ~16%    +200.3%      37.44 ~ 0%  brickland2/debug2/vm-scalability/300s-ext4-lru-file-readtwice
> > >      15.36 ~11%    +145.4%      37.68 ~ 1%  brickland2/debug2/vm-scalability/300s-xfs-lru-file-readtwice
> > >      39.73         +184.5%     113.01       TOTAL perf-profile.cpu-cycles._raw_spin_lock.put_super.drop_super.super_cache_count.shrink_slab
> > > 
> > > perf report for 9b17c62382dd2e7507984b989:
> > > 
> > > # Overhead          Command       Shared Object                                          Symbol
> > > # ........  ...............  ..................  ..............................................
> > > #
> > >     77.74%               dd  [kernel.kallsyms]   [k] _raw_spin_lock                            
> > >                          |
> > >                          --- _raw_spin_lock
> > >                             |          
> > >                             |--47.65%-- grab_super_passive
> > 
> > Oh, it's superblock lock contention, probably caused by an increase
> > in shrinker calls (i.e. per-node rather than global). I think we've
> > seen this before - can you try the two patches from Tim Chen here:
> > 
> > https://lkml.org/lkml/2013/9/6/353
> > https://lkml.org/lkml/2013/9/6/356
> > 
> > If they fix the problem, I'll get them into 3.14 and pushed back to
> > the relevant stable kernels.
> 
> Yes, the two patches help a lot:
> 
> 9b17c62382dd2e7  8401edd4b12960c703233f4ed
> ---------------  -------------------------  
>    6748913 ~ 2%     +37.5%    9281049 ~ 1%  brickland2/debug2/vm-scalability/300s-btrfs-lru-file-readtwice
>    8417200 ~ 0%     +56.5%   13172417 ~ 0%  brickland2/debug2/vm-scalability/300s-ext4-lru-file-readtwice
>    8333983 ~ 1%     +56.9%   13078610 ~ 0%  brickland2/debug2/vm-scalability/300s-xfs-lru-file-readtwice
>   23500096 ~ 1%     +51.2%   35532077 ~ 0%  TOTAL vm-scalability.throughput
> 
> They restore performance numbers back to 1d3d4437eae1bb2's level
> (which is 9b17c62382's parent commit).
> 
> Thanks,
> Fengguang

Dave,

You're going to merge the two patches to 3.14?

Thanks.

Tim

