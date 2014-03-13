Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbaCMLDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 07:03:18 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46950 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbaCMLDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 07:03:16 -0400
Date: Thu, 13 Mar 2014 07:02:58 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Shreyas Bhatewara <sbhatewara@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vmxnet3: fix building without CONFIG_PCI_MSI
Message-ID: <20140313110258.GB20768@hmsreliant.think-freely.org>
References: <7825453.7LB7BmvA2b@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7825453.7LB7BmvA2b@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 10:44:34AM +0100, Arnd Bergmann wrote:
> Since commit d25f06ea466e "vmxnet3: fix netpoll race condition",
> the vmxnet3 driver fails to build when CONFIG_PCI_MSI is disabled,
> because it unconditionally references the vmxnet3_msix_rx()
> function.
> 
> To fix this, use the same #ifdef in the caller that exists around
> the function definition.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Shreyas Bhatewara <sbhatewara@vmware.com>
> Cc: "VMware, Inc." <pv-drivers@vmware.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: stable@vger.kernel.org
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> ---
> Found this during randconfig testing on ARM. Most of the time when
> I report network driver problems, they get fixed in the netdev tree
> before I even find them, but since this is for a patch marked "stable",
> I made a proper patch anyway.
> 
> Please ignore if this is already a known problem, otherwise make sure
> the original patch doesn't get backported without addressing this
> issue first.
> 
> diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
> index cbd898f..28965ad 100644
> --- a/drivers/net/vmxnet3/vmxnet3_drv.c
> +++ b/drivers/net/vmxnet3/vmxnet3_drv.c
> @@ -1761,13 +1761,16 @@ static void
>  vmxnet3_netpoll(struct net_device *netdev)
>  {
>  	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
> -	int i;
>  
>  	switch (adapter->intr.type) {
> -	case VMXNET3_IT_MSIX:
> +#ifdef CONFIG_PCI_MSI
> +	case VMXNET3_IT_MSIX: {
> +		int i;
>  		for (i = 0; i < adapter->num_rx_queues; i++)
>  			vmxnet3_msix_rx(0, &adapter->rx_queue[i]);
>  		break;
> +	}
> +#endif
>  	case VMXNET3_IT_MSI:
>  	default:
>  		vmxnet3_intr(0, adapter->netdev);
> 
> 
