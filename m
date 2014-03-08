Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaCHPbj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 10:31:39 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:35828 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaCHPbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 10:31:37 -0500
X-Greylist: delayed 1452 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Mar 2014 10:31:37 EST
X-SENDER-IP: [85.230.168.69]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAKYxG1NV5qhF/2dsb2JhbAANTcVJgSGDGQEBAQECASdRAQULCyEWDwkDAgECAUUGAQwBBwEBh20NrUeiKheOWweEOAEDoxuLBQ
X-IPAS-Result: ApMBAKYxG1NV5qhF/2dsb2JhbAANTcVJgSGDGQEBAQECASdRAQULCyEWDwkDAgECAUUGAQwBBwEBh20NrUeiKheOWweEOAEDoxuLBQ
X-IronPort-AV: E=Sophos;i="4.97,614,1389740400"; 
   d="scan'208";a="615149335"
Message-ID: <531B3331.9050008@euromail.se>
Date: Sat, 08 Mar 2014 16:11:45 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>, dmitry.torokhov@gmail.com
CC: jcbian@pixcir.com.cn, balbi@ti.com, dmurphy@ti.com, mugunthanvnm@ti.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 4/8] Input: pixcir_i2c_ts: Use Type-B Multi-Touch protocol
References: <1393428486-15001-1-git-send-email-rogerq@ti.com> <1393428486-15001-5-git-send-email-rogerq@ti.com>
In-Reply-To: <1393428486-15001-5-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

the MT implementation seems mostly fine, just one curiosity:

>  static irqreturn_t pixcir_ts_isr(int irq, void *dev_id)
>  {
>  	struct pixcir_i2c_ts_data *tsdata = dev_id;
>  	const struct pixcir_ts_platform_data *pdata = tsdata->chip;
> +	struct pixcir_report_data report;
>  
>  	while (!tsdata->exiting) {
> -		pixcir_ts_poscheck(tsdata);
> -
> -		if (gpio_get_value(pdata->gpio_attb))
> +		/* parse packet */
> +		pixcir_ts_parse(tsdata, &report);
> +
> +		/* report it */
> +		pixcir_ts_report(tsdata, &report);
> +
> +		if (gpio_get_value(pdata->gpio_attb)) {
> +			if (report.num_touches) {
> +				/*
> +				 * Last report with no finger up?
> +				 * Do it now then.
> +				 */
> +				input_mt_sync_frame(tsdata->input);
> +				input_sync(tsdata->input);

Why is this special handling needed?

Thanks,
Henrik

