Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbaLWHCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 02:02:52 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:64072 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbaLWHCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 02:02:50 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-bb-5499137d0973
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <1419179723-3234-1-git-send-email-jaegeuk@kernel.org>
 <1419179723-3234-6-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1419179723-3234-6-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 6/6] f2fs: avoid double lock for cp_rwsem
Date: Tue, 23 Dec 2014 15:01:36 +0800
Message-id: <003201d01e7e$66126ae0$323740a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQG1NCgn0vPNMcmFarKO/1VZ45E3HgHz1ZrOnMLyYHA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jQd064ZkhBl9vsFg8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlfF40kb2gsUiFYd2
	P2ZvYHwl0MXIySEhYCLx9d0ZVghbTOLCvfVsXYxcHEIC0xkljq+YzQzh/GCU+Lx/EhNIFZuA
	isTyjv9MIAkRgV5GiR9n+plBEkIClRK/7q1iAbE5BZwk7v6ZCzSKg0NYwENiV1cpSJhFQFXi
	57ed7CBhXgFLiXP/wY7gFRCU+DH5Hlgns4CWxPqdx5kgbHmJzWveMkMcpyCx4+xrRpBWEQEr
	iTnPuSFKxCU2HrnFMoFRcBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl
	5+duYgSH9zPpHYyrGiwOMQpwMCrx8C44MyNEiDWxrLgy9xCjBAezkgiveitQiDclsbIqtSg/
	vqg0J7X4EKM0B4uSOK+SfVuIkEB6YklqdmpqQWoRTJaJg1OqgbF1u+ynh2szVnD++28wnb1V
	Leyt0q3/i2YrTvH81R499/Aj+eRgplXH07bM/xH2wnl3TrQ217my/Pu+J/UuzlkT/597gvC9
	Q5lpn5XSc+5Z1ToLM0f/svKPZJ7PqfrsmOy1+nmBZW27e99dEM87sLDT33it3p/nda9WrzLV
	efDj4e9pXlx1cxuVWIozEg21mIuKEwGBmIPbawIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Monday, December 22, 2014 12:35 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 6/6] f2fs: avoid double lock for cp_rwsem
> 
> The __f2fs_add_link is covered by cp_rwsem all the time.
> This calls init_inode_metadata, which conducts some acl operations including
> memory allocation with GFP_KERNEL previously.
> But, under memory pressure, f2fs_write_data_page can be called, which also
> grabs cp_mutex too.

grabs cp_rwsem.

> Basically, it's safe since down_read was used in both of cases, but it'd
> better avoid this situation in advance.

If checkpoint intend to hold down_write in the middle of the two down_read
caller, it will cause a deadlock, so it's not safe.

Could you update the comments?

> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Anyway, Nice catch and please add:

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> ---
>  fs/f2fs/acl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/f2fs/acl.c b/fs/f2fs/acl.c
> index 1ccb26b..7f12d28 100644
> --- a/fs/f2fs/acl.c
> +++ b/fs/f2fs/acl.c
> @@ -62,7 +62,7 @@ static struct posix_acl *f2fs_acl_from_disk(const char *value, size_t size)
>  	if (count == 0)
>  		return NULL;
> 
> -	acl = posix_acl_alloc(count, GFP_KERNEL);
> +	acl = posix_acl_alloc(count, GFP_NOFS);
>  	if (!acl)
>  		return ERR_PTR(-ENOMEM);
> 
> @@ -116,7 +116,7 @@ static void *f2fs_acl_to_disk(const struct posix_acl *acl, size_t *size)
>  	int i;
> 
>  	f2fs_acl = kmalloc(sizeof(struct f2fs_acl_header) + acl->a_count *
> -			sizeof(struct f2fs_acl_entry), GFP_KERNEL);
> +			sizeof(struct f2fs_acl_entry), GFP_NOFS);
>  	if (!f2fs_acl)
>  		return ERR_PTR(-ENOMEM);
> 
> --
> 2.1.1
> 
> 
> ------------------------------------------------------------------------------
> Download BIRT iHub F-Type - The Free Enterprise-Grade BIRT Server
> from Actuate! Instantly Supercharge Your Business Reports and Dashboards
> with Interactivity, Sharing, Native Excel Exports, App Integration & more
> Get technology previously reserved for billion-dollar corporations, FREE
> http://pubads.g.doubleclick.net/gampad/clk?id=164703151&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

