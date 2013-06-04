Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab3FDJDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:03:13 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:45735 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab3FDJDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:03:12 -0400
X-AuditID: 9c93017d-b7c04ae00000207d-b1-51adad4e8669
Date: Tue, 4 Jun 2013 18:03:09 +0900
From: Minchan Kim <minchan@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 2/8] zram: avoid invalid memory access in
 zram_exit()
Message-ID: <20130604090309.GB28551@blaptop>
References: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com>
 <1370274140-26420-3-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370274140-26420-3-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 11:42:14PM +0800, Jiang Liu wrote:
> Memory for zram->disk object may have already been freed after returning
> from destroy_device(zram), then it's unsafe for zram_reset_device(zram)
> to access zram->disk again.
> 
> Fix it by holding an extra reference to zram->disk before calling
> destroy_device(zram).
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> ---
>  drivers/staging/zram/zram_drv.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index e34e3fe..ee6b67d 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -727,8 +727,10 @@ static void __exit zram_exit(void)
>  	for (i = 0; i < num_devices; i++) {
>  		zram = &zram_devices[i];
>  
> +		get_disk(zram->disk);
>  		destroy_device(zram);
>  		zram_reset_device(zram);
> +		put_disk(zram->disk);

Can't we simple reverse calling order of above two functions?

        zram_reset_device(zram);
        destroy_device(zram);

-- 
Kind regards,
Minchan Kim
