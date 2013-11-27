Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab3K0Q6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:58:55 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:57955 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336Ab3K0Q6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:58:53 -0500
Message-ID: <529624CA.6030604@wwwdotorg.org>
Date: Wed, 27 Nov 2013 09:58:50 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>, thierry.reding@gmail.com,
        sameo@linux.intel.com, dev@lynxeye.de
CC: mark.rutland@arm.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: tps6586x: add version detection
References: <cover.1385508112.git.stefan@agner.ch> <ef881d39f78b75b4badeebb5be0264edc3906d86.1385508112.git.stefan@agner.ch>
In-Reply-To: <ef881d39f78b75b4badeebb5be0264edc3906d86.1385508112.git.stefan@agner.ch>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 04:45 PM, Stefan Agner wrote:
> Use the VERSIONCRC to determine the exact device version. According to
> the datasheet this register can be used as device identifier. The
> identification is needed since some tps6586x regulators use a different
> voltage table.

> diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c

> @@ -477,6 +486,7 @@ static int tps6586x_i2c_probe(struct i2c_client *client,
>  {
>  	struct tps6586x_platform_data *pdata = dev_get_platdata(&client->dev);
>  	struct tps6586x *tps6586x;
> +	const char *name = "";

There's no need to assign any value here; the switch below always
assigns something over the top of the variable, so it doesn't need to be
pre-initialized.

> +	tps6586x = devm_kzalloc(&client->dev, sizeof(*tps6586x), GFP_KERNEL);
> +	if (tps6586x == NULL) {
> +		dev_err(&client->dev, "memory for tps6586x alloc failed\n");
> +		return -ENOMEM;
> +	}

> +	tps6586x->version = (enum tps6586x_version)ret;

Why not make the version variable an integer of some kind. Then, the
cast wouldn't be required. The values like TPS658621A can be #defines or
const u32.

> +	switch (ret) {

That should switch on tps6586x->version since that's been assigned;
it'll make the purpose a bit clearer.

> +	default:
> +		name = "TPS6586X";
> +		break;
>  	}

I hope the rest of the code deals with unknown values of
tps6586x->version OK.
