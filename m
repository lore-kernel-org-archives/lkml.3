Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab3HSUQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:16:27 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:34283 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab3HSUQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:16:26 -0400
Date: Mon, 19 Aug 2013 22:15:16 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: ujhelyi.m@gmail.com
Cc: davem@davemloft.net, mugunthanvnm@ti.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] net: cpsw: Add support for wake-on-lan for cpsw
Message-ID: <20130819201516.GA30230@electric-eye.fr.zoreil.com>
References: <1376910358-19882-1-git-send-email-ujhelyi.m@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376910358-19882-1-git-send-email-ujhelyi.m@gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ujhelyi.m@gmail.com <ujhelyi.m@gmail.com> :
[...]
> Some phy's can be configured to enable wake on lan (e.g. at803x or marvell 88E1318S).
> There is no way how to enable wol on CPSW with such connected phys. This patch
> adds this support. It is provided by calling the phy's related code.
> 
> Tested on board with at8030x connected phy. Wol interrupt line is
> connected to GPIO0 on am335x.

This patch adds a feature. It isn't a bugfix. It should thus target
'net-next', not 'net' (it does not apply to net-next as of 2ff1cf12c9 btw).

> 
> Signed-off-by: Matus Ujhelyi <ujhelyi.m@gmail.com>
> ---
>  drivers/net/ethernet/ti/cpsw.c |   23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
> index 22a7a43..fe8d973 100644
> --- a/drivers/net/ethernet/ti/cpsw.c
> +++ b/drivers/net/ethernet/ti/cpsw.c
> @@ -1416,6 +1416,27 @@ static int cpsw_set_settings(struct net_device *ndev, struct ethtool_cmd *ecmd)
>  		return -EOPNOTSUPP;
>  }
>  
> +static void cpsw_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
> +{
> +	struct cpsw_priv *priv = netdev_priv(ndev);
> +	int slave_no = cpsw_slave_index(priv);
> +	wol->supported = 0;

Variable declarations and code should be separated: please add an empty
line.

> +	wol->wolopts = 0;
> +	if (priv->slaves[slave_no].phy)
> +		phy_ethtool_get_wol(priv->slaves[slave_no].phy, wol);
> +
> +}

Useless empty line.

> +
> +static int cpsw_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
> +{
> +	struct cpsw_priv *priv = netdev_priv(ndev);
> +	int slave_no = cpsw_slave_index(priv);
> +	if (priv->slaves[slave_no].phy)

Variable declarations and code should be separated: please add an empty
line.

> +		return phy_ethtool_set_wol(priv->slaves[slave_no].phy, wol);
> +	else
> +		return -EOPNOTSUPP;
> +}
> +
>  static const struct ethtool_ops cpsw_ethtool_ops = {
>  	.get_drvinfo	= cpsw_get_drvinfo,
>  	.get_msglevel	= cpsw_get_msglevel,
> @@ -1426,6 +1447,8 @@ static const struct ethtool_ops cpsw_ethtool_ops = {
>  	.set_settings	= cpsw_set_settings,
>  	.get_coalesce	= cpsw_get_coalesce,
                     ^^^ tab
>  	.set_coalesce	= cpsw_set_coalesce,
                     ^^^ tab
> +	.get_wol        = cpsw_get_wol,
                ^^^^^^^^  spaces, please use tabs.
> +	.set_wol        = cpsw_set_wol,
                ^^^^^^^^  spaces, please use tabs.

-- 
Ueimor
