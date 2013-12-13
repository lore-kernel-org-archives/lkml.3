Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab3LMS7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 13:59:49 -0500
Received: from unicorn.mansr.com ([81.2.72.234]:33603 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab3LMS7s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 13:59:48 -0500
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: "Chen.Yu" <chyyuu@gmail.com>
Cc: linux-kernel@vger.kernel.org, levex@linux.com, xiaoqixue_1@163.com,
        fanwlexca@gmail.com
Subject: Re: [PATCH] scsi: integer overflow in megadev_ioctl()
References: <1386960092-32475-1-git-send-email-chyyuu@gmail.com>
Date: Fri, 13 Dec 2013 18:59:44 +0000
In-Reply-To: <1386960092-32475-1-git-send-email-chyyuu@gmail.com> (Chen Yu's
	message of "Sat, 14 Dec 2013 02:41:32 +0800")
Message-ID: <yw1xbo0kinkv.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Chen.Yu" <chyyuu@gmail.com> writes:

> From: "Chen.Yu" <chyyuu@gmail.com>
>
> There is a potential integer overflow in megadev_ioctl() if
> userspace passes in a large u32 variable uioc.adapno.
> The int variable adapno would < 0, leading to an error
> array access for hdb_soft_state[adapno], or an error
> copy_to_user(uioc.uioc_uaddr, mcontroller+adapno,..)
>
> Reported-by: Wenliang Fan <fanwlexca@gmail.com>
> Suggested-by: Qixue Xiao <xiaoqixue_1@163.com>
> Signed-off-by: Yu Chen <chyyuu@gmail.com>
> Reviewed-by: Levente Kurusa <levex@linux.com>
> ---
>  drivers/scsi/megaraid.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> index 816db12..0b90c54 100644
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -3099,7 +3099,10 @@ megadev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
>  		/*
>  		 * Which adapter
>  		 */
> -		if( (adapno = GETADAP(uioc.adapno)) >= hba_count )
> +		adapno = GETADAP(uioc.adapno);
> +		if( adapno < 0 )
> +			return (-EINVAL);
> +		if( adapno >= hba_count )
>  			return (-ENODEV);

This relies on implementation-defined behaviour when converting an
unsigned integer to signed integer.  A simpler and more robust fix is to
make the local variable 'adapno' unsigned.

-- 
Måns Rullgård
mans@mansr.com
