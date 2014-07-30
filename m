Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaG3NAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:00:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32203 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbaG3NAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:00:44 -0400
X-AuditID: cbfee61b-f79f86d00000144c-9c-53d8ec7a1a1c
From: Chao Yu <chao2.yu@samsung.com>
To: dh.sim@samsung.com, jaegeuk@kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <31343962.57441406703161454.JavaMail.weblogic@epml04>
In-reply-to: <31343962.57441406703161454.JavaMail.weblogic@epml04>
Subject: RE: [f2fs-dev] [PATCH v2] f2fs: remove redundant lines in
	allocate_data_block
Date: Wed, 30 Jul 2014 20:59:36 +0800
Message-id: <00f501cfabf6$439f94b0$cadebe10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: zh-cn
Thread-index: AQLn4ek39UJ2R6uoZrPVdx/Uc0/Mt5mIKClg
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t9jQd2qNzeCDW581bVY/M3a4sn6WcwW
	lxa5W+zZe5LF4vKuOWwOrB6bVnWyeexe8JnJo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDLm
	vpzEVDBBquJv6wbWBsbVol2MnBwSAiYSPb/esUHYYhIX7q0Hsrk4hASmM0psnLYAyvnBKHHo
	zxtmkCo2ARWJ5R3/mUBsEQEtibvz7rKC2MwCmRJzXk8Gs4UEHCUe/DwDVsMp4CSx4PAMdhBb
	WCBC4nHvNrA4i4CqxMXXH4DiHBy8ApYSD+/wg4R5BQQlfky+xwIxUkti/c7jTBC2vMTmNW+Z
	IQ5VkNhx9jUjRFxcYuORWywQ5xhJtF2cxTaBUWgWklGzkIyahWTULCTtCxhZVjGKphYkFxQn
	peca6RUn5haX5qXrJefnbmIEx8Iz6R2MqxosDjEKcDAq8fDO+H89WIg1say4MvcQowQHs5II
	b+PTG8FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+2WgcKCaQnlqRmp6YWpBbBZJk4OKUaGFlv
	nDrxtO2azvacl7O3uPQ771ztt8P4fHqV123eD6xffh+9ya+XM+Hx7qd8qgd9Vfvm5s2Ol/9+
	cX9uY+zbd2c701IWm/raHJc1yF6UYXLM9Oq0l4lbNlt75x/KvfHuj+uKxUst36z/dNCa68ii
	gyVNNS8viUZNOFoySWvTW7EpQooR3r0njx9RYinOSDTUYi4qTgQA3/ciOIECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Dongho Sim [mailto:dh.sim@samsung.com]
> Sent: Wednesday, July 30, 2014 2:53 PM
> To: jaegeuk@kernel.org
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Subject: [f2fs-dev] [PATCH v2] f2fs: remove redundant lines in allocate_data_block
> 
> There are redundant lines in allocate_data_block.
> 
> In this function, we call refresh_sit_entry with old seg and old curseg.
> After that, we call locate_dirty_segment with old curseg.
> 
> But, the new address is always allocated from old curseg and
> we call locate_dirty_segment with old curseg in refresh_sit_entry.
> So, we do not need to call locate_dirty_segment with old curseg again.
> 
> We've discussed like below:
> 
> Jaegeuk said:
>  "When considering SSR, we need to take care of the following scenario.
>   - old segno : X
>   - new address : Z
>   - old curseg : Y
>   This means, a new block is supposed to be written to Z from X.
>   And Z is newly allocated in the same path from Y.
> 
>   In that case, we should trigger locate_dirty_segment for Y, since
>   it was a current_segment and can be dirty owing to SSR.
>   But that was not included in the dirty list."
> 
> Changman said:
>  "We already choosed old curseg(Y) and then we allocate new address(Z) from old
>   curseg(Y). After that we call refresh_sit_entry(old address, new address).
>   In the funcation, we call locate_dirty_segment with old seg and old curseg.
>   So calling locate_dirty_segment after refresh_sit_entry again is redundant."
> 
> Jaegeuk said:
>  "Right. The new address is always allocated from old_curseg."
> 
> Signed-off-by: Dongho Sim <dh.sim@samsung.com>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> ---
>  fs/f2fs/segment.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index 8a6e57d..7af4a8d 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -973,14 +973,12 @@ void allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
>  {
>  	struct sit_info *sit_i = SIT_I(sbi);
>  	struct curseg_info *curseg;
> -	unsigned int old_cursegno;
> 
>  	curseg = CURSEG_I(sbi, type);
> 
>  	mutex_lock(&curseg->curseg_mutex);
> 
>  	*new_blkaddr = NEXT_FREE_BLKADDR(sbi, curseg);
> -	old_cursegno = curseg->segno;
> 
>  	/*
>  	 * __add_sum_entry should be resided under the curseg_mutex
> @@ -1001,7 +999,6 @@ void allocate_data_block(struct f2fs_sb_info *sbi, struct page *page,
>  	 * since SSR needs latest valid block information.
>  	 */
>  	refresh_sit_entry(sbi, old_blkaddr, *new_blkaddr);
> -	locate_dirty_segment(sbi, old_cursegno);
> 
>  	mutex_unlock(&sit_i->sentry_lock);
> 
> --
> 1.9.1
> 
> ------------------------------------------------------------------------------
> Infragistics Professional
> Build stunning WinForms apps today!
> Reboot your WinForms applications with our WinForms controls.
> Build a bridge from your legacy apps to the future.
> http://pubads.g.doubleclick.net/gampad/clk?id=153845071&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

