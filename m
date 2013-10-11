Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343Ab3JKQLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 12:11:16 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:29781 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207Ab3JKQLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 12:11:15 -0400
Message-ID: <1381507866.23236.2.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2] partitions/efi: treat size mismatch as a warning,
 not an error
From: Davidlohr Bueso <davidlohr@hp.com>
To: Doug Anderson <dianders@chromium.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, Karel Zak <kzak@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Sean Paul <seanpaul@chromium.org>, Olof Johansson <olof@lixom.net>,
        Bill Richardson <wfrichar@chromium.org>,
        Josh Triplett <josh@joshtriplett.org>
Date: Fri, 11 Oct 2013 09:11:06 -0700
In-Reply-To: <1381506454-28760-1-git-send-email-dianders@chromium.org>
References: <1381447702-6240-1-git-send-email-dianders@chromium.org>
	 <1381506454-28760-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 08:47 -0700, Doug Anderson wrote:
> In (27a7c64 partitions/efi: account for pmbr size in lba) we started
> treating bad sizes in lba field of the partition that has the 0xEE
> (GPT protective) as errors.  However, we may run into these "bad
> sizes" in the real world if someone uses dd to copy an image from a
> smaller disk to a bigger disk.  Since this case used to work (even
> without using force_gpt), keep it working and treat the size mismatch
> as a warning instead of an error.
> 
> Reported-by: Josh Triplett <josh@joshtriplett.org>
> Reported-by: Sean Paul <seanpaul@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Davidlohr Bueso <davidlohr@hp.com>

Andrew, could you queue this up?

Thanks,
Davidlohr

> ---
> Changes in v2:
> - Cleaned up comments/warning as per Davidlohr.
> 
>  block/partitions/efi.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/block/partitions/efi.c b/block/partitions/efi.c
> index 1eb09ee..a8287b4 100644
> --- a/block/partitions/efi.c
> +++ b/block/partitions/efi.c
> @@ -222,11 +222,16 @@ check_hybrid:
>  	 * the disk size.
>  	 *
>  	 * Hybrid MBRs do not necessarily comply with this.
> +	 *
> +	 * Consider a bad value here to be a warning to support dd'ing
> +	 * an image from a smaller disk to a larger disk.
>  	 */
>  	if (ret == GPT_MBR_PROTECTIVE) {
>  		sz = le32_to_cpu(mbr->partition_record[part].size_in_lba);
>  		if (sz != (uint32_t) total_sectors - 1 && sz != 0xFFFFFFFF)
> -			ret = 0;
> +			pr_debug("GPT: mbr size in lba (%u) different than whole disk (%u).\n",
> +				 sz, min_t(uint32_t,
> +					   total_sectors - 1, 0xFFFFFFFF));
>  	}
>  done:
>  	return ret;


