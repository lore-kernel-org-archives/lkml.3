Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaBKJvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 04:51:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbaBKJvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 04:51:42 -0500
Message-ID: <52F9F293.7080601@redhat.com>
Date: Tue, 11 Feb 2014 17:51:15 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Haiyang Zhang <haiyangz@microsoft.com>, davem@davemloft.net,
        netdev@vger.kernel.org
CC: kys@microsoft.com, olaf@aepfle.de, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net,v2] hyperv: Fix the carrier status setting
References: <1392056129-29398-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1392056129-29398-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 02:15 AM, Haiyang Zhang wrote:
> Without this patch, the "cat /sys/class/net/ethN/operstate" shows
> "unknown", and "ethtool ethN" shows "Link detected: yes", when VM
> boots up with or without vNIC connected.
>
> This patch fixed the problem.
>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/net/hyperv/netvsc_drv.c |   24 +++++++++++++++---------
>  1 files changed, 15 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
> index 7756118..18916f7 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -88,8 +88,12 @@ static int netvsc_open(struct net_device *net)
>  {
>  	struct net_device_context *net_device_ctx = netdev_priv(net);
>  	struct hv_device *device_obj = net_device_ctx->device_ctx;
> +	struct netvsc_device *nvdev;
> +	struct rndis_device *rdev;
>  	int ret = 0;
>  
> +	netif_carrier_off(net);
> +
>  	/* Open up the device */
>  	ret = rndis_filter_open(device_obj);
>  	if (ret != 0) {
> @@ -99,6 +103,11 @@ static int netvsc_open(struct net_device *net)
>  
>  	netif_start_queue(net);
>  
> +	nvdev = hv_get_drvdata(device_obj);
> +	rdev = nvdev->extension;
> +	if (!rdev->link_state)

What if the link status interrupt comes here at this time?
> +		netif_carrier_on(net);
> +
>  	return ret;
>  }
>  
> @@ -229,15 +238,17 @@ void netvsc_linkstatus_callback(struct hv_device *device_obj,
>  	struct net_device *net;
>  	struct net_device_context *ndev_ctx;
>  	struct netvsc_device *net_device;
> +	struct rndis_device *rdev;
>  
>  	net_device = hv_get_drvdata(device_obj);
> +	rdev = net_device->extension;
> +
> +	rdev->link_state = status != 1;
> +
>  	net = net_device->ndev;
>  
> -	if (!net) {
> -		netdev_err(net, "got link status but net device "
> -				"not initialized yet\n");
> +	if (!net || net->reg_state != NETREG_REGISTERED)
>  		return;
> -	}
>  
>  	if (status == 1) {
>  		netif_carrier_on(net);
> @@ -414,9 +425,6 @@ static int netvsc_probe(struct hv_device *dev,
>  	if (!net)
>  		return -ENOMEM;
>  
> -	/* Set initial state */
> -	netif_carrier_off(net);
> -
>  	net_device_ctx = netdev_priv(net);
>  	net_device_ctx->device_ctx = dev;
>  	hv_set_drvdata(dev, net);
> @@ -443,8 +451,6 @@ static int netvsc_probe(struct hv_device *dev,
>  	}
>  	memcpy(net->dev_addr, device_info.mac_adr, ETH_ALEN);
>  
> -	netif_carrier_on(net);
> -
>  	ret = register_netdev(net);
>  	if (ret != 0) {
>  		pr_err("Unable to register netdev.\n");

