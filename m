Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbbA2Lxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:53:42 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:22765 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbbA2Lxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:53:41 -0500
X-AuditID: cbfee61a-f79c06d000004e71-f7-54ca1f425195
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <1422401503-4769-1-git-send-email-jaegeuk@kernel.org>
 <1422401503-4769-2-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1422401503-4769-2-git-send-email-jaegeuk@kernel.org>
Subject: RE: [PATCH 2/5] f2fs: support norecovery mount option
Date: Thu, 29 Jan 2015 19:52:56 +0800
Message-id: <002b01d03bba$37f763a0$a7e62ae0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKDs63B3JtDSVeEmIqjDxgyUQN23AF9mXXTm2QZ25A=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t9jQV0n+VMhBpuP8Vo8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlfFo2RrmgiPCFX2v
	zzM1ML7n72Lk5JAQMJE4M/0tG4QtJnHh3nowW0hgOqPEozeVXYxcQPYPRonjm1awgCTYBFQk
	lnf8ZwJJiAj0Mkr8ONPPDNFRKXHxy1omEJtTwEmid/0txi5GDg5hATuJWy/sQcIsAqoSBxad
	ZwWxeQUsJTqnXGGHsAUlfky+BzafWUBLYv3O40wQtrzE5jVvmSGOU5DYcfY1I4gtImAlcXr5
	BHaIGnGJjUdusUxgFJyFZNQsJKNmIRk1C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5
	mxjBAf5MagfjygaLQ4wCHIxKPLwc9SdDhFgTy4orcw8xSnAwK4nwigmcChHiTUmsrEotyo8v
	Ks1JLT7EKM3BoiTOq2TfFiIkkJ5YkpqdmlqQWgSTZeLglGpgzNLebBkqejPq/+6NrtPKdp69
	UZfHK857viXrlru0SPRipd8yu/5xJBoWWISnHzQVXnmUxZGpV7LYfvuhE7GTe7hnCbc99mb8
	wSJQqtsoK6qlyx2+9pe89m5vx5lzVFjdUsrzzk9xknyw9nnUlbOx8WtWTj2nsXtD45zlSk2T
	REr3NtyW+iykxFKckWioxVxUnAgACz/ISWwCAAA=
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
> Subject: [PATCH 2/5] f2fs: support norecovery mount option
> 
> This patch adds a mount option, norecovery, which is mostly same as
> disable_roll_forward. The only difference is that norecovery should be activated
> with read-only mount option.
> 
> This can be used when user wants to check whether f2fs is mountable or not
> without any recovery process. (e.g., xfstests/200)
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/super.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index fbc7f5a..0ca1fb2 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -42,6 +42,7 @@ static struct kset *f2fs_kset;
>  enum {
>  	Opt_gc_background,
>  	Opt_disable_roll_forward,
> +	Opt_norecovery,
>  	Opt_discard,
>  	Opt_noheap,
>  	Opt_user_xattr,
> @@ -62,6 +63,7 @@ enum {
>  static match_table_t f2fs_tokens = {
>  	{Opt_gc_background, "background_gc=%s"},
>  	{Opt_disable_roll_forward, "disable_roll_forward"},
> +	{Opt_norecovery, "norecovery"},

IMO, it's better to show 'norecovery' in f2fs_show_options instead of showing
'disable_roll_forward', so user will know the details of mount option as we show.

>  	{Opt_discard, "discard"},
>  	{Opt_noheap, "no_heap"},
>  	{Opt_user_xattr, "user_xattr"},
> @@ -287,6 +289,12 @@ static int parse_options(struct super_block *sb, char *options)
>  		case Opt_disable_roll_forward:
>  			set_opt(sbi, DISABLE_ROLL_FORWARD);
>  			break;
> +		case Opt_norecovery:
> +			/* this option mounts f2fs with ro */
> +			set_opt(sbi, DISABLE_ROLL_FORWARD);

set_opt(sbi, NORECOVERY); and check this option before recover_fsync_data()?

It's better to add description for this "norecovery" option in Documentation.

Thanks,

> +			if (!f2fs_readonly(sb))
> +				return -EINVAL;
> +			break;
>  		case Opt_discard:
>  			set_opt(sbi, DISCARD);
>  			break;
> --
> 2.1.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

