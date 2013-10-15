Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327Ab3JORTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:19:40 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:54418 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759478Ab3JORTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:19:39 -0400
Date: Tue, 15 Oct 2013 10:19:20 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Weijie Yang <weijie.yang.kh@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Shaohua Li <shli@fusionio.com>, Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH] swap: fix setting PAGE_SIZE blocksize during swapoff/swapon
 race
In-Reply-To: <1381836170.18389.13.camel@AMDC1943>
Message-ID: <alpine.LNX.2.00.1310150950100.12358@eggly.anvils>
References: <1381759136-8616-1-git-send-email-k.kozlowski@samsung.com> <alpine.LNX.2.00.1310150257030.6194@eggly.anvils> <1381836170.18389.13.camel@AMDC1943>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013, Krzysztof Kozlowski wrote:
> On Tue, 2013-10-15 at 02:59 -0700, Hugh Dickins wrote:
> > On Mon, 14 Oct 2013, Krzysztof Kozlowski wrote:
> > 
> > > Fix race between swapoff and swapon resulting in setting blocksize of
> > > PAGE_SIZE for block devices during swapoff.
> > > 
> > > The swapon modifies swap_info->old_block_size before acquiring
> > > swapon_mutex. It reads block_size of bdev, stores it under
> > > swap_info->old_block_size and sets new block_size to PAGE_SIZE.
> > > 
> > > On the other hand the swapoff sets the device's block_size to
> > > old_block_size after releasing swapon_mutex.
> > > 
> > > This patch locks the swapon_mutex much earlier during swapon. It also
> > > releases the swapon_mutex later during swapoff.
> > > 
> > > The effect of race can be triggered by following scenario:
> > >  - One block swap device with block size of 512
> > >  - thread 1: Swapon is called, swap is activated,
> > >    p->old_block_size = block_size(p->bdev); /512/
> > >    block_size(p->bdev) = PAGE_SIZE;
> > >    Thread ends.
> > > 
> > >  - thread 2: Swapoff is called and it goes just after releasing the
> > >    swapon_mutex. The swap is now fully disabled except of setting the
> > >    block size to old value. The p->bdev->block_size is still equal to
> > >    PAGE_SIZE.
> > > 
> > >  - thread 3: New swapon is called. This swap is disabled so without
> > >    acquiring the swapon_mutex:
> > >    - p->old_block_size = block_size(p->bdev); /PAGE_SIZE (!!!)/
> > >    - block_size(p->bdev) = PAGE_SIZE;
> > >    Swap is activated and thread ends.
> > > 
> > >  - thread 2: resumes work and sets blocksize to old value:
> > >    - set_blocksize(bdev, p->old_block_size)
> > >    But now the p->old_block_size is equal to PAGE_SIZE.
> > > 
> > > The patch swap-fix-set_blocksize-race-during-swapon-swapoff does not fix
> > > this particular issue. It reduces the possibility of races as the swapon
> > > must overwrite p->old_block_size before acquiring swapon_mutex in
> > > swapoff.
> > > 
> > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > 
> > Sorry you're being blown back and forth on this, but I say Nack to
> > this version.  I've not spent the time to check whether it ends up
> > correct or not; but your original patch was appropriate to the bug,
> > and this one is just unnecessary churn in my view.
> 
> Hi,
> 
> I still think my previous patch does not solve the issue entirely.
> The call set_blocksize() in swapoff quite often sets PAGE_SIZE instead
> of valid block size (e.g. 512). I trigger this with:

PAGE_SIZE and 512 are equally valid block sizes,
it's just hard to support both consistently at the same instant.

> ------
> for i in `seq 1000`
> do
> 	swapoff /dev/sdc1 &
> 	swapon /dev/sdc1 &
> 	swapon /dev/sdc1 &
> done
> ------
> 10 seconds run of this script resulted in 50% of set_blocksize(PAGE_SIZE).
> Although effect can only be observed after adding printks (block device is
> released).

But despite PAGE_SIZE being a valid block size,
I agree that it's odd if you see variation there.

Here's my guess: it looks as if the p->bdev test is inadequate, in the
decision whether bad_swap should set_blocksize() or not: p->bdev is not
usually reset when a swap_info_struct is released for reuse.

Please try correcting that, either by resetting p->bdev where necessary,
or by putting a better test in bad_swap: see if that fixes this oddity.

I still much prefer your original little patch,
to this extension of the use of swapon_mutex.

However, a bigger question would be, why does swapoff have to set block
size back to old_block_size anyway?  That was introduced in 2.5.13 by

<viro@math.psu.edu> (02/05/01 1.447.69.1)
	[PATCH] (1/6) blksize_size[] removal
	
	 - preliminary cleanups: make sure that swapoff restores original block
	   size, kill set_blocksize() (and use of __bread()) in multipath.c,
	   reorder opening device and finding its block size in mtdblock.c.

Al, not an urgent question, but is this swapoff old_block_size stuff
still necessary?  And can't swapon just use whatever bd_block_size is
already in force?  IIUC, it plays no part beyond the initial readpage
of swap header.

Thanks,
Hugh
