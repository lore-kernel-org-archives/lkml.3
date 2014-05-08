Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbaEHUGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:06:04 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40960 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755465AbaEHUGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:06:02 -0400
Message-ID: <536BE3A7.8030402@free-electrons.com>
Date: Thu, 08 May 2014 22:05:59 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chen-Yu Tsai <wens@csie.org>, Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Subject: Re: [PATCH v2 2/7] reset: sunxi: allow MFD subdevices probe
References: <1399483554-8824-1-git-send-email-boris.brezillon@free-electrons.com> <1399483554-8824-3-git-send-email-boris.brezillon@free-electrons.com> <20140508030722.GL7047@lukather>
In-Reply-To: <20140508030722.GL7047@lukather>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/05/2014 05:07, Maxime Ripard wrote:
> On Wed, May 07, 2014 at 07:25:49PM +0200, Boris BREZILLON wrote:
>> The current implementation uses sunxi_reset_init function for both early
>> init and platform device probe.
>>
>> The sunxi_reset_init function uses DT to retrieve device resources, which
>> will be an issue if reset controllers are registered from an MFD device
>> that define resources from mfd_cell definition.
>>
>> Moreover, we can make of devm functions when we're in the probe context.
>>
>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> ---
>>  drivers/reset/reset-sunxi.c | 21 ++++++++++++++++++---
>>  1 file changed, 18 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/reset/reset-sunxi.c b/drivers/reset/reset-sunxi.c
>> index 695bd34..1b5fea6 100644
>> --- a/drivers/reset/reset-sunxi.c
>> +++ b/drivers/reset/reset-sunxi.c
>> @@ -145,7 +145,24 @@ MODULE_DEVICE_TABLE(of, sunxi_reset_dt_ids);
>>  
>>  static int sunxi_reset_probe(struct platform_device *pdev)
>>  {
>> -	return sunxi_reset_init(pdev->dev.of_node);
>> +	struct sunxi_reset_data *data;
>> +	struct resource *res;
>> +
>> +	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
>> +	if (!data)
>> +		return -ENOMEM;
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	data->membase = devm_request_and_ioremap(&pdev->dev, res);
>> +	if (!data->membase)
>> +		return -ENOMEM;
> You'd probably be better off using devm_ioremap_resource so that you
> get a meaningful error code.

Oh, I missed this one. I'll fix it for the next version.

> Apart from this, you have my 
> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>
> Thanks!
> Maxime
>

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

