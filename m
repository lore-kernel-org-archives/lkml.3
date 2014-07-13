Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaGMInF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 04:43:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41487 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbaGMIm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 04:42:57 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 13 Jul 2014 10:42:38 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH] drivers: firewire: Let several sub-modules depend on
 HAS_DMA
Message-ID: <20140713104238.7214db0f@kant>
In-Reply-To: <53C1F7C4.2010901@gmail.com>
References: <53C1F7C4.2010901@gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 13 Chen Gang wrote:
> Several sub-modules of 'firewire' need HAS_DMA, so let them depend on it.
> FIREWIRE_NET and FIREWIRE_OHCI use 'core-iso.c' which also needs HAS_DMA,
> so need 'ifdef' the related function by CONFIG_HAS_DMA in 'core-iso.c'.
> 
> The related error (with allmodconfig under score):
> 
>     MODPOST 1365 modules
>   ERROR: "dma_mapping_error" [drivers/firewire/firewire-sbp2.ko] undefined!
>   ERROR: "dma_map_single" [drivers/firewire/firewire-sbp2.ko] undefined!
>   ERROR: "dma_unmap_single" [drivers/firewire/firewire-sbp2.ko] undefined!
>   ERROR: "scsi_dma_map" [drivers/firewire/firewire-sbp2.ko] undefined!
>   ERROR: "scsi_dma_unmap" [drivers/firewire/firewire-sbp2.ko] undefined!
>   ERROR: "dma_mapping_error" [drivers/firewire/firewire-core.ko] undefined!
>   ERROR: "dma_map_page" [drivers/firewire/firewire-core.ko] undefined!
>   ERROR: "dma_unmap_page" [drivers/firewire/firewire-core.ko] undefined!
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  drivers/firewire/Kconfig    |  6 +++---
>  drivers/firewire/core-iso.c | 15 +++++++++++++++
>  2 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/firewire/Kconfig b/drivers/firewire/Kconfig
> index 4199849..fd75278 100644
> --- a/drivers/firewire/Kconfig
> +++ b/drivers/firewire/Kconfig
> @@ -19,7 +19,7 @@ config FIREWIRE
>  
>  config FIREWIRE_OHCI
>  	tristate "OHCI-1394 controllers"
> -	depends on PCI && FIREWIRE && MMU
> +	depends on PCI && FIREWIRE && MMU && HAS_DMA
>  	help
>  	  Enable this driver if you have a FireWire controller based
>  	  on the OHCI specification.  For all practical purposes, this

As far as I understand, architecture configuration files shall already
ensure that CONFIG_PCI is not enabled if !CONFIG_HAS_DMA.  If so, this
part can be omitted.  Or am I mistaken?


> @@ -30,7 +30,7 @@ config FIREWIRE_OHCI
>  
>  config FIREWIRE_SBP2
>  	tristate "Storage devices (SBP-2 protocol)"
> -	depends on FIREWIRE && SCSI
> +	depends on FIREWIRE && SCSI && HAS_DMA
>  	help
>  	  This option enables you to use SBP-2 devices connected to a
>  	  FireWire bus.  SBP-2 devices include storage devices like

This is correct.


> @@ -45,7 +45,7 @@ config FIREWIRE_SBP2
>  
>  config FIREWIRE_NET
>  	tristate "IP networking over 1394"
> -	depends on FIREWIRE && INET
> +	depends on FIREWIRE && INET && HAS_DMA
>  	help
>  	  This enables IPv4/IPv6 over IEEE 1394, providing IP connectivity
>  	  with other implementations of RFC 2734/3146 as found on several

This is not completely necessary:  firewire-net does not use DMA mapping
APIs directly, it uses them only through firewire-core.  Same with
sound/firewire/* (a few audio device drivers) and with
drivers/media/firewire/* (a DVB device driver) which you did not patch.

So they could be *compiled* on architectures without HAS_DMA, they could
just not be *used* (because firewire-core's isochronous DMA mapping
functions would return errors, but more so because there are no IEEE 1394
host bus adapters on these platforms in the first place.  Actually Texas
Instruments used to make a 1394 HBA chip with some sort of GPIO host
interface instead of PCI interface, but Linux only has a driver for PCI
HBAs.)

But see below.


> diff --git a/drivers/firewire/core-iso.c b/drivers/firewire/core-iso.c
> index 38c0aa6..995f038 100644
> --- a/drivers/firewire/core-iso.c
> +++ b/drivers/firewire/core-iso.c
> @@ -64,6 +64,7 @@ int fw_iso_buffer_alloc(struct fw_iso_buffer *buffer, int page_count)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_HAS_DMA
>  int fw_iso_buffer_map_dma(struct fw_iso_buffer *buffer, struct fw_card *card,
>  			  enum dma_data_direction direction)
>  {
> @@ -86,6 +87,13 @@ int fw_iso_buffer_map_dma(struct fw_iso_buffer *buffer, struct fw_card *card,
>  
>  	return 0;
>  }
> +#else
> +int fw_iso_buffer_map_dma(struct fw_iso_buffer *buffer, struct fw_card *card,
> +			  enum dma_data_direction direction)
> +{
> +	return -ENXIO;
> +}
> +#endif
>  
>  int fw_iso_buffer_init(struct fw_iso_buffer *buffer, struct fw_card *card,
>  		       int page_count, enum dma_data_direction direction)
> @@ -122,6 +130,7 @@ int fw_iso_buffer_map_vma(struct fw_iso_buffer *buffer,
>  	return 0;
>  }
>  
> +#ifdef CONFIG_HAS_DMA
>  void fw_iso_buffer_destroy(struct fw_iso_buffer *buffer,
>  			   struct fw_card *card)
>  {
> @@ -141,6 +150,12 @@ void fw_iso_buffer_destroy(struct fw_iso_buffer *buffer,
>  	buffer->page_count = 0;
>  	buffer->page_count_mapped = 0;
>  }
> +#else
> +void fw_iso_buffer_destroy(struct fw_iso_buffer *buffer,
> +			   struct fw_card *card)
> +{
> +}
> +#endif
>  EXPORT_SYMBOL(fw_iso_buffer_destroy);
>  
>  /* Convert DMA address to offset into virtually contiguous buffer. */

All in all, I like the following approach better:

Date: Wed,  9 Jul 2014 21:04:00 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Jean Delvare <jdelvare@suse.de>, linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] firewire: IEEE 1394 (FireWire) support should depend on HAS_DMA

Commit b3d681a4fc108f9653bbb44e4f4e72db2b8a5734 ("firewire: Use
COMPILE_TEST for build testing") added COMPILE_TEST as an alternative
dependency for the purpose of build testing the firewire core.
However, this bypasses all other implicit dependencies assumed by PCI,
like HAS_DMA.

If NO_DMA=y:

    drivers/built-in.o: In function `fw_iso_buffer_destroy':
    (.text+0x36a096): undefined reference to `dma_unmap_page'
    drivers/built-in.o: In function `fw_iso_buffer_map_dma':
    (.text+0x36a164): undefined reference to `dma_map_page'
    drivers/built-in.o: In function `fw_iso_buffer_map_dma':
    (.text+0x36a172): undefined reference to `dma_mapping_error'
    drivers/built-in.o: In function `sbp2_send_management_orb':
    sbp2.c:(.text+0x36c6b4): undefined reference to `dma_map_single'
    sbp2.c:(.text+0x36c6c8): undefined reference to `dma_mapping_error'
    sbp2.c:(.text+0x36c772): undefined reference to `dma_map_single'
    sbp2.c:(.text+0x36c786): undefined reference to `dma_mapping_error'
    sbp2.c:(.text+0x36c854): undefined reference to `dma_unmap_single'
    sbp2.c:(.text+0x36c872): undefined reference to `dma_unmap_single'
    drivers/built-in.o: In function `sbp2_map_scatterlist':
    sbp2.c:(.text+0x36ccbc): undefined reference to `scsi_dma_map'
    sbp2.c:(.text+0x36cd36): undefined reference to `dma_map_single'
    sbp2.c:(.text+0x36cd4e): undefined reference to `dma_mapping_error'
    sbp2.c:(.text+0x36cd84): undefined reference to `scsi_dma_unmap'
    drivers/built-in.o: In function `sbp2_unmap_scatterlist':
    sbp2.c:(.text+0x36cda6): undefined reference to `scsi_dma_unmap'
    sbp2.c:(.text+0x36cdc6): undefined reference to `dma_unmap_single'
    drivers/built-in.o: In function `complete_command_orb':
    sbp2.c:(.text+0x36d6ac): undefined reference to `dma_unmap_single'
    drivers/built-in.o: In function `sbp2_scsi_queuecommand':
    sbp2.c:(.text+0x36d8e0): undefined reference to `dma_map_single'
    sbp2.c:(.text+0x36d8f6): undefined reference to `dma_mapping_error'

Add an explicit dependency on HAS_DMA to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
---
 drivers/firewire/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firewire/Kconfig b/drivers/firewire/Kconfig
index 4199849e3758..145974f9662b 100644
--- a/drivers/firewire/Kconfig
+++ b/drivers/firewire/Kconfig
@@ -1,4 +1,5 @@
 menu "IEEE 1394 (FireWire) support"
+	depends on HAS_DMA
 	depends on PCI || COMPILE_TEST
 	# firewire-core does not depend on PCI but is
 	# not useful without PCI controller driver

As a downside, this removes the ability to test-build the sound and DVB
high-level 1394 drivers (and firewire-net) on !HAS_DMA architectures.
But on the positive side, it is simpler.  If there are no objections,
I am going to commit Geert's fix.
-- 
Stefan Richter
-=====-====- -=== -==-=
http://arcgraph.de/sr/
