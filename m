Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934560AbaHZKXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:23:14 -0400
Received: from mail-bl2lp0206.outbound.protection.outlook.com ([207.46.163.206]:13230
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934257AbaHZKXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:23:13 -0400
Date: Tue, 26 Aug 2014 18:22:40 +0800
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
Subject: Re: [PATCH v3 8/9] usb: chipidea: move usb_otg into struct ci_hdrc
Message-ID: <20140826102239.GD16758@peterchendt>
References: <1408722621-3635-1-git-send-email-antoine.tenart@free-electrons.com>
 <1408722621-3635-9-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408722621-3635-9-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199003)(24454002)(189002)(51704005)(19580395003)(50466002)(83506001)(106466001)(81542001)(19580405001)(84676001)(95666004)(107046002)(86362001)(6806004)(99396002)(31966008)(46102001)(74662001)(57986006)(110136001)(83322001)(74502001)(81156004)(105606002)(50986999)(44976005)(76176999)(33716001)(68736004)(69596002)(54356999)(104016003)(77982001)(97736001)(81342001)(85306004)(4396001)(76482001)(87936001)(26826002)(83072002)(64706001)(33656002)(47776003)(79102001)(80022001)(92726001)(92566001)(85852003)(23756003)(102836001)(90102001)(20776003)(21056001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB564;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 03152A99FF
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 05:50:19PM +0200, Antoine Ténart wrote:
> Move the usb_otg member from struct usb_phy to struct ci_hdrc. Rework
> its initialization taking in account this modification.
> 

If the common usb_otg and usb_phy struct still has another's pointer, you
may not need to add this patch.

> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  drivers/usb/chipidea/ci.h      |  1 +
>  drivers/usb/chipidea/host.c    |  8 +++-----
>  drivers/usb/chipidea/otg_fsm.c | 15 ++-------------
>  3 files changed, 6 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
> index b2caa1772712..dac5ab6adfa2 100644
> --- a/drivers/usb/chipidea/ci.h
> +++ b/drivers/usb/chipidea/ci.h
> @@ -177,6 +177,7 @@ struct ci_hdrc {
>  	struct ci_role_driver		*roles[CI_ROLE_END];
>  	enum ci_role			role;
>  	bool				is_otg;
> +	struct usb_otg			otg;
>  	struct otg_fsm			fsm;
>  	struct ci_otg_fsm_timer_list	*fsm_timer;
>  	struct work_struct		work;
> diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
> index 0b67d78dd953..0952d4adfa4c 100644
> --- a/drivers/usb/chipidea/host.c
> +++ b/drivers/usb/chipidea/host.c
> @@ -85,13 +85,11 @@ static int host_start(struct ci_hdrc *ci)
>  	if (ret) {
>  		goto disable_reg;
>  	} else {
> -		struct usb_otg *otg = ci->usb_phy->otg;
> +		struct usb_otg *otg = &ci->otg;
>  
>  		ci->hcd = hcd;
> -		if (otg) {
> -			otg->host = &hcd->self;
> -			hcd->self.otg_port = 1;
> -		}
> +		otg->host = &hcd->self;
> +		hcd->self.otg_port = 1;
>  	}

You may need use other way to identify if otg is supported or not

>  
>  	if (ci->platdata->flags & CI_HDRC_DISABLE_STREAMING)
> diff --git a/drivers/usb/chipidea/otg_fsm.c b/drivers/usb/chipidea/otg_fsm.c
> index 8a64ce87364e..7eb86863fb3c 100644
> --- a/drivers/usb/chipidea/otg_fsm.c
> +++ b/drivers/usb/chipidea/otg_fsm.c
> @@ -778,20 +778,9 @@ void ci_hdrc_otg_fsm_start(struct ci_hdrc *ci)
>  int ci_hdrc_otg_fsm_init(struct ci_hdrc *ci)
>  {
>  	int retval = 0;
> -	struct usb_otg *otg;
>  
> -	otg = devm_kzalloc(ci->dev,
> -			sizeof(struct usb_otg), GFP_KERNEL);
> -	if (!otg) {
> -		dev_err(ci->dev,
> -		"Failed to allocate usb_otg structure for ci hdrc otg!\n");
> -		return -ENOMEM;
> -	}
> -
> -	otg->usb_phy = ci->usb_phy;
> -	otg->gadget = &ci->gadget;
> -	ci->fsm.otg = otg;
> -	ci->usb_phy->otg = ci->fsm.otg;
> +	ci->otg.usb_phy = ci->usb_phy;
> +	ci->fsm.otg = &ci->otg;
>  	ci->fsm.power_up = 1;
>  	ci->fsm.id = hw_read_otgsc(ci, OTGSC_ID) ? 1 : 0;
>  	ci->fsm.otg->state = OTG_STATE_UNDEFINED;

Why otg->gadget and ci->usb_phy->otg initialization are deleted?
At least, the parameters of usb_otg_state_string at your 7th patch uses it.

-- 
Best Regards,
Peter Chen
