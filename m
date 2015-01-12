Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbbALTGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:06:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:18023 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009AbbALTGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:06:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,745,1413270000"; 
   d="scan'208";a="649958700"
Date: Mon, 12 Jan 2015 14:06:00 -0500
From: Matthew Wilcox <willy@linux.intel.com>
To: Vaishali Thakkar <vthakkar1994@gmail.com>
Cc: matthew.r.wilcox@intel.com, axboe@fb.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH v2] NVMe: Use put_unaligned_be64
Message-ID: <20150112190600.GF5661@wil.cx>
References: <20150110085259.GA3120@vaishali-Ideapad-Z570>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150110085259.GA3120@vaishali-Ideapad-Z570>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 02:22:59PM +0530, Vaishali Thakkar wrote:
> This patch introduces the use of function put_unaligned_be64.
> 
> This is done using Coccinelle and semantic patch used is as follows:

I appreciate you're using an automated tool to find the problem ...

> diff --git a/drivers/block/nvme-scsi.c b/drivers/block/nvme-scsi.c
> index 5e78568..12893ef 100644
> --- a/drivers/block/nvme-scsi.c
> +++ b/drivers/block/nvme-scsi.c
> @@ -1417,7 +1418,6 @@ static void nvme_trans_fill_read_cap(u8 *response, struct nvme_id_ns *id_ns,
>  	u64 rlba;
>  	u8 prot_en;
>  	u8 p_type_lut[4] = {0, 0, 1, 2};
> -	__be64 tmp_rlba;
>  	__be32 tmp_rlba_32;
>  	__be32 tmp_len;
>  
> @@ -1434,9 +1434,8 @@ static void nvme_trans_fill_read_cap(u8 *response, struct nvme_id_ns *id_ns,
>  		memcpy(response, &tmp_rlba_32, sizeof(u32));
>  		memcpy(&response[4], &tmp_len, sizeof(u32));
>  	} else {
> -		tmp_rlba = cpu_to_be64(rlba);
>  		tmp_len = cpu_to_be32(lba_length);
> -		memcpy(response, &tmp_rlba, sizeof(u64));
> +		put_unaligned_be64(rlba, response);
>  		memcpy(&response[8], &tmp_len, sizeof(u32));
>  		response[12] = (p_type_lut[id_ns->dps & 0x3] << 1) | prot_en;
>  		/* P_I_Exponent = 0x0 | LBPPBE = 0x0 */

... but can't you look at the code you're modifying and notice that
maybe there's an opportunity to do better?  The two things I notice when
looking at this code:

 - There are also 32-bit variables being used in the same way, so a
   complete patch would also eliminate them.
 - The 'response' buffer is allocated from kmalloc, so it's aligned, and
   these fields are aligned relative to the start of the buffer,
   so we know they're aligned.  So we should be using something in
   the cpu_to_be64p family to store the value to the fields, not
   put_unaligned_be64().
