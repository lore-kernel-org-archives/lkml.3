Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596AbaLEDnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 22:43:11 -0500
Received: from mail-by2on0112.outbound.protection.outlook.com ([207.46.100.112]:60607
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932863AbaLEDnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 22:43:10 -0500
X-Greylist: delayed 942 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Dec 2014 22:43:09 EST
Date: Fri, 5 Dec 2014 10:54:29 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Jan Kara <jack@suse.cz>
CC: Dong Aisheng <dongas86@gmail.com>, <tj@kernel.org>,
        <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.or>,
        <r64343@freescale.com>
Subject: Re: WARNING: at fs/fs-writeback.c when plug out SD card after
 system suspend/resume
Message-ID: <20141205025416.GA16771@shlinux1.ap.freescale.net>
References: <CAA+hA=R2x5dUkZAh9=nHLsmaqA5YiAjEya-vQnjLx6i7fruV1w@mail.gmail.com>
 <20141204124139.GC8569@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141204124139.GC8569@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(51704005)(69234005)(53754006)(377424004)(24454002)(199003)(51914003)(189002)(50466002)(23726002)(110136001)(87936001)(6806004)(77096005)(46102003)(68736005)(19580395003)(4396001)(83506001)(106466001)(19580405001)(62966003)(105606002)(84676001)(97756001)(77156002)(46406003)(104016003)(120916001)(99396003)(92566001)(575784001)(21056001)(50986999)(47776003)(20776003)(64706001)(97736003)(33656002)(54356999)(31966008)(76176999)(107046002)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1211;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1211;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:CY1PR0301MB1211;
X-Forefront-PRVS: 04163EF38A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Aisheng.Dong@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1211;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 01:41:39PM +0100, Jan Kara wrote:
> On Thu 04-12-14 11:43:17, Dong Aisheng wrote:
> > Hi ALL,
> > 
> > We met an filesystem issue when do stable kernel upgrade from 3.10.31 to
> > 3.10.53. And we found it's caused by the following commit bf0972039 which
> > introduced in 3.10.53.
> > After applying this patch, after system suspend/resume, plug out a SD card
> > will cause the following WARNING if SD card has a filesystem mounted.
> > If revert it, no such WARNING shows.
> > 
> > I also tried the latest linux-next tree, it also has such issue.
> > 
> > Looks the patch is used to fixing a potential system crashing.
> > We're not sure whether this WARNING is as expected and reasonable
> > or a BUG because there's no such WARNING before this patch.
> > 
> > Can someone explain about it?
>   The warning happens because bdi disappeared from under filesystem (likely
> it was even freed) but filesystem still has references to it. Previously,
> we were just silenly using freed memory, now we warn about it because we
> now clear the BDI_registered bit before freeing the bdi.
> 
> So for now the best advice I can give you is: Don't remove device from
> under mounted filesystem (even when the system is suspended). I may easily
> crash your machine.
> 
> We should fix bdi lifetime issues by making bdi live as long as the
> filesystem on top of it but someone has to find time to do that...
> 

Thanks for the explanation.
BTW, FYI, it seems ext4 and vfat do not have such WARNING after a few
simple tests, looks like it just happens on ext3.

Regards
Dong Aisheng

> 								Honza
> 
> > Reproduce step is as follows:
> > root@imx6qdlsolo:~# mmc2: mmc_rescan_try_freq: trying to init card at 400000 Hz
> > mmc2: Problem setting current limit!
> > mmc2: new ultra high speed DDR50 SDHC card at address aaaa
> > mmcblk2: mmc2:aaaa SL32G 29.7 GiB
> >  mmcblk2: p1 p2
> > wm8962 3-001a: Failed to get supply 'DCVDD': -517
> > wm8962 3-001a: Failed to request supplies: -517
> > i2c 3-001a: Driver wm8962 requests probe deferral
> > kjournald starting.  Commit interval 5 seconds
> > EXT3-fs (mmcblk2p2): using internal journal
> > EXT3-fs (mmcblk2p2): recovery complete
> > EXT3-fs (mmcblk2p2): mounted filesystem with ordered data mode
> > FAT-fs (mmcblk2p1): Volume was not properly unmounted. Some data may
> > be corrupt. Please run fsck.
> > 
> > root@imx6qdlsolo:~#
> > root@imx6qdlsolo:~# echo mem > /sys/power/state
> > PM: Syncing filesystems ... done.
> > Freezing user space processes ... (elapsed 0.01 seconds) done.
> > Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> > Suspending console(s) (use no_console_suspend to debug)
> > PM: suspend of devices complete after 45.436 msecs
> > PM: suspend devices took 0.050 seconds
> > PM: late suspend of devices complete after 0.599 msecs
> > PM: noirq suspend of devices complete after 0.704 msecs
> > Disabling non-boot CPUs ...
> > Turn off M/F mix!
> > PM: noirq resume of devices complete after 0.380 msecs
> > PM: early resume of devices complete after 0.498 msecs
> > imx-sdma 20ec000.sdma: loaded firmware 1.1
> > mmc2: Problem setting current limit!
> > PM: resume of devices complete after 409.704 msecs
> > PM: resume devices took 0.410 seconds
> > Restarting tasks ... done.
> > root@imx6qdlsolo:~#
> > root@imx6qdlsolo:~# libphy: 2188000.ethernet:01 - Link is Up - 100/Full
> > mmc2: card aaaa removed
> > ------------[ cut here ]------------
> > WARNING: at fs/fs-writeback.c:1196 __mark_inode_dirty+0x1d0/0x1d4()
> > bdi-block not registered
> > Modules linked in:
> > CPU: 0 PID: 927 Comm: umount Not tainted 3.10.53-02602-g89aa41e #751
> > [<80013b00>] (unwind_backtrace+0x0/0xf4) from [<80011524>]
> > (show_stack+0x10/0x14)
> > [<80011524>] (show_stack+0x10/0x14) from [<8002c290>]
> > (warn_slowpath_common+0x54/0x6c)
> > [<8002c290>] (warn_slowpath_common+0x54/0x6c) from [<8002c2d8>]
> > (warn_slowpath_fmt+0x30/0x40)
> > [<8002c2d8>] (warn_slowpath_fmt+0x30/0x40) from [<800e8bbc>]
> > (__mark_inode_dirty+0x1d0/0x1d4)
> > [<800e8bbc>] (__mark_inode_dirty+0x1d0/0x1d4) from [<80131ba8>]
> > (ext3_put_super+0x20c/0x23c)
> > [<80131ba8>] (ext3_put_super+0x20c/0x23c) from [<800c88e0>]
> > (generic_shutdown_super+0x58/0xc4)
> > [<800c88e0>] (generic_shutdown_super+0x58/0xc4) from [<800c8b14>]
> > (kill_block_super+0x18/0x68)
> > [<800c8b14>] (kill_block_super+0x18/0x68) from [<800c8e60>]
> > (deactivate_locked_super+0x48/0x64)
> > [<800c8e60>] (deactivate_locked_super+0x48/0x64) from [<800e271c>]
> > (SyS_umount+0x94/0x38c)
> > [<800e271c>] (SyS_umount+0x94/0x38c) from [<8000e080>]
> > (ret_fast_syscall+0x0/0x30)
> > ---[ end trace a52c980ef229d9da ]---
> > EXT3-fs (mmcblk2p2): I/O error while writing superblock
> > 
> > Caused by following commit:
> > commit bf0972039ddc483a9cb79edae73076c635876568
> > Author: Jan Kara <jack@suse.cz>
> > Date:   Thu Apr 3 14:46:23 2014 -0700
> > 
> >     bdi: avoid oops on device removal
> > 
> >     commit 5acda9d12dcf1ad0d9a5a2a7c646de3472fa7555 upstream.
> > 
> >     After commit 839a8e8660b6 ("writeback: replace custom worker pool
> >     implementation with unbound workqueue") when device is removed while we
> >     are writing to it we crash in bdi_writeback_workfn() ->
> >     set_worker_desc() because bdi->dev is NULL.
> > 
> >     This can happen because even though bdi_unregister() cancels all pending
> >     flushing work, nothing really prevents new ones from being queued from
> >     balance_dirty_pages() or other places.
> > 
> >     Fix the problem by clearing BDI_registered bit in bdi_unregister() and
> >     checking it before scheduling of any flushing work.
> > 
> >     Fixes: 839a8e8660b6777e7fe4e80af1a048aebe2b5977
> > 
> >     Reviewed-by: Tejun Heo <tj@kernel.org>
> >     Signed-off-by: Jan Kara <jack@suse.cz>
> >     Cc: Derek Basehore <dbasehore@chromium.org>
> >     Cc: Jens Axboe <axboe@kernel.dk>
> >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > Regards
> > Dong Aisheng
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
