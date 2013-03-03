Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab3CCKe7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 05:34:59 -0500
Received: from 19.mo4.mail-out.ovh.net ([87.98.179.66]:44125 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752369Ab3CCKe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 05:34:57 -0500
Date: Sun, 3 Mar 2013 11:27:43 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        nicolas.ferre@atmel.com, richard.genoud@gmail.com, JM.Lin@atmel.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH v5 01/16] spi/spi-atmel: fix master->num_chipselect
 wrongly set.
Message-ID: <20130303102743.GM30595@game.jcrosoft.org>
References: <1361861289-30332-1-git-send-email-wenyou.yang@atmel.com>
 <1361861289-30332-2-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361861289-30332-2-git-send-email-wenyou.yang@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 2726366625274899333
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiuddrudefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiuddrudefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:47 Tue 26 Feb     , Wenyou Yang wrote:
> if the spi property "cs-gpios" is set as below:
> 
> 	cs-gpios = <0>, <&pioC 11 0>, <0>, <0>;
> 
> the master->num_chipselect will wrongly be set to 0,
> and the spi fail to probe.
> 
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> Cc: spi-devel-general@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/spi/spi-atmel.c |    2 +-
>  drivers/spi/spi.c       |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
> index ab34497..5bf3786 100644
> --- a/drivers/spi/spi-atmel.c
> +++ b/drivers/spi/spi-atmel.c
> @@ -944,7 +944,7 @@ static int atmel_spi_probe(struct platform_device *pdev)
>  
>  	master->dev.of_node = pdev->dev.of_node;
>  	master->bus_num = pdev->id;
> -	master->num_chipselect = master->dev.of_node ? 0 : 4;
> +	master->num_chipselect = 4;
Nack

we use 0 hardware gpio we only use the cs-gpio

and you do not follow the binding

it's
	cs-gpios = < 0 0 0
	 	    &pioC 11 0>;

so the code work a expected

Best Regards,
J.
>  	master->setup = atmel_spi_setup;
>  	master->transfer = atmel_spi_transfer;
>  	master->cleanup = atmel_spi_cleanup;
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 19ee901..d88cbef 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -1070,7 +1070,7 @@ static int of_spi_register_master(struct spi_master *master)
>  	master->num_chipselect = max(nb, master->num_chipselect);
>  
>  	if (nb < 1)
> -		return 0;
> +		nb = master->num_chipselect;
>  
>  	cs = devm_kzalloc(&master->dev,
>  			  sizeof(int) * master->num_chipselect,
> -- 
> 1.7.9.5
> 
