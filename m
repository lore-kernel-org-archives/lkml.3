Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab3HEI0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:26:22 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:45218 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab3HEI0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:26:20 -0400
X-AuditID: 9c93017e-b7b62ae000000eeb-86-51ff61aa0dcd
Date: Mon, 5 Aug 2013 17:27:00 +0900
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jiang Liu <jiang.liu@huawei.com>,
        Nitin Gupta <ngupta@vflare.org>, stable@vger.kernel.org
Subject: Re: [PATCH] zram: bug fix: delay lock holding in zram_slot_free_noity
Message-ID: <20130805082700.GP32486@bbox>
References: <1375687114-4001-1-git-send-email-minchan@kernel.org>
 <20130805080422.GB15376@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805080422.GB15376@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

On Mon, Aug 05, 2013 at 04:04:22PM +0800, Greg Kroah-Hartman wrote:
> On Mon, Aug 05, 2013 at 04:18:34PM +0900, Minchan Kim wrote:
> > I was preparing to promote zram and it was almost done.
> > Before sending patch, I tried to test and eyebrows went up.
> > 
> > [1] introduced down_write in zram_slot_free_notify to prevent race
> > between zram_slot_free_notify and zram_bvec_[read|write]. The race
> > could happen if somebody who has right permission to open swap device
> > is reading swap device while it is used by swap in parallel.
> > 
> > However, zram_slot_free_notify is called with holding spin_lock of
> > swap layer so we shouldn't avoid holing mutex. Otherwise, lockdep
> > warns it.
> 
> As it should.

It's okay to call down_write_trylock instead of down_write under spinlock.
Is there any problem? Might need to rewrite description?

> 
> > I guess, best solution is to redesign zram lock scheme totally but
> > we are on the verge of promoting so it's not desirable to change a lot
> > critical code and such big change isn't good shape for backporting to
> > stable trees so I think the simple patch is best at the moment.
> 
> What do you mean by "verge of promoting"?  If it's wrong, it needs to be
> fixed properly, don't paper over something.

It seems you consider the patch as bandaid due to rather misleading my
description. I didn't mean it. I guess ideal solution would be to change
locking scheme totally to enhance concurrency but others might think it's
rather overkill because we don't see any reports about such parallel workloads
to make coarse-grained lock trouble. So, I think below simple patch looks
reasonable to me. Let's wait other zram developers's opinons.

> 
> Please fix this correctly, I really don't care about staging drivers in
> stable kernels as lots of distros refuse to enable them (and rightly
> so.)

It might be a huge so early decision is rather hurry.
Let's wait others's opition.
Nitin, could you post your opinion?

> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
