Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbbALSpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:45:16 -0500
Received: from mail-bl2on0092.outbound.protection.outlook.com ([65.55.169.92]:27051
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754044AbbALSpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:45:12 -0500
Date: Mon, 12 Jan 2015 10:45:04 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Kedareswara rao Appana <appana.durga.rao@xilinx.com>
CC: <wg@grandegger.com>, <mkl@pengutronix.de>, <michal.simek@xilinx.com>,
        <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Kedareswara rao Appana <appanad@xilinx.com>
Subject: Re: [PATCH v5] can: Convert to runtime_pm
References: <baf987c11c0242c2bf87b81f9396b09d@BN1BFFO11FD018.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <baf987c11c0242c2bf87b81f9396b09d@BN1BFFO11FD018.protection.gbl>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21244.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <3a3437c5c8ff48d9a45fee7e81fa8dca@BY2FFO11FD058.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(51704005)(199003)(377424004)(50986999)(77156002)(53416004)(6806004)(62966003)(46102003)(47776003)(64706001)(106466001)(110136001)(85202003)(54356999)(76176999)(87936001)(74316001)(92726002)(86362001)(19580395003)(83506001)(50466002)(85182001)(19580405001)(108616004)(104016003)(23676002)(2950100001)(92566002)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB042;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB042;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2FFO11HUB042;
X-Forefront-PRVS: 0454444834
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB042;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2015 18:45:08.9771
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2FFO11HUB042
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-12 at 08:34PM +0530, Kedareswara rao Appana wrote:
> Instead of enabling/disabling clocks at several locations in the driver,
> Use the runtime_pm framework. This consolidates the actions for runtime PM
> In the appropriate callbacks and makes the driver more readable and mantainable.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
> ---
> Changes for v5:
>  - Updated with the review comments.
>    Updated the remove fuction to use runtime_pm.
> Chnages for v4:
>  - Updated with the review comments.
> Changes for v3:
>   - Converted the driver to use runtime_pm.
> Changes for v2:
>   - Removed the struct platform_device* from suspend/resume
>     as suggest by Lothar.
> 
>  drivers/net/can/xilinx_can.c |  157 ++++++++++++++++++++++++++++-------------
>  1 files changed, 107 insertions(+), 50 deletions(-)
[..]
> +static int __maybe_unused xcan_runtime_resume(struct device *dev)
>  {
> -	struct platform_device *pdev = dev_get_drvdata(dev);
> -	struct net_device *ndev = platform_get_drvdata(pdev);
> +	struct net_device *ndev = dev_get_drvdata(dev);
>  	struct xcan_priv *priv = netdev_priv(ndev);
>  	int ret;
> +	u32 isr, status;
>  
>  	ret = clk_enable(priv->bus_clk);
>  	if (ret) {
> @@ -1014,15 +1030,28 @@ static int __maybe_unused xcan_resume(struct device *dev)
>  	ret = clk_enable(priv->can_clk);
>  	if (ret) {
>  		dev_err(dev, "Cannot enable clock.\n");
> -		clk_disable_unprepare(priv->bus_clk);
> +		clk_disable(priv->bus_clk);
[...]
> @@ -1173,12 +1219,23 @@ static int xcan_remove(struct platform_device *pdev)
>  {
>  	struct net_device *ndev = platform_get_drvdata(pdev);
>  	struct xcan_priv *priv = netdev_priv(ndev);
> +	int ret;
> +
> +	ret = pm_runtime_get_sync(&pdev->dev);
> +	if (ret < 0) {
> +		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
> +				__func__, ret);
> +		return ret;
> +	}
>  
>  	if (set_reset_mode(ndev) < 0)
>  		netdev_err(ndev, "mode resetting failed!\n");
>  
>  	unregister_candev(ndev);
> +	pm_runtime_disable(&pdev->dev);
>  	netif_napi_del(&priv->napi);
> +	clk_disable_unprepare(priv->bus_clk);
> +	clk_disable_unprepare(priv->can_clk);

Shouldn't pretty much all these occurrences of clk_disable/enable
disappear? This should all be handled by the runtime_pm framework now.

	Sören
