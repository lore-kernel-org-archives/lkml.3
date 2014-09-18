Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbaIROu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 10:50:29 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:57952 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756313AbaIROu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 10:50:26 -0400
Message-ID: <541AF116.9010004@st.com>
Date: Thu, 18 Sep 2014 16:49:58 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kweh Hock Leong <hock.leong.kweh@intel.com>,
        "David S. Miller" <davem@davemloft.net>, <rayagond@vayavyalabs.com>
Cc: Vince Bridgers <vbridgers2013@gmail.com>, Chen-Yu Tsai <wens@csie.org>,
        <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
Subject: Re: [PATCH] net: stmmac: fix stmmac_pci_probe failed when CONFIG_HAVE_CLK
 is selected
References: <1411043650-31712-1-git-send-email-hock.leong.kweh@intel.com>
In-Reply-To: <1411043650-31712-1-git-send-email-hock.leong.kweh@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.138.218]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-18_05:2014-09-18,2014-09-18,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/18/2014 2:34 PM, Kweh Hock Leong wrote:
> From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
>
> When the CONFIG_HAVE_CLK is selected for the system, the stmmac_pci_probe
> will fail with dmesg:
> [    2.167225] stmmaceth 0000:00:14.6: enabling device (0000 -> 0002)
> [    2.178267] stmmaceth 0000:00:14.6: enabling bus mastering
> [    2.178436] stmmaceth 0000:00:14.6: irq 24 for MSI/MSI-X
> [    2.178703] stmmaceth 0000:00:14.6: stmmac_dvr_probe: warning: cannot
> get CSR clock
> [    2.186503] stmmac_pci_probe: main driver probe failed
> [    2.194003] stmmaceth 0000:00:14.6: disabling bus mastering
> [    2.196473] stmmaceth: probe of 0000:00:14.6 failed with error -2
>
> This patch fix the issue by breaking the dependency to devm_clk_get()
> as the CSR clock can be obtained at priv->plat->clk_csr from pci driver.
>
> Reported-by: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>
> Signed-off-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>
> ---
>   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   13 +++++++++----
>   1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 08addd6..ea3859a 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -2714,10 +2714,15 @@ struct stmmac_priv *stmmac_dvr_probe(struct device *device,
>
>   	priv->stmmac_clk = devm_clk_get(priv->device, STMMAC_RESOURCE_NAME);
>   	if (IS_ERR(priv->stmmac_clk)) {
> -		dev_warn(priv->device, "%s: warning: cannot get CSR clock\n",


Hmm I am not sure this is the right fix. The driver has to fail if the
main clock is not found. Indeed dev_warn has to be changed in dev_err.

Take a look at Documentation/networking/stmmac.txt but I will post some
patch to improve the documentation adding further detail for clocks too.

The the logic behind the code is that the CSR clock will be set at
runtime if in case of priv->plat->clk_csr ==0 or it will be forced to
a fixed value if passed from the platform instead of.
IIRC This was required on some platforms time ago.
For sure the driver is designed to fail in case of no main clock is
found.

Peppe


> -			 __func__);
> -		ret = PTR_ERR(priv->stmmac_clk);
> -		goto error_clk_get;
> +		if (!priv->plat->clk_csr) {
> +			dev_warn(priv->device,
> +				 "%s: warning: cannot get CSR clock\n",
> +				 __func__);
> +			ret = PTR_ERR(priv->stmmac_clk);
> +			goto error_clk_get;
> +		} else {
> +			priv->stmmac_clk = NULL;
> +		}
>   	}
>   	clk_prepare_enable(priv->stmmac_clk);
>
>

