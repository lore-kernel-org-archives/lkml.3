Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbaLQCIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 21:08:39 -0500
Received: from mail-bl2on0139.outbound.protection.outlook.com ([65.55.169.139]:46880
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750939AbaLQCIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 21:08:37 -0500
From: Peter Chen <Peter.Chen@freescale.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC: "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb: hcd: add OTG ID signal sensing
Thread-Topic: [PATCH] usb: hcd: add OTG ID signal sensing
Thread-Index: AQHQGYZlxKbkUkW4ekGjR3qdiS7kwZyTCV3w
Date: Wed, 17 Dec 2014 02:08:34 +0000
Message-ID: <BN3PR0301MB08495DD76B65E14BDE460E42816D0@BN3PR0301MB0849.namprd03.prod.outlook.com>
References: <3663198.HSrURZGche@wasted.cogentembedded.com>
In-Reply-To: <3663198.HSrURZGche@wasted.cogentembedded.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.211]
authentication-results: cogentembedded.com; dkim=none (message not signed)
 header.d=none;
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB0849;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB0849;
x-forefront-prvs: 042857DBB5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(199003)(189002)(2501002)(50986999)(77156002)(54356999)(76176999)(99286002)(62966003)(76576001)(4396001)(31966008)(21056001)(87936001)(54206007)(2656002)(97736003)(74316001)(107046002)(122556002)(20776003)(40100003)(46102003)(54606007)(64706001)(15975445007)(19580405001)(68736005)(19580395003)(99396003)(66066001)(86362001)(33656002)(106356001)(92566001)(105586002)(101416001)(102836002)(2950100001)(106116001)(120916001)(2900100001)(422495003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB0849;H:BN3PR0301MB0849.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2014 02:08:34.8639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0301MB0849
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> 
> On the Renesas R8A7791 SoC based boards there's MAX3355 USB OTG chip and
> mini-AB USB connector corresponding to USB port 0 driven either by EHCI/OHCI
> or  Renesas USBHS gadget controller. And we'd like the  host/gadget drivers to
> work based on the cable type connected. An 'extcon' driver for MAX3355 has
> been written, so we only need to bind  to it via device tree which I'm doing in
> this patch.
> 
> I wasn't able to find a solution better than checking the cable type at the host
> driver probe time and refusing to drive a host if B-cable is connected.
> 

You may need a dual-role/otg driver to do it, which can enable host/device function
according to ID pin.

Peter

> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> ---
> The patch is against the 'usb-next' branch of Greg KH's 'usb.git' repo.
> It needs the recent 'extcon' core in order to properly handle probe deferral.
> 
>  drivers/usb/core/hcd.c |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> Index: usb/drivers/usb/core/hcd.c
> ============================================================
> =======
> --- usb.orig/drivers/usb/core/hcd.c
> +++ usb/drivers/usb/core/hcd.c
> @@ -42,6 +42,7 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/types.h>
> 
> +#include <linux/extcon.h>
>  #include <linux/phy/phy.h>
>  #include <linux/usb.h>
>  #include <linux/usb/hcd.h>
> @@ -2632,6 +2633,23 @@ int usb_add_hcd(struct usb_hcd *hcd,
>  	int retval;
>  	struct usb_device *rhdev;
> 
> +	if (IS_ENABLED(CONFIG_EXTCON) &&
> +	    of_property_read_bool(hcd->self.controller->of_node, "extcon")) {
> +		struct extcon_dev *edev;
> +
> +		edev = extcon_get_edev_by_phandle(hcd->self.controller, 0);
> +		if (IS_ERR(edev))
> +			return PTR_ERR(edev);
> +
> +		retval = extcon_get_cable_state(edev, "USB-HOST");
> +		if (!retval) {
> +			dev_err(hcd->self.controller,
> +				"OTG B-cable plugged in, host driver won't
> load\n");
> +			return -EINVAL;
> +		} else if (retval < 0)
> +			return retval;
> +	}
> +
>  	if (IS_ENABLED(CONFIG_USB_PHY) && !hcd->usb_phy) {
>  		struct usb_phy *phy = usb_get_phy_dev(hcd->self.controller,
> 0);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
