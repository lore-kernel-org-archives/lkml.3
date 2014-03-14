Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434AbaCNVI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:08:57 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:37804
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756150AbaCNVIz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:08:55 -0400
From: "suresh.gupta@freescale.com" <suresh.gupta@freescale.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Stefani Seibold" <stefani@seibold.net>
Subject: RE: [PATCH] USB: Gadget: fsl driver pullup fix
Thread-Topic: [PATCH] USB: Gadget: fsl driver pullup fix
Thread-Index: AQHPPo+XZEI7T+n+/Eyk3iTo1DVy5JrfI8CAgAHhkxA=
Date: Fri, 14 Mar 2014 20:53:24 +0000
Message-ID: <797f2a4344754765a968250ef26f2b53@BN1PR03MB251.namprd03.prod.outlook.com>
References: <1394716255-26963-1-git-send-email-suresh.gupta@freescale.com>
 <20140313152517.GG4599@saruman.home>
In-Reply-To: <20140313152517.GG4599@saruman.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377454003)(24454002)(189002)(199002)(51704005)(76786001)(77096001)(76482001)(53806001)(54356001)(51856001)(69226001)(50986001)(19580405001)(85852003)(93516002)(46102001)(66066001)(65816001)(80022001)(77982001)(86362001)(81686001)(83322001)(59766001)(33646001)(76796001)(76576001)(49866001)(56776001)(19580395003)(81342001)(80976001)(4396001)(81816001)(74366001)(2656002)(20776003)(79102001)(95666003)(74662001)(92566001)(31966008)(97186001)(94316002)(90146001)(54316002)(87266001)(74706001)(93136001)(47736001)(83072002)(47446002)(81542001)(87936001)(63696002)(95416001)(74876001)(74502001)(74316001)(85306002)(97336001)(47976001)(94946001)(56816005)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB024;H:BN1PR03MB251.namprd03.prod.outlook.com;FPR:E43CC173.A43086DC.71F83924.81E4F870.202F1;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

-----Original Message-----
From: Felipe Balbi [mailto:balbi@ti.com] 
Sent: Thursday, March 13, 2014 8:55 PM
To: Gupta Suresh-B42813
Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Stefani Seibold
Subject: Re: [PATCH] USB: Gadget: fsl driver pullup fix

Hi,

On Thu, Mar 13, 2014 at 06:40:55PM +0530, Suresh Gupta wrote:
> Attached is a small fix for the fsl usb gadget driver. This fix the 
> driver in a way that the usb device will be only "pulled up" on 
> requests like other usb gadget drivers do.
> This is necessary, because the device information is not always 
> available until an application is up and running which provides this 
> datas.
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> Signed-off-by: Suresh Gupta <suresh.gupta@freescale.com>
> ---
>  drivers/usb/gadget/fsl_udc_core.c | 38 
> +++++++++++++++++++++-----------------
>  1 file changed, 21 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/usb/gadget/fsl_udc_core.c 
> b/drivers/usb/gadget/fsl_udc_core.c
> index 35cb972..9a93727 100644
> --- a/drivers/usb/gadget/fsl_udc_core.c
> +++ b/drivers/usb/gadget/fsl_udc_core.c
> @@ -153,6 +153,21 @@ static inline void fsl_set_accessors(struct 
> fsl_usb2_platform_data *pdata) {}
>  /********************************************************************
>   *	Internal Used Function
>  ********************************************************************/
> +static int can_pullup(struct fsl_udc *udc) {
> +	return udc->driver && udc->softconnect && udc->vbus_active; }
> +
> +static void set_pullup(struct fsl_udc *udc) {
> +	if (can_pullup(udc))
> +		fsl_writel((fsl_readl(&dr_regs->usbcmd) | USB_CMD_RUN_STOP),
> +				&dr_regs->usbcmd);
> +	else
> +		fsl_writel((fsl_readl(&dr_regs->usbcmd) & ~USB_CMD_RUN_STOP),
> +				&dr_regs->usbcmd);
> +}

why is this a "fix", you just re-factored some code into set_pullup().
[SuresH] I set udc->vbus_active and udc->softconnect to default value 
of 1 in struct_udc_setup. This was actual fix in this patch.
The can_pullup function return false when these values was not set 
and intern the code return without enabling the pullup and gadget controller stops. 

--
Thanks
SuresH
