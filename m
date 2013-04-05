Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161144Ab3DEBxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:53:37 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:36934 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161131Ab3DEBxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:53:35 -0400
Date: Fri, 5 Apr 2013 09:53:27 +0800
From: Shaohua Li <shli@kernel.org>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, slava@dubeyko.com
Subject: Re: mkfs.f2fs gets stuck with "blk_update_request: bio idx 0 >= vcnt
 0" on 3.8
Message-ID: <20130405015327.GA319@kernel.org>
References: <CAMo8BfLusS_vT4LWU93iCXpVSgN_Uvi1mBvLUVx+892V67X1JQ@mail.gmail.com>
 <254789F5-7950-4239-AB7B-2DB9DC73565F@dubeyko.com>
 <5159EC3D.2020501@gmail.com>
 <1364884045.3301.18.camel@slavad-ubuntu>
 <CAMo8Bf+83t3ML_Ctr4V-pVL7Meei=pdOeC5cgtrPJB12tOcGtA@mail.gmail.com>
 <CAMo8BfKgTPO6AJng6zo1my4K_PivC1gJFQmcvy8q=iDYWSO2Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMo8BfKgTPO6AJng6zo1my4K_PivC1gJFQmcvy8q=iDYWSO2Pw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 06:00:18AM +0400, Max Filippov wrote:
> Hi,
> 
> On Tue, Apr 2, 2013 at 7:41 PM, Max Filippov <jcmvbkbc@gmail.com> wrote:
> > I'm trying to create f2fs filesystem on SD card on pandaboard using
> > f2fs-tools v1.0.0.
> > It works fine on Linus' v3.6, but fails on both v3.8 and stable v3.8.5:
> >
> > # mkfs.f2fs /dev/mmcblk0p3
> > Info: sector size = 512
> > Info: total sectors = 11370496 (in 512bytes)
> > Info: zone aligned segment0 blkaddr: 512
> > [  257.789764] blk_update_request: bio idx 0 >= vcnt 0
> >
> > mkfs process gets stuck in D state and I see the following in the dmesg:
> >
> > [  257.789733] __end_that: dev mmcblk0: type=1, flags=122c8081
> > [  257.789764]   sector 4194304, nr/cnr 2981888/4294959104
> > [  257.789764]   bio df3840c0, biotail df3848c0, buffer   (null), len 1526726656
> > [  257.789764] blk_update_request: bio idx 0 >= vcnt 0
> > [  257.794921] request botched: dev mmcblk0: type=1, flags=122c8081
> > [  257.794921]   sector 4194304, nr/cnr 2981888/4294959104
> > [  257.794921]   bio df3840c0, biotail df3848c0, buffer   (null), len 1526726656
> 
> [...]
> 
> >> So, I think that it needs to investigate issue in the direction of
> >> BLKDISCARD code on the kernel side. It makes sense to debug
> >> f2fs_trim_device() method of mkfs.f2fs utility too. But I can't see
> >> anything strange in this function at a glance.
> >
> > Ok, I'll try to find what has changed in that ioctl handler since 3.6.
> 
> the commit 0cfbcafcae8b7364b5fa96c2b26ccde7a3a296a9 'block: add plug
> for blkdev_issue_discard'
> have added merge opportunity for DISCARD requests. When I do
> mkfs.f2fs on a 5G partition (0xad8000 sectors) it submits two bios,
> one for 0x7fe000 sectors (0xffc00000 bytes) and another for
> 0x2da000 sectors (0x5b400000 bytes). Prior to that commit these
> bios weren't merged into one request. Now the second bio gets
> merged with the first, but the request's __data_len field is unsigned int
> and it gets wrapped to 0x5b000000 bytes instead of 0x15b000000
> in the bio_attempt_back_merge. Later this reduced size is passed to
> the blk_update_request causing KERN_ERR and not completed
> request. Reverting this commit fixes mkfs.f2fs for me.

A workaround is setting limits.max_discard_sectors to a smaller value.

So the question is why __data_len isn't sector based? Since disk is sector
based, is there any disk finishing IO in byte granularity? Maybe Jens can
answer.

Thanks,
Shaohua
