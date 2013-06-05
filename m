Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab3FENbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:31:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab3FENbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:31:12 -0400
Date: Wed, 5 Jun 2013 09:30:59 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Robin Dong <sanbai@taobao.com>
Cc: linux-kernel@vger.kernel.org, Zhu Yanhai <gaoyang.zyh@taobao.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <taoma.tm@gmail.com>
Subject: Re: [RFC v1] add new io-scheduler to use cgroup on high-speed device
Message-ID: <20130605133059.GA16339@redhat.com>
References: <1370398171-25173-1-git-send-email-sanbai@taobao.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370398171-25173-1-git-send-email-sanbai@taobao.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 10:09:31AM +0800, Robin Dong wrote:
> We want to use blkio.cgroup on high-speed device (like fusionio) for our mysql clusters.
> After testing different io-scheduler, we found that  cfq is too slow and deadline can't run on cgroup.

So why not enhance deadline to be able to be used with cgroups instead of
coming up with a new scheduler?

> So we developed a new io-scheduler: tpps (Tiny Parallel Proportion Scheduler).It dispatch requests
> only by using their individual weight and total weight (proportion) therefore it's simply and efficient.

Can you give more details. Do you idle? Idling kills performance. If not,
then without idling how do you achieve performance differentiation.

> 
> Test case: fusionio card, 4 cgroups, iodepth-512
> 
> groupname  weight
> test1      1000
> test2      800
> test3      600
> test4      400
> 

What's the workload used for this?

> Use tpps, the result is:
> 
> groupname  iops    avg-rt(ms)   max-rt(ms)
> test1      30220   16           54
> test2      28261   18           56
> test3      26333   19           69
> test4      20152   25           87
> 
> Use cfq, the result is:
> 
> groupname  iops    avg-rt(ms)   max-rt(ms)
> test1      16478   30           242
> test2      13015   39           347
> test3       9300   54           371
> test4       5806   87           393

How do results look like with cfq if this is run with slice_idle=0 and
quatum=128 or higher.

cfqq idles on 3 things. queue (cfqq), service tree and cfq group.
slice_idle will disable idling on cfqq but not no service tree. If
we provide a knob for that, then idling on service tree can be disabled
too and then we will be left with group idling only and then it should
be much better.

Thanks
Vivek
