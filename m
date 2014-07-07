Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaGGCKf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 22:10:35 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:10397 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752024AbaGGCKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 22:10:34 -0400
X-IronPort-AV: E=Sophos;i="5.00,846,1396972800"; 
   d="scan'208";a="32912112"
Message-ID: <53B9FED5.80009@cn.fujitsu.com>
Date: Mon, 7 Jul 2014 09:58:45 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Chao Yu <chao2.yu@samsung.com>
CC: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>,
        <linux-f2fs-devel@lists.sourceforge.net>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [f2fs-dev][PATCH] f2fs: avoid to access NULL pointer in issue_flush_thread
References: <006001cf9984$6b07f490$4117ddb0$@samsung.com>
In-Reply-To: <006001cf9984$6b07f490$4117ddb0$@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yu,
Thanks for your catch.

Regards,
Gu
On 07/07/2014 09:39 AM, Chao Yu wrote:

> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=75861
> 
> Denis 2014-05-10 11:28:59 UTC reported:
> "F2FS-fs (mmcblk0p28): mounting..
>  Unable to handle kernel NULL pointer dereference at virtual address 00000018
>  ...
>  [<c0a2f678>] (_raw_spin_lock+0x3c/0x70) from [<c03a0330>] (issue_flush_thread+0x50/0x17c)
>  [<c03a0330>] (issue_flush_thread+0x50/0x17c) from [<c01b4064>] (kthread+0x98/0xa4)
>  [<c01b4064>] (kthread+0x98/0xa4) from [<c0108060>] (kernel_thread_exit+0x0/0x8)"
> 
> This patch assign cmd_control_info in sm_info before issue_flush_thread is being
> created, so this make sure that issue flush thread will have no chance to access
> invalid info in fcc.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>

Reviewed-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

> ---
>  fs/f2fs/segment.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index bb5980d..a4f8375 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -272,14 +272,15 @@ int create_flush_cmd_control(struct f2fs_sb_info *sbi)
>  		return -ENOMEM;
>  	spin_lock_init(&fcc->issue_lock);
>  	init_waitqueue_head(&fcc->flush_wait_queue);
> +	sbi->sm_info->cmd_control_info = fcc;
>  	fcc->f2fs_issue_flush = kthread_run(issue_flush_thread, sbi,
>  				"f2fs_flush-%u:%u", MAJOR(dev), MINOR(dev));
>  	if (IS_ERR(fcc->f2fs_issue_flush)) {
>  		err = PTR_ERR(fcc->f2fs_issue_flush);
>  		kfree(fcc);
> +		sbi->sm_info->cmd_control_info = NULL;
>  		return err;
>  	}
> -	sbi->sm_info->cmd_control_info = fcc;
>  
>  	return err;
>  }


