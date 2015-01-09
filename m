Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbbAIVZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:25:19 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:52176 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758316AbbAIVZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:25:14 -0500
Message-ID: <54B046BC.8060802@vanguardiasur.com.ar>
Date: Fri, 09 Jan 2015 18:23:08 -0300
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Organization: VanguardiaSur
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] UBI: Fastmap: Care about the protection queue
References: <1416835236-25185-1-git-send-email-richard@nod.at> <1416835236-25185-2-git-send-email-richard@nod.at>
In-Reply-To: <1416835236-25185-2-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 10:20 AM, Richard Weinberger wrote:
> Fastmap can miss a PEB if it is in the protection queue
> and not jet in the used tree.

s/jet/yet

> Treat every protected PEB as used.
> 

I'm wondering if we can have a detailed description of the issues this
commit fixes (if any?). In other words, what's the result of *not*
having the patch?

> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/mtd/ubi/fastmap.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
> index b56672b..db3defd 100644
> --- a/drivers/mtd/ubi/fastmap.c
> +++ b/drivers/mtd/ubi/fastmap.c
> @@ -1196,6 +1196,19 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
>  		fm_pos += sizeof(*fec);
>  		ubi_assert(fm_pos <= ubi->fm_size);
>  	}
> +
> +	for (i = 0; i < UBI_PROT_QUEUE_LEN; i++) {
> +		list_for_each_entry(wl_e, &ubi->pq[i], u.list) {
> +			fec = (struct ubi_fm_ec *)(fm_raw + fm_pos);
> +
> +			fec->pnum = cpu_to_be32(wl_e->pnum);
> +			fec->ec = cpu_to_be32(wl_e->ec);
> +
> +			used_peb_count++;
> +			fm_pos += sizeof(*fec);
> +			ubi_assert(fm_pos <= ubi->fm_size);
> +		}
> +	}
>  	fmh->used_peb_count = cpu_to_be32(used_peb_count);
>  
>  	for (node = rb_first(&ubi->scrub); node; node = rb_next(node)) {
> 


-- 
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar
