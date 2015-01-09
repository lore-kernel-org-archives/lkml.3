Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbbAIACN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 19:02:13 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:50314 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021AbbAIACL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 19:02:11 -0500
Date: Fri, 9 Jan 2015 01:00:57 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Stephen Wang <wstephen@codeaurora.org>
Cc: jcliburn@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] ethernet: atheros: Add nss-gmac driver
Message-ID: <20150109000057.GB11396@electric-eye.fr.zoreil.com>
References: <y>
 <1420754626-30121-1-git-send-email-wstephen@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420754626-30121-1-git-send-email-wstephen@codeaurora.org>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Wang <wstephen@codeaurora.org> :
> This driver adds support for the internal GMACs on IPQ806x SoCs.
> It supports the device-tree and will register up to 4 ethernet
> interfaces.
> 
> Signed-off-by: Stephen Wang <wstephen@codeaurora.org>
> ---
[...]
> +/*
> + * NSS GMAC data plane ops, default would be slowpath and can be override by
> + * nss-drv
> + */
> +struct nss_gmac_data_plane_ops {
> +	int (*open)(void *ctx, uint32_t tx_desc_ring, uint32_t rx_desc_ring,
> +							uint32_t mode);
> +	int (*close)(void *ctx);
> +	int (*link_state)(void *ctx, uint32_t link_state);
> +	int (*mac_addr)(void *ctx, uint8_t *addr);
> +	int (*change_mtu)(void *ctx, uint32_t mtu);
> +	int (*xmit)(void *ctx, struct sk_buff *os_buf);
> +};

Weak types.

[...]
> +/*
> + * nss_gmac_register_offload()
> + *
> + * @param[netdev] netdev instance that is going to register
> + * @param[dp_ops] dataplan ops for chaning mac addr/mtu/link status
> + * @param[ctx] passing the ctx of this nss_phy_if to gmac
> + *
> + * @return Return SUCCESS or FAILURE
> + */
> +int nss_gmac_override_data_plane(struct net_device *netdev,
> +				struct nss_gmac_data_plane_ops *dp_ops,
> +				void *ctx)
> +{
> +	struct nss_gmac_dev *gmacdev = (struct nss_gmac_dev *)netdev_priv(netdev);
> +
> +	BUG_ON(!gmacdev);
> +
> +	if (!dp_ops->open || !dp_ops->close || !dp_ops->link_state
> +		|| !dp_ops->mac_addr || !dp_ops->change_mtu || !dp_ops->xmit) {
> +		netdev_dbg(netdev, "%s: All the op functions must be present, reject this registeration",
> +								__func__);
> +		return NSS_GMAC_FAILURE;
> +	}
> +
> +	/*
> +	 * If this gmac is up, close the netdev to force TX/RX stop
> +	 */
> +	if (test_bit(__NSS_GMAC_UP, &gmacdev->flags))
> +		nss_gmac_linux_close(netdev);
> +
> +	/* Recored the data_plane_ctx, data_plane_ops */
> +	gmacdev->data_plane_ctx = ctx;
> +	gmacdev->data_plane_ops = dp_ops;
> +	gmacdev->first_linkup_done = 0;
> +
> +	return NSS_GMAC_SUCCESS;
> +}
> +EXPORT_SYMBOL(nss_gmac_override_data_plane);

Why is this hook needed ?

-- 
Ueimor
