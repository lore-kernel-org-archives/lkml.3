Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbaIPAHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 20:07:37 -0400
Received: from mail-bn1bon0139.outbound.protection.outlook.com ([157.56.111.139]:6678
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755212AbaIPAHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 20:07:36 -0400
Date: Tue, 16 Sep 2014 08:07:21 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <stern@rowland.harvard.edu>, <sergei.shtylyov@cogentembedded.com>,
        <yoshihiro.shimoda.uh@renesas.com>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 9/9] usb: chipidea: add support to the generic PHY
 framework in ChipIdea
Message-ID: <20140916000720.GB3379@peterchendt>
References: <1410777309-12552-1-git-send-email-antoine.tenart@free-electrons.com>
 <1410777309-12552-10-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1410777309-12552-10-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(189002)(199003)(51704005)(33656002)(99396002)(6806004)(44976005)(102836001)(4396001)(85306004)(50466002)(46406003)(110136001)(23726002)(76176999)(97736003)(83506001)(105606002)(107046002)(26826002)(19580405001)(19580395003)(54356999)(68736004)(84676001)(90102001)(83322001)(106466001)(74502001)(33716001)(74662001)(64706001)(81542001)(31966008)(97756001)(92726001)(20776003)(83072002)(57986006)(76482001)(85852003)(95666004)(47776003)(50986999)(86362001)(46102001)(77982001)(79102001)(104016003)(81342001)(87936001)(92566001)(80022001)(21056001)(41533002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB264;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 12:35:09PM +0200, Antoine Tenart wrote:
> This patch adds support of the PHY framework for ChipIdea drivers.
> Changes are done in both the ChipIdea common code and in the drivers
> accessing the PHY. This is done by adding a new PHY member in
> ChipIdea's structures and by taking care of it in the code.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> ---
>  drivers/usb/chipidea/ci.h      |  5 ++-
>  drivers/usb/chipidea/core.c    | 83 +++++++++++++++++++++++++++++++++---------
>  drivers/usb/chipidea/debug.c   |  2 +-
>  drivers/usb/chipidea/host.c    |  5 ++-
>  drivers/usb/chipidea/otg_fsm.c |  6 ++-
>  include/linux/usb/chipidea.h   |  2 +
>  6 files changed, 81 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
> index dac5ab6adfa2..7e9e8223672a 100644
> --- a/drivers/usb/chipidea/ci.h
> +++ b/drivers/usb/chipidea/ci.h
> @@ -161,7 +161,8 @@ struct hw_bank {
>   * @test_mode: the selected test mode
>   * @platdata: platform specific information supplied by parent device
>   * @vbus_active: is VBUS active
> - * @usb_phy: pointer to USB PHY, if any
> + * @phy: pointer to PHY, if any
> + * @usb_phy: pointer to USB PHY, if any and if using the USB PHY framework
>   * @hcd: pointer to usb_hcd for ehci host driver
>   * @debugfs: root dentry for this controller in debugfs
>   * @id_event: indicates there is an id event, and handled at ci_otg_work
> @@ -202,6 +203,8 @@ struct ci_hdrc {
>  
>  	struct ci_hdrc_platform_data	*platdata;
>  	int				vbus_active;
> +	struct phy			*phy;
> +	/* old usb_phy interface */
>  	struct usb_phy			*usb_phy;
>  	struct usb_hcd			*hcd;
>  	struct dentry			*debugfs;
> diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
> index ee96b0696a7b..e1d3d3f44075 100644
> --- a/drivers/usb/chipidea/core.c
> +++ b/drivers/usb/chipidea/core.c
> @@ -47,6 +47,7 @@
>  #include <linux/delay.h>
>  #include <linux/device.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/phy/phy.h>
>  #include <linux/platform_device.h>
>  #include <linux/module.h>
>  #include <linux/idr.h>
> @@ -293,6 +294,49 @@ static void hw_phymode_configure(struct ci_hdrc *ci)
>  }
>  
>  /**
> + * _ci_usb_phy_init: initialize phy taking in account both phy and usb_phy
> + * interfaces
> + * @ci: the controller
> + *
> + * This function returns an error code if the phy failed to init
> + */
> +static int _ci_usb_phy_init(struct ci_hdrc *ci)
> +{
> +	int ret;
> +
> +	if (ci->phy) {
> +		ret = phy_init(ci->phy);
> +		if (ret)
> +			return ret;
> +
> +		ret = phy_power_on(ci->phy);
> +		if (ret) {
> +			phy_exit(ci->phy);
> +			return ret;
> +		}
> +	} else {
> +		ret = usb_phy_init(ci->usb_phy);
> +	}
> +
> +	return ret;
> +}
> +
> +/**
> + * _ci_usb_phy_exit: deinitialize phy taking in account both phy and usb_phy
> + * interfaces
> + * @ci: the controller
> + */
> +static void ci_usb_phy_exit(struct ci_hdrc *ci)
> +{
> +	if (ci->phy) {
> +		phy_power_off(ci->phy);
> +		phy_exit(ci->phy);
> +	} else {
> +		usb_phy_shutdown(ci->usb_phy);
> +	}
> +}
> +
> +/**
>   * ci_usb_phy_init: initialize phy according to different phy type
>   * @ci: the controller
>    *
> @@ -306,7 +350,7 @@ static int ci_usb_phy_init(struct ci_hdrc *ci)
>  	case USBPHY_INTERFACE_MODE_UTMI:
>  	case USBPHY_INTERFACE_MODE_UTMIW:
>  	case USBPHY_INTERFACE_MODE_HSIC:
> -		ret = usb_phy_init(ci->usb_phy);
> +		ret = _ci_usb_phy_init(ci);
>  		if (ret)
>  			return ret;
>  		hw_phymode_configure(ci);
> @@ -314,12 +358,12 @@ static int ci_usb_phy_init(struct ci_hdrc *ci)
>  	case USBPHY_INTERFACE_MODE_ULPI:
>  	case USBPHY_INTERFACE_MODE_SERIAL:
>  		hw_phymode_configure(ci);
> -		ret = usb_phy_init(ci->usb_phy);
> +		ret = _ci_usb_phy_init(ci);
>  		if (ret)
>  			return ret;
>  		break;
>  	default:
> -		ret = usb_phy_init(ci->usb_phy);
> +		ret = _ci_usb_phy_init(ci);
>  	}
>  
>  	return ret;
> @@ -595,23 +639,26 @@ static int ci_hdrc_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  	}
>  
> -	if (ci->platdata->usb_phy)
> +	if (ci->platdata->phy) {
> +		ci->phy = ci->platdata->phy;
> +	} else if (ci->platdata->usb_phy) {
>  		ci->usb_phy = ci->platdata->usb_phy;
> -	else
> +	} else {
> +		ci->phy = devm_phy_get(dev, "usb-phy");
>  		ci->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
>  
> -	if (IS_ERR(ci->usb_phy)) {
> -		ret = PTR_ERR(ci->usb_phy);
> -		/*
> -		 * if -ENXIO is returned, it means PHY layer wasn't
> -		 * enabled, so it makes no sense to return -EPROBE_DEFER
> -		 * in that case, since no PHY driver will ever probe.
> -		 */
> -		if (ret == -ENXIO)
> -			return ret;
> +		/* if both generic PHY and USB PHY layers aren't enabled */
> +		if (PTR_ERR(ci->phy) == -ENOSYS &&
> +				PTR_ERR(ci->usb_phy) == -ENXIO)
> +			return -ENXIO;
> +
> +		if (IS_ERR(ci->phy) && IS_ERR(ci->usb_phy))
> +			return -EPROBE_DEFER;
>  
> -		dev_err(dev, "no usb2 phy configured\n");
> -		return -EPROBE_DEFER;
> +		if (IS_ERR(ci->phy))
> +			ci->phy = NULL;
> +		else if (IS_ERR(ci->usb_phy))
> +			ci->usb_phy = NULL;
>  	}
>  
>  	ret = ci_usb_phy_init(ci);
> @@ -718,7 +765,7 @@ static int ci_hdrc_probe(struct platform_device *pdev)
>  stop:
>  	ci_role_destroy(ci);
>  deinit_phy:
> -	usb_phy_shutdown(ci->usb_phy);
> +	ci_usb_phy_exit(ci);
>  
>  	return ret;
>  }
> @@ -731,7 +778,7 @@ static int ci_hdrc_remove(struct platform_device *pdev)
>  	free_irq(ci->irq, ci);
>  	ci_role_destroy(ci);
>  	ci_hdrc_enter_lpm(ci, true);
> -	usb_phy_shutdown(ci->usb_phy);
> +	ci_usb_phy_exit(ci);
>  	kfree(ci->hw_bank.regmap);
>  
>  	return 0;
> diff --git a/drivers/usb/chipidea/debug.c b/drivers/usb/chipidea/debug.c
> index 8f437e1512fa..999e9d683d7a 100644
> --- a/drivers/usb/chipidea/debug.c
> +++ b/drivers/usb/chipidea/debug.c
> @@ -220,7 +220,7 @@ static int ci_otg_show(struct seq_file *s, void *unused)
>  
>  	/* ------ State ----- */
>  	seq_printf(s, "OTG state: %s\n\n",
> -		usb_otg_state_string(ci->usb_phy->otg.state));
> +		   usb_otg_state_string(ci->otg.state));

This one should be at your 8th patch, isn't it?

Others look ok, but need test.

Peter
>  
>  	/* ------ State Machine Variables ----- */
>  	seq_printf(s, "a_bus_drop: %d\n", fsm->a_bus_drop);
> diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
> index 4fcebb6a6d14..e9a872ac355d 100644
> --- a/drivers/usb/chipidea/host.c
> +++ b/drivers/usb/chipidea/host.c
> @@ -59,7 +59,10 @@ static int host_start(struct ci_hdrc *ci)
>  	hcd->has_tt = 1;
>  
>  	hcd->power_budget = ci->platdata->power_budget;
> -	hcd->usb_phy = ci->usb_phy;
> +	if (ci->phy)
> +		hcd->phy = ci->phy;
> +	else
> +		hcd->usb_phy = ci->usb_phy;
>  
>  	ehci = hcd_to_ehci(hcd);
>  	ehci->caps = ci->hw_bank.cap;
> diff --git a/drivers/usb/chipidea/otg_fsm.c b/drivers/usb/chipidea/otg_fsm.c
> index 862d7cb01b92..3c2ab1ae00fc 100644
> --- a/drivers/usb/chipidea/otg_fsm.c
> +++ b/drivers/usb/chipidea/otg_fsm.c
> @@ -779,7 +779,11 @@ int ci_hdrc_otg_fsm_init(struct ci_hdrc *ci)
>  {
>  	int retval = 0;
>  
> -	ci->otg.usb_phy = ci->usb_phy;
> +	if (ci->phy)
> +		ci->otg.phy = ci->phy;
> +	else
> +		ci->otg.usb_phy = ci->usb_phy;
> +
>  	ci->otg.gadget = &ci->gadget;
>  	ci->fsm.otg = &ci->otg;
>  	ci->fsm.power_up = 1;
> diff --git a/include/linux/usb/chipidea.h b/include/linux/usb/chipidea.h
> index 57d757a1aa83..a0285623b9c1 100644
> --- a/include/linux/usb/chipidea.h
> +++ b/include/linux/usb/chipidea.h
> @@ -13,6 +13,8 @@ struct ci_hdrc_platform_data {
>  	/* offset of the capability registers */
>  	uintptr_t	 capoffset;
>  	unsigned	 power_budget;
> +	struct phy	*phy;
> +	/* old usb_phy interface */
>  	struct usb_phy	*usb_phy;
>  	enum usb_phy_interface phy_mode;
>  	unsigned long	 flags;
> -- 
> 1.9.1
> 

-- 
Best Regards,
Peter Chen
