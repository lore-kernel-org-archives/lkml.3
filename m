Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab3LERHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:07:00 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:40328 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab3LERG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:06:58 -0500
Message-ID: <52A0B2AF.60803@wwwdotorg.org>
Date: Thu, 05 Dec 2013 10:06:55 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>, thierry.reding@gmail.com, dev@lynxeye.de,
        lee.jones@linaro.org, lgirdwood@gmail.com, broonie@kernel.org
CC: kai.poggensee@avionic-design.de, sameo@linux.intel.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] mfd: tps6586x: add version detection
References: <cover.1386108712.git.stefan@agner.ch> <77384d24810d9a22fc04cad6f7468f54a9cbaafe.1386108712.git.stefan@agner.ch>
In-Reply-To: <77384d24810d9a22fc04cad6f7468f54a9cbaafe.1386108712.git.stefan@agner.ch>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 03:18 PM, Stefan Agner wrote:
> Use the VERSIONCRC to determine the exact device version. According to
> the datasheet this register can be used as device identifier. The
> identification is needed since some tps6586x regulators use a different
> voltage table.

> diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c

> @@ -493,13 +527,12 @@ static int tps6586x_i2c_probe(struct i2c_client *client,
>  		return -EIO;
>  	}
>  
> -	dev_info(&client->dev, "VERSIONCRC is %02x\n", ret);
> -
>  	tps6586x = devm_kzalloc(&client->dev, sizeof(*tps6586x), GFP_KERNEL);
> -	if (tps6586x == NULL) {
> -		dev_err(&client->dev, "memory for tps6586x alloc failed\n");
> +	if (!tps6586x)
>  		return -ENOMEM;
> -	}
> +
> +	tps6586x->version = ret;

I have to say, I dislike this version of the patch. Separating the
reading of the version register from the assignment to tps6586x->version
doesn't make any sense, especially given that the version value is
stored in a variable named "ret"; that name isn't remotely related to
what's stored there. What if someone comes along later and adds more
code that assigns to ret between where it's repurposed for the version
value and where it's assigned to tps6586x->version? It'd be extremely
difficult for a patch reviewer to spot that given the limited context in
a diff, and quite non-obvious to the person changing the code too..
