Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab3LCFuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 00:50:12 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:54658 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3LCFuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 00:50:09 -0500
X-AuditID: cbfee61b-b7f166d000007a34-25-529d7110caf5
From: Chao Yu <chao2.yu@samsung.com>
To: liuyiyang@hisense.com
Cc: "'fs-devel'" <linux-fsdevel@vger.kernel.org>,
        "'kernel'" <linux-kernel@vger.kernel.org>,
        "'f2fs'" <linux-f2fs-devel@lists.sourceforge.net>,
        "'Jaegeuk Kim'" <jaegeuk.kim@samsung.com>,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: RE: [f2fs-dev] [PATCH 0/2] f2fs: remove debufs dir if
 debugfs_create_file() failed
Date: Tue, 03 Dec 2013 13:49:05 +0800
Message-id: <001001ceefeb$86ebb3b0$94c31b10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7v1Gh70QJuFxRcT8u6LRjewLuCVg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t9jAV2BwrlBBpv/8Flc3/WXyeLSIneL
	PXtPslhc3jWHzWL/2zYmi9aF55kd2Dw2vV/E6rF7wWcmj74tqxg9Pm+SC2CJ4rJJSc3JLEst
	0rdL4MrY+4y94IxIxf7Feg2MRwS6GDk5JARMJI7ebmODsMUkLtxbD2RzcQgJLGKUWPVkDROE
	84NRouXdJnaQKjYBFYnlHf+ZQGwRAUmJ07OuMIMUMQs8Y5TY0LiVESQhLBArceLTarAGFgFV
	iR9bl4Gt4BWwlLj9cyUrhC0o8WPyPRYQm1lAQ6J/0QY2CFteYvOat8wQJylI7Dj7mhFimZ7E
	6htTmSBqxCU2HrnFMoFRYBaSUbOQjJqFZNQsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl
	5+duYgSH+TPpHYyrGiwOMQpwMCrx8D7YPidIiDWxrLgy9xCjBAezkgjv/PS5QUK8KYmVValF
	+fFFpTmpxYcYpTlYlMR5D7ZaBwoJpCeWpGanphakFsFkmTg4pRoYbeMr8jcyaW+YfE6RLdPw
	x1T+bq9tot8uT9Z4GRQy/VBIhOIRzZdf63zmXEvSXX598eHZyXkGHD2X7zKJup16t9P1SbuV
	WvPLxeoJ8TU7nq07qeEmzZwstD63pd3zyG+BWaprv/e+UbBrFMnxFz7iGcx7a1MVO3vBoczE
	/Skb7j1pFtn7XztPiaU4I9FQi7moOBEAFcV1928CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liu,

You're right, we should release it instead of holding the resource
with no use. And here are some comments as following.

BTW, your patch is out of format. You'd better not let remote
terminal or editor to instead tab with blanks in the patch.

Thanks,
Yu

> -----Original Message-----
> From: Younger Liu [mailto:younger.liucn@gmail.com]
> Sent: Monday, December 02, 2013 9:16 PM
> To: Jaegeuk Kim
> Cc: fs-devel; kernel; f2fs
> Subject: [f2fs-dev] [PATCH 0/2] f2fs: remove debufs dir if debugfs_create_file() failed
> 
> From: Younger Liu <liuyiyang@hisense.com>
> 
> When debugfs_create_file() failed in f2fs_create_root_stats(),
> debugfs_root should be removed.
> 
> Signed-off-by: Younger Liu <liuyiyang@hisense.com>
> Cc: Younger Liu <younger.liucn@gmail.com>
> Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> ---
>  fs/f2fs/debug.c |   20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
> index a84b0a8..d27b689 100644
> --- a/fs/f2fs/debug.c
> +++ b/fs/f2fs/debug.c
> @@ -340,10 +340,24 @@ void f2fs_destroy_stats(struct f2fs_sb_info *sbi)
> 
>  void __init f2fs_create_root_stats(void)
>  {
> +    struct dentry *file;
> +
>      debugfs_root = debugfs_create_dir("f2fs", NULL);
> -    if (debugfs_root)
> -        debugfs_create_file("status", S_IRUGO, debugfs_root,
> -                     NULL, &stat_fops);
> +    if (!debugfs_root)
> +        goto bail;
> +
> +    file = debugfs_create_file("status", S_IRUGO,
> +            debugfs_root, NULL, &stat_fops);
> +    if (!file)
> +        goto free_debugfs_dir;
> +
> +    return;
> +
> +free_debugfs_dir:
> +    debugfs_remove(debugfs_root);

debugfs_root = NULL;

> +
> +bail:
> +    return;
>  }
> 
>  void f2fs_destroy_root_stats(void)

You should judge debugfs_root value in f2fs_destroy_root_stats
to decide free or not.

> --
> 1.7.9.5
> 
> 
> 
> ------------------------------------------------------------------------------
> Rapidly troubleshoot problems before they affect your business. Most IT
> organizations don't have a clear picture of how application performance
> affects their revenue. With AppDynamics, you get 100% visibility into your
> Java,.NET, & PHP application. Start your 15-day FREE TRIAL of AppDynamics Pro!
> http://pubads.g.doubleclick.net/gampad/clk?id=84349351&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

