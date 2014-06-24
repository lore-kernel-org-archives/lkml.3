Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaFXFuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 01:50:08 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8878 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaFXFuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 01:50:06 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-8f-53a9118bfd98
Message-id: <53A9118A.7070100@samsung.com>
Date: Tue, 24 Jun 2014 07:50:02 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Robert Baldyga <r.baldyga@samsung.com>, "balbi@ti.com" <balbi@ti.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andrzej.p@samsung.com" <andrzej.p@samsung.com>
Subject: Re: [PATCH 06/11] usb: dwc2/gadget: ensure that all fifos have correct
 memory buffers
References: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
 <1403509890-14103-7-git-send-email-r.baldyga@samsung.com>
 <A2CA0424C0A6F04399FB9E1CD98E0304844B9CC5@US01WEMBX2.internal.synopsys.com>
In-reply-to: <A2CA0424C0A6F04399FB9E1CD98E0304844B9CC5@US01WEMBX2.internal.synopsys.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xy7rdgiuDDZovSFrMetnOYnHwfr1F
	8+L1bBaXd81hs1i0rJXZ4tHDrawWDw7vZHdg99g/dw27R9+WVYweW/Z/ZvQ4fmM7k8fnTXIB
	rFFcNimpOZllqUX6dglcGT2fKwraJSsutO1mbWD8K9zFyMkhIWAicX3BPmYIW0ziwr31bF2M
	XBxCAksZJQ4v+cMK4XxilPi25CAbSBWvgJbElTv3WUBsFgFViefN28HibAKGEl1vu8BsUYEY
	iTO9n5kh6gUlfky+B1YvIlAp8f7oHHaQocwCbxglju8+BtYgLJAgcf75MmaIbecZJU4+WwnW
	zSkQJXF94VxWEJtZwEziUcs6ZghbXmLzmrfMExgFZiFZMgtJ2SwkZQsYmVcxiqaWJhcUJ6Xn
	GuoVJ+YWl+al6yXn525ihIT5lx2Mi49ZHWIU4GBU4uG9sGtFsBBrYllxZe4hRgkOZiURXssv
	QCHelMTKqtSi/Pii0pzU4kOMTBycUg2MRZKxNlwOZo1rqm1L8jKW6nf6Sx4/N2fS1jvvDT/7
	Pp28a/fEvQ9jOrY9uSYyZe49y3sPz+/XbmV1s14nNVljk77hFsOdK+5+Snm3qDjkvpeXjOOF
	qWpSE9N7mM9Mf3DyTFcy96q7T+Sbcm/7S7Z+Wq1R1qM1m7XDuo7niEJ2+4roJXsl4k5IKbEU
	ZyQaajEXFScCACtlHMhRAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-06-23 20:40, Paul Zimmerman wrote:
>> From: Robert Baldyga [mailto:r.baldyga@samsung.com]
>> Sent: Monday, June 23, 2014 12:51 AM
>>
>> From: Marek Szyprowski <m.szyprowski@samsung.com>
>>
>> Print warning if FIFOs are configured in such a way that they don't fit
>> into the SPRAM available on the s3c hsotg module.
>>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
>> ---
>>   drivers/usb/dwc2/core.h   |  1 +
>>   drivers/usb/dwc2/gadget.c | 15 ++++++++++-----
>>   2 files changed, 11 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
>> index 1efd10c..067390e 100644
>> --- a/drivers/usb/dwc2/core.h
>> +++ b/drivers/usb/dwc2/core.h
>> @@ -194,6 +194,7 @@ struct s3c_hsotg {
>>   	struct regulator_bulk_data supplies[ARRAY_SIZE(s3c_hsotg_supply_names)];
>>
>>   	u32                     phyif;
>> +	int			fifo_mem;
>>   	unsigned int            dedicated_fifos:1;
>>   	unsigned char           num_of_eps;
>>
>> diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
>> index 95b6dcb..21d21de 100644
>> --- a/drivers/usb/dwc2/gadget.c
>> +++ b/drivers/usb/dwc2/gadget.c
>> @@ -194,6 +194,8 @@ static void s3c_hsotg_init_fifo(struct s3c_hsotg *hsotg)
>>   	for (ep = 1; ep <= 15; ep++) {
>>   		val = addr;
>>   		val |= size << FIFOSIZE_DEPTH_SHIFT;
>> +		WARN_ONCE(addr + size > hsotg->fifo_mem,
>> +			  "insufficient fifo memory");
>>   		addr += size;
>>
>>   		writel(val, hsotg->regs + DPTXFSIZN(ep));
>> @@ -3030,19 +3032,22 @@ static void s3c_hsotg_initep(struct s3c_hsotg *hsotg,
>>    */
>>   static void s3c_hsotg_hw_cfg(struct s3c_hsotg *hsotg)
>>   {
>> -	u32 cfg2, cfg4;
>> +	u32 cfg2, cfg3, cfg4;
>>   	/* check hardware configuration */
>>
>>   	cfg2 = readl(hsotg->regs + 0x48);
>>   	hsotg->num_of_eps = (cfg2 >> 10) & 0xF;
>>
>> -	dev_info(hsotg->dev, "EPs:%d\n", hsotg->num_of_eps);
>> +	cfg3 = readl(hsotg->regs + 0x4C);
>> +	hsotg->fifo_mem = (cfg3 >> 16);
>>
>>   	cfg4 = readl(hsotg->regs + 0x50);
>>   	hsotg->dedicated_fifos = (cfg4 >> 25) & 1;
>>
>> -	dev_info(hsotg->dev, "%s fifos\n",
>> -		 hsotg->dedicated_fifos ? "dedicated" : "shared");
>> +	dev_info(hsotg->dev, "EPs: %d, %s fifos, %d entries in SPRAM\n",
>> +		 hsotg->num_of_eps,
>> +		 hsotg->dedicated_fifos ? "dedicated" : "shared",
>> +		 hsotg->fifo_mem);
>>   }
>>
>>   /**
>> @@ -3495,8 +3500,8 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
>>   	s3c_hsotg_phy_enable(hsotg);
>>
>>   	s3c_hsotg_corereset(hsotg);
>> -	s3c_hsotg_init(hsotg);
>>   	s3c_hsotg_hw_cfg(hsotg);
>> +	s3c_hsotg_init(hsotg);
> This last hunk looks like it is not related to the rest of the patch? If
> so, I think it should be a separate patch.

s3c_hsotg_hw_cfg() only reads hw configuration and some values read there (fifo_mem)
are used in s3c_hsotg_init_fifo(), which is called from s3c_hsotg_init(). This chunk
really belongs to this patch, although it might not be easy to notice it at the first
glance.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

