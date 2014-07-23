Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbaGWLH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:07:27 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:19940
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751103AbaGWLHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:07:25 -0400
Date: Wed, 23 Jul 2014 18:59:41 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <stern@rowland.harvard.edu>, <sergei.shtylyov@cogentembedded.com>,
        <yoshihiro.shimoda.uh@renesas.com>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 6/8] usb: allow to supply the PHY in the drivers
 when using HCD
Message-ID: <20140723105940.GA5071@shlinux1.ap.freescale.net>
References: <1405435156-27297-1-git-send-email-antoine.tenart@free-electrons.com>
 <1405435156-27297-7-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405435156-27297-7-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(51704005)(189002)(199002)(81542001)(23756003)(4396001)(74502001)(575784001)(80022001)(102836001)(20776003)(64706001)(47776003)(81342001)(79102001)(74662001)(83072002)(44976005)(19580405001)(68736004)(6806004)(84676001)(69596002)(83506001)(87936001)(21056001)(31966008)(76176999)(86362001)(92726001)(110136001)(50986999)(54356999)(85852003)(26826002)(83322001)(99396002)(92566001)(97736001)(107046002)(104016003)(106466001)(85306003)(46102001)(105606002)(19580395003)(77982001)(50466002)(33656002)(95666004)(76482001)(81156004);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB563;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 04:39:14PM +0200, Antoine Ténart wrote:
> This patch modify the generic code handling PHYs to allow them to be
> supplied from the drivers. This adds checks to ensure no PHY was already
> there when looking for one in the generic code. This also makes sure we
> do not modify its state in the generic HCD functions, it it was
> provided by the driver.

one extra "it"

> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  drivers/usb/core/hcd.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index 228bad89f09b..ce9ea309ab0f 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -2650,7 +2650,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
>  		}
>  	}
>  
> -	if (IS_ENABLED(CONFIG_GENERIC_PHY)) {
> +	if (IS_ENABLED(CONFIG_GENERIC_PHY) && !hcd->phy) {
>  		struct phy *phy = phy_get(hcd->self.controller, "usb");
>  
>  		if (IS_ERR(phy)) {
> @@ -2670,6 +2670,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
>  				goto err_phy;
>  			}
>  			hcd->phy = phy;
> +			hcd->remove_phy = 1;
>  		}
>  	}
>  
> @@ -2816,7 +2817,7 @@ err_allocate_root_hub:
>  err_register_bus:
>  	hcd_buffer_destroy(hcd);
>  err_create_buf:
> -	if (IS_ENABLED(CONFIG_GENERIC_PHY) && hcd->phy) {
> +	if (IS_ENABLED(CONFIG_GENERIC_PHY) && hcd->remove_phy && hcd->phy) {
>  		phy_power_off(hcd->phy);
>  		phy_exit(hcd->phy);
>  		phy_put(hcd->phy);
> @@ -2900,7 +2901,7 @@ void usb_remove_hcd(struct usb_hcd *hcd)
>  	usb_deregister_bus(&hcd->self);
>  	hcd_buffer_destroy(hcd);
>  
> -	if (IS_ENABLED(CONFIG_GENERIC_PHY) && hcd->phy) {
> +	if (IS_ENABLED(CONFIG_GENERIC_PHY) && hcd->remove_phy && hcd->phy) {
>  		phy_power_off(hcd->phy);
>  		phy_exit(hcd->phy);
>  		phy_put(hcd->phy);
> -- 
> 1.9.1
> 

-- 

Best Regards,
Peter Chen
