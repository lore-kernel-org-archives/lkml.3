Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab3CSJYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:24:05 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:58665 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628Ab3CSJYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:24:03 -0400
Message-ID: <51482EAF.20105@slimlogic.co.uk>
Date: Tue, 19 Mar 2013 09:23:59 +0000
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: sameo@linux.intel.com, swarren@nvidia.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] mfd: palmas: initialise client->of_node for dummy created
 client
References: <1363683500-24891-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1363683500-24891-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I discussed this with Grant Likely and we came to the same conclusion
that this was the only way to "fix" the issue. But his concern was
because dummys have a probe/remove of their own this might cause issues
in some cases. His opinion was to do this the probe/remove of the dummys
should also be removed to make them not real devices.

I have added him to CC in case my memory is faulty!

This is a generic issue which will affect all multi address i2c mfds.

Graeme

On 19/03/13 08:58, Laxman Dewangan wrote:
> Palmas device have three different i2c addresses. The device creates
> the two new dummy i2c clients for accessing the register by using
> primary client adapter. This new dummy i2c client have their of_node
> as NULL.
>
> The dummy i2c client is used for registering interrupt and on this,
> it creates irq domain handle. This created irq domain handle has
> their of_node as NULL.
>
> Now when any child of this device is registered through the DT as
> follows:
>          palmas: tps65913@58 {
>          	::::::::::::::::::
>
>          	#interrupt-cells = <2>;
>                 interrupt-controller;
>
>                 palmas_rtc {
>                        compatible = "ti,palmas-rtc";
>                        interrupt-parent = <&palmas>;
>                        interrupts = <8 0>;
>                 };
>                 ::::::::::;;;
>          };
>
> And child driver (palam-rtc in this case) get their irq number as
> 	irq = platform_get_irq(pdev, 0);
>
> The returned irq number is error in this case. The reason is that
> the created irq_domain handle for the palmas interrupt does not have
> valid node and so matching of node fails with palmas node.
>
> Hence initialising the newly dummy created client->of_node with the
> primary clients of_node so that irq_domain handle have proper of_node
> for matching.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/mfd/palmas.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
> index 73bf76d..a3f2836 100644
> --- a/drivers/mfd/palmas.c
> +++ b/drivers/mfd/palmas.c
> @@ -349,6 +349,7 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
>  				ret = -ENOMEM;
>  				goto err;
>  			}
> +			palmas->i2c_clients[i]->dev.of_node = of_node_get(node);
>  		}
>  		palmas->regmap[i] = devm_regmap_init_i2c(palmas->i2c_clients[i],
>  				&palmas_regmap_config[i]);

