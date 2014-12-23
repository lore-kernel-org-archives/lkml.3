Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbaLWWn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 17:43:26 -0500
Received: from mail-bn1bon0092.outbound.protection.outlook.com ([157.56.111.92]:46839
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756487AbaLWWnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 17:43:22 -0500
Date: Tue, 23 Dec 2014 14:43:08 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Kedareswara rao Appana <appana.durga.rao@xilinx.com>
CC: <wg@grandegger.com>, <mkl@pengutronix.de>, <michal.simek@xilinx.com>,
        <grant.likely@linaro.org>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Kedareswara rao Appana <appanad@xilinx.com>
Subject: Re: [PATCH v4] can: Convert to runtime_pm
References: <58f37b6fd9104ce185c413c473fe047b@BY2FFO11FD050.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <58f37b6fd9104ce185c413c473fe047b@BY2FFO11FD050.protection.gbl>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21198.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <46c28dc78c764efb80cc334df189db3b@BY2FFO11FD055.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(51704005)(377424004)(199003)(189002)(85182001)(99396003)(50986999)(54356999)(62966003)(76176999)(86362001)(92726002)(77156002)(106466001)(85202003)(46102003)(2950100001)(107046002)(92566001)(53416004)(83506001)(108616004)(120916001)(21056001)(74316001)(23676002)(104016003)(110136001)(31966008)(50466002)(64706001)(20776003)(47776003)(4396001)(19580405001)(6806004)(87936001)(19580395003)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB001;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB001;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2FFO11HUB001;
X-Forefront-PRVS: 04347F8039
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB001;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2014 22:43:17.9240
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2FFO11HUB001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-23 at 05:55PM +0530, Kedareswara rao Appana wrote:
> Instead of enabling/disabling clocks at several locations in the driver,
> use the runtime_pm framework. This consolidates the actions for
> runtime PM in the appropriate callbacks and makes the driver more
> readable and mantainable.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
> ---
> Chnages for v4:
>  - Updated with the review comments.
> Changes for v3:
>   - Converted the driver to use runtime_pm.
> Changes for v2:
>   - Removed the struct platform_device* from suspend/resume
>     as suggest by Lothar.
> 
>  drivers/net/can/xilinx_can.c |  123 +++++++++++++++++++++++++-----------------
>  1 files changed, 74 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
> index 6c67643..c71f683 100644
> --- a/drivers/net/can/xilinx_can.c
> +++ b/drivers/net/can/xilinx_can.c
> @@ -32,6 +32,7 @@
>  #include <linux/can/dev.h>
>  #include <linux/can/error.h>
>  #include <linux/can/led.h>
> +#include <linux/pm_runtime.h>
>  
>  #define DRIVER_NAME	"xilinx_can"
>  
> @@ -138,7 +139,7 @@ struct xcan_priv {
>  	u32 (*read_reg)(const struct xcan_priv *priv, enum xcan_reg reg);
>  	void (*write_reg)(const struct xcan_priv *priv, enum xcan_reg reg,
>  			u32 val);
> -	struct net_device *dev;
> +	struct device *dev;
>  	void __iomem *reg_base;
>  	unsigned long irq_flags;
>  	struct clk *bus_clk;
> @@ -842,6 +843,13 @@ static int xcan_open(struct net_device *ndev)
>  	struct xcan_priv *priv = netdev_priv(ndev);
>  	int ret;
>  
> +	ret = pm_runtime_get_sync(priv->dev);
> +	if (ret < 0) {
> +		netdev_err(ndev, "%s: pm_runtime_get failed\r(%d)\n\r",

Does this create the intended output? I haven't seen '\r' anywhere else.
Shouldn't this simply be:
	netdev_err(ndev, "%s: pm_runtime_get failed (%d)\n",

[...]
> @@ -934,27 +927,20 @@ static int xcan_get_berr_counter(const struct net_device *ndev,
>  	struct xcan_priv *priv = netdev_priv(ndev);
>  	int ret;
>  
> -	ret = clk_prepare_enable(priv->can_clk);
> -	if (ret)
> -		goto err;
> -
> -	ret = clk_prepare_enable(priv->bus_clk);
> -	if (ret)
> -		goto err_clk;
> +	ret = pm_runtime_get_sync(priv->dev);
> +	if (ret < 0) {
> +		netdev_err(ndev, "%s: pm_runtime_get failed\r(%d)\n\r",

ditto

	Sören
