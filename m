Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbaEXSg5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 14:36:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59913 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751133AbaEXSgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 14:36:54 -0400
Date: Sat, 24 May 2014 15:36:14 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Gianluca Anzolin <gianluca@sottospazio.it>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] parport: Add support for the WCH353 1S/1P multi-IO card
Message-ID: <20140524183614.GA27495@arch.cereza>
References: <1400955891-27294-1-git-send-email-ezequiel.garcia@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400955891-27294-1-git-send-email-ezequiel.garcia@free-electrons.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Ccing linux-serial)

On 24 May 03:24 PM, Ezequiel Garcia wrote:
> This Multi-IO card has one serial 16550-like and one parallel port connector.
> Here's the lspci output, after this commit is applied:
> 
> 03:07.0 Serial controller: Device 4348:5053 (rev 10) (prog-if 02 [16550])
> 	Subsystem: Device 4348:5053
> 	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Interrupt: pin A routed to IRQ 21
> 	Region 0: I/O ports at cf00 [size=8]
> 	Region 1: I/O ports at ce00 [size=8]
> 	Kernel driver in use: parport_serial
> 	Kernel modules: 8250_pci, parport_serial
> 
> This commit adds an entry with the device ID to the blacklist declared in
> 8250_pci to prevent the driver from taking ownership. Also, and as was done
> for the 2S/1P variant, add a quirk to skip autodetection and set the correct
> type to 16550A clone.
> 
> Proper entries are added to parport_serial, to support the device parallel
> and serial ports.
> 
> Cc: Gianluca Anzolin <gianluca@sottospazio.it>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> ---
>  drivers/parport/parport_serial.c   |  9 +++++++++
>  drivers/tty/serial/8250/8250_pci.c | 10 ++++++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/drivers/parport/parport_serial.c b/drivers/parport/parport_serial.c
> index ff53314..ee93200 100644
> --- a/drivers/parport/parport_serial.c
> +++ b/drivers/parport/parport_serial.c
> @@ -62,6 +62,7 @@ enum parport_pc_pci_cards {
>  	timedia_9079a,
>  	timedia_9079b,
>  	timedia_9079c,
> +	wch_ch353_1s1p,
>  	wch_ch353_2s1p,
>  	sunix_2s1p,
>  };
> @@ -148,6 +149,7 @@ static struct parport_pc_pci cards[] = {
>  	/* timedia_9079a */             { 1, { { 2, 3 }, } },
>  	/* timedia_9079b */             { 1, { { 2, 3 }, } },
>  	/* timedia_9079c */             { 1, { { 2, 3 }, } },
> +	/* wch_ch353_1s1p*/             { 1, { { 1, -1}, } },
>  	/* wch_ch353_2s1p*/             { 1, { { 2, -1}, } },
>  	/* sunix_2s1p */                { 1, { { 3, -1 }, } },
>  };
> @@ -253,6 +255,7 @@ static struct pci_device_id parport_serial_pci_tbl[] = {
>  	{ 0x1409, 0x7168, 0x1409, 0xd079, 0, 0, timedia_9079c },
>  
>  	/* WCH CARDS */
> +	{ 0x4348, 0x5053, PCI_ANY_ID, PCI_ANY_ID, 0, 0, wch_ch353_1s1p},
>  	{ 0x4348, 0x7053, 0x4348, 0x3253, 0, 0, wch_ch353_2s1p},
>  
>  	/*
> @@ -479,6 +482,12 @@ static struct pciserial_board pci_parport_serial_boards[] = {
>  		.base_baud	= 921600,
>  		.uart_offset	= 8,
>  	},
> +	[wch_ch353_1s1p] = {
> +		.flags          = FL_BASE0|FL_BASE_BARS,
> +		.num_ports      = 1,
> +		.base_baud      = 115200,
> +		.uart_offset    = 8,
> +	},
>  	[wch_ch353_2s1p] = {
>  		.flags          = FL_BASE0|FL_BASE_BARS,
>  		.num_ports      = 2,
> diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
> index b14bcba..f35a85f 100644
> --- a/drivers/tty/serial/8250/8250_pci.c
> +++ b/drivers/tty/serial/8250/8250_pci.c
> @@ -1778,6 +1778,7 @@ pci_wch_ch353_setup(struct serial_private *priv,
>  #define PCI_DEVICE_ID_WCH_CH352_2S	0x3253
>  #define PCI_DEVICE_ID_WCH_CH353_4S	0x3453
>  #define PCI_DEVICE_ID_WCH_CH353_2S1PF	0x5046
> +#define PCI_DEVICE_ID_WCH_CH353_1S1P	0x5053
>  #define PCI_DEVICE_ID_WCH_CH353_2S1P	0x7053
>  #define PCI_VENDOR_ID_AGESTAR		0x5372
>  #define PCI_DEVICE_ID_AGESTAR_9375	0x6872
> @@ -2410,6 +2411,14 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
>  		.subdevice	= PCI_ANY_ID,
>  		.setup		= pci_omegapci_setup,
>  	},
> +	/* WCH CH353 1S1P card (16550 clone) */
> +	{
> +		.vendor         = PCI_VENDOR_ID_WCH,
> +		.device         = PCI_DEVICE_ID_WCH_CH353_1S1P,
> +		.subvendor      = PCI_ANY_ID,
> +		.subdevice      = PCI_ANY_ID,
> +		.setup          = pci_wch_ch353_setup,
> +	},
>  	/* WCH CH353 2S1P card (16550 clone) */
>  	{
>  		.vendor         = PCI_VENDOR_ID_WCH,
> @@ -3526,6 +3535,7 @@ static const struct pci_device_id blacklist[] = {
>  
>  	/* multi-io cards handled by parport_serial */
>  	{ PCI_DEVICE(0x4348, 0x7053), }, /* WCH CH353 2S1P */
> +	{ PCI_DEVICE(0x4348, 0x5053), }, /* WCH CH353 1S1P */
>  };
>  
>  /*
> -- 
> 1.9.1
> 

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
