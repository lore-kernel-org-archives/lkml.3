Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab3EBXNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 19:13:15 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:42995 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab3EBXNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 19:13:13 -0400
Date: Thu, 2 May 2013 16:13:07 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCHSET] blk-throttle: implement proper hierarchy support
Message-ID: <20130502231307.GT19814@mtj.dyndns.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
 <20130502173428.GA4771@redhat.com>
 <20130502175701.GL19814@mtj.dyndns.org>
 <20130502181747.GH30020@redhat.com>
 <20130502182933.GN19814@mtj.dyndns.org>
 <20130502184514.GI30020@redhat.com>
 <20130502184953.GP19814@mtj.dyndns.org>
 <20130502190732.GK30020@redhat.com>
 <CAOS58YOk7G=dBG1v5Ed2z3biMMyKkkutp30vH5XC72z0_Z85cw@mail.gmail.com>
 <20130502193139.GL30020@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502193139.GL30020@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Thu, May 02, 2013 at 03:31:39PM -0400, Vivek Goyal wrote:
> I think my example was little flawed previously. I think you are right.
> Penalty is not probably as bad as I have been thinking.
> 
> So if both parent and child have limit of 1MB/s and application is doing
> IO (say at 2MB/sec), in long term it should still see 1MB/s rate.
> 
> 		T1	T2	T3	T4	T5	T6
> Parent group:		B1	B2	B3	B4	B5
> Child group:	B1	B2	B3	B4	B5	B6 
> 
> Above B1 to B6 are bios of 1MB size. T1 to T6 are 1 second time interval.
> B1 waits for T1 interval in child group and then for T2 interval in
> parent group and then gets dispatched. But a pipe line has formed in
> child group and B2 is waiting in child group in T2 slice. So penalty
> is not double.
> 
> So each group migration will add one extra wait period. In above case
> 5 bios dispatched in 6 seconds. Longer the sampling interval, delay
> remains the constant to one time interval and % penalty goes down.

Yeah, I think that's what *should* be happening but not what I'm
seeing.  I'm seeing ~15% penalty.  It works fine if there are more
than one active children but with a single child configured at the
same limit, it doesn't work as expected.  I'm a bit lost where the
difference is coming from.  Hmmm... also in the above example, we
really should be doing the following.

 		T1	T2	T3	T4	T5	T6
 Parent group:	B1	B2	B3	B4	B5	B6
 Child group:	B1	B2	B3	B4	B5	B6 

I mean, if there's no other IO going on, there's no point in delaying
the first IO.  ie. the slice should be considered as started before so
that B1 can be issued immediately, right?

Thanks.

-- 
tejun
