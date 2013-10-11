Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab3JKAbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 20:31:35 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:38249 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab3JKAbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 20:31:34 -0400
Message-ID: <1381451492.2367.63.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] partitions/efi: treat size mismatch as a warning, not
 an error
From: Davidlohr Bueso <davidlohr@hp.com>
To: Doug Anderson <dianders@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Karel Zak <kzak@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Sean Paul <seanpaul@chromium.org>, Olof Johansson <olof@lixom.net>,
        Bill Richardson <wfrichar@chromium.org>,
        Josh Triplett <josh@joshtriplett.org>
Date: Thu, 10 Oct 2013 17:31:32 -0700
In-Reply-To: <1381447702-6240-1-git-send-email-dianders@chromium.org>
References: <20131009232642.GA12776@jtriplet-mobl1>
	 <1381447702-6240-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-10 at 16:28 -0700, Doug Anderson wrote:
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

dd'ing instead?

> +	 * an image from a smaller disk to a bigger disk.

'larger' disk sounds better.

>  	 */
>  	if (ret == GPT_MBR_PROTECTIVE) {
>  		sz = le32_to_cpu(mbr->partition_record[part].size_in_lba);
>  		if (sz != (uint32_t) total_sectors - 1 && sz != 0xFFFFFFFF)
> -			ret = 0;
> +			pr_warn("%s: mbr size mismatch (%u != %u)\n", __func__,
> +				sz, (uint32_t)((uint32_t) total_sectors - 1));

How about this instead?
pr_debug("GPT: mbr size in lba (%d) different than whole disk (%d).\n", sz, min(total_sectors -1, 0xFFFFFFFF));

>  	}
>  done:
>  	return ret;

Thanks,
Davidlohr

