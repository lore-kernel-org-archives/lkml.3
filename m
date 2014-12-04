Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbaLDKwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:52:30 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:34693 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbaLDKw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:52:28 -0500
Message-ID: <54803CE7.9090002@codeaurora.org>
Date: Thu, 04 Dec 2014 12:52:23 +0200
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/35] UBI: Add initial support for fastmap self checks
References: <1414586758-9972-1-git-send-email-richard@nod.at> <1414586758-9972-2-git-send-email-richard@nod.at>
In-Reply-To: <1414586758-9972-2-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 2:45 PM, Richard Weinberger wrote:
> Using this debugfs knob fastmap self checks can be controlled.
>

Reviewed-by: Tanya Brokhman <tlinder@codeaurora.org>

> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>   drivers/mtd/ubi/debug.c | 11 +++++++++++
>   drivers/mtd/ubi/debug.h |  5 +++++
>   drivers/mtd/ubi/ubi.h   |  4 ++++
>   3 files changed, 20 insertions(+)
>
> diff --git a/drivers/mtd/ubi/debug.c b/drivers/mtd/ubi/debug.c
> index 63cb1d7..ea9be20 100644
> --- a/drivers/mtd/ubi/debug.c
> +++ b/drivers/mtd/ubi/debug.c
> @@ -275,6 +275,8 @@ static ssize_t dfs_file_read(struct file *file, char __user *user_buf,
>   		val = d->chk_gen;
>   	else if (dent == d->dfs_chk_io)
>   		val = d->chk_io;
> +	else if (dent == d->dfs_chk_fastmap)
> +		val = d->chk_fastmap;
>   	else if (dent == d->dfs_disable_bgt)
>   		val = d->disable_bgt;
>   	else if (dent == d->dfs_emulate_bitflips)
> @@ -336,6 +338,8 @@ static ssize_t dfs_file_write(struct file *file, const char __user *user_buf,
>   		d->chk_gen = val;
>   	else if (dent == d->dfs_chk_io)
>   		d->chk_io = val;
> +	else if (dent == d->dfs_chk_fastmap)
> +		d->chk_fastmap = val;
>   	else if (dent == d->dfs_disable_bgt)
>   		d->disable_bgt = val;
>   	else if (dent == d->dfs_emulate_bitflips)
> @@ -406,6 +410,13 @@ int ubi_debugfs_init_dev(struct ubi_device *ubi)
>   		goto out_remove;
>   	d->dfs_chk_io = dent;
>
> +	fname = "chk_fastmap";
> +	dent = debugfs_create_file(fname, S_IWUSR, d->dfs_dir, (void *)ubi_num,
> +				   &dfs_fops);
> +	if (IS_ERR_OR_NULL(dent))
> +		goto out_remove;
> +	d->dfs_chk_fastmap = dent;
> +
>   	fname = "tst_disable_bgt";
>   	dent = debugfs_create_file(fname, S_IWUSR, d->dfs_dir, (void *)ubi_num,
>   				   &dfs_fops);
> diff --git a/drivers/mtd/ubi/debug.h b/drivers/mtd/ubi/debug.h
> index cba89fc..e99ef37 100644
> --- a/drivers/mtd/ubi/debug.h
> +++ b/drivers/mtd/ubi/debug.h
> @@ -127,4 +127,9 @@ static inline int ubi_dbg_chk_gen(const struct ubi_device *ubi)
>   {
>   	return ubi->dbg.chk_gen;
>   }
> +
> +static inline int ubi_dbg_chk_fastmap(const struct ubi_device *ubi)
> +{
> +	return ubi->dbg.chk_fastmap;
> +}
>   #endif /* !__UBI_DEBUG_H__ */
> diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
> index 320fc38..f80a726 100644
> --- a/drivers/mtd/ubi/ubi.h
> +++ b/drivers/mtd/ubi/ubi.h
> @@ -352,6 +352,7 @@ struct ubi_wl_entry;
>    *
>    * @chk_gen: if UBI general extra checks are enabled
>    * @chk_io: if UBI I/O extra checks are enabled
> + * @chk_fastmap: if UBI fastmap extra checks are enabled
>    * @disable_bgt: disable the background task for testing purposes
>    * @emulate_bitflips: emulate bit-flips for testing purposes
>    * @emulate_io_failures: emulate write/erase failures for testing purposes
> @@ -359,6 +360,7 @@ struct ubi_wl_entry;
>    * @dfs_dir: direntry object of the UBI device debugfs directory
>    * @dfs_chk_gen: debugfs knob to enable UBI general extra checks
>    * @dfs_chk_io: debugfs knob to enable UBI I/O extra checks
> + * @dfs_chk_fastmap: debugfs knob to enable UBI fastmap extra checks
>    * @dfs_disable_bgt: debugfs knob to disable the background task
>    * @dfs_emulate_bitflips: debugfs knob to emulate bit-flips
>    * @dfs_emulate_io_failures: debugfs knob to emulate write/erase failures
> @@ -366,6 +368,7 @@ struct ubi_wl_entry;
>   struct ubi_debug_info {
>   	unsigned int chk_gen:1;
>   	unsigned int chk_io:1;
> +	unsigned int chk_fastmap:1;
>   	unsigned int disable_bgt:1;
>   	unsigned int emulate_bitflips:1;
>   	unsigned int emulate_io_failures:1;
> @@ -373,6 +376,7 @@ struct ubi_debug_info {
>   	struct dentry *dfs_dir;
>   	struct dentry *dfs_chk_gen;
>   	struct dentry *dfs_chk_io;
> +	struct dentry *dfs_chk_fastmap;
>   	struct dentry *dfs_disable_bgt;
>   	struct dentry *dfs_emulate_bitflips;
>   	struct dentry *dfs_emulate_io_failures;
>



Thanks,
Tanya Brokhman
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
