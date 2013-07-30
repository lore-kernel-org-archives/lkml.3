Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab3G3ATa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 20:19:30 -0400
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:57514
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272Ab3G3AT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 20:19:29 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Date: Mon, 29 Jul 2013 19:19:13 -0500
From: Scott Wood <scottwood@freescale.com>
To: Sergey Gerasimov <Sergey.Gerasimov@astrosoft-development.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Roy Zang <tie-fei.zang@freescale.com>,
        Jia Hongtao <B38951@freescale.com>, Li Yang <leoli@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [1/1] MPC831x: fix PCI express probing
Message-ID: <20130730001913.GA8120@home.buserror.net>
References: <1369657783-19962-1-git-send-email-Sergey.Gerasimov@astrosoft-development.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1369657783-19962-1-git-send-email-Sergey.Gerasimov@astrosoft-development.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 02:29:43PM +0200, Sergey Gerasimov wrote:
> For MPC831x the bus probing function also needs the fixup to assign
> addresses to the PCI devices as it was for MPC85xx and MPC86xx.
> The fixup of the bridge vendor and device ID should be done early in
> PCI probing. Else the bridge is not detected as FIXUP_HEADER is called
> too late.
> 
> Signed-off-by: Sergey Gerasimov <Sergey.Gerasimov@astrosoft-development.com>
> 
> ---
> arch/powerpc/sysdev/fsl_pci.c | 68 +++++++++++++++++++------------------------
>  1 file changed, 30 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
> index 028ac1f..94d1bd4 100644
> --- a/arch/powerpc/sysdev/fsl_pci.c
> +++ b/arch/powerpc/sysdev/fsl_pci.c
> @@ -84,6 +84,34 @@ static int fsl_pcie_check_link(struct pci_controller *hose)
>  	return 0;
>  }
>  
> +void fsl_pcibios_fixup_bus(struct pci_bus *bus)
> +{
> +	struct pci_controller *hose = (struct pci_controller *) bus->sysdata;
> +	int i;
> +
> +
> +	if ((bus->parent == hose->bus)
> +		&& ((fsl_pcie_bus_fixup
> +			&& pci_bus_find_capability(bus, 0, PCI_CAP_ID_EXP))
> +			|| (hose->indirect_type
> +				& PPC_INDIRECT_TYPE_NO_PCIE_LINK))) {
> +		for (i = 0; i < 4; ++i) {
> +			struct resource *res = bus->resource[i];
> +			struct resource *par = bus->parent->resource[i];
> +			if (res) {
> +				res->start = 0;
> +				res->end   = 0;
> +				res->flags = 0;
> +			}
> +			if (res && par) {
> +				res->start = par->start;
> +				res->end   = par->end;
> +				res->flags = par->flags;
> +			}
> +		}
> +	}
> +}

Why are you moving this function?  This makes it hardaer to see the
changes you make -- and is likely the cause of unintended changes being
made due to a bad conflict resolution.  In particular, you seem to be
reverting commit 13635dfdc6aa8d2890e02dc441decfcb4ae63e14
("powerpc/fsl/pci: Fix PCIe fixup regression").

Also please confirm that the problem still exists in after "Fix PCIe
fixup regression".

-Scott

