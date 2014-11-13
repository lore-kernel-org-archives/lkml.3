Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964908AbaKMXkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 18:40:33 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:59338 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964887AbaKMXkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 18:40:31 -0500
MIME-Version: 1.0
In-Reply-To: <23608147.9L5xhJDu6b@wuerfel>
References: <1415912288-26926-1-git-send-email-abrestic@chromium.org>
	<11336807.gWpZoH7Aih@wuerfel>
	<CAL1qeaGvaHmfCHAhVejEqtV-dMVTEGprZJZPOevOmXaSyf8Uyw@mail.gmail.com>
	<23608147.9L5xhJDu6b@wuerfel>
Date: Thu, 13 Nov 2014 15:40:30 -0800
X-Google-Sender-Auth: yQF6jaO2XKuzaY0L1qhnWU818qA
Message-ID: <CAL1qeaE7BixrsBn5EUMXOb4wweV4ARXc8T9AegNrauL=uJ=SqA@mail.gmail.com>
Subject: Re: [PATCH 2/2] dmaengine: Add driver for IMG MDC
From: Andrew Bresticker <abrestic@chromium.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        James Hartley <james.hartley@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        Ezequiel Garcia <ezequiel.garcia@imgtec.com>,
        Damien Horsley <Damien.Horsley@imgtec.com>, dmaengine@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 3:14 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 13 November 2014 15:07:06 Andrew Bresticker wrote:
>> On Thu, Nov 13, 2014 at 2:13 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Thursday 13 November 2014 12:58:08 Andrew Bresticker wrote:
>> >> +
>> >> +static bool mdc_filter_fn(struct dma_chan *chan, void *fn_param)
>> >> +{
>> >> +       struct mdc_filter_data *data = fn_param;
>> >> +       struct mdc_chan *mchan;
>> >> +
>> >> +       if (chan->device->dev->driver == &mdc_dma_driver.driver) {
>> >> +               mchan = to_mdc_chan(chan);
>> >> +               if (!(data->mask & BIT(mchan->chan_nr)))
>> >> +                       return false;
>> >> +               mchan->periph = data->periph;
>> >> +               mchan->thread = data->thread;
>> >> +               return true;
>> >> +       }
>> >> +       return false;
>> >> +}
>> >> +
>> >> +static struct dma_chan *mdc_of_xlate(struct of_phandle_args *dma_spec,
>> >> +                                    struct of_dma *ofdma)
>> >> +{
>> >> +       struct mdc_dma *mdma = ofdma->of_dma_data;
>> >> +       struct mdc_filter_data data;
>> >> +
>> >> +       if (dma_spec->args_count != 3)
>> >> +               return NULL;
>> >> +
>> >> +       data.periph = dma_spec->args[0];
>> >> +       data.mask = dma_spec->args[1];
>> >> +       data.thread = dma_spec->args[2];
>> >> +
>> >> +       return dma_request_channel(mdma->dma_dev.cap_mask, mdc_filter_fn,
>> >> +                                  &data);
>> >> +}
>> >
>> > The filter function is broken if you ever have multiple instances
>> > of the device. Better avoid calling dma_request_channel and scan
>> > the channels that the device knows about.
>>
>> It seems unlikely that there would be multiple instances of this IP in
>> a system, but it doesn't hurt to be safe.  Perhaps instead of
>> iterating through the list here I could extend struct mdc_filter_data
>> to include a pointer to the struct dma_device corresponding to this
>> instance of the MDC and compare based on that.
>
> You still need to iterate through all channels of all dma engines
> in the system. Since you have the pointer to the engine here,
> just go through the channels that you already know are there.
> Unfortunately, the mask prevents you from just using
> dma_get_any_slave_channel(), that would be the easiest approach
> that we prefer in most drivers these days.

Ok, I'll do that then.
