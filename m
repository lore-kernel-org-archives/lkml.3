Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041Ab3CLQHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 12:07:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37830 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932910Ab3CLQHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 12:07:01 -0400
Date: Tue, 12 Mar 2013 12:07:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: gregkh@linuxfoundation.org, <balbi@ti.com>, <b-cousson@ti.com>,
        <mark.rutland@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <kishon@ti.com>
Subject: Re: [PATCH v2 12/12] USB: ehci-omap: Fix detection in HSIC mode
In-Reply-To: <1363086540-30567-1-git-send-email-rogerq@ti.com>
Message-ID: <Pine.LNX.4.44L0.1303121201050.2153-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Mar 2013, Roger Quadros wrote:

> The HSIC devices need to be kept in reset while the EHCI controller
> is being initialized and only brought out of reset after the
> initialization is complete, else HSIC devices will not be detected.

This is not a great description of what the patch does.  You should say
that it moves PHY initialization until after EHCI initialization is
complete, instead of initializing the PHYs first, shutting them down
again, and then initializing them a second time.

> Also remove outdated TODO list from header.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> CC: Alan Stern <stern@rowland.harvard.edu>
> ---
>  drivers/usb/host/ehci-omap.c |   38 +++++++++++++++-----------------------
>  1 files changed, 15 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
> index 1ba1df8..dc2de47 100644
> --- a/drivers/usb/host/ehci-omap.c
> +++ b/drivers/usb/host/ehci-omap.c
> @@ -29,12 +29,6 @@
>   * along with this program; if not, write to the Free Software
>   * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
>   *
> - * TODO (last updated Feb 27, 2010):
> - *	- add kernel-doc
> - *	- enable AUTOIDLE
> - *	- add suspend/resume
> - *	- add HSIC and TLL support
> - *	- convert to use hwmod and runtime PM
>   */
>  
>  #include <linux/kernel.h>
> @@ -90,26 +84,13 @@ static inline u32 ehci_read(void __iomem *base, u32 reg)
>  static int omap_ehci_init(struct usb_hcd *hcd)
>  {
>  	struct ehci_hcd	*ehci = hcd_to_ehci(hcd);
> -	struct omap_hcd	*omap = (struct omap_hcd *)ehci->priv;
> -	int rc, i;
> -
> -	/* Hold PHYs in reset while initializing EHCI controller */
> -	for (i = 0; i < omap->nports; i++) {
> -		if (omap->phy[i])
> -			usb_phy_shutdown(omap->phy[i]);
> -	}
> +	int rc;
>  
>  	/* we know this is the memory we want, no need to ioremap again */
>  	ehci->caps = hcd->regs;
>  
>  	rc = ehci_setup(hcd);
>  
> -	/* Bring PHYs out of reset */
> -	for (i = 0; i < omap->nports; i++) {
> -		if (omap->phy[i])
> -			usb_phy_init(omap->phy[i]);
> -	}
> -
>  	return rc;
>  }

Now that there's almost nothing left of this function, you can get rid
of it completely.  Move the assignment to ehci->caps into
ehci_hcd_omap_probe() and remove the init entry in the overrides
structure.

Alan Stern

