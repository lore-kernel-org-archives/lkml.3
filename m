Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161619Ab3DEHvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 03:51:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932563Ab3DEHvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 03:51:31 -0400
Message-ID: <515E827C.3070702@redhat.com>
Date: Fri, 05 Apr 2013 09:51:24 +0200
From: Ivan Vecera <ivecera@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130318 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Craig Hada <craig.hada@hp.com>, netdev@vger.kernel.org,
        sathya.perla@emulex.com, subbu.seetharaman@emulex.com,
        ajit.khaparde@emulex.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] drivers/net: Enable IOMMU pass through for
 be2net
References: <1358562195-2028-1-git-send-email-craig.hada@hp.com> <1358562195-2028-2-git-send-email-craig.hada@hp.com>
In-Reply-To: <1358562195-2028-2-git-send-email-craig.hada@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2013 03:23 AM, Craig Hada wrote:
> This patch sets the coherent DMA mask to 64-bit after the be2net driver
> has been acknowledged that the system is 64-bit DMA capable. The coherent
> DMA mask is examined by the Intel IOMMU driver to determine whether to
> allow pass through context mapping for all devices. With this patch, the
> be2net driver combined with be2net compatible hardware provides
> comparable performance to the case where vt-d is disabled. The main use
> case for this change is to decrease the time necessary to copy virtual
> machine memory during KVM live migration instantiations.
>
> This patch was tested on a system that enables the IOMMU in non-coherent
> mode. Two DMA remapper issues were encountered in the previous version and
> both patches have been committed.
>      commit ea2447f700cab264019b52e2b417d689e052dcfd
>      commit 2e12bc29fc5a12242d68e11875db3dd58efad9ff
>
> Signed-off-by: Craig Hada <craig.hada@hp.com>
> ---
>   drivers/net/ethernet/emulex/benet/be_main.c |    6 ++++++
>   1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
> index 9dca22b..b507e99 100644
> --- a/drivers/net/ethernet/emulex/benet/be_main.c
> +++ b/drivers/net/ethernet/emulex/benet/be_main.c
> @@ -4052,6 +4052,12 @@ static int be_probe(struct pci_dev *pdev, const struct pci_device_id *pdev_id)
>
>   	status = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
>   	if (!status) {
> +		status = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
> +		if (status < 0) {
> +			dev_err(&pdev->dev,
> +				"dma_set_coherent_mask failed, aborting\n");
> +			goto free_netdev;
> +		}
>   		netdev->features |= NETIF_F_HIGHDMA;
>   	} else {
>   		status = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
>

Dave, I'd like to ask when do you plan to apply this patch?

Thanks,
Ivan
