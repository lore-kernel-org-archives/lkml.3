Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaGUIW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:22:57 -0400
Received: from smtp-out-064.synserver.de ([212.40.185.64]:1091 "EHLO
	smtp-out-064.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbaGUIW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:22:56 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 4630
Message-ID: <53CCCDAD.5080001@metafoo.de>
Date: Mon, 21 Jul 2014 10:22:05 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dan Williams <dan.j.williams@intel.com>
CC: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] dmaengine: pl330: Check if the DMA descriptor is
 NULL
References: <1405732907-30964-1-git-send-email-javier.martinez@collabora.co.uk> <53CBCFBF.1040208@metafoo.de> <53CC032C.4000105@collabora.co.uk>
In-Reply-To: <53CC032C.4000105@collabora.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2014 07:58 PM, Javier Martinez Canillas wrote:
> Hello Lars-Peter,
>
> On 07/20/2014 04:18 PM, Lars-Peter Clausen wrote:
>> On 07/19/2014 03:21 AM, Javier Martinez Canillas wrote:
>>> Commit 6079d38 ("dmaengine: pl330: Remove useless xfer_cb indirection")
>>> removed the __callback() function which created an unnecessary level of
>>> indirection to execute the tranfer callback .xfer_cb
>>>
>>> Unfortunately the commit also changed the semantics slightly since that
>>> function used to check if the request was not NULL before attempting to
>>> execute the callback function. Not checking this could lead to a kernel
>>> NULL pointer dereference error.
>>
>> This should not happen, but I guess it can happen when terminal_all() is
>
> I should had mentioned before that this patch is not trying to fix a theoretical
> issue but a kernel oops when booting linux next-20140718 on a Exynos5420 SoC
> based Chromebook 2 machine.
>
> I'm sending as an attachment the complete kernel crash log but the problem
> happens when the spi_master .unprepare_transfer_hardware function handler in the
> spi-s3c64xx driver tries to release a DMA channel:
>
> s3c64xx_spi_unprepare_transfer() ->
> dma_release_channel() ->
> dma_chan_put() ->
> chan->device->device_free_chan_resources() ->
> pl330_free_chan_resources() ->
> pl330_release_channel() ->
> dma_pl330_rqcb()
>
>> called. (It's wrong to try to complete a descriptor from terminal_all() in
>> the first place, but that's a different issue)
>
> If this should not really happen and this patch is only a workaround since the
> bug is elsewhere, please give me some hints and I'll try to fix it properly. I'm
> not familiar with the PL330 DMA controller but just found what was the NULL
> pointer being dereferenced and looked at your changes to see what was different now.

I think the patch is fine as a quick workaround since it is simple and the 
previous commit broke previously working code.

The long term fix is to stop calling dma_pl330_rqcb() from 
pl330_release_channel(). The first thing is you wouldn't expect any transfer 
to be active when the channel is released. And even if it was by accident we 
should not call the descriptor callback, but rather but it just back onto 
the descriptor pool.

- Lars

