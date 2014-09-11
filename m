Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbaIKBAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 21:00:00 -0400
Received: from mail-bl2on0124.outbound.protection.outlook.com ([65.55.169.124]:17675
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754089AbaIKA75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 20:59:57 -0400
X-Greylist: delayed 1033 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2014 20:59:57 EDT
Date: Thu, 11 Sep 2014 08:26:43 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <stern@rowland.harvard.edu>, <sergei.shtylyov@cogentembedded.com>,
        <yoshihiro.shimoda.uh@renesas.com>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 8/9] usb: chipidea: move usb_otg into struct ci_hdrc
Message-ID: <20140911002641.GB3609@peterchendt>
References: <1409730040-14200-1-git-send-email-antoine.tenart@free-electrons.com>
 <1409730040-14200-9-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409730040-14200-9-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(24454002)(51704005)(81342001)(20776003)(64706001)(47776003)(105606002)(80022001)(85306004)(84676001)(86362001)(106466001)(81156004)(107046002)(81542001)(31966008)(83506001)(74662001)(79102001)(46406003)(76482001)(74502001)(85852003)(83072002)(77982001)(33656002)(97756001)(110136001)(95666004)(19580395003)(83322001)(19580405001)(68736004)(69596002)(102836001)(23726002)(44976005)(6806004)(4396001)(21056001)(92566001)(33716001)(97736003)(46102001)(87936001)(92726001)(57986006)(50466002)(26826002)(104016003)(99396002)(90102001)(54356999)(76176999)(50986999);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB214;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03319F6FEF
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 09:40:39AM +0200, Antoine Tenart wrote:
> Move the usb_otg member from struct usb_phy to struct ci_hdrc. Rework
> its initialization taking in account this modification.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> ---
>  drivers/usb/chipidea/ci.h      |  1 +
>  drivers/usb/chipidea/host.c    |  5 +++--
>  drivers/usb/chipidea/otg_fsm.c | 16 +++-------------
>  3 files changed, 7 insertions(+), 15 deletions(-)
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
> index 0b67d78dd953..4fcebb6a6d14 100644
> --- a/drivers/usb/chipidea/host.c
> +++ b/drivers/usb/chipidea/host.c
> @@ -85,10 +85,11 @@ static int host_start(struct ci_hdrc *ci)
>  	if (ret) {
>  		goto disable_reg;
>  	} else {
> -		struct usb_otg *otg = ci->usb_phy->otg;
> +		struct usb_otg *otg = &ci->otg;
>  
>  		ci->hcd = hcd;
> -		if (otg) {
> +
> +		if (ci_otg_is_fsm_mode(ci)) {
>  			otg->host = &hcd->self;
>  			hcd->self.otg_port = 1;
>  		}
> diff --git a/drivers/usb/chipidea/otg_fsm.c b/drivers/usb/chipidea/otg_fsm.c
> index 8a64ce87364e..862d7cb01b92 100644
> --- a/drivers/usb/chipidea/otg_fsm.c
> +++ b/drivers/usb/chipidea/otg_fsm.c
> @@ -778,20 +778,10 @@ void ci_hdrc_otg_fsm_start(struct ci_hdrc *ci)
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
> +	ci->otg.gadget = &ci->gadget;
> +	ci->fsm.otg = &ci->otg;
>  	ci->fsm.power_up = 1;
>  	ci->fsm.id = hw_read_otgsc(ci, OTGSC_ID) ? 1 : 0;
>  	ci->fsm.otg->state = OTG_STATE_UNDEFINED;
> -- 

Acked-by: Peter Chen <peter.chen@freescale.com>

-- 
Best Regards,
Peter Chen
