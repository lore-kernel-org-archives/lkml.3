Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934771AbaKMXO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 18:14:29 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:57489 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933920AbaKMXO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 18:14:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Bresticker <abrestic@chromium.org>
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
Subject: Re: [PATCH 2/2] dmaengine: Add driver for IMG MDC
Date: Fri, 14 Nov 2014 00:14:05 +0100
Message-ID: <23608147.9L5xhJDu6b@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL1qeaGvaHmfCHAhVejEqtV-dMVTEGprZJZPOevOmXaSyf8Uyw@mail.gmail.com>
References: <1415912288-26926-1-git-send-email-abrestic@chromium.org> <11336807.gWpZoH7Aih@wuerfel> <CAL1qeaGvaHmfCHAhVejEqtV-dMVTEGprZJZPOevOmXaSyf8Uyw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:0RsPf9QfloTMG2NHtlPV6FXUvNCo926Xb2YjvKlqpgp
 AhjkP6/T0YvujHe5Xd1iCg/QgiA73hT/u/YniWBKHTzQuYzB+s
 fnS4lnumijG5k8PPtTG5Y2b5Nqf/EggEbS1WDPXmC+lGmUXUtv
 A5FYZJBpziT8oe0GmjBPPuIbJK1YCZTaSy3EoK5o747rzhpakg
 BR/7ekhKdgb04zGkp0WgE0DpPGIW1oe08W3fB1f41TizA5c5nh
 qW4J+2kKgfMTOju5Be7PQwvrnWQNRPloTQDAYxGrGCwC7z65j9
 sNJO5WkZ9VSTrASolTvlLo7fB4urjVhSIjTF9uro2L0Euzh0h/
 m1YhLowtcz2oLpzo3SwE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 November 2014 15:07:06 Andrew Bresticker wrote:
> On Thu, Nov 13, 2014 at 2:13 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Thursday 13 November 2014 12:58:08 Andrew Bresticker wrote:
> >> +
> >> +static bool mdc_filter_fn(struct dma_chan *chan, void *fn_param)
> >> +{
> >> +       struct mdc_filter_data *data = fn_param;
> >> +       struct mdc_chan *mchan;
> >> +
> >> +       if (chan->device->dev->driver == &mdc_dma_driver.driver) {
> >> +               mchan = to_mdc_chan(chan);
> >> +               if (!(data->mask & BIT(mchan->chan_nr)))
> >> +                       return false;
> >> +               mchan->periph = data->periph;
> >> +               mchan->thread = data->thread;
> >> +               return true;
> >> +       }
> >> +       return false;
> >> +}
> >> +
> >> +static struct dma_chan *mdc_of_xlate(struct of_phandle_args *dma_spec,
> >> +                                    struct of_dma *ofdma)
> >> +{
> >> +       struct mdc_dma *mdma = ofdma->of_dma_data;
> >> +       struct mdc_filter_data data;
> >> +
> >> +       if (dma_spec->args_count != 3)
> >> +               return NULL;
> >> +
> >> +       data.periph = dma_spec->args[0];
> >> +       data.mask = dma_spec->args[1];
> >> +       data.thread = dma_spec->args[2];
> >> +
> >> +       return dma_request_channel(mdma->dma_dev.cap_mask, mdc_filter_fn,
> >> +                                  &data);
> >> +}
> >
> > The filter function is broken if you ever have multiple instances
> > of the device. Better avoid calling dma_request_channel and scan
> > the channels that the device knows about.
> 
> It seems unlikely that there would be multiple instances of this IP in
> a system, but it doesn't hurt to be safe.  Perhaps instead of
> iterating through the list here I could extend struct mdc_filter_data
> to include a pointer to the struct dma_device corresponding to this
> instance of the MDC and compare based on that.

You still need to iterate through all channels of all dma engines
in the system. Since you have the pointer to the engine here,
just go through the channels that you already know are there.
Unfortunately, the mask prevents you from just using
dma_get_any_slave_channel(), that would be the easiest approach
that we prefer in most drivers these days.

	Arnd
