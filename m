Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819Ab3BNJNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 04:13:53 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:39390 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab3BNJNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 04:13:50 -0500
Message-ID: <1360833226.24917.41.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] Ensure that the GPT header is at least the size of the
 structure.
From: Matt Fleming <matt.fleming@intel.com>
To: Peter Jones <pjones@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Warren <swarren@nvidia.com>
Date: Thu, 14 Feb 2013 09:13:46 +0000
In-Reply-To: <1360797349-19308-1-git-send-email-pjones@redhat.com>
References: <1360796990-14148-1-git-send-email-pjones@redhat.com>
	 <1360797349-19308-1-git-send-email-pjones@redhat.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 18:15 -0500, Peter Jones wrote:
> UEFI 2.3.1D will include a change to the spec language mandating that a
> GPT header must be greater than *or equal to* the size of the defined
> structure.  While verifying that this would work on Linux, I discovered
> that we're not actually checking the minimum bound at all.
> 
> The result of this is that when we verify the checksum, it's possible
> that on a malformed header (with header_size of 0), we won't actually
> verify any data.
> 
> (ammended to fix type error in pr_debug())
> 
> Signed-off-by: Peter Jones <pjones@redhat.com>
> ---
>  block/partitions/efi.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/block/partitions/efi.c b/block/partitions/efi.c
> index b62fb88..a7475e7 100644
> --- a/block/partitions/efi.c
> +++ b/block/partitions/efi.c
> @@ -310,15 +310,23 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
>  		goto fail;
>  	}
>  
> -	/* Check the GUID Partition Table header size */
> +	/* Check the GUID Partition Table header size is too big */
>  	if (le32_to_cpu((*gpt)->header_size) >
>  			bdev_logical_block_size(state->bdev)) {
> -		pr_debug("GUID Partition Table Header size is wrong: %u > %u\n",
> +		pr_debug("GUID Partition Table Header size is too large: %u > %u\n",
>  			le32_to_cpu((*gpt)->header_size),
>  			bdev_logical_block_size(state->bdev));
>  		goto fail;
>  	}
>  
> +	/* Check the GUID Partition Table header size is too small */
> +	if (le32_to_cpu((*gpt)->header_size) < sizeof(gpt_header)) {
> +		pr_debug("GUID Partition Table Header size is too small: %u < %lu\n",
> +			le32_to_cpu((*gpt)->header_size),
> +			sizeof(gpt_header));
> +		goto fail;
> +	}
> +
>  	/* Check the GUID Partition Table CRC */
>  	origcrc = le32_to_cpu((*gpt)->header_crc32);
>  	(*gpt)->header_crc32 = 0;

Seems straight forward.

Acked-by: Matt Fleming <matt.fleming@intel.com>

