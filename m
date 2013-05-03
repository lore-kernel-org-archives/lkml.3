Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934145Ab3ECR5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 13:57:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933827Ab3ECR47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 13:56:59 -0400
Date: Fri, 3 May 2013 13:56:52 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCHSET] blk-throttle: implement proper hierarchy support
Message-ID: <20130503175652.GB6062@redhat.com>
References: <20130502173428.GA4771@redhat.com>
 <20130502175701.GL19814@mtj.dyndns.org>
 <20130502181747.GH30020@redhat.com>
 <20130502182933.GN19814@mtj.dyndns.org>
 <20130502184514.GI30020@redhat.com>
 <20130502184953.GP19814@mtj.dyndns.org>
 <20130502190732.GK30020@redhat.com>
 <CAOS58YOk7G=dBG1v5Ed2z3biMMyKkkutp30vH5XC72z0_Z85cw@mail.gmail.com>
 <20130502193139.GL30020@redhat.com>
 <20130502231307.GT19814@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502231307.GT19814@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 04:13:07PM -0700, Tejun Heo wrote:
> Hello, Vivek.
> 
> On Thu, May 02, 2013 at 03:31:39PM -0400, Vivek Goyal wrote:
> > I think my example was little flawed previously. I think you are right.
> > Penalty is not probably as bad as I have been thinking.
> > 
> > So if both parent and child have limit of 1MB/s and application is doing
> > IO (say at 2MB/sec), in long term it should still see 1MB/s rate.
> > 
> > 		T1	T2	T3	T4	T5	T6
> > Parent group:		B1	B2	B3	B4	B5
> > Child group:	B1	B2	B3	B4	B5	B6 
> > 
> > Above B1 to B6 are bios of 1MB size. T1 to T6 are 1 second time interval.
> > B1 waits for T1 interval in child group and then for T2 interval in
> > parent group and then gets dispatched. But a pipe line has formed in
> > child group and B2 is waiting in child group in T2 slice. So penalty
> > is not double.
> > 
> > So each group migration will add one extra wait period. In above case
> > 5 bios dispatched in 6 seconds. Longer the sampling interval, delay
> > remains the constant to one time interval and % penalty goes down.
> 
> Yeah, I think that's what *should* be happening but not what I'm
> seeing.  I'm seeing ~15% penalty.

What test are you running. I am running a simple dd with directIO and
I am not seeing any penalty.

# set limit to 1000000 bytes/second both in parent and child cgroup
# dd if=/dev/vdb of=/dev/null iflag=direct

I will capture blktrace and analyze it though to understand better
what's happening.

>  It works fine if there are more
> than one active children but with a single child configured at the
> same limit, it doesn't work as expected.  I'm a bit lost where the
> difference is coming from.  Hmmm... also in the above example, we
> really should be doing the following.
> 
>  		T1	T2	T3	T4	T5	T6
>  Parent group:	B1	B2	B3	B4	B5	B6
>  Child group:	B1	B2	B3	B4	B5	B6 
> 
> I mean, if there's no other IO going on, there's no point in delaying
> the first IO.  ie. the slice should be considered as started before so
> that B1 can be issued immediately, right?

Yes that's the right thing to do. So may be we can tell parent group when
bio was queued in. Parent will have to start a new time slice. It also
needs to look into when was the last slice it finished and take greater
of last slice finished and time slice passed by child.

/me needs to think little more about time slice management.

Thanks
Vivek
