Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab3LWQVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:21:10 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51808 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764Ab3LWQVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:21:04 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 23 Dec 2013 17:20:21 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Lubomir Rintel <lkundrak@v3.sk>, linux-kernel@vger.kernel.org
Cc: linux1394-devel@lists.sourceforge.net,
        Dave Hansen <dave.hansen@linux.intel.com>, security@kernel.org
Subject: security review needed - Re: [PATCH] ohci: Turn remote DMA support
 into a module parameter
Message-ID: <20131223172021.2c8a8f48@stein>
In-Reply-To: <1387708462-12139-1-git-send-email-lkundrak@v3.sk>
References: <1387708462-12139-1-git-send-email-lkundrak@v3.sk>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 22 Lubomir Rintel wrote:
> This makes it possible to debug kernel over FireWire without the need to
> recompile it.
> 
> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>

Looks good to me.  A load-time option is preferable over a compile-time
option not only from the POV of the debugging use case, but also from the
maintenance POV.

It weakens security in two scenarios though, AFAICS:

A)
  - There are firewire-ohci and firewire-sbp2 installed on the machine,
  - the attacker cannot upload code
  - but can load kernel modules
  - and has physical access to a 1394 port
  - and is not able to run a minimal SBP-2 target on the remote 1394 end.

B)
  - There is firewire-ohci but not firewire-sbp2 installed on the machine,
  - the attacker cannot upload code
  - but can load kernel modules
  - and has physical access to a 1394 port.

(In both scenarios, the attacker additionally has to be able to /un/load
kernel modules if firewire-ohci was loaded already before the attack.)

That's both quite specific.  Hence the security impact of this patch is
negligible in my opinion.  Any other opinions or insights into it?

> ---
>  Documentation/debugging-via-ohci1394.txt |  4 +---
>  drivers/firewire/ohci.c                  | 19 +++++++++++--------
>  lib/Kconfig.debug                        | 11 -----------
>  3 files changed, 12 insertions(+), 22 deletions(-)
> 
> diff --git a/Documentation/debugging-via-ohci1394.txt b/Documentation/debugging-via-ohci1394.txt
> index 14d1944..73473aa 100644
> --- a/Documentation/debugging-via-ohci1394.txt
> +++ b/Documentation/debugging-via-ohci1394.txt
> @@ -38,9 +38,7 @@ Drivers
>  
>  The firewire-ohci driver in drivers/firewire uses filtered physical
>  DMA by default, which is more secure but not suitable for remote debugging.
> -Compile the driver with CONFIG_FIREWIRE_OHCI_REMOTE_DMA (Kernel hacking menu:
> -Remote debugging over FireWire with firewire-ohci) to get unfiltered physical
> -DMA.
> +Pass the remote_dma=1 parameter to the driver to get unfiltered physical DMA.
>  
>  Because the firewire-ohci driver depends on the PCI enumeration to be
>  completed, an initialization routine which runs pretty early has been
> diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
> index 6aa8a86..6313735 100644
> --- a/drivers/firewire/ohci.c
> +++ b/drivers/firewire/ohci.c
> @@ -370,6 +370,10 @@ MODULE_PARM_DESC(debug, "Verbose logging (default = 0"
>  	", busReset events = "	__stringify(OHCI_PARAM_DEBUG_BUSRESETS)
>  	", or a combination, or all = -1)");
>  
> +static bool param_remote_dma;
> +module_param_named(remote_dma, param_remote_dma, bool, 0444);

Permissions could also be 0644; then it would not be required to unload
firewire-ohci before altering the mode.  A hot change of this parameter
would only become effective after a 1394 bus reset though.  0444 keep
things simpler to understand though.

> +MODULE_PARM_DESC(remote_dma, "Enable unfiltered remote DMA (default = 0)");

Trivial comment:  I suggest the wording 'default = N' here.
0/1, n/y, or N/Y can be used to set the parameter value, but N/Y will be
shown as value in sysfs.

> +
>  static void log_irqs(struct fw_ohci *ohci, u32 evt)
>  {
>  	if (likely(!(param_debug &
> @@ -2050,10 +2054,10 @@ static void bus_reset_work(struct work_struct *work)
>  			  be32_to_cpu(ohci->next_header));
>  	}
>  
> -#ifdef CONFIG_FIREWIRE_OHCI_REMOTE_DMA
> -	reg_write(ohci, OHCI1394_PhyReqFilterHiSet, ~0);
> -	reg_write(ohci, OHCI1394_PhyReqFilterLoSet, ~0);
> -#endif
> +	if (param_remote_dma) {
> +		reg_write(ohci, OHCI1394_PhyReqFilterHiSet, ~0);
> +		reg_write(ohci, OHCI1394_PhyReqFilterLoSet, ~0);
> +	}
>  
>  	spin_unlock_irq(&ohci->lock);
>  
> @@ -2587,13 +2591,13 @@ static int ohci_cancel_packet(struct fw_card *card, struct fw_packet *packet)
>  static int ohci_enable_phys_dma(struct fw_card *card,
>  				int node_id, int generation)
>  {
> -#ifdef CONFIG_FIREWIRE_OHCI_REMOTE_DMA
> -	return 0;
> -#else
>  	struct fw_ohci *ohci = fw_ohci(card);
>  	unsigned long flags;
>  	int n, ret = 0;
>  
> +	if (param_remote_dma)
> +		return 0;
> +
>  	/*
>  	 * FIXME:  Make sure this bitmask is cleared when we clear the busReset
>  	 * interrupt bit.  Clear physReqResourceAllBuses on bus reset.
> @@ -2622,7 +2626,6 @@ static int ohci_enable_phys_dma(struct fw_card *card,
>  	spin_unlock_irqrestore(&ohci->lock, flags);
>  
>  	return ret;
> -#endif /* CONFIG_FIREWIRE_OHCI_REMOTE_DMA */
>  }
>  
>  static u32 ohci_read_csr(struct fw_card *card, int csr_offset)
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index db25707..dc30284 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1547,17 +1547,6 @@ config PROVIDE_OHCI1394_DMA_INIT
>  
>  	  See Documentation/debugging-via-ohci1394.txt for more information.
>  
> -config FIREWIRE_OHCI_REMOTE_DMA
> -	bool "Remote debugging over FireWire with firewire-ohci"
> -	depends on FIREWIRE_OHCI
> -	help
> -	  This option lets you use the FireWire bus for remote debugging
> -	  with help of the firewire-ohci driver. It enables unfiltered
> -	  remote DMA in firewire-ohci.
> -	  See Documentation/debugging-via-ohci1394.txt for more information.
> -
> -	  If unsure, say N.
> -
>  config BUILD_DOCSRC
>  	bool "Build targets in Documentation/ tree"
>  	depends on HEADERS_CHECK



-- 
Stefan Richter
-=====-===-= ==-- =-===
http://arcgraph.de/sr/
