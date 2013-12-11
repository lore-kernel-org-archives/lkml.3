Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab3LKV16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:27:58 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62488 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab3LKV14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:27:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH v13] dmaengine: Add MOXA ART DMA engine driver
Date: Wed, 11 Dec 2013 22:27:18 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Jonas Jensen <jonas.jensen@gmail.com>, dmaengine@vger.kernel.org,
        mark.rutland@arm.com, lars@metafoo.de, linux@arm.linux.org.uk,
        vinod.koul@intel.com, linux-kernel@vger.kernel.org, arm@kernel.org,
        djbw@fb.com, andriy.shevchenko@linux.intel.com
References: <1386340059-24738-1-git-send-email-jonas.jensen@gmail.com> <1386774824-1638-1-git-send-email-jonas.jensen@gmail.com>
In-Reply-To: <1386774824-1638-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312112227.19016.arnd@arndb.de>
X-Provags-ID: V02:K0:BPHso7fpCUWIT7m8VQHasw+8gxW9RGaij6wDFE7LRQu
 ZvA4VaYS3xGfdV9Ec2vDg95tWFUmCm+T/7QfjKwY9rDdz10Ev8
 fTMxmLUNJch2B7tnRPXtPixwjHyLcUl6lttwk5ZFRWMQ244iLx
 qXu7KG/IJCEmsKOrVDkiKDDaMXJGAwc8bCbcf9FoJTqlEn3c2t
 gfylAxTj0FVXCQEMQdotP290FPf7oVIN4BBsZUlJYod4KwAFUc
 81dncxMeZ9PjXuAOn+znKWtpJCcR8dXAuMaMeaBERF5HmPLnQD
 EYQGUMPBco8ZG+ESkPRewLEAZwyd97882KITqkvuvod/IduzG3
 7KmOD6bcTzs1cK7lgzKo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't comment on this earlier since you had already gone through 12 revisions
and I didn't want to hold up merging any longer. This can be done as a follow-up,
or you can include it if you end up doing a v14:

On Wednesday 11 December 2013, Jonas Jensen wrote:

> +bool moxart_dma_filter_fn(struct dma_chan *chan, void *param)
> +{
> +       struct moxart_filter_data *fdata = param;
> +       struct moxart_chan *ch = to_moxart_dma_chan(chan);
> +
> +       if (chan->device->dev != fdata->mdc->dma_slave.dev ||
> +           chan->device->dev->of_node != fdata->dma_spec->np) {
> +               dev_dbg(chan2dev(chan), "device not registered to this DMA engine\n");
> +               return false;
> +       }
> +
> +       dev_dbg(chan2dev(chan), "%s: ch=%p line_reqno=%u ch->ch_num=%u\n",
> +               __func__, ch, fdata->dma_spec->args[0], ch->ch_num);
> +
> +       ch->line_reqno = fdata->dma_spec->args[0];
> +
> +       return true;
> +}
> +
> +static struct dma_chan *moxart_of_xlate(struct of_phandle_args *dma_spec,
> +                                       struct of_dma *ofdma)
> +{
> +       struct moxart_dmadev *mdc = ofdma->of_dma_data;
> +       struct moxart_filter_data fdata = {
> +               .mdc = mdc,
> +       };
> +
> +       if (dma_spec->args_count < 1)
> +               return NULL;
> +
> +       fdata.dma_spec = dma_spec;
> +
> +       return dma_request_channel(mdc->dma_slave.cap_mask,
> +                                  moxart_dma_filter_fn, &fdata);
> +}

The moxart_dma_filter_fn should get removed and the moxart_of_xlate() rewritten
based on Stephen Warren's dma_get_any_slave_channel() interface once that
is available in the dmaengine git tree.

	Arnd
