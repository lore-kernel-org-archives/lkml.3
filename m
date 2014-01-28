Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaA1MCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:02:53 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:53260 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaA1MCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:02:51 -0500
Date: Tue, 28 Jan 2014 13:02:45 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jose Alonso <joalonsof@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Lukasz Dorau <lukasz.dorau@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] for_each macros correctness
Message-ID: <20140128120245.GB4280@osiris>
References: <1390733658.3059.10.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390733658.3059.10.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012812-5024-0000-0000-0000088932E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 26, 2014 at 08:54:18AM -0200, Jose Alonso wrote:
> 
> I observed that there are for_each macros that do an extra memory access
> beyond the defined area.
> Normally this does not cause problems.
> But, this can cause exceptions. For example: if the area is allocated at
> the end of a page and the next page is not accessible.
> 
> For correctness, I suggest changing the arguments of the 'for loop' like
> others 'for_each' do in the kernel.
> 
> files involved:
>    drivers/s390/cio/qdio.h
>    drivers/scsi/isci/host.h
>    drivers/sh/clk/core.c
>    include/linux/blk-mq.h
>    include/linux/shdma-base.h
>    sound/soc/sh/rcar/adg.c
> 
> 
> Signed-off-by: Jose Alonso <joalonsof@gmail.com>
> ---
> diff --git a/drivers/s390/cio/qdio.h b/drivers/s390/cio/qdio.h
> index 8acaae1..a563e4c 100644
> --- a/drivers/s390/cio/qdio.h
> +++ b/drivers/s390/cio/qdio.h
> @@ -359,14 +359,12 @@ static inline int multicast_outbound(struct qdio_q *q)
>  #define need_siga_sync_out_after_pci(q)	\
>  	(unlikely(q->irq_ptr->siga_flag.sync_out_after_pci))
> 
> -#define for_each_input_queue(irq_ptr, q, i)	\
> -	for (i = 0, q = irq_ptr->input_qs[0];	\
> -		i < irq_ptr->nr_input_qs;	\
> -		q = irq_ptr->input_qs[++i])
> -#define for_each_output_queue(irq_ptr, q, i)	\
> -	for (i = 0, q = irq_ptr->output_qs[0];	\
> -		i < irq_ptr->nr_output_qs;	\
> -		q = irq_ptr->output_qs[++i])
> +#define for_each_input_queue(irq_ptr, q, i)		\
> +	for (i = 0; i < irq_ptr->nr_input_qs &&		\
> +		({ q = irq_ptr->input_qs[i]; 1; }); i++)
> +#define for_each_output_queue(irq_ptr, q, i)		\
> +	for (i = 0; i < irq_ptr->nr_output_qs &&	\
> +		({ q = irq_ptr->output_qs[i]; 1; }); i++)

Hi Jose,

I generated a single commit of this part of your patch and applied
it to the s390 git tree.

Thanks!

