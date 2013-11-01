Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab3KAI6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 04:58:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:19465 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190Ab3KAI6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 04:58:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,615,1378882800"; 
   d="scan'208";a="420753088"
Message-ID: <1383296284.2722.73.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/1]  MTD: UBI:  try to avoid program data to NOR flash
 after erasure interrupted
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Qi Wang =?UTF-8?Q?=E7=8E=8B=E8=B5=B7?= "(qiwang)" 
	<qiwang@micron.com>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 01 Nov 2013 10:58:04 +0200
In-Reply-To: <71CF8D7F32C5C24C9CD1D0E02D52498A770B220C@NTXXIAMBX02.xacn.micron.com>
References: <71CF8D7F32C5C24C9CD1D0E02D52498A77082AC5@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A77082DDB@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770AED11@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770AED44@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770AED67@NTXXIAMBX02.xacn.micron.com>
	 <1382779164.5901.1.camel@karhu.quadriga.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B1B97@NTXXIAMBX02.xacn.micron.com>
	 <1383059901.29619.52.camel@sauron.fi.intel.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770B220C@NTXXIAMBX02.xacn.micron.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

could you please re-send your patch separately, without quoting any
parts of this conversation, so that I could use 'git am'.

Your patch also contains trailing white-spaces, please, get rid of them
in the next submission.

Also, could you please clearly state whether you have tested this patch
on a real NOR flash or not. If yes, then could you share the chip
vendor/type information?

On Thu, 2013-10-31 at 04:07 +0000, Qi Wang 王起 (qiwang) wrote:

> --- a/drivers/mtd/ubi/io.c
> +++ b/drivers/mtd/ubi/io.c
> @@ -499,59 +499,44 @@ static int nor_erase_prepare(struct ubi_device *ubi, int pnum)
>  	size_t written;
>  	loff_t addr;
>  	uint32_t data = 0;
> -	/*
> -	 * Note, we cannot generally define VID header buffers on stack,
> -	 * because of the way we deal with these buffers (see the header
> -	 * comment in this file). But we know this is a NOR-specific piece of
> -	 * code, so we can do this. But yes, this is error-prone and we should
> -	 * (pre-)allocate VID header buffer instead.
> -	 */

Please, do not remove this comment.

>  	struct ubi_vid_hdr vid_hdr;
> +	struct ubi_ec_hdr ec_hdr;

To make it obvious what the above big comment talks about, could you
please define 'struct ubi_ec_hdr ec_hdr' above that big comment.

Otherwise looks good to me, thank you!


> My Comments for above changing:
> 1. 
> 	-	/*
> 	-	 * Note, we cannot generally define VID header buffers on stack,
> 	-	 * because of the way we deal with these buffers (see the header
> 	-	 * comment in this file). But we know this is a NOR-specific piece of
> 	-	 * code, so we can do this. But yes, this is error-prone and we should
> 	-	 * (pre-)allocate VID header buffer instead.
> 	-	 */
> 	I remove above comment, because I pre-allocate VID header and EC header together. 
> 	So I think no need to emphasize VID header buffers cannot be on stack.
> 	(Maybe my understanding about this comment is error, if so, please correct me)

The problem is that some functions in io.c can read or write _beyond_
sizeof(struct ubi_vid_hdr), but this is only relevant to NAND, not for
NOR, and the code you change is NOR-only. This is why that comment is
there, and I'd like to keep it.

> 2.
> 	why use
> 	"if (err != UBI_IO_BAD_HDR_EBADMSG && err != UBI_IO_BAD_HDR && err != UBI_IO_FF)"
> 	but not 
> 	"if (!err)" 
> 	to judge if need to program '0' to invalid this block.
> 
> 	In case err == UBI_IO_FF_BITFLIPS, err == UBI_IO_BITFLIPS or unexpected value return
> 	from read function, I think UBI still need to invalid this block for above mentioned 
> 	condition. So I use
> 	"if (err != UBI_IO_BAD_HDR_EBADMSG && err != UBI_IO_BAD_HDR && err != UBI_IO_FF)"
> 	to judge. 

In case of UBI_IO_FF (all FFs) UBI will erase the eraseblock before
using it anyway, so invalidation is not necessary.

Thanks!

-- 
Best Regards,
Artem Bityutskiy

