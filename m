Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150Ab3FGTyB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 15:54:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756613Ab3FGTx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 15:53:59 -0400
Date: Fri, 7 Jun 2013 15:53:51 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: sanbai <sanbai@taobao.com>
Cc: linux-kernel@vger.kernel.org, Zhu Yanhai <gaoyang.zyh@taobao.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tao Ma <taoma.tm@gmail.com>
Subject: Re: [RFC v1] add new io-scheduler to use cgroup on high-speed device
Message-ID: <20130607195351.GD14015@redhat.com>
References: <1370398171-25173-1-git-send-email-sanbai@taobao.com>
 <20130605133059.GA16339@redhat.com>
 <51B14F02.9090409@taobao.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51B14F02.9090409@taobao.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 11:09:54AM +0800, sanbai wrote:
> On 2013年06月05日 21:30, Vivek Goyal wrote:
> >On Wed, Jun 05, 2013 at 10:09:31AM +0800, Robin Dong wrote:
> >>We want to use blkio.cgroup on high-speed device (like fusionio) for our mysql clusters.
> >>After testing different io-scheduler, we found that  cfq is too slow and deadline can't run on cgroup.
> >So why not enhance deadline to be able to be used with cgroups instead of
> >coming up with a new scheduler?
> I think if we add cgroups support into deadline, it will not be
> suitable to call "deadline" anymore...so a new ioscheduler and a new
> name may not confuse users.

Nobody got confused when we added cgroup support to CFQ. Not that
I am saying go add support to deadline. I am just saying that need
for cgroup support does not sound like it justfies need of a new
IO scheduler.

[..]
> >Can you give more details. Do you idle? Idling kills performance. If not,
> >then without idling how do you achieve performance differentiation.
> We don't idle, when comes to .elevator_dispatch_fn，we just compute
> quota for every group:
> 
> quota = nr_requests - rq_in_driver;
> group_quota = quota * group_weight / total_weight;
> 
> and dispatch 'group_quota' requests for the coordinate group.
> Therefore high-weight group
> will dispatch more requests than low-weight group.

Ok, this works only if all the groups are full all the time otherwise
groups will lose their fair share. This simplifies the things a lot.
That is fairness is provided only if group is always backlogged. In
practice, this happens only if a group is doing IO at very high rate
(like your fio scripts). Have you tried running any real life workload
in these cgroups (apache, databases etc) and see how good is service
differentiation.

Anyway, sounds like this can be done at generic block layer like
blk-throtl and it can sit on top so that it can work with all schedulers
and can also work with bio based block drivers.  

[..]
> I do the test again for cfq (slice_idle=0, quatum=128) and tpps
> 
> cfq (slice_idle=0, quatum=128)
> groupname iops avg-rt(ms) max-rt(ms)
> test1 16148 15 188
> test2 12756 20 117
> test3 9778 26 268
> test4 6198 41 209
> 
> tpps
> groupname iops avg-rt(ms) max-rt(ms)
> test1 17292 14 65
> test2 15221 16 80
> test3 12080 21 66
> test4 7995 32 90
> 
> Looks cfq with is much better than before.

Yep, I am sure there are more simple opportunites for optimization
where it can help. Can you try couple more things.

- Drive even deeper queue depth. Set quantum=512.

- set group_idle=0.

  Ideally this should effectively emulate what you are doing. That is try
  to provide fairness without idling on group.

  In practice I could not keep group queue full and before group exhausted
  its slice, it got empty and got deleted from service tree and lost its
  fair share. So if group_idle=0 leads to no service differentiation,
  try slice_sync=10 and see what happens.

Thanks
Vivek
