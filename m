Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab3GIPIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:08:21 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45322 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab3GIPIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:08:18 -0400
Date: Tue, 9 Jul 2013 08:08:15 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Sha Zhengju <handai.szj@gmail.com>, devel@openvz.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
Message-ID: <20130709150815.GG2478@htj.dyndns.org>
References: <51DBC99F.4030301@openvz.org>
 <20130709125734.GA2478@htj.dyndns.org>
 <51DC0CE2.2050906@openvz.org>
 <20130709131605.GB2478@htj.dyndns.org>
 <20130709131646.GC2478@htj.dyndns.org>
 <51DC136E.6020901@openvz.org>
 <20130709134558.GD2478@htj.dyndns.org>
 <20130709141833.GA2237@redhat.com>
 <20130709142908.GE2478@htj.dyndns.org>
 <20130709145430.GB2237@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709145430.GB2237@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Tue, Jul 09, 2013 at 10:54:30AM -0400, Vivek Goyal wrote:
> It is not clear whether counting bio or counting request is right
> thing to do here. It depends where you are trying to throttle. For
> bio based drivers there is request and they need throttling mechanism
> too. So keeping it common for both, kind of makes sense.

It gets weird because we may end up with wildy disagreeing statistics
from queue and the resource management.  It should have been part of
request_queue not something sitting on top.  Note that with
multi-queue support, we're unlikely to need bio based drivers except
for the stacking ones.

> Ok, so first of all you agree that time slice management is not a
> requirement for fast devices.

Not fast, but consistent.

> So time slice management is a problem even on slow devices which implement
> NCQ. IIRC, in the beginning even CFQ as doing some kind of request
> management (and not time slice management). And later it switched to
> time slice management in an effort to provide better fairness (If somebody
> is doing random IO and seek takes more time the process should be
> accounted for it).
> 
> But ideal time slice accounting requires driving a queue depth of 1
> and for any non-sequential IO, it kills performance.

Yeap, complete control only works with qd == 1 and even then write
buffering will throw you off.  But even w/ qd > 1 and write buffering,
time slice is fundamentally right thing to manage and than iops for
disks - e.g. you want to group IOs from the same issuer in the same
time slice even if the time accounting for that is not accurate so
that you can size the slice according to the operating characteristics
of the device and do things like idling inbetween.

> Seriously, time slice accounting is one way of managing resource. Same
> disk resource can be divided proportionally by counting either iops
> or by counting amount of IO done (bandwidth).

In practice, bio iops based proportional control becomes almost
completely worthless if you have any mix of random and sequential
accesses.  cfq wouldn't be accurate but it'd be *far* closer than
anything based on iops.

> If we count iops or bandwidth, it might not be most fair way of doing
> things on rotational media but it also should provide more accurate
> results in case of NCQ. When multiple requests have been dispatched
> to disk we have no idea which request consumed how much of disk time.
> So there is no way to account it properly. Iops or bandwidth based
> accounting will work just fine even with NCQ.

Sure, if iops or bw is what you explicitly want to control with hard
limits, it's fine, but doing proportional control with that on
rotating disk is just silly.

> So you want this generic block layer proportional implementation to
> do time slice management?
> 
> I thought we talked about this implementation to use some kind of
> token based mechanism so that it scales better on faster
> devices. And on slower devices one will continue to use CFQ.

I want to leave rotating disk proportional control to cfq-iosched for
as long as it matters and do iops / bw based things in the generic
layer.

Thanks.

-- 
tejun
