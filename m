Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965290AbaDJDbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:31:32 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:53204 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934239AbaDJDb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:31:28 -0400
MIME-Version: 1.0
In-Reply-To: <d0106d723f7455208f83e50522007fee7887e67e.1392419479.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
References: <d0106d723f7455208f83e50522007fee7887e67e.1392419479.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
Date: Wed, 9 Apr 2014 20:31:27 -0700
X-Google-Sender-Auth: IIGisEJBiEk02BmqE4pTGvlpo8I
Message-ID: <CAA9_cmfD_tgDK+mpZx0WNqHyVZ01yFtuUe33WpD0=8TXpC2jfQ@mail.gmail.com>
Subject: Re: [PATCH dmaengine-fixes 1/1] dmaengine: read completed cookie
 before used cookie
From: Dan Williams <dan.j.williams@intel.com>
To: Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 3:32 PM, Siva Yerramreddy
<siva.krishna.kumar.reddy.yerramreddy@intel.com> wrote:
> When running dmatest with my yet-to-be submitted driver for the Intel MIC DMA
> engine, dmatest detected "dma0chan3-copy5: result #8096161:completion busy
> status with src_off=0x0 dst_off=0x0 len=0x40 (0)". This is caused by reading
> the used cookie before the completed cookie in dma_cookie_status(),  if a DMA
> request is submitted in between the two reads, and completes,  the completed
> cookie will be newer than the used cookie value read previously.  Reversing
> the order of reads ensures that the completed cookie is for a DMA request
> older than the used cookie.
>
> Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
> Reviewed-by: Sudeep Dutt <sudeep.dutt@intel.com>
> Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
> Signed-off-by: Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>
> ---
>  drivers/dma/dmaengine.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/dma/dmaengine.h b/drivers/dma/dmaengine.h
> index 17f983a..4c96892 100644
> --- a/drivers/dma/dmaengine.h
> +++ b/drivers/dma/dmaengine.h
> @@ -7,6 +7,7 @@
>
>  #include <linux/bug.h>
>  #include <linux/dmaengine.h>
> +#include <asm/barrier.h>
>
>  /**
>   * dma_cookie_init - initialize the cookies for a DMA channel
> @@ -69,8 +70,13 @@ static inline enum dma_status dma_cookie_status(struct dma_chan *chan,
>  {
>         dma_cookie_t used, complete;
>
> -       used = chan->cookie;
>         complete = chan->completed_cookie;
> +       /*
> +        * If this order is not maintained, used can end up being older than
> +        * complete
> +        */
> +       smp_rmb();
> +       used = chan->cookie;
>         barrier();
>         if (state) {
>                 state->last = complete;

Hmm, this patch by itself is problematic because the rmb() needs to be
paired with a wmb() otherwise it really has no effect.  Is there a
wmb() in your driver?

I think this does need to be fixed, but we need to provide generic
helpers for other drivers.  I also think smb_rmb() and smb_wmb() are
overkill we should just be able to use smp_store_release() and
smp_load_acquire() for this.
