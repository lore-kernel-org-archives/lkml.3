Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbaISK6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 06:58:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:16440 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944AbaISK6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 06:58:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,554,1406617200"; 
   d="scan'208";a="605328458"
Date: Fri, 19 Sep 2014 13:58:33 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, "Chew, Kean Ho" <kean.ho.chew@intel.com>
Subject: Re: [PATCHv2] serial: 8250: Add Quark X1000 to 8250 PCI driver
Message-ID: <20140919105833.GB31784@xps8300>
References: <1411112629-3238-1-git-send-email-pure.logic@nexus-software.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411112629-3238-1-git-send-email-pure.logic@nexus-software.ie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 08:43:49AM +0100, Bryan O'Donoghue wrote:
> Adds PCI identifier for the X1000
> Adds clocking and register size and register shift
> 
> Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
> ---
>  drivers/tty/serial/8250/8250_pci.c | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)

The UART on Quark SoC has an integrated DMA engine and Kean Ho (CC'd)
is working with support for it. The plan is to add completely separate
probe driver for the Quark UART. Dealing with the integrated DMA
engine is too much for a quirk in 8250_pci.c.

So we can take this now and when Kean Ho is ready he needs to
basically revert it, or you could already introduce the new probe
driver, 8250_quark.c, and Kean Ho can then add the DMA engine handling
later to it.

IMO we should add the 8250_quark.c already now.


> diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
> index 61830b1..5e72959 100644
> --- a/drivers/tty/serial/8250/8250_pci.c
> +++ b/drivers/tty/serial/8250/8250_pci.c
> @@ -1481,6 +1481,19 @@ byt_serial_setup(struct serial_private *priv,
>  	return ret;
>  }
>  
> +#define PCI_DEVICE_ID_INTEL_QRK_UART	0x0936
> +
> +static int
> +pci_intel_qrk_setup(struct serial_private *priv,
> +		const struct pciserial_board *board,
> +		struct uart_8250_port *port, int idx)
> +{
> +	unsigned int bar, offset = board->first_offset;
> +
> +	bar = FL_GET_BASE(board->flags);
> +
> +	return setup_port(priv, port, bar, offset, board->reg_shift);
> +}
>  static int
>  pci_omegapci_setup(struct serial_private *priv,
>  		      const struct pciserial_board *board,
> @@ -1898,6 +1911,13 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
>  		.subdevice	= PCI_ANY_ID,
>  		.setup		= byt_serial_setup,
>  	},
> +	{
> +		.vendor		= PCI_VENDOR_ID_INTEL,
> +		.device		= PCI_DEVICE_ID_INTEL_QRK_UART,
> +		.subvendor	= PCI_ANY_ID,
> +		.subdevice	= PCI_ANY_ID,
> +		.setup		= pci_intel_qrk_setup,
> +	},
>  	/*
>  	 * ITE
>  	 */
> @@ -2740,6 +2760,7 @@ enum pci_board_num_t {
>  	pbn_ADDIDATA_PCIe_8_3906250,
>  	pbn_ce4100_1_115200,
>  	pbn_byt,
> +	pbn_qrk,
>  	pbn_omegapci,
>  	pbn_NETMOS9900_2s_115200,
>  	pbn_brcm_trumanage,
> @@ -3490,6 +3511,12 @@ static struct pciserial_board pci_boards[] = {
>  		.uart_offset	= 0x80,
>  		.reg_shift      = 2,
>  	},
> +	[pbn_qrk] = {
> +		.flags		= FL_BASE0,
> +		.num_ports	= 1,
> +		.base_baud	= 2764800,
> +		.reg_shift	= 2,
> +	},
>  	[pbn_omegapci] = {
>  		.flags		= FL_BASE0,
>  		.num_ports	= 8,
> @@ -5192,6 +5219,12 @@ static struct pci_device_id serial_pci_tbl[] = {
>  		pbn_byt },
>  
>  	/*
> +	 * Intel Quark x1000
> +	 */
> +	{	PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_QRK_UART,
> +		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +		pbn_qrk },
> +	/*
>  	 * Cronyx Omega PCI
>  	 */
>  	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_CRONYX_OMEGA,
> -- 
> 1.9.1

Cheers,

-- 
heikki
