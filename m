Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaJHGLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 02:11:33 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:44357 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaJHGLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 02:11:32 -0400
Message-ID: <1412748690.31947.38.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH] target/file: fix inclusive vfs_fsync_range() end
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Zach Brown <zab@zabbo.net>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 07 Oct 2014 23:11:30 -0700
In-Reply-To: <1412638813-13285-1-git-send-email-zab@zabbo.net>
References: <1412638813-13285-1-git-send-email-zab@zabbo.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-06 at 16:40 -0700, Zach Brown wrote:
> Both of the file target's calls to vfs_fsync_range() got the end offset
> off by one.  The range is inclusive, not exclusive.  It would sync a bit
> more data than was required.
> 
> The sync path already tested the length of the range and fell back to
> LLONG_MAX so I copied that pattern in the rw path.
> 
> This is untested. I found the errors by inspection while following other
> code.
> 
> Signed-off-by: Zach Brown <zab@zabbo.net>
> ---
>  drivers/target/target_core_file.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
> index 7d6cdda..176588f 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
> @@ -415,7 +415,7 @@ fd_execute_sync_cache(struct se_cmd *cmd)
>  	} else {
>  		start = cmd->t_task_lba * dev->dev_attrib.block_size;
>  		if (cmd->data_length)
> -			end = start + cmd->data_length;
> +			end = start + cmd->data_length - 1;
>  		else
>  			end = LLONG_MAX;
>  	}
> @@ -680,7 +680,12 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
>  			struct fd_dev *fd_dev = FD_DEV(dev);
>  			loff_t start = cmd->t_task_lba *
>  				dev->dev_attrib.block_size;
> -			loff_t end = start + cmd->data_length;
> +			loff_t end;
> +
> +			if (cmd->data_length)
> +				end = start + cmd->data_length - 1;
> +			else
> +				end = LLONG_MAX;
>  
>  			vfs_fsync_range(fd_dev->fd_file, start, end, 1);
>  		}

Nice catch Zach.  Applying to target-pending/for-next now.

Thank you,

--nab

