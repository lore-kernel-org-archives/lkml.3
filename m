Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbaGTR6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 13:58:15 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:51277 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbaGTR6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 13:58:10 -0400
Message-ID: <53CC032C.4000105@collabora.co.uk>
Date: Sun, 20 Jul 2014 19:58:04 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>,
        Dan Williams <dan.j.williams@intel.com>
CC: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] dmaengine: pl330: Check if the DMA descriptor is
 NULL
References: <1405732907-30964-1-git-send-email-javier.martinez@collabora.co.uk> <53CBCFBF.1040208@metafoo.de>
In-Reply-To: <53CBCFBF.1040208@metafoo.de>
Content-Type: multipart/mixed;
 boundary="------------050901080808090509040508"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050901080808090509040508
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello Lars-Peter,

On 07/20/2014 04:18 PM, Lars-Peter Clausen wrote:
> On 07/19/2014 03:21 AM, Javier Martinez Canillas wrote:
>> Commit 6079d38 ("dmaengine: pl330: Remove useless xfer_cb indirection")
>> removed the __callback() function which created an unnecessary level of
>> indirection to execute the tranfer callback .xfer_cb
>>
>> Unfortunately the commit also changed the semantics slightly since that
>> function used to check if the request was not NULL before attempting to
>> execute the callback function. Not checking this could lead to a kernel
>> NULL pointer dereference error.
> 
> This should not happen, but I guess it can happen when terminal_all() is 

I should had mentioned before that this patch is not trying to fix a theoretical
issue but a kernel oops when booting linux next-20140718 on a Exynos5420 SoC
based Chromebook 2 machine.

I'm sending as an attachment the complete kernel crash log but the problem
happens when the spi_master .unprepare_transfer_hardware function handler in the
spi-s3c64xx driver tries to release a DMA channel:

s3c64xx_spi_unprepare_transfer() ->
dma_release_channel() ->
dma_chan_put() ->
chan->device->device_free_chan_resources() ->
pl330_free_chan_resources() ->
pl330_release_channel() ->
dma_pl330_rqcb()

> called. (It's wrong to try to complete a descriptor from terminal_all() in 
> the first place, but that's a different issue)

If this should not really happen and this patch is only a workaround since the
bug is elsewhere, please give me some hints and I'll try to fix it properly. I'm
not familiar with the PL330 DMA controller but just found what was the NULL
pointer being dereferenced and looked at your changes to see what was different now.

> 
>>
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> 
> Acked-by: Lars-Peter Clausen <lars@metafoo.de>
> 

Thanks a lot and best regards,
Javier

--------------050901080808090509040508
Content-Type: text/x-log;
 name="kernel_oops.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kernel_oops.log"

[    1.973959] Unable to handle kernel NULL pointer dereference at virtual address 00000050
[    1.981807] pgd = 80004000
[    1.984496] [00000050] *pgd=00000000
[    1.988056] Internal error: Oops: 5 [#1] SMP ARM
[    1.992651] Modules linked in:
[    1.995689] CPU: 1 PID: 71 Comm: spi2 Not tainted 3.16.0-rc5-next-20140718-00021-ga43ca5e #451
[    2.004276] task: de5bd400 ti: de63c000 task.ti: de63c000
[    2.009657] PC is at dma_pl330_rqcb.isra.2+0x14/0x64
[    2.014599] LR is at pl330_release_channel.part.3+0x34/0xa8
[    2.020151] pc : [<8027b140>]    lr : [<8027b5f8>]    psr: 60000193
[    2.020151] sp : de63de48  ip : de63de68  fp : de63de64
[    2.031601] r10: 00000000  r9 : 00000000  r8 : 00000000
[    2.036806] r7 : de4eb270  r6 : 60000113  r5 : 0000000c  r4 : de5dd000
[    2.043312] r3 : de5dd000  r2 : 00000000  r1 : 00020001  r0 : 00000000
[    2.049819] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[    2.057192] Control: 10c5387d  Table: 4000406a  DAC: 00000015
[    2.062918] Process spi2 (pid: 71, stack limit = 0xde63c248)
[    2.068556] Stack: (0xde63de48 to 0xde63e000)
[    2.072896] de40:                   de5dd000 de5dd000 0000000c 60000113 de63de7c de63de68
[    2.081050] de60: 8027b5f8 8027b138 de499300 de49935c de63de9c de63de80 8027b6bc 8027b5d0
[    2.089204] de80: 8027b66c de499314 de4eb000 00000000 de63deb4 de63dea0 80278c94 8027b678
[    2.097359] dea0: 00000001 de499314 de63decc de63deb8 80278cf4 80278c44 de4eb2e8 de4eb000
[    2.105513] dec0: de63dee4 de63ded0 802f0220 80278ca4 802f01f0 de4eb248 de63df1c de63dee8
[    2.113668] dee0: 802eee8c 802f01fc de4eb224 de4eb248 de63c000 de4eb224 de4eb248 de63c000
[    2.121822] df00: de63c000 00000000 00000000 00000000 de63df44 de63df20 8003c810 802eee04
[    2.129977] df20: 00000000 de613b00 00000000 de4eb224 8003c72c 00000000 de63dfac de63df48
[    2.138131] df40: 8003ca90 8003c738 decdbc00 00000000 de63df6c de4eb224 00000000 00000000
[    2.146286] df60: dead4ead ffffffff ffffffff de63df6c de63df6c 00000000 00000000 dead4ead
[    2.154440] df80: ffffffff ffffffff de63df88 de63df88 de613b00 8003c998 00000000 00000000
[    2.162595] dfa0: 00000000 de63dfb0 8000e3d8 8003c9a4 00000000 00000000 00000000 00000000
[    2.170749] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    2.178904] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[    2.187067] [<8027b140>] (dma_pl330_rqcb.isra.2) from [<8027b5f8>] (pl330_release_channel.part.3+0x34/0xa8)
[    2.196776] [<8027b5f8>] (pl330_release_channel.part.3) from [<8027b6bc>] (pl330_free_chan_resources+0x50/0xac)
[    2.206839] [<8027b6bc>] (pl330_free_chan_resources) from [<80278c94>] (dma_chan_put+0x5c/0x60)
[    2.215513] [<80278c94>] (dma_chan_put) from [<80278cf4>] (dma_release_channel+0x5c/0xa0)
[    2.223676] [<80278cf4>] (dma_release_channel) from [<802f0220>] (s3c64xx_spi_unprepare_transfer+0x30/0x50)
[    2.233387] [<802f0220>] (s3c64xx_spi_unprepare_transfer) from [<802eee8c>] (spi_pump_messages+0x94/0x534)
[    2.243018] [<802eee8c>] (spi_pump_messages) from [<8003c810>] (kthread_worker_fn+0xe4/0x144)
[    2.251516] [<8003c810>] (kthread_worker_fn) from [<8003ca90>] (kthread+0xf8/0x10c)
[    2.259153] [<8003ca90>] (kthread) from [<8000e3d8>] (ret_from_fork+0x14/0x20)
[    2.266350] Code: e92dd878 e24cb004 e92d4000 e8bd4000 (e5904050)
[    2.272436] ---[ end trace 30023402b522a7ab ]---


--------------050901080808090509040508--
