Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763390Ab3ECT1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 15:27:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763076Ab3ECT1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 15:27:02 -0400
Date: Fri, 3 May 2013 15:26:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCHSET] blk-throttle: implement proper hierarchy support
Message-ID: <20130503192656.GD6062@redhat.com>
References: <20130502184514.GI30020@redhat.com>
 <20130502184953.GP19814@mtj.dyndns.org>
 <20130502190732.GK30020@redhat.com>
 <CAOS58YOk7G=dBG1v5Ed2z3biMMyKkkutp30vH5XC72z0_Z85cw@mail.gmail.com>
 <20130502193139.GL30020@redhat.com>
 <20130502231307.GT19814@mtj.dyndns.org>
 <20130503175652.GB6062@redhat.com>
 <20130503185751.GA22860@mtj.dyndns.org>
 <20130503190823.GC6062@redhat.com>
 <20130503191418.GC22860@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130503191418.GC22860@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 12:14:18PM -0700, Tejun Heo wrote:
> On Fri, May 03, 2013 at 03:08:23PM -0400, Vivek Goyal wrote:
> > 		T1	T2	T3	T4	T5	T6	T7
> > parent:			b1	b2	b3		b4 	b5
> > child: 		b1	b2	b3		b4	b5	
> > 
> > 
> > So continuity breaks down because application is waiting for previous
> > IO to finish. This forces expiry of existing time slices and new time
> > slice start both in child and parent and penalty keep on increasing.
> 
> It's a problem even in flat mode as the "child" above can easily be
> just a process which is throttling itself and it won't be able to get
> the configured bandwidth due to the scheduling bubbles introduced
> whenever new slice is started.  Shouldn't be too difficult to get rid
> of, right?

Key thing here is when to start a new slice. Generally when an IO has been
dispatched from a group, we do not expire slice immediately. We kind of
give group some grace period of throtl_slice (100ms). If next IO does not
come with-in that duration, we start a fresh slice upon next IO arrival.

I think similar problem should happen if there are two stacked devices
and both are doing throttling and if delays between 2 IOs are big enough
that it forces expirty of slice on each device.

Atleast for the hiearchy case, we should be able to start a fresh time
slice when child transfer bio to parent. I will write a patch and do
some experiment.

Thanks
Vivek
