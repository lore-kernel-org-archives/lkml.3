Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab3KBX2s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 19:28:48 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50892 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab3KBX2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 19:28:47 -0400
Message-ID: <1383434908.15049.10.camel@maxim-laptop>
Subject: Re: [PATCH] memstick: fix unreachable state in h_msb_read_page() in
 ms_block.c
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: rogerable@realtek.com
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, oakad@yahoo.com, wei_wang@realsil.com.cn,
        micky_ching@realsil.com.cn
Date: Sun, 03 Nov 2013 01:28:28 +0200
In-Reply-To: <1383119651-31317-1-git-send-email-rogerable@realtek.com>
References: <1383119651-31317-1-git-send-email-rogerable@realtek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-30 at 15:54 +0800, rogerable@realtek.com wrote: 
> From: Roger Tseng <rogerable@realtek.com>
> 
> In h_msb_read_page() in ms_block.c, flow never reaches case
> MSB_RP_RECIVE_STATUS_REG. This causes error when MEMSTICK_INT_ERR is
> encountered and status error bits are going to be examined, but the status will
> never be copied back.
> 
> Fix it by transiting to MSB_RP_RECIVE_STATUS_REG right after
> MSB_RP_SEND_READ_STATUS_REG.
> 
> Signed-off-by: Roger Tseng <rogerable@realtek.com>
> ---
>  drivers/memstick/core/ms_block.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
> index 08e7023..9188ef5 100644
> --- a/drivers/memstick/core/ms_block.c
> +++ b/drivers/memstick/core/ms_block.c
> @@ -401,7 +401,7 @@ again:
>  			sizeof(struct ms_status_register)))
>  			return 0;
>  
> -		msb->state = MSB_RP_RECEIVE_OOB_READ;
> +		msb->state = MSB_RP_RECIVE_STATUS_REG;
>  		return 0;
>  
>  	case MSB_RP_RECIVE_STATUS_REG:

This is indeed a bug here. Probably added when I converted to use
#defines for states.

So,

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>


Btw, there is another  minor or major (pun inteded) bug out there in
this driver, which I still have no time to send patch for yet :-(

I accidentally didn't set the major and minor for the disk.
It happens to work as usually there is just one card reader out there,
and major is allocated dynamically.

The two lines in msb_init_disk,

msb->disk->major = major;
msb->disk->first_minor = disk_id << MS_BLOCK_PART_SHIFT;

Somehow fell through the cracks. I had this in older revision.

Feel free to add it, or maybe I find time to compile and test this and
send a patch.

You also welcome to write a driver for xD portion of the card reader
too.
I back then implemented all the generic support, and you only need to
expose an NAND driver (look at r852.c for my code).


-- 
Best regards,
        Maxim Levitsky


