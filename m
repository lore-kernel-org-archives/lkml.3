Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab3J2PS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 11:18:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:55650 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab3J2PS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 11:18:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="314282332"
Message-ID: <1383059901.29619.52.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/1]  MTD: UBI:  try to avoid program data to NOR flash
 after erasure interrupted
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Qi Wang =?UTF-8?Q?=E7=8E=8B=E8=B5=B7?= "(qiwang)" 
	<qiwang@micron.com>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 29 Oct 2013 17:18:21 +0200
In-Reply-To: <71CF8D7F32C5C24C9CD1D0E02D52498A770B1B97@NTXXIAMBX02.xacn.micron.com>
References: <71CF8D7F32C5C24C9CD1D0E02D52498A77082AC5@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A77082DDB@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770AED11@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770AED44@NTXXIAMBX02.xacn.micron.com>
	 <71CF8D7F32C5C24C9CD1D0E02D52498A770AED67@NTXXIAMBX02.xacn.micron.com>
	 <1382779164.5901.1.camel@karhu.quadriga.com>
	  <71CF8D7F32C5C24C9CD1D0E02D52498A770B1B97@NTXXIAMBX02.xacn.micron.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-28 at 04:54 +0000, Qi Wang 王起 (qiwang) wrote:
> On Sa, 2013-10-26 at 05:19 +0000, Artem Bityutskiy wrote:
> >On Thu, 2013-10-10 at 08:28 +0000, Qi Wang 王起 (qiwang) wrote:
> >> But I want to say the potential risk is if low level driver program data to 
> >> this block, it will get “timeout error”. And the timeout period could be very 
> >> long(almost several minutes), during this period, any operation on NOR flash 
> >> cannot be accept. so program data to a erasure interrupted block isn’t a 
> >> sensible action. in order to avoid program a erasure interrupted block, 
> >> I suggest UBIFS can read this block before program data. the code changing as below:
> >
> >Yes, reading first sounds like a good idea. Would you please send a
> >patch implementing it?
> 
> From: Qi Wang <qiwang@micron.com>
> 
> nor_erase_prepare() will be called before erase a NOR flash, it will program '0'
> into a block to mark this block. But program data into a erasure interrupted block
> can cause program timtout(several minutes at most) error, could impact other 
> operation on NOR flash. So UBIFS can read this block first to avoid unneeded 
> program operation. 
> 
> This patch try to put read operation at at head of write operation in 
> nor_erase_prepare(), read out the data. 
> If the data is already corrupt, then no need to program any data into this block, 
> just go to erase this block.
> 
> Signed-off-by: Qi Wang <qiwang@qiwang@micron.com>
> ---
> diff --git a/drivers/mtd/ubi/io.c b/drivers/mtd/ubi/io.c
> index bf79def..be6ab56 100644
> --- a/drivers/mtd/ubi/io.c
> +++ b/drivers/mtd/ubi/io.c
> @@ -509,26 +509,10 @@ static int nor_erase_prepare(struct ubi_device *ubi, int pnum)
>  	struct ubi_vid_hdr vid_hdr;
>  
>  	/*
> -	 * It is important to first invalidate the EC header, and then the VID
> -	 * header. Otherwise a power cut may lead to valid EC header and
> -	 * invalid VID header, in which case UBI will treat this PEB as
> -	 * corrupted and will try to preserve it, and print scary warnings.
> -	 */
> -	addr = (loff_t)pnum * ubi->peb_size;
> -	err = mtd_write(ubi->mtd, addr, 4, &written, (void *)&data);
> -	if (!err) {
> -		addr += ubi->vid_hdr_aloffset;
> -		err = mtd_write(ubi->mtd, addr, 4, &written, (void *)&data);
> -		if (!err)
> -			return 0;
> -	}

How about structuring the code this way:

if (EC header is good)
     invalidate EC header()
if (VID header is good)
     invalidate VID header()

Then you'll handle the case when only one of the headers is already
corrupted.

-- 
Best Regards,
Artem Bityutskiy

