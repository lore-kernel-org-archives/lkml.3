Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaLaGCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 01:02:11 -0500
Received: from mail-bl2on0125.outbound.protection.outlook.com ([65.55.169.125]:52049
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750734AbaLaGCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 01:02:10 -0500
Message-ID: <1420005717.4961.9.camel@freescale.com>
Subject: Re: [PATCH] tty: 8250: Add 64byte UART support for FSL platforms
From: Scott Wood <scottwood@freescale.com>
To: Vijay Rai <vijay.rai@freescale.com>
CC: <gregkh@linuxfoundation.org>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        "Poonam Aggrwal" <poonam.aggrwal@freescale.com>,
        Priyanka Jain <Priyanka.Jain@freescale.com>
Date: Wed, 31 Dec 2014 00:01:57 -0600
In-Reply-To: <1419932288-17562-1-git-send-email-vijay.rai@freescale.com>
References: <1419932288-17562-1-git-send-email-vijay.rai@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BLUPR05CA0075.namprd05.prod.outlook.com (10.141.20.45) To
 BY2PR0301MB0728.namprd03.prod.outlook.com (25.160.63.18)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=scottwood@freescale.com; 
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0728;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0728;
X-Forefront-PRVS: 0442E569BC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(51704005)(24454002)(377424004)(20776003)(47776003)(64706001)(92566001)(33646002)(68736005)(50466002)(76176999)(31966008)(2950100001)(19580405001)(23676002)(62966003)(106356001)(19580395003)(87976001)(101416001)(103116003)(107046002)(99396003)(77156002)(105586002)(110136001)(122386002)(97736003)(50986999)(89996001)(86362001)(120916001)(21056001)(50226001)(36756003)(46102003)(42186005)(40100003)(4396001)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0728;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0728;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2014 06:02:05.2550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0728
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-30 at 15:08 +0530, Vijay Rai wrote:
> Some of FSL SoCs like T1040 has new version of UART controller which
> can support 64byte FiFo.
> To enable 64 byte support, following needs to be done:
> -FCR[EN64] needs to be programmed to 1 to enable it.
> -Also, when FCR[EN64]==1, RTL bits to be used as below
> to define various Receive Trigger Levels:
>         -FCR[RTL] = 00  1 byte
>         -FCR[RTL] = 01  16 bytes
>         -FCR[RTL] = 10  32 bytes
>         -FCR[RTL] = 11  56 bytes
> -tx_loadsz is set to 32-bytes instead of 64-bytes to implement
>  workaround of errata A-008006 which states that tx_loadsz should
>  be configured less than Maximum supported fifo bytes

Why 32 and not 63?

> Signed-off-by: Vijay Rai <vijay.rai@freescale.com>
> Signed-off-by: Priyanka Jain <Priyanka.Jain@freescale.com>
> Signed-off-by: Poonam Aggrwal <poonam.aggrwal@freescale.com>
> ---
>  drivers/tty/serial/8250/8250_core.c |   20 +++++++++++++++++++-
>  include/uapi/linux/serial_core.h    |    3 ++-
>  include/uapi/linux/serial_reg.h     |    3 ++-
>  3 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
> index 11c6685..565748c 100644
> --- a/drivers/tty/serial/8250/8250_core.c
> +++ b/drivers/tty/serial/8250/8250_core.c
> @@ -329,6 +329,14 @@ static const struct serial8250_config uart_config[] = {
>  		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
>  		.flags		= UART_CAP_FIFO | UART_CAP_AFE,
>  	},
> +	[PORT_16550A_FSL64] = {
> +		.name		= "16550A_FSL64",
> +		.fifo_size	= 64,
> +		.tx_loadsz	= 32,

Put a comment here mentioning the erratum.

> diff --git a/include/uapi/linux/serial_core.h b/include/uapi/linux/serial_core.h
> index c172180..a3b4491 100644
> --- a/include/uapi/linux/serial_core.h
> +++ b/include/uapi/linux/serial_core.h
> @@ -55,7 +55,8 @@
>  #define PORT_ALTR_16550_F64 27	/* Altera 16550 UART with 64 FIFOs */
>  #define PORT_ALTR_16550_F128 28 /* Altera 16550 UART with 128 FIFOs */
>  #define PORT_RT2880	29	/* Ralink RT2880 internal UART */
> -#define PORT_MAX_8250	29	/* max port ID */
> +#define PORT_16550A_FSL64 30	/* Freescale 16550 UART with 64 FIFOs */
> +#define PORT_MAX_8250	31	/* max port ID */

Why are you adding 2 to PORT_MAX_8250 when you only add one new type?
 
-Scott


