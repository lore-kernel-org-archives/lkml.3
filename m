Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab3DLSBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 14:01:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab3DLSBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 14:01:30 -0400
Date: Fri, 12 Apr 2013 14:01:08 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Tejun Heo <tj@kernel.org>
cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>,
        "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [PATCH v2] make dm and dm-crypt forward cgroup context (was:
 dm-crypt parallelization patches)
In-Reply-To: <20130411200005.GB11956@mtj.dyndns.org>
Message-ID: <Pine.LNX.4.64.1304121340350.3359@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1304091450410.26327@file.rdu.redhat.com>
 <20130409195259.GL6186@mtj.dyndns.org> <Pine.LNX.4.64.1304091624110.19672@file.rdu.redhat.com>
 <20130409210735.GR6320@redhat.com> <Pine.LNX.4.64.1304091710150.24735@file.rdu.redhat.com>
 <20130410192427.GA14911@redhat.com> <Pine.LNX.4.64.1304101938280.24258@file.rdu.redhat.com>
 <20130410235009.GI17641@mtj.dyndns.org> <Pine.LNX.4.64.1304111544050.32536@file.rdu.redhat.com>
 <20130411195203.GA11956@mtj.dyndns.org> <20130411200005.GB11956@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Apr 2013, Tejun Heo wrote:

> On Thu, Apr 11, 2013 at 12:52:03PM -0700, Tejun Heo wrote:
> > If this becomes an actual bottleneck, the right thing to do is making
> > css ref per-cpu.  Please stop messing around with refcounting.
> 
> If you think this kind of hackery is acceptable, you really need to
> re-evaluate your priorities in making engineering decisions.  In
> tightly coupled code, maybe, but you're trying to introduce utterly
> broken error-prone thing as a generic block layer API.  I mean, are
> you for real?
> 
> -- 
> tejun

Please describe what is wrong with the code? Why do you call it hackery?

When device mapper is creating a cloned bio for the lower layer, it is 
already assumed that the cloned bio has shorter lifetime than the original 
bio it was created from.

The device mapper copies a part of the bio vector from the original bio to 
the cloned bio, it copies pointers to pages without increasing reference 
counts on those pages. As long as the original bio is not returned with 
bio_endio, the pages must exist, so there is no need to increase their 
reference counts.

Now, if copying pointers without increasing reference counts is OK for 
pages, why do you think it is not OK for cgroup context?

Why do you call this bug-prone? - how do you think a bug could happen? If 
someone in device mapper errorneously ends the master bio while the cloned 
bio is still in progress, there is already a memory corruption bug (the 
cloned bio vector points to potentially free pages) and safeguarding the 
cgroup pointers won't fix it.


So if you think that reference counts should be incremented by every clone 
of the original bio, what kind of bug should it protect against? If we 
don't increment reference counts for pages, why should we do it for cgroup 
pointers?

Mikulas
