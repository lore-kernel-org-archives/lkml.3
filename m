Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749Ab3APJPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 04:15:43 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:44826 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab3APJPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 04:15:39 -0500
MIME-Version: 1.0
In-Reply-To: <1358326637-10109-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1358326637-10109-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 16 Jan 2013 14:45:39 +0530
X-Google-Sender-Auth: 8Bp1D1TMQ_NVHESKRciRpw69ENc
Message-ID: <CAOh2x=nUbwrWOSirCQm2qw57+OHa2u4WUCMtg8rK+5kzhSOt5w@mail.gmail.com>
Subject: Re: [PATCHv2] dw_dmac: don't exceed AHB master number in dwc_get_data_width
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks fine now, just some minor issues.

- I believe there should be a space between "PATCH" and "v2" in subject.
- Changelog missing v1->v2, place it after three dash "-" and before file name
present below.

On Wed, Jan 16, 2013 at 2:27 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> The driver's default assumes that hardware has two AHB masters which might be
> not true. In such rare cases we have not to exceed a number of the AHB masters
> present in the hardware. Thus, the AHB master with highest possible number will
> be used to retrieve the data witdh value.

I would write it as:

The driver assumes that hardware has two AHB masters which might not be
always true. In such cases we must not exceed number of the AHB masters
present in the hardware. In the proposed scheme in this patch, we would choose
the master with highest possible number whenever we exceed max AHB masters.

> The patch also changes the logic a bit when the master parameter of the
> dwc_get_data_width() is out of range. Now the function will return a value
> related to the first AHB master.

This para is not required, i believe.

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c |   33 ++++++++++++++++++++-------------
>  1 file changed, 20 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 30ff2a4..561bb9a 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -46,13 +46,29 @@ static inline unsigned int dwc_get_sms(struct dw_dma_slave *slave)
>         return slave ? slave->src_master : 1;
>  }
>
> +#define SRC_MASTER     0
> +#define DST_MASTER     1
> +
> +static inline unsigned int dwc_get_master(struct dma_chan *chan, int master)
> +{
> +       struct dw_dma *dw = to_dw_dma(chan->device);
> +       struct dw_dma_slave *dws = chan->private;
> +       unsigned int m = 0;

no need to initialize m.

> +
> +       if (master == SRC_MASTER)
> +               m = dwc_get_sms(dws);
> +       else if (master == DST_MASTER)
> +               m = dwc_get_dms(dws);
> +
> +       return min_t(unsigned int, dw->nr_masters - 1, m);
> +}
> +
>  #define DWC_DEFAULT_CTLLO(_chan) ({                            \
> -               struct dw_dma_slave *__slave = (_chan->private);        \
>                 struct dw_dma_chan *_dwc = to_dw_dma_chan(_chan);       \
>                 struct dma_slave_config *_sconfig = &_dwc->dma_sconfig; \
>                 bool _is_slave = is_slave_direction(_dwc->direction);   \
> -               int _dms = dwc_get_dms(__slave);                \
> -               int _sms = dwc_get_sms(__slave);                \
> +               int _dms = dwc_get_master(_chan, DST_MASTER);           \
> +               int _sms = dwc_get_master(_chan, SRC_MASTER);           \
>                 u8 _smsize = _is_slave ? _sconfig->src_maxburst :       \
>                         DW_DMA_MSIZE_16;                        \
>                 u8 _dmsize = _is_slave ? _sconfig->dst_maxburst :       \
> @@ -73,20 +89,11 @@ static inline unsigned int dwc_get_sms(struct dw_dma_slave *slave)
>   */
>  #define NR_DESCS_PER_CHANNEL   64
>
> -#define SRC_MASTER     0
> -#define DST_MASTER     1
> -
>  static inline unsigned int dwc_get_data_width(struct dma_chan *chan, int master)
>  {
>         struct dw_dma *dw = to_dw_dma(chan->device);
> -       struct dw_dma_slave *dws = chan->private;
>
> -       if (master == SRC_MASTER)
> -               return dw->data_width[dwc_get_sms(dws)];
> -       else if (master == DST_MASTER)
> -               return dw->data_width[dwc_get_dms(dws)];
> -
> -       return 0;
> +       return dw->data_width[dwc_get_master(chan, master)];
>  }

After fixing these,

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
