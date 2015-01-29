Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbbA2MRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 07:17:35 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:25442 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbbA2MRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 07:17:33 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-5e-54ca24d68be7
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <1422401503-4769-1-git-send-email-jaegeuk@kernel.org>
 <1422401503-4769-4-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1422401503-4769-4-git-send-email-jaegeuk@kernel.org>
Subject: RE: [PATCH 4/5] f2fs: should fail mount when trying to recover data on
 read-only dev
Date: Thu, 29 Jan 2015 20:16:38 +0800
Message-id: <002d01d03bbd$8b533c10$a1f9b430$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKDs63B3JtDSVeEmIqjDxgyUQN23AIvNw77m16YisA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jQd1rKqdCDBoeylg8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlfHg9XHmgiV8FW/v
	TGVsYNzN3cXIySEhYCLR3tPNBmGLSVy4tx7I5uIQEpjOKLH98U5GkISQwA9GiZ73GiA2m4CK
	xPKO/0wgRSICvYwSP870M3cxcgAVVUrMXGgAUsMp4CSx+tYDZhBbWCBeYve8B2ALWARUJboO
	TGECKecVsJR4+tcZJMwrICjxY/I9FhCbWUBLYv3O40wQtrzE5jVvmSFuU5DYcfY12DkiAlYS
	fTf/QdWIS2w8cotlAqPgLCSjZiEZNQvJqFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vO
	z93ECA7vZ9I7GFc1WBxiFOBgVOLhTWg8GSLEmlhWXJl7iFGCg1lJhLdQ6VSIEG9KYmVValF+
	fFFpTmrxIUZpDhYlcV4l+7YQIYH0xJLU7NTUgtQimCwTB6dUA6NE+esu8evOYjlX/LckC12+
	kda6TyHBtp5psdDTBt4Hope4fAxVTY82sTcwT9uR893jyfX7q843lzBJzapaLrlA5VeowZKb
	0vbKB5xKXxk47Mncx6JWc/APo8yr1a9Pzk0z2DFLek/6+pSM6O+rU9qFv9/aEr1+/ueSHe/f
	TD9YEP/gSZVU4RklluKMREMt5qLiRABujBBdawIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: linux-fsdevel-owner@vger.kernel.org [mailto:linux-fsdevel-owner@vger.kernel.org] On
> Behalf Of Jaegeuk Kim
> Sent: Wednesday, January 28, 2015 7:32 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [PATCH 4/5] f2fs: should fail mount when trying to recover data on read-only dev
> 
> If device is read-only, we should not proceed data recovery.
> But, if the previous checkpoint was done by normal clean shutdown, it's safe to
> proceed the recovery, since there will be no data to be recovered.

Now, with 'fastboot' option, f2fs will write cp with CP_UMOUNT_FLAG, but we count not
guarantee there is no abnormally power cut after data fsynced.

Thanks,

> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/super.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index 0ca1fb2..7039969 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -1149,6 +1149,15 @@ try_onemore:
> 
>  	/* recover fsynced data */
>  	if (!test_opt(sbi, DISABLE_ROLL_FORWARD)) {
> +		/*
> +		 * mount should be failed, when device has readonly mode, and
> +		 * previous checkpoint was not done by clean system shutdown.
> +		 */
> +		if (bdev_read_only(sb->s_bdev) &&
> +				!is_set_ckpt_flags(sbi->ckpt, CP_UMOUNT_FLAG)) {
> +			err = -EROFS;
> +			goto free_kobj;
> +		}
>  		err = recover_fsync_data(sbi);
>  		if (err) {
>  			f2fs_msg(sb, KERN_ERR,
> --
> 2.1.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

