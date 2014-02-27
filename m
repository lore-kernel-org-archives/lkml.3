Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaB0QHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:07:20 -0500
Received: from mail.arcturusnetworks.com ([66.11.68.20]:51890 "EHLO
	mail.arcturusnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaB0QHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:07:16 -0500
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Feb 2014 11:07:16 EST
Message-ID: <530F60F3.10604@arcturusnetworks.com>
Date: Thu, 27 Feb 2014 10:59:47 -0500
From: Oleksandr G Zhadan <oleks@arcturusnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>, Marc Kleine-Budde <mkl@pengutronix.de>
CC: Randy Dunlap <rdunlap@infradead.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        LKML <linux-kernel@vger.kernel.org>, dmaengine@vger.kernel.org
Subject: Re: blackfin + dmaengine: conflicting define/enum "DMA_COMPLETE"
References: <52D188DA.6020904@pengutronix.de> <52D18DE4.2020008@infradead.org> <52D19393.8090608@pengutronix.de> <201401180202.06161.vapier@gentoo.org>
In-Reply-To: <201401180202.06161.vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

It's good to "... matched the manual ...", and in this case we can match 
the manual more pedantically, maybe with prefix "HOST".

In the case of Host DMA port STATUS register:

 From manual :
.... HOST_STATUS register bits include:
• DMA Ready (DMA_RDY)
• FIFO Full (FIFOFULL)
• FIFO Empty (FIFOEMPTY)
• DMA Complete (DMA_CMPLT)
• HOSTDP Handshake (HSHK)
• HOSTDP Timeout (HOSTDP_TOUT)
• HOSTDP Interrupt Request (HIRQ).
• Allow Configurations (ALLOW_CNFG)
• DMA Direction (DMA_DIR)
• Bus Timeout Enabled (BTE)

We could change definitions to something like:

#define DMA_CMPLT    0x08        /* DMA Complete */
or
#define HOST_DMA_CMPLT  0x08    /* DMA Complete */

And make the similar for other bits/registers.

Oleks

On 01/18/2014 02:02 AM, Mike Frysinger wrote:
> On Saturday 11 January 2014 13:55:15 Marc Kleine-Budde wrote:
>> On 01/11/2014 07:31 PM, Randy Dunlap wrote:
>>> On 01/11/2014 10:09 AM, Marc Kleine-Budde wrote:
>>>> Hello,
>>>>
>>>> in current linux-next (and net-next) the compilation of the CAN
>>>>
>>>> drivers[1] with ARCH=blackfin fails with:
>>>>>    CC [M]  drivers/net/can/c_can/c_can.o
>>>>>
>>>>> In file included from linux/include/linux/netdevice.h:38:0,
>>>>>
>>>>>                   from linux/drivers/net/can/c_can/c_can.c:32:
>>>>> linux/include/linux/dmaengine.h:55:2: error: expected identifier before
>>>>> numeric constant linux/include/linux/dmaengine.h: In function
>>>>> 'dma_async_is_complete': linux/include/linux/dmaengine.h:1023:9:
>>>>> error: 'DMA_IN_PROGRESS' undeclared (first use in this function)
>>>>> linux/include/linux/dmaengine.h:1023:9: note: each undeclared
>>>>> identifier is reported only once for each function it appears in
>>>> There are two locations where DMA_COMPLETE is defined:
>>>>> arch/blackfin/mach-bf548/include/mach/defBF547.h:602:#define
>>>>>    DMA_COMPLETE  0x8        /* DMA Complete */
>>>>> arch/blackfin/mach-bf548/include/mach/defBF544.h:622:#define
>>>>>     DMA_COMPLETE  0x8        /* DMA Complete */
>>>> and
>>>>
>>>>> include/linux/dmaengine.h-enum dma_status {
>>>>> include/linux/dmaengine.h:      DMA_COMPLETE,
>>>>> include/linux/dmaengine.h-      DMA_IN_PROGRESS,
>>>>> include/linux/dmaengine.h-      DMA_PAUSED,
>>>>> include/linux/dmaengine.h-      DMA_ERROR,
>>>>> include/linux/dmaengine.h-};
>>>> What's the appropriate fix for the problem?
>>> arch/blackfin/mach-bf548/ needs a less generic name for its macro.
>> Mike, is there a in tree user of blacksfin's DMA_COMPLETE? I cannot find
>> anyone.
> looks like those are defines for the host port peripheral on the BF54x.
> typically for peripherals we didn't have proper drivers for (like CAN and UART
> and SPI and such), we left the defines in the headers.  those in turn matched
> the manual so people coming from other Blackfin environments (and reading the
> manuals) didn't have to figure out what name the Linux headers used.
>
> unfortunately, it leads to cases like this where the names are pretty bad.
> considering the host peripheral most likely never saw any serious use, it
> should be fine to delete all the bit defines in those headers related to those
> registers (i see HOST_{STATUS,CONTROL,TIMEOUT}.
> -mike

