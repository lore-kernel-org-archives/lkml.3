Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbbAJK4l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 05:56:41 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34477 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbbAJK4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 05:56:39 -0500
Date: Sat, 10 Jan 2015 02:56:35 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: zhangxingcai <zhangxingcai@huawei.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, fengfuqiu@huawei.com,
        tanhaijun@huawei.com, Adrian McMenamin <adrian@mcmen.demon.co.uk>
Subject: Re: [PATCH 3/3] [PATCH] mtd: fix concurrent access to mtd->usecount
Message-ID: <20150110105635.GD5999@norris-Latitude-E6410>
References: <1417008990-24413-1-git-send-email-zhangxingcai@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417008990-24413-1-git-send-email-zhangxingcai@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 09:36:30PM +0800, zhangxingcai wrote:
> __get_mtd_device() is called to increment mtd->usecount when we access
> mtd via /dev/mtd1 or /dev/mtdblock1, but mtd_table_mutex lock is used in the former
> via get_mtd_device(), while &dev->lock lock is used in the latter.  Therefore mtd->usecount is
> not properly protected if we access /dev/mtd1 and /dev/mtdblock1 at the same time.
> 
> call graph as follows:
> /dev/mtd1 --> mtdchar_open() --> get_mtd_device() --> <hold mtd_table_mutex> --> __get_mtd_device() --> <increment mtd->usecount>
> /dev/mtdblock1 --> blktrans_open() --><hold &dev->lock> --> __get_mtd_device() --> <increment mtd->usecount>
> 
> Actually we triggerd the BUG_ON in put_mtd_device() on 2.6.34 kernel
> due to this race.

Have you retested and seen this on any more recent kernel? The locking
schemes here have changed a bit since then.

> To fix this convert mtd->usecount from int to atomic_t.

Is mtd->usecount the *only* important race in __get_mtd_device() and
__put_mtd_device()? Sometimes a race on a counter just shows that there
are other concurrency issues nearby that would be better served by a
lock. But your fix may be sufficient in this case.

> <0>------------[ cut here ]------------
> <2>kernel BUG at drivers/mtd/mtdcore.c:565!
> Oops: Exception in kernel mode, sig: 5 [#1]
> PREEMPT SMP NR_CPUS=4 LTT NESTING LEVEL : 0
> P2041 RDB
> <0>last sysfs file: /sys/mbe_detect/ecc_mbe_detect
> ...
> NIP [c037a808] put_mtd_device+0x58/0x80
> LR [c037a808] put_mtd_device+0x58/0x80
> Call Trace:
> [ca453e90] [c037a808] put_mtd_device+0x58/0x80 (unreliable)
> [ca453eb0] [c037ced8] mtd_close+0x48/0x70
> [ca453ed0] [c0119078] __fput+0xe8/0x220
> [ca453ef0] [c01144fc] filp_close+0x6c/0xb0
> [ca453f10] [c01145fc] sys_close+0xbc/0x180
> [ca453f40] [c0010ae8] ret_from_syscall+0x0/0x4
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Zhang Xingcai <zhangxingcai@huawei.com>
> ---
>  drivers/mtd/maps/vmu-flash.c |  2 +-
>  drivers/mtd/mtdcore.c        | 12 ++++++------
>  include/linux/mtd/mtd.h      |  2 +-
>  3 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/mtd/maps/vmu-flash.c b/drivers/mtd/maps/vmu-flash.c
> index 6b223cf..0a10779 100644
> --- a/drivers/mtd/maps/vmu-flash.c
> +++ b/drivers/mtd/maps/vmu-flash.c
> @@ -721,7 +721,7 @@ static int vmu_can_unload(struct maple_device *mdev)
>  	card = maple_get_drvdata(mdev);
>  	for (x = 0; x < card->partitions; x++) {
>  		mtd = &((card->mtd)[x]);
> -		if (mtd->usecount > 0)
> +		if (atomic_read(&mtd->usecount) > 0)

Hmm, the use of mtd->usecount here seems kinda wrong. I think this
driver should be implementing mtd->_get_device() and mtd->_put_device()
instead.

>  			return 0;
>  	}
>  	return 1;
> diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
> index 4c61187..95e7cfc 100644
> --- a/drivers/mtd/mtdcore.c
> +++ b/drivers/mtd/mtdcore.c
> @@ -402,7 +402,7 @@ int add_mtd_device(struct mtd_info *mtd)
>  		goto fail_locked;
>  
>  	mtd->index = i;
> -	mtd->usecount = 0;
> +	atomic_set(&mtd->usecount, 0);
>  
>  	/* default value if not set by driver */
>  	if (mtd->bitflip_threshold == 0)
> @@ -492,9 +492,9 @@ int del_mtd_device(struct mtd_info *mtd)
>  	list_for_each_entry(not, &mtd_notifiers, list)
>  		not->remove(mtd);
>  
> -	if (mtd->usecount) {
> +	if (atomic_read(&mtd->usecount)) {

If we're using atomic_read(), wouldn't it make more sense just to read
once and save the result?

>  		printk(KERN_NOTICE "Removing MTD device #%d (%s) with use count %d\n",
> -		       mtd->index, mtd->name, mtd->usecount);
> +		       mtd->index, mtd->name, atomic_read(&mtd->usecount));
>  		ret = -EBUSY;
>  	} else {
>  		device_unregister(&mtd->dev);
> @@ -702,7 +702,7 @@ int __get_mtd_device(struct mtd_info *mtd)
>  			return err;
>  		}
>  	}
> -	mtd->usecount++;
> +	atomic_inc(&mtd->usecount);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(__get_mtd_device);
> @@ -756,8 +756,8 @@ EXPORT_SYMBOL_GPL(put_mtd_device);
>  
>  void __put_mtd_device(struct mtd_info *mtd)
>  {
> -	--mtd->usecount;
> -	BUG_ON(mtd->usecount < 0);
> +	atomic_dec(&mtd->usecount);
> +	BUG_ON(atomic_read(&mtd->usecount) < 0);

Again, two atomic operations in a row don't make a lot of sense. Try
using atomic_dec_return():

	int count = atomic_dec_return(&mtd->usecount);
	
	BUG_ON(count < 0);

>  
>  	if (mtd->_put_device)
>  		mtd->_put_device(mtd);
> diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
> index 031ff3a..af98132 100644
> --- a/include/linux/mtd/mtd.h
> +++ b/include/linux/mtd/mtd.h
> @@ -250,7 +250,7 @@ struct mtd_info {
>  
>  	struct module *owner;
>  	struct device dev;
> -	int usecount;
> +	atomic_t usecount;
>  };
>  
>  int mtd_erase(struct mtd_info *mtd, struct erase_info *instr);

Brian
