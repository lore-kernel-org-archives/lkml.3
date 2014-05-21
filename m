Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbaEUV6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:58:12 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:39671 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbaEUV6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:58:10 -0400
Message-ID: <537D2174.8040405@cogentembedded.com>
Date: Thu, 22 May 2014 01:58:12 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
CC: davem@davemloft.net, Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>, Li Yang <leoli@freescale.com>,
        Grant Likely <grant.likely@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Aida Mynzhasova <aida.mynzhasova@skitlab.ru>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@freescale.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH RESEND net-next 5/9] fs_enet: use the new fixed PHY helpers
References: <1400708331-18088-1-git-send-email-f.fainelli@gmail.com> <1400708331-18088-6-git-send-email-f.fainelli@gmail.com>
In-Reply-To: <1400708331-18088-6-git-send-email-f.fainelli@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 01:38 AM, Florian Fainelli wrote:

> of_phy_connect_fixed_link() is becoming obsolete, and also required
> platform code to register the fixed PHYs at the specified addresses for
> those to be usable. Get rid of it and use the new of_phy_is_fixed_link()
> plus of_phy_register_fixed_link() helpers to transition over the new
> scheme.

> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>   drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c | 16 +++++++++-------
>   1 file changed, 9 insertions(+), 7 deletions(-)

> diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
> index dc80db41d6b3..d602711e00e9 100644
> --- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
> +++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
[...]
> @@ -1029,9 +1025,15 @@ static int fs_enet_probe(struct platform_device *ofdev)
>   	fpi->use_napi = 1;
>   	fpi->napi_weight = 17;
>   	fpi->phy_node = of_parse_phandle(ofdev->dev.of_node, "phy-handle", 0);
> -	if ((!fpi->phy_node) && (!of_get_property(ofdev->dev.of_node, "fixed-link",
> -						  NULL)))
> -		goto out_free_fpi;
> +	if (!fpi->phy_node) {
> +		if (of_phy_is_fixed_link(ofdev->dev.of_node)) {

    These two *if* statements could be collapsed, reducing the indentation 
level below.

> +			err = of_phy_register_fixed_link(ofdev->dev.of_node);
> +			if (err)
> +				goto out_free_fpi;
> +
> +			fpi->phy_node = ofdev->dev.of_node;
> +		}
> +	}

WBR, Sergei

