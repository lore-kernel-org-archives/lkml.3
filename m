Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab3AOBy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 20:54:58 -0500
Received: from mail-vb0-f53.google.com ([209.85.212.53]:46659 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757011Ab3AOBy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 20:54:56 -0500
MIME-Version: 1.0
In-Reply-To: <1358173253-680-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1358173253-680-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 15 Jan 2013 07:24:55 +0530
X-Google-Sender-Auth: dTkYmGGbgXaSOOC02O0md9ZIb5o
Message-ID: <CAOh2x==d46_R2btWmi1KnmY-TfAGRxHrwSzT6NFVFP-Hp0-0Kw@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: don't exceed AHB master number in dwc_get_data_width
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 7:50 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> The driver's default assumes that hardware has two AHB masters which might be
> not true. In such rare cases we have not to exceed a number of the AHB masters
> present in the hardware. Thus, the AHB master with highest possible number will
> be used to retrieve the data witdh value.
>
> The patch also changes the logic a bit when the master parameter of the
> dwc_get_data_width() is out of range. Now the function will return a value
> related to the first AHB master.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 30ff2a4..b2d564a 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -80,13 +80,14 @@ static inline unsigned int dwc_get_data_width(struct dma_chan *chan, int master)
>  {
>         struct dw_dma *dw = to_dw_dma(chan->device);
>         struct dw_dma_slave *dws = chan->private;
> +       unsigned int m = 0;
>
>         if (master == SRC_MASTER)
> -               return dw->data_width[dwc_get_sms(dws)];
> +               m = dwc_get_sms(dws);
>         else if (master == DST_MASTER)
> -               return dw->data_width[dwc_get_dms(dws)];
> +               m = dwc_get_dms(dws);
>
> -       return 0;
> +       return dw->data_width[min_t(unsigned int, dw->nr_masters - 1, m)];

The details of the patch are fine, but i didn't get how do you get
master 1 selected
on a system where you have only 1 master?
