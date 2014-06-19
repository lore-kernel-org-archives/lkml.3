Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934303AbaFSSoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:44:04 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59876 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934184AbaFSSoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:44:01 -0400
Message-ID: <1403203437.17294.25.camel@dabdike.int.hansenpartnership.com>
Subject: Re: Cannot partition 32GB disk on a 32bit machine (correct version
 of the patch this time)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Cox, Alan" <alan.cox@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "aeb@cwi.nl" <aeb@cwi.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 19 Jun 2014 11:43:57 -0700
In-Reply-To: <1403170400.10778.38.camel@acox1-desk.ger.corp.intel.com>
References: <1403170201.10778.36.camel@acox1-desk.ger.corp.intel.com>
	 <1403170400.10778.38.camel@acox1-desk.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-19 at 09:33 +0000, Cox, Alan wrote:
> On Thu, 2014-06-19 at 10:30 +0100, Alan Cox wrote:
> > The block code has 32bit cleanness problems with the iterator. This
> > prevents things like partitioning a 32GB volume on a 32bit system.
> > 
> > I hit this with a volume of exactly 32GB in size (easy to duplicate with
> > virtual machines). Tracing at step by step through the kernel I found
> > the problem lines in blkdev_read_iter which truncates the size value
> > into a 32bit value when setting up the iterator.
> > 
> > The hack below if applied "fixes" this and I think demonstrates that
> > this is the problem spot.
> > 
> > What I'm less clear on is what the correct fix for this should be.
> 
> block: fix inability to partition large volumes
> 
> From: Alan <alan@linux.intel.com>
> 
> The block code has 32bit cleanness problems with the iterator. This
> prevents things like partitioning a 32GB volume on a 32bit system.
> 
> This is a simple initial "fix" that clips the problem cases so get
> behaviour that is at least sane and trivially backportable.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>  fs/block_dev.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 6d72746..bef2414 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1603,6 +1603,9 @@ static ssize_t blkdev_read_iter(struct kiocb
> *iocb, struct iov_iter *to)
>  
>  	size -= pos;
>  	iov_iter_truncate(to, size);
> +	/* Fix up for 32bit boxes for now */
> +	if (to->count < size)
> +	        to->count = 0xFFFFFFFF;
>  	return generic_file_read_iter(iocb, to);
>  }
>  
> 
> ---------------------------------------------------------------------
> Intel Corporation (UK) Limited
> Registered No. 1134945 (England)
> Registered Office: Pipers Way, Swindon SN3 1RJ
> VAT No: 860 2173 47
> 
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
> NrybXǧv^)޺{.n+{~^b^nrzh&Gh(階ݢj"mzޖfh~m

Wow that's junk issued by an Exchange server ... Alan, really ...

Do you have CONFIG_LBD turned on?  That's supposed to let us go up to
about 16TB before we run out of page index bits.  If you do, we might
have a variable that's int but should be sector_t somewhere.

James


