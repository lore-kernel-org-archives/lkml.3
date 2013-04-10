Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765875Ab3DJTY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 15:24:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab3DJTYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 15:24:55 -0400
Date: Wed, 10 Apr 2013 15:24:27 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>
Subject: Re: dm-crypt parallelization patches
Message-ID: <20130410192427.GA14911@redhat.com>
References: <20130328204522.GA25501@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091242350.10025@file.rdu.redhat.com>
 <20130409175753.GA6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091402150.10025@file.rdu.redhat.com>
 <20130409181031.GC6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091450410.26327@file.rdu.redhat.com>
 <20130409195259.GL6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091624110.19672@file.rdu.redhat.com>
 <20130409210735.GR6320@redhat.com>
 <Pine.LNX.4.64.1304091710150.24735@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1304091710150.24735@file.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 05:18:25PM -0400, Mikulas Patocka wrote:

[..]
> > bio_associate_current() return -EBUSY if bio has already been associated
> > with an io context.
> > 
> > So in a stack if every driver calls bio_associate_current(), upon bio
> > submission, it will automatically amke sure bio gets associated with
> > submitter task in top level device and calls by lower level device
> > will be ignored.
> 
> The stacking drivers do not pass the same bio to each other.
> 
> The stacking driver receives a bio, allocates zero or more new bios and 
> sends these new bios to the lower layer. So you need to propagate 
> ownership from the received bio to newly allocated bios, you don't want to 
> associate newly allocated bio with "current" process.

Actually I was asking to call bio_associate_current() for the incoming
bio in the driver and not for the newly created bios by the driver.

For any newly created bios on behalf of this incoming bio, we need to
copy the context so that this context info can be propogated down the
stack.


> 
> > Lower level devices I think just need to make sure this context
> > info is propogated to cloned bios.
> > 
> > 
> > [..]
> > > +#ifdef CONFIG_BLK_CGROUP
> > > +	tio->clone.bi_ioc = ci->bio->bi_ioc;
> > > +	tio->clone.bi_css = ci->bio->bi_css;
> > 
> > You also need to take references to ioc and css objects. I guess a helper
> > function will be better. May be something like.
> 
> The lifetime of the "tio" structure is shorter than the lifetime of 
> "ci->bio". So we don't need to increment reference.
> 
> We only need to increment reference if we copy ownership to a new bio that 
> has could have longer lifetime than the original bio. But this situation 
> is very rare - in most stacking drivers the newly allocated bio has 
> shorter lifetime than the original one.

I think it is not a good idea to rely on the fact that cloned bios or
newly created bios will have shorter lifetime than the original bio. In fact
when the bio completes and you free it up bio_disassociate_task() will try
to put io context and blkcg reference. So it is important to take
reference if you are copying context info in any newly created bio.

Thanks
Vivek
