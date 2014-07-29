Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaG2L3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:29:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38171 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbaG2L3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:29:11 -0400
X-AuditID: cbfee61a-f79e46d00000134f-32-53d785848ca9
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
References: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
In-reply-to: <1406328445-63707-1-git-send-email-jaegeuk@kernel.org>
Subject: RE: [f2fs-dev] [PATCH 01/11] f2fs: add nobarrier mount option
Date: Tue, 29 Jul 2014 19:28:16 +0800
Message-id: <007d01cfab20$4d5cbc20$e8163460$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: zh-cn
Thread-index: AQH0/sFA7oYZ7Fd/hcfctysO+ZeFcptrs91g
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9jAd2W1uvBBtd7rSyerJ/FbHFpkbvF
	nr0nWSwu75rD5sDisWlVJ5vH7gWfmTw+b5ILYI7isklJzcksSy3St0vgynix7ThrwVSlim8L
	HrI0MH6S7mLk5JAQMJFYt3UNK4QtJnHh3no2EFtIYBGjxLnOTAj7B6PEvzuCIDabgIrE8o7/
	TCC2iICaRO++KWA2s0CmxIT+F+wQ9U4SBw4tB4tzCjhLrJxzEywuLOAm0XLoNDOIzSKgKrH+
	+1awGl4BS4lD266xQNiCEj8m32OBmKklsX7ncaj58hKb17xlhrhTQWLH2deMEHFxiY1HbrFA
	3GMk8e/wbqYJjEKzkIyahWTULCSjZiFpX8DIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMj
	OOyfSe1gXNlgcYhRgINRiYd3w9xrwUKsiWXFlbmHGCU4mJVEeF+UXw8W4k1JrKxKLcqPLyrN
	SS0+xCjNwaIkznug1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwNi9YSdr34uU3yJsRuE1motC9/Rd
	VMu9nijydcKPLY+iWwq7Ep+EFHTXzlJ7Yh5lJ7zTJXxu1oflYu675s1MPnp09t0bWyK7V2du
	zSqO/j111ZcFD9M5Xl9XnXA+hy/ruOHi+f/tYkp/ss/d+5r5muyBQys/VguoSr+NWtN6msdL
	crvyt1ZX/WQlluKMREMt5qLiRAD8JbsJdwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Saturday, July 26, 2014 6:47 AM
> To: linux-kernel@vger.kernel.org; linux-fsdevel@vger.kernel.org;
> linux-f2fs-devel@lists.sourceforge.net
> Cc: Jaegeuk Kim
> Subject: [f2fs-dev] [PATCH 01/11] f2fs: add nobarrier mount option
> 
> This patch adds a mount option, nobarrier, in f2fs.
> The assumption in here is that file system keeps the IO ordering, but
> doesn't care about cache flushes inside the storages.

Looks good to me.
But it's better to add some description in f2fs document.

> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Chao Yu <chao2.yu@samsung.com>

> ---
>  fs/f2fs/data.c    | 5 ++++-
>  fs/f2fs/f2fs.h    | 1 +
>  fs/f2fs/segment.c | 3 +++
>  fs/f2fs/super.c   | 7 +++++++
>  4 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index c77c667..482313d 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -139,7 +139,10 @@ void f2fs_submit_merged_bio(struct f2fs_sb_info *sbi,
>  	/* change META to META_FLUSH in the checkpoint procedure */
>  	if (type >= META_FLUSH) {
>  		io->fio.type = META_FLUSH;
> -		io->fio.rw = WRITE_FLUSH_FUA | REQ_META | REQ_PRIO;
> +		if (test_opt(sbi, NOBARRIER))
> +			io->fio.rw = WRITE_FLUSH | REQ_META | REQ_PRIO;
> +		else
> +			io->fio.rw = WRITE_FLUSH_FUA | REQ_META | REQ_PRIO;
>  	}
>  	__submit_merged_bio(io);
>  	up_write(&io->io_rwsem);
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 8f507d4..e999eec 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -41,6 +41,7 @@
>  #define F2FS_MOUNT_INLINE_XATTR		0x00000080
>  #define F2FS_MOUNT_INLINE_DATA		0x00000100
>  #define F2FS_MOUNT_FLUSH_MERGE		0x00000200
> +#define F2FS_MOUNT_NOBARRIER		0x00000400
> 
>  #define clear_opt(sbi, option)	(sbi->mount_opt.opt &= ~F2FS_MOUNT_##option)
>  #define set_opt(sbi, option)	(sbi->mount_opt.opt |= F2FS_MOUNT_##option)
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index 8a6e57d..9fce0f47 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -239,6 +239,9 @@ int f2fs_issue_flush(struct f2fs_sb_info *sbi)
>  	struct flush_cmd_control *fcc = SM_I(sbi)->cmd_control_info;
>  	struct flush_cmd cmd;
> 
> +	if (test_opt(sbi, NOBARRIER))
> +		return 0;
> +
>  	if (!test_opt(sbi, FLUSH_MERGE))
>  		return blkdev_issue_flush(sbi->sb->s_bdev, GFP_KERNEL, NULL);
> 
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index 34649aa..eec89a2 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -52,6 +52,7 @@ enum {
>  	Opt_inline_xattr,
>  	Opt_inline_data,
>  	Opt_flush_merge,
> +	Opt_nobarrier,
>  	Opt_err,
>  };
> 
> @@ -69,6 +70,7 @@ static match_table_t f2fs_tokens = {
>  	{Opt_inline_xattr, "inline_xattr"},
>  	{Opt_inline_data, "inline_data"},
>  	{Opt_flush_merge, "flush_merge"},
> +	{Opt_nobarrier, "nobarrier"},
>  	{Opt_err, NULL},
>  };
> 
> @@ -339,6 +341,9 @@ static int parse_options(struct super_block *sb, char *options)
>  		case Opt_flush_merge:
>  			set_opt(sbi, FLUSH_MERGE);
>  			break;
> +		case Opt_nobarrier:
> +			set_opt(sbi, NOBARRIER);
> +			break;
>  		default:
>  			f2fs_msg(sb, KERN_ERR,
>  				"Unrecognized mount option \"%s\" or missing value",
> @@ -544,6 +549,8 @@ static int f2fs_show_options(struct seq_file *seq, struct dentry *root)
>  		seq_puts(seq, ",inline_data");
>  	if (!f2fs_readonly(sbi->sb) && test_opt(sbi, FLUSH_MERGE))
>  		seq_puts(seq, ",flush_merge");
> +	if (!f2fs_readonly(sbi->sb) && test_opt(sbi, NOBARRIER))
> +		seq_puts(seq, ",nobarrier");
>  	seq_printf(seq, ",active_logs=%u", sbi->active_logs);
> 
>  	return 0;
> --
> 1.8.5.2 (Apple Git-48)
> 
> 
> ------------------------------------------------------------------------------
> Want fast and easy access to all the code in your enterprise? Index and
> search up to 200,000 lines of code with a free copy of Black Duck
> Code Sight - the same software that powers the world's largest code
> search on Ohloh, the Black Duck Open Hub! Try it now.
> http://p.sf.net/sfu/bds
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

