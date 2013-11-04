Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab3KDPUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 10:20:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167Ab3KDPUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 10:20:13 -0500
Date: Mon, 4 Nov 2013 10:20:02 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH for-next] dm: fix missing bi_remaining accounting
Message-ID: <20131104152001.GA12398@redhat.com>
References: <20131101135931.GA22903@redhat.com>
 <5273C2B8.5030608@kernel.dk>
 <alpine.LRH.2.02.1311041003400.4548@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1311041003400.4548@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04 2013 at 10:06am -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Fri, 1 Nov 2013, Jens Axboe wrote:
> 
> > On 11/01/2013 07:59 AM, Mike Snitzer wrote:
> > > Add the missing bi_remaining increment, required by the block layer's
> > > new bio-chaining code, to both the verity and old snapshot DM targets.
> > > 
> > > Otherwise users will hit the bi_remaining <= 0 BUG_ON in bio_endio().
> > 
> > Thanks Mike, added to the mix.
> > 
> > -- 
> > Jens Axboe
> 
> Hi
> 
> This improves a little bit on the previous patch, by replacing costly 
> atomic_inc with cheap atomic_set.
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> dm: change atomic_inc to atomic_set(1)
> 
> There are places in dm where we save bi_endio and bi_private, set them to
> target's routine, submit the bio, from the target's bi_endio routine we
> restore bi_endio and bi_private and end the bio with bi_endio.
> 
> This causes underflow of bi_remaining, so we must restore bi_remaining
> before ending the bio from the target bi_endio routine.
> 
> The code uses atomic_inc for restoration of bi_remaining. This patch
> changes it to atomic_set(1) to avoid an interlocked instruction. In the
> target's bi_endio routine we are sure that bi_remaining is zero
> (otherwise, the bi_endio routine wouldn't be called) and there are no
> concurrent users of the bio, so we can replace atomic_inc with
> atomic_set(1).

This isn't DM-specific.  Shouldn't the other places in the tree that use
atomic_inc on bi_remaining should really be converted at the same time?
