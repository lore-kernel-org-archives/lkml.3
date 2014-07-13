Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbaGMKTs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 06:19:48 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:42326 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbaGMKTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 06:19:43 -0400
Message-ID: <53C25D3C.9070707@gmail.com>
Date: Sun, 13 Jul 2014 18:19:40 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH] drivers: firewire: Let several sub-modules depend on
 HAS_DMA
References: <53C1F7C4.2010901@gmail.com> <20140713104238.7214db0f@kant>
In-Reply-To: <20140713104238.7214db0f@kant>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2014 04:42 PM, Stefan Richter wrote:
> On Jul 13 Chen Gang wrote:
>>  
>>  config FIREWIRE_OHCI
>>  	tristate "OHCI-1394 controllers"
>> -	depends on PCI && FIREWIRE && MMU
>> +	depends on PCI && FIREWIRE && MMU && HAS_DMA
>>  	help
>>  	  Enable this driver if you have a FireWire controller based
>>  	  on the OHCI specification.  For all practical purposes, this
> 
> As far as I understand, architecture configuration files shall already
> ensure that CONFIG_PCI is not enabled if !CONFIG_HAS_DMA.  If so, this
> part can be omitted.  Or am I mistaken?
> 

Yeah, this part can be omitted, what you said is OK to me. FIREWIER_OHCI
need not append additional "depends on HAS_DMA".
 
>> @@ -45,7 +45,7 @@ config FIREWIRE_SBP2
>>  
>>  config FIREWIRE_NET
>>  	tristate "IP networking over 1394"
>> -	depends on FIREWIRE && INET
>> +	depends on FIREWIRE && INET && HAS_DMA
>>  	help
>>  	  This enables IPv4/IPv6 over IEEE 1394, providing IP connectivity
>>  	  with other implementations of RFC 2734/3146 as found on several
> 
> This is not completely necessary:  firewire-net does not use DMA mapping
> APIs directly, it uses them only through firewire-core.  Same with
> sound/firewire/* (a few audio device drivers) and with
> drivers/media/firewire/* (a DVB device driver) which you did not patch.
> 

Yeah, thanks.

> So they could be *compiled* on architectures without HAS_DMA, they could
> just not be *used* (because firewire-core's isochronous DMA mapping
> functions would return errors, but more so because there are no IEEE 1394
> host bus adapters on these platforms in the first place.  Actually Texas
> Instruments used to make a 1394 HBA chip with some sort of GPIO host
> interface instead of PCI interface, but Linux only has a driver for PCI
> HBAs.)
> 
> But see below.
> 

OK, thank you for your details information.

> 
> All in all, I like the following approach better:
> 
> Date: Wed,  9 Jul 2014 21:04:00 +0200
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> To: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Cc: Jean Delvare <jdelvare@suse.de>, linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
> Subject: [PATCH] firewire: IEEE 1394 (FireWire) support should depend on HAS_DMA
> 
> Commit b3d681a4fc108f9653bbb44e4f4e72db2b8a5734 ("firewire: Use
> COMPILE_TEST for build testing") added COMPILE_TEST as an alternative
> dependency for the purpose of build testing the firewire core.
> However, this bypasses all other implicit dependencies assumed by PCI,
> like HAS_DMA.
> 
> If NO_DMA=y:
> 
>     drivers/built-in.o: In function `fw_iso_buffer_destroy':
>     (.text+0x36a096): undefined reference to `dma_unmap_page'
>     drivers/built-in.o: In function `fw_iso_buffer_map_dma':
>     (.text+0x36a164): undefined reference to `dma_map_page'
>     drivers/built-in.o: In function `fw_iso_buffer_map_dma':
>     (.text+0x36a172): undefined reference to `dma_mapping_error'
>     drivers/built-in.o: In function `sbp2_send_management_orb':
>     sbp2.c:(.text+0x36c6b4): undefined reference to `dma_map_single'
>     sbp2.c:(.text+0x36c6c8): undefined reference to `dma_mapping_error'
>     sbp2.c:(.text+0x36c772): undefined reference to `dma_map_single'
>     sbp2.c:(.text+0x36c786): undefined reference to `dma_mapping_error'
>     sbp2.c:(.text+0x36c854): undefined reference to `dma_unmap_single'
>     sbp2.c:(.text+0x36c872): undefined reference to `dma_unmap_single'
>     drivers/built-in.o: In function `sbp2_map_scatterlist':
>     sbp2.c:(.text+0x36ccbc): undefined reference to `scsi_dma_map'
>     sbp2.c:(.text+0x36cd36): undefined reference to `dma_map_single'
>     sbp2.c:(.text+0x36cd4e): undefined reference to `dma_mapping_error'
>     sbp2.c:(.text+0x36cd84): undefined reference to `scsi_dma_unmap'
>     drivers/built-in.o: In function `sbp2_unmap_scatterlist':
>     sbp2.c:(.text+0x36cda6): undefined reference to `scsi_dma_unmap'
>     sbp2.c:(.text+0x36cdc6): undefined reference to `dma_unmap_single'
>     drivers/built-in.o: In function `complete_command_orb':
>     sbp2.c:(.text+0x36d6ac): undefined reference to `dma_unmap_single'
>     drivers/built-in.o: In function `sbp2_scsi_queuecommand':
>     sbp2.c:(.text+0x36d8e0): undefined reference to `dma_map_single'
>     sbp2.c:(.text+0x36d8f6): undefined reference to `dma_mapping_error'
> 
> Add an explicit dependency on HAS_DMA to fix this.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Reviewed-by: Jean Delvare <jdelvare@suse.de>
> ---
>  drivers/firewire/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/firewire/Kconfig b/drivers/firewire/Kconfig
> index 4199849e3758..145974f9662b 100644
> --- a/drivers/firewire/Kconfig
> +++ b/drivers/firewire/Kconfig
> @@ -1,4 +1,5 @@
>  menu "IEEE 1394 (FireWire) support"
> +	depends on HAS_DMA
>  	depends on PCI || COMPILE_TEST
>  	# firewire-core does not depend on PCI but is
>  	# not useful without PCI controller driver
> 
> As a downside, this removes the ability to test-build the sound and DVB
> high-level 1394 drivers (and firewire-net) on !HAS_DMA architectures.
> But on the positive side, it is simpler.  If there are no objections,
> I am going to commit Geert's fix.
> 

What Geert has done (patch and comments) also sounds fine to me. Thank
you for all of your work.


Thanks.
-- 
Chen Gang

Open share and attitude like air water and life which God blessed
