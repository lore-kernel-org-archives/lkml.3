Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab3JKAZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 20:25:34 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:59239 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab3JKAZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 20:25:33 -0400
X-Originating-IP: 173.246.103.110
Date: Thu, 10 Oct 2013 17:25:22 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Doug Anderson <dianders@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Karel Zak <kzak@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Sean Paul <seanpaul@chromium.org>, Olof Johansson <olof@lixom.net>,
        Bill Richardson <wfrichar@chromium.org>,
        Davidlohr Bueso <davidlohr@hp.com>
Subject: Re: [PATCH] partitions/efi: treat size mismatch as a warning, not an
 error
Message-ID: <20131011002521.GB32546@jtriplet-mobl1>
References: <20131009232642.GA12776@jtriplet-mobl1>
 <1381447702-6240-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381447702-6240-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 04:28:22PM -0700, Doug Anderson wrote:
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

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> ---
>  block/partitions/efi.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/block/partitions/efi.c b/block/partitions/efi.c
> index 1eb09ee..ac23dc1 100644
> --- a/block/partitions/efi.c
> +++ b/block/partitions/efi.c
> @@ -222,11 +222,15 @@ check_hybrid:
>  	 * the disk size.
>  	 *
>  	 * Hybrid MBRs do not necessarily comply with this.
> +	 *
> +	 * Consider a bad value here to be a warning to support dd-ing
> +	 * an image from a smaller disk to a bigger disk.
>  	 */
>  	if (ret == GPT_MBR_PROTECTIVE) {
>  		sz = le32_to_cpu(mbr->partition_record[part].size_in_lba);
>  		if (sz != (uint32_t) total_sectors - 1 && sz != 0xFFFFFFFF)
> -			ret = 0;
> +			pr_warn("%s: mbr size mismatch (%u != %u)\n", __func__,
> +				sz, (uint32_t)((uint32_t) total_sectors - 1));
>  	}
>  done:
>  	return ret;
> -- 
> 1.8.4
> 
