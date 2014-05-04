Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbaEDBi7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 21:38:59 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:43233
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753274AbaEDBi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 21:38:58 -0400
Date: Sun, 4 May 2014 08:26:10 +0800
From: Peter Chen <peter.chen@freescale.com>
To: xiao jin <jin.xiao@intel.com>
CC: <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yanmin.zhang@intel.com>, <juan.zou@intel.com>,
        <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH] USB: ehci-hub: wait for RESUME finished when hub try
 to clear SUSPEND
Message-ID: <20140504002607.GA30091@shlinux1.ap.freescale.net>
References: <1399089145-21351-1-git-send-email-jin.xiao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1399089145-21351-1-git-send-email-jin.xiao@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(24454002)(189002)(199002)(51704005)(80976001)(81542001)(87936001)(77982001)(23726002)(83506001)(6806004)(15975445006)(4396001)(19580395003)(83322001)(50466002)(54356999)(77096999)(76176999)(46102001)(46406003)(50986999)(551934002)(575784001)(21056001)(76482001)(86362001)(85852003)(33656001)(74502001)(83072002)(44976005)(19580405001)(80022001)(64706001)(31966008)(74662001)(79102001)(47776003)(97756001)(20776003)(92726001)(99396002)(15202345003)(92566001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB026;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:gate-az5.freescale.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 02015246A9
Authentication-Results: spf=fail (sender IP is 192.88.158.246)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2014 at 11:52:25AM +0800, xiao jin wrote:
> We use usb ehci to connect with modem and run stress test on ehci
> remote wake. Sometimes usb disconnect. We add more debug ftrace
> (Kernel version: 3.10) and list the key log to show how problem
> happened.
> 
> <idle>-0     [000] d.h2 26879.385095: ehci_irq: irq status 1008c PPCE FLR PCD
> <idle>-0     [000] d.h2 26879.385099: ehci_irq: rh_state[2] hcd->state[132] pstatus[0][238014c5] suspended_ports[1] reset_done[0]
> <...>-12873 [000] d..1 26879.393536: ehci_hub_control: GetStatus port:1 status 238014c5 17  ERR POWER sig=k SUSPEND RESUME PE CONNECT
> <...>-12873 [000] d..1 26879.393549: ehci_hub_control: typeReq [2301] wIndex[1] wValue[2]
> <...>-12873 [000] d..1 26879.393553: ehci_hub_control: [ehci_hub_control]line[891]  port[0] hostpc_reg [44000202]->[44000202]
> <idle>-0     [001] ..s. 26879.403122: ehci_hub_status_data: wgq[ehci_hub_status_data] ignore_oc[0] resuming_ports[1]
> <...>-12873 [000] d..1 26879.413379: ehci_hub_control: [ehci_hub_control]line[907]  port[0] write portsc_reg[238014c5] reset_done[2105769]
> <...>-12873 [000] d..1 26879.453173: ehci_hub_control: GetStatus port:1 status 23801885 17  ERR POWER sig=j SUSPEND PE CONNECT
> <...>-12873 [000] .... 26879.473158: check_port_resume_type: port 1 status 0000.0507 after resume, -19
> <...>-12873 [000] .... 26879.473160: usb_port_resume: status = -19 after check_port_resume_type
> <...>-12873 [000] .... 26879.473161: usb_port_resume: can't resume, status -19
> <...>-12873 [000] .... 26879.473162: hub_port_logical_disconnect: logical disconnect on port 1
> 
> There is a in-band remote wakeup and controller run in k-state. Then kernel
> driver(ClearPortFeature/USB_PORT_FEAT_SUSPEND) write RESUME|LS(k-state) bit
> into controller. It makes controller status weird. It's defined in EHCI

Are you sure you are at this path? If there is a remote wakeup, the
sending resume signal from host controller will be skipped
(USB_PORT_FEAT_SUSPEND), see usb_port_resume at drivers/usb/core/hub.c.

> controller spec(Revision 1.0), "If it has enabled remote wake-up, a K-state
> on the bus will turn the transceiver clock and generate an interrupt. The
> software will then have to wait 20 ms for the resume to complete and the
> port to go back to an active state." In this case Kernel should wait for
> the wakeup finished, then judge what should do next step.

Do you use a chipidea core? Try to do not clear run/stop to see if this
problem is fixed or not.

> 
> We have some thought and give a patch. This patch is to wait for controller
> RESUME finished when hub try to clear port SUSPEND feature.
> 
> Signed-off-by: xiao jin <jin.xiao@intel.com>
> Reviewed-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>  drivers/usb/host/ehci-hub.c  |    7 +++++++
>  include/linux/usb/ehci_def.h |    5 +++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
> index 7ae0c4d..09a8b6b 100644
> --- a/drivers/usb/host/ehci-hub.c
> +++ b/drivers/usb/host/ehci-hub.c
> @@ -935,6 +935,13 @@ static int ehci_hub_control (
>  				break;
>  			}
>  #endif
> +			if ((temp & PORT_RESUME)
> +				&& ((temp & PORT_LS_MASK) == PORT_K_STATE)) {
> +				ehci_handshake(ehci, status_reg,
> +					PORT_RESUME, 0, 20000 /* 20msec */);
> +				temp = ehci_readl(ehci, status_reg);
> +				temp &= ~PORT_RWC_BITS;
> +			}
>  			if (!(temp & PORT_SUSPEND))
>  				break;
>  			if ((temp & PORT_PE) == 0)
> diff --git a/include/linux/usb/ehci_def.h b/include/linux/usb/ehci_def.h
> index daec99a..0f0f919 100644
> --- a/include/linux/usb/ehci_def.h
> +++ b/include/linux/usb/ehci_def.h
> @@ -149,6 +149,11 @@ struct ehci_regs {
>  #define PORT_POWER	(1<<12)		/* true: has power (see PPC) */
>  #define PORT_USB11(x) (((x)&(3<<10)) == (1<<10))	/* USB 1.1 device */
>  /* 11:10 for detecting lowspeed devices (reset vs release ownership) */
> +#define PORT_LS_MASK	(0x3<<10)	/* line status */
> +#define PORT_SE0_STATE	(0<<10)
> +#define PORT_K_STATE	(1<<10)
> +#define PORT_J_STATE	(2<<10)
> +#define PORT_UNDEFINED_STATE	(3<<10)
>  /* 9 reserved */
>  #define PORT_LPM	(1<<9)		/* LPM transaction */
>  #define PORT_RESET	(1<<8)		/* reset port */
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

Best Regards,
Peter Chen
