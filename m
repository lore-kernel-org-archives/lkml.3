Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3JJJbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 05:31:41 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36669 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab3JJJbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 05:31:39 -0400
Message-ID: <525673D9.9060900@ti.com>
Date: Thu, 10 Oct 2013 12:31:05 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Roger Quadros <rogerq@ti.com>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH v2 6/6] mfd: omap-usb: prepare/unprepare clock while enable/disable
References: <1381226799-29158-1-git-send-email-rogerq@ti.com> <1381226799-29158-7-git-send-email-rogerq@ti.com>
In-Reply-To: <1381226799-29158-7-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

Could you please pick this one for 3.13 if OK? Thanks.

cheers,
-roger

On 10/08/2013 01:06 PM, Roger Quadros wrote:
> This should fix the following warning at boot on OMAP5 uEVM
> [    8.783155] WARNING: CPU: 0 PID: 1 at drivers/clk/clk.c:883 __clk_enable+0x94/0xa4()
> 
> CC: Samuel Ortiz <sameo@linux.intel.com>
> CC: Lee Jones <lee.jones@linaro.org>
> CC: Tero Kristo <t-kristo@ti.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/mfd/omap-usb-host.c |   16 ++++++++--------
>  drivers/mfd/omap-usb-tll.c  |    4 ++--
>  2 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index 29ee54d..a5b91f1 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -328,13 +328,13 @@ static int usbhs_runtime_resume(struct device *dev)
>  	omap_tll_enable(pdata);
>  
>  	if (!IS_ERR(omap->ehci_logic_fck))
> -		clk_enable(omap->ehci_logic_fck);
> +		clk_prepare_enable(omap->ehci_logic_fck);
>  
>  	for (i = 0; i < omap->nports; i++) {
>  		switch (pdata->port_mode[i]) {
>  		case OMAP_EHCI_PORT_MODE_HSIC:
>  			if (!IS_ERR(omap->hsic60m_clk[i])) {
> -				r = clk_enable(omap->hsic60m_clk[i]);
> +				r = clk_prepare_enable(omap->hsic60m_clk[i]);
>  				if (r) {
>  					dev_err(dev,
>  					 "Can't enable port %d hsic60m clk:%d\n",
> @@ -343,7 +343,7 @@ static int usbhs_runtime_resume(struct device *dev)
>  			}
>  
>  			if (!IS_ERR(omap->hsic480m_clk[i])) {
> -				r = clk_enable(omap->hsic480m_clk[i]);
> +				r = clk_prepare_enable(omap->hsic480m_clk[i]);
>  				if (r) {
>  					dev_err(dev,
>  					 "Can't enable port %d hsic480m clk:%d\n",
> @@ -354,7 +354,7 @@ static int usbhs_runtime_resume(struct device *dev)
>  
>  		case OMAP_EHCI_PORT_MODE_TLL:
>  			if (!IS_ERR(omap->utmi_clk[i])) {
> -				r = clk_enable(omap->utmi_clk[i]);
> +				r = clk_prepare_enable(omap->utmi_clk[i]);
>  				if (r) {
>  					dev_err(dev,
>  					 "Can't enable port %d clk : %d\n",
> @@ -382,15 +382,15 @@ static int usbhs_runtime_suspend(struct device *dev)
>  		switch (pdata->port_mode[i]) {
>  		case OMAP_EHCI_PORT_MODE_HSIC:
>  			if (!IS_ERR(omap->hsic60m_clk[i]))
> -				clk_disable(omap->hsic60m_clk[i]);
> +				clk_disable_unprepare(omap->hsic60m_clk[i]);
>  
>  			if (!IS_ERR(omap->hsic480m_clk[i]))
> -				clk_disable(omap->hsic480m_clk[i]);
> +				clk_disable_unprepare(omap->hsic480m_clk[i]);
>  		/* Fall through as utmi_clks were used in HSIC mode */
>  
>  		case OMAP_EHCI_PORT_MODE_TLL:
>  			if (!IS_ERR(omap->utmi_clk[i]))
> -				clk_disable(omap->utmi_clk[i]);
> +				clk_disable_unprepare(omap->utmi_clk[i]);
>  			break;
>  		default:
>  			break;
> @@ -398,7 +398,7 @@ static int usbhs_runtime_suspend(struct device *dev)
>  	}
>  
>  	if (!IS_ERR(omap->ehci_logic_fck))
> -		clk_disable(omap->ehci_logic_fck);
> +		clk_disable_unprepare(omap->ehci_logic_fck);
>  
>  	omap_tll_disable(pdata);
>  
> diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
> index e59ac4c..1e57712 100644
> --- a/drivers/mfd/omap-usb-tll.c
> +++ b/drivers/mfd/omap-usb-tll.c
> @@ -429,7 +429,7 @@ int omap_tll_enable(struct usbhs_omap_platform_data *pdata)
>  			if (IS_ERR(tll->ch_clk[i]))
>  				continue;
>  
> -			r = clk_enable(tll->ch_clk[i]);
> +			r = clk_prepare_enable(tll->ch_clk[i]);
>  			if (r) {
>  				dev_err(tll_dev,
>  				 "Error enabling ch %d clock: %d\n", i, r);
> @@ -460,7 +460,7 @@ int omap_tll_disable(struct usbhs_omap_platform_data *pdata)
>  	for (i = 0; i < tll->nch; i++) {
>  		if (omap_usb_mode_needs_tll(pdata->port_mode[i])) {
>  			if (!IS_ERR(tll->ch_clk[i]))
> -				clk_disable(tll->ch_clk[i]);
> +				clk_disable_unprepare(tll->ch_clk[i]);
>  		}
>  	}
>  
> 

