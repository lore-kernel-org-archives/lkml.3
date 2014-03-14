Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbaCNSdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 14:33:06 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:40704 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881AbaCNSdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 14:33:03 -0400
Message-ID: <5323596E.5070209@cogentembedded.com>
Date: Fri, 14 Mar 2014 22:33:02 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Neil Horman <nhorman@tuxdriver.com>
CC: Shreyas Bhatewara <sbhatewara@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vmxnet3: fix building without CONFIG_PCI_MSI
References: <7825453.7LB7BmvA2b@wuerfel>
In-Reply-To: <7825453.7LB7BmvA2b@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03/13/2014 12:44 PM, Arnd Bergmann wrote:

> Since commit d25f06ea466e "vmxnet3: fix netpoll race condition",
> the vmxnet3 driver fails to build when CONFIG_PCI_MSI is disabled,
> because it unconditionally references the vmxnet3_msix_rx()
> function.

> To fix this, use the same #ifdef in the caller that exists around
> the function definition.

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Shreyas Bhatewara <sbhatewara@vmware.com>
> Cc: "VMware, Inc." <pv-drivers@vmware.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: stable@vger.kernel.org
> ---
> Found this during randconfig testing on ARM. Most of the time when
> I report network driver problems, they get fixed in the netdev tree
> before I even find them, but since this is for a patch marked "stable",
> I made a proper patch anyway.

> Please ignore if this is already a known problem, otherwise make sure
> the original patch doesn't get backported without addressing this
> issue first.

> diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
> index cbd898f..28965ad 100644
> --- a/drivers/net/vmxnet3/vmxnet3_drv.c
> +++ b/drivers/net/vmxnet3/vmxnet3_drv.c
> @@ -1761,13 +1761,16 @@ static void
>   vmxnet3_netpoll(struct net_device *netdev)
>   {
>   	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
> -	int i;
>
>   	switch (adapter->intr.type) {
> -	case VMXNET3_IT_MSIX:
> +#ifdef CONFIG_PCI_MSI
> +	case VMXNET3_IT_MSIX: {
> +		int i;

    This file's coding style assumes empty line after declaration, so does the 
networking coding style in general.

>   		for (i = 0; i < adapter->num_rx_queues; i++)
>   			vmxnet3_msix_rx(0, &adapter->rx_queue[i]);
>   		break;
> +	}
> +#endif
>   	case VMXNET3_IT_MSI:
>   	default:
>   		vmxnet3_intr(0, adapter->netdev);

WBR, Sergei

