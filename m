Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab3GWMrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 08:47:32 -0400
Received: from mail-db9lp0252.outbound.messaging.microsoft.com ([213.199.154.252]:38474
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756626Ab3GWMra convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 08:47:30 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Antonios Motakis <a.motakis@virtualopensystems.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
CC: Sachin Kamat <sachin.kamat@linaro.org>, Jiri Kosina <jkosina@suse.cz>,
        open list <linux-kernel@vger.kernel.org>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Cho KyongHo <pullip.cho@samsung.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Subject: RE: [PATCH] iommu/exynos: add devices attached to the System MMU to
 an	IOMMU group
Thread-Topic: [PATCH] iommu/exynos: add devices attached to the System MMU
 to an	IOMMU group
Thread-Index: AQHOh4u9nXaqpxzAAEuNAkqbLqk0aJlyNQ2g
Date: Tue, 23 Jul 2013 12:46:27 +0000
Message-ID: <C5ECD7A89D1DC44195F34B25E172658D0A3C0DB3@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1374573694-30595-1-git-send-email-a.motakis@virtualopensystems.com>
In-Reply-To: <1374573694-30595-1-git-send-email-a.motakis@virtualopensystems.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.249.187]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: iommu-bounces@lists.linux-foundation.org [mailto:iommu-
> bounces@lists.linux-foundation.org] On Behalf Of Antonios Motakis
> Sent: Tuesday, July 23, 2013 3:32 PM
> To: linux-arm-kernel@lists.infradead.org; iommu@lists.linux-
> foundation.org; linux-samsung-soc@vger.kernel.org
> Cc: Sachin Kamat; Jiri Kosina; open list; Wei Yongjun; Antonios Motakis;
> Cho KyongHo; kvmarm@lists.cs.columbia.edu
> Subject: [PATCH] iommu/exynos: add devices attached to the System MMU to
> an IOMMU group
> 
> IOMMU groups are expected by certain users of the IOMMU API, e.g. VFIO.
> Since each device is behind its own System MMU, we can allocate a new
> IOMMU group for each device.
> 
> This patch depends on Cho KyongHo's patch series titled "[PATCH v7 00/12]
> iommu/exynos: Fixes and Enhancements of System MMU driver with DT",
> applied on a Linux 3.10.1 kernel. It has been tested on the Arndale
> board.
> 
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> ---
>  drivers/iommu/exynos-iommu.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index 51d43bb..9f39eaa 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -1134,6 +1134,28 @@ static phys_addr_t
> exynos_iommu_iova_to_phys(struct iommu_domain *domain,
>  	return phys;
>  }
> 
> +static int exynos_iommu_add_device(struct device *dev) {
> +	struct iommu_group *group;
> +	int ret;
> +
> +	group = iommu_group_alloc();
> +	if (IS_ERR(group)) {
> +		dev_err(dev, "Failed to allocate IOMMU group\n");
> +		return PTR_ERR(group);
> +	}
> +
> +	ret = iommu_group_add_device(group, dev);
> +	iommu_group_put(group);
> +
> +	return ret;
> +}
> +
> +static void exynos_iommu_remove_device(struct device *dev) {
> +	iommu_group_remove_device(dev);
> +}
> +
>  static struct iommu_ops exynos_iommu_ops = {
>  	.domain_init = &exynos_iommu_domain_init,
>  	.domain_destroy = &exynos_iommu_domain_destroy, @@ -1142,6 +1164,8
> @@ static struct iommu_ops exynos_iommu_ops = {
>  	.map = &exynos_iommu_map,
>  	.unmap = &exynos_iommu_unmap,
>  	.iova_to_phys = &exynos_iommu_iova_to_phys,
> +	.add_device	= exynos_iommu_add_device,
> +	.remove_device	= exynos_iommu_remove_device,
>  	.pgsize_bitmap = SECT_SIZE | LPAGE_SIZE | SPAGE_SIZE,  };
> 
[Sethi Varun-B16395] Do you support PCI devices? This assumption of one iommu group per pci device may not hold true in case of PCI devices.

-Varun

