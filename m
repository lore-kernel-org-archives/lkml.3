Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319Ab3CKNXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 09:23:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63331 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3CKNXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 09:23:37 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Subject: Re: A proposal to check the device in generic way
Date: Mon, 11 Mar 2013 13:23:26 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
References: <1363001537.18714.3.camel@smile>
In-Reply-To: <1363001537.18714.3.camel@smile>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303111323.26783.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:C5YPx1GFjD3dqsO0IHu+9+aoJNAEkmmofmmXwIeqFu8
 P7jwf/P7/6UwK7hY1d2+cFLdsyBKyf1ftbMyghgTaCsdxszp1V
 uIbMCbb0t4klsv9OjtAWUAnsXza2oOVH7t3mvVhx2jAZFYdssj
 5r4QQ4pZorPq4WsFhrfETZ/7WUgNj24pNo5NH5mWUHfTppgai/
 aONcH//eVjx9DfH7ZdpAuOvfF8agY07S3dwtR8uWC7eOBd0dD9
 zDE7iezR8t0jfaaWt1kinxURgNmmHh3MHycwnYD9xhvpgHlFZW
 POZXUbTpR2kYW6TuzZyLCYqEmLk3owh1VHu95LdikEUUidw+0I
 kvCcCnNkQhZjcW7VzGfwu7x/MxtvhgcLjKNktFk7f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 March 2013, Shevchenko, Andriy wrote:
> Hello.
> 
> Currently in linux-next we have the following things:
> 
> $ git grep -n 'chan->device->dev->driver' drivers/dma/
> 
> drivers/dma/amba-pl08x.c:1594:  if (chan->device->dev->driver !=
> &pl08x_amba_driver.drv)
> drivers/dma/dmaengine.c:190:    return chan->device->dev->driver->owner;
> drivers/dma/edma.c:609: if (chan->device->dev->driver ==
> &edma_driver.driver) {
> drivers/dma/omap-dma.c:654:     if (chan->device->dev->driver ==
> &omap_dma_driver.driver) {
> drivers/dma/pl330.c:2374:       if (chan->device->dev->driver !=
> &pl330_driver.drv)
> drivers/dma/sa11x0-dma.c:1080:  if (chan->device->dev->driver ==
> &sa11x0_dma_driver.driver) 
> 
> I think it's a non-generic way to check which driver provides a channel
> into filter function. First of all, I don't get why that comparison goes
> as deep as driver structure. Isn't clearer to check chan->device->dev
> against the struct dev passed in the custom parameter structure? Like:

I agree that checking the driver is wrong and that we should check the
device instead, if we have a filter function called from ->xlate(), which
in turn gets called by dma_request_slave_channel().

Some of the filter functions above are passed to device drivers and
are not used in combination with the DT binding, which implies that
there is nothing to check the device against, so it would not work.

If you look for instance at the pl330 driver, there
are two filter functions: pl330_dt_filter correctly compares the
device pointer, while pl330_filter only gets an integer argument
and cannot compare that to the device.

> struct filter_params {
>  struct dev *dev;
>  void *param;
> };
> 
> bool filter_fn(struct dma_chan *chan, void *fparams)
> {
>   struct filter_params *p = fparams;
>   if (chan->device->dev != p->dev)
>    return false;
>  ...
> }
> 
> In case my idea has a right to live, what about to move such check inside
> DMA engine code?

> Opinions, comments?
> 
> Earlier I tried to discuss this with Arnd here: http://www.spinics.net/lists/arm-kernel/msg220716.html

I think the right solution is to provide an interface in the dmaengine
common code that lets the ->xlate() callback get right at the channel
it wants, rather than call dma_request_channel(). It is rather silly d
a dmaengine driver that has all the information about the dma channel
it wants to return, we have to call back into a common function that
then searches all the channel known to the system.

	Arnd
