Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab3FYP5C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:57:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:2351 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab3FYP46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:56:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,938,1363158000"; 
   d="scan'208";a="355539884"
Date: Tue, 25 Jun 2013 20:46:12 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        alsa-devel@alsa-project.org, Kukjin Kim <kgene.kim@samsung.com>,
        Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Padmavathi Venna <padma.v@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: Re: [RFC PATCH v2 01/12] dmaengine: PL08x: Refactor
 pl08x_getbytes_chan() to lower indentation
Message-ID: <20130625151612.GO23141@intel.com>
References: <1371933764-24875-1-git-send-email-tomasz.figa@gmail.com>
 <1371933764-24875-2-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371933764-24875-2-git-send-email-tomasz.figa@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 22, 2013 at 10:42:33PM +0200, Tomasz Figa wrote:
> Further patch will introduce support for PL080S, which requires some
> things to be done conditionally, thus increasing indentation level of
> some functions even more.
> 
> This patch reduces indentation level of pl08x_getbytes_chan() function
> by inverting several conditions and returning from function wherever
> possible.
> 
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> ---
>  drivers/dma/amba-pl08x.c | 53 ++++++++++++++++++++++++++----------------------
>  1 file changed, 29 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
> index 06fe45c..6a12392 100644
> --- a/drivers/dma/amba-pl08x.c
> +++ b/drivers/dma/amba-pl08x.c
> @@ -469,47 +469,52 @@ static inline u32 get_bytes_in_cctl(u32 cctl)
>  /* The channel should be paused when calling this */
>  static u32 pl08x_getbytes_chan(struct pl08x_dma_chan *plchan)
>  {
> +	struct pl08x_lli *llis_va;
>  	struct pl08x_phy_chan *ch;
> +	dma_addr_t llis_bus;
>  	struct pl08x_txd *txd;
> -	size_t bytes = 0;
> +	size_t bytes;
> +	int index;
> +	u32 clli;
>  
>  	ch = plchan->phychan;
>  	txd = plchan->at;
>  
> +	if (!ch || !txd)
> +		return 0;
shouldnt this be err return

> +
>  	/*
>  	 * Follow the LLIs to get the number of remaining
>  	 * bytes in the currently active transaction.
>  	 */
> -	if (ch && txd) {
> -		u32 clli = readl(ch->base + PL080_CH_LLI) & ~PL080_LLI_LM_AHB2;
> +	clli = readl(ch->base + PL080_CH_LLI) & ~PL080_LLI_LM_AHB2;
>  
> -		/* First get the remaining bytes in the active transfer */
> -		bytes = get_bytes_in_cctl(readl(ch->base + PL080_CH_CONTROL));
> +	/* First get the remaining bytes in the active transfer */
> +	bytes = get_bytes_in_cctl(readl(ch->base + PL080_CH_CONTROL));
>  
> -		if (clli) {
> -			struct pl08x_lli *llis_va = txd->llis_va;
> -			dma_addr_t llis_bus = txd->llis_bus;
> -			int index;
> +	if (!clli)
> +		return bytes;
>  
> -			BUG_ON(clli < llis_bus || clli >= llis_bus +
> +	llis_va = txd->llis_va;
> +	llis_bus = txd->llis_bus;
> +
> +	BUG_ON(clli < llis_bus || clli >= llis_bus +
>  				sizeof(struct pl08x_lli) * MAX_NUM_TSFR_LLIS);
IMO BUG_ON is too much for this. Perhaps returning error and logging error would
be okay

--
~Vinod
