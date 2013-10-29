Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab3J2X56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 19:57:58 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:64720 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab3J2X54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 19:57:56 -0400
Message-ID: <52704B80.2040507@gmail.com>
Date: Wed, 30 Oct 2013 00:57:52 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        linux@arm.linux.org.uk, jiada_wang@mentor.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH v7 1/5] omap3isp: Modify clocks registration to avoid
 circular references
References: <1383076268-8984-1-git-send-email-s.nawrocki@samsung.com> <1383076268-8984-2-git-send-email-s.nawrocki@samsung.com> <16467881.81yEf9zq68@avalon>
In-Reply-To: <16467881.81yEf9zq68@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

(adding Mauro and LMML at Cc)

On 10/29/2013 11:28 PM, Laurent Pinchart wrote:
> Hi Sylwester,
>
> Thank you for the patch.
>
> On Tuesday 29 October 2013 20:51:04 Sylwester Nawrocki wrote:
>> The clock core code is going to be modified so clk_get() takes
>> reference on the clock provider module. Until the potential circular
>> reference issue is properly addressed, we pass NULL as as the first
>> argument to clk_register(), in order to disallow sub-devices taking
>> a reference on the ISP module back trough clk_get(). This should
>> prevent locking the modules in memory.
>>
>> Cc: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>
> Acked-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
>
> Do you plan to push this to mainline as part of this patch series ? I don't
> have pending patches for the omap3isp that would conflict with this patch, so
> that would be fine with me.

Thanks, yes I thought this patch might be merged together through the clk
tree, if Mike is willing to take it and we get yours and Mauro's Ack on it.

>> ---
>> This patch has been "compile tested" only.
>>
>> ---
>>   drivers/media/platform/omap3isp/isp.c |   22 ++++++++++++++++------
>>   drivers/media/platform/omap3isp/isp.h |    1 +
>>   2 files changed, 17 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/media/platform/omap3isp/isp.c
>> b/drivers/media/platform/omap3isp/isp.c index df3a0ec..286027a 100644
>> --- a/drivers/media/platform/omap3isp/isp.c
>> +++ b/drivers/media/platform/omap3isp/isp.c
>> @@ -290,9 +290,11 @@ static int isp_xclk_init(struct isp_device *isp)
>>   	struct clk_init_data init;
>>   	unsigned int i;
>>
>> +	for (i = 0; i<  ARRAY_SIZE(isp->xclks); ++i)
>> +		isp->xclks[i].clk = ERR_PTR(-EINVAL);
>> +
>>   	for (i = 0; i<  ARRAY_SIZE(isp->xclks); ++i) {
>>   		struct isp_xclk *xclk =&isp->xclks[i];
>> -		struct clk *clk;
>>
>>   		xclk->isp = isp;
>>   		xclk->id = i == 0 ? ISP_XCLK_A : ISP_XCLK_B;
>> @@ -305,10 +307,15 @@ static int isp_xclk_init(struct isp_device *isp)
>>   		init.num_parents = 1;
>>
>>   		xclk->hw.init =&init;
>> -
>> -		clk = devm_clk_register(isp->dev,&xclk->hw);
>> -		if (IS_ERR(clk))
>> -			return PTR_ERR(clk);
>> +		/*
>> +		 * The first argument is NULL in order to avoid circular
>> +		 * reference, as this driver takes reference on the
>> +		 * sensor subdevice modules and the sensors would take
>> +		 * reference on this module through clk_get().
>> +		 */
>> +		xclk->clk = clk_register(NULL,&xclk->hw);
>> +		if (IS_ERR(xclk->clk))
>> +			return PTR_ERR(xclk->clk);
>>
>>   		if (pdata->xclks[i].con_id == NULL&&
>>   		pdata->xclks[i].dev_id == NULL)
>> @@ -320,7 +327,7 @@ static int isp_xclk_init(struct isp_device *isp)
>>
>>   		xclk->lookup->con_id = pdata->xclks[i].con_id;
>>   		xclk->lookup->dev_id = pdata->xclks[i].dev_id;
>> -		xclk->lookup->clk = clk;
>> +		xclk->lookup->clk = xclk->clk;
>>
>>   		clkdev_add(xclk->lookup);
>>   	}
>> @@ -335,6 +342,9 @@ static void isp_xclk_cleanup(struct isp_device *isp)
>>   	for (i = 0; i<  ARRAY_SIZE(isp->xclks); ++i) {
>>   		struct isp_xclk *xclk =&isp->xclks[i];
>>
>> +		if (!IS_ERR(xclk->clk))
>> +			clk_unregister(xclk->clk);
>> +
>>   		if (xclk->lookup)
>>   			clkdev_drop(xclk->lookup);
>>   	}
>> diff --git a/drivers/media/platform/omap3isp/isp.h
>> b/drivers/media/platform/omap3isp/isp.h index cd3eff4..1498f2b 100644
>> --- a/drivers/media/platform/omap3isp/isp.h
>> +++ b/drivers/media/platform/omap3isp/isp.h
>> @@ -135,6 +135,7 @@ struct isp_xclk {
>>   	struct isp_device *isp;
>>   	struct clk_hw hw;
>>   	struct clk_lookup *lookup;
>> +	struct clk *clk;
>>   	enum isp_xclk_id id;
>>
>>   	spinlock_t lock;	/* Protects enabled and divider */

--
Regards,
Sylwester
