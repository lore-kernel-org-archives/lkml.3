Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab3LCRUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:20:30 -0500
Received: from 19.mo1.mail-out.ovh.net ([178.32.97.206]:49037 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752829Ab3LCRU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:20:29 -0500
Message-ID: <529E12CD.5040607@overkiz.com>
Date: Tue, 03 Dec 2013 18:20:13 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Grant Likely <grant.likely@linaro.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] usb: ohci-at91: use device managed clk retrieval
References: <1386079669-3995-1-git-send-email-b.brezillon@overkiz.com> <1386079669-3995-4-git-send-email-b.brezillon@overkiz.com> <529E1C82.8070501@cogentembedded.com>
In-Reply-To: <529E1C82.8070501@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 1468454955530352823
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sergei,

On 03/12/2013 19:01, Sergei Shtylyov wrote:
> Hello.
>
> On 12/03/2013 05:07 PM, Boris BREZILLON wrote:
>
>> Replace clk_get calls by devm_clk_get calls.
>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> Tested-by: Robert Nelson <robertcnelson@gmail.com>
>> ---
>>   drivers/usb/host/ohci-at91.c |   32 ++++++++------------------------
>>   1 file changed, 8 insertions(+), 24 deletions(-)
>
>> diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
>> index c406f1e..3652962 100644
>> --- a/drivers/usb/host/ohci-at91.c
>> +++ b/drivers/usb/host/ohci-at91.c
>> @@ -164,30 +164,30 @@ static int usb_hcd_at91_probe(const struct 
>> hc_driver *driver,
>>           goto err;
>>       }
>>
>> -    iclk = clk_get(&pdev->dev, "ohci_clk");
>> +    iclk = devm_clk_get(dev, "ohci_clk");
>>       if (IS_ERR(iclk)) {
>> -        dev_err(&pdev->dev, "failed to get ohci_clk\n");
>> +        dev_err(dev, "failed to get ohci_clk\n");
>
>    You changed this call...
>
>>           retval = PTR_ERR(iclk);
>>           goto err;
>>       }
>> -    fclk = clk_get(&pdev->dev, "uhpck");
>> +    fclk = devm_clk_get(dev, "uhpck");
>>       if (IS_ERR(fclk)) {
>>           dev_err(&pdev->dev, "failed to get uhpck\n");
>
>    ... but not this one.

This is an oversight.

>
>>           retval = PTR_ERR(fclk);
>> -        goto err4;
>> +        goto err;
>>       }
>> -    hclk = clk_get(&pdev->dev, "hclk");
>> +    hclk = devm_clk_get(dev, "hclk");
>>       if (IS_ERR(hclk)) {
>>           dev_err(&pdev->dev, "failed to get hclk\n");
>
>    ... or this one. Actually, I think cganging these calls would be 
> out of scope for this patch.

Ditto.

I'll split the patch to in 2 patches:
  1) replace &pdev->dev by dev
  2) use devm_clk_get instead of clk_get.

>
>>           retval = PTR_ERR(hclk);
>> -        goto err5;
>> +        goto err;
>>       }
>>       if (IS_ENABLED(CONFIG_COMMON_CLK)) {
>> -        uclk = clk_get(&pdev->dev, "usb_clk");
>> +        uclk = devm_clk_get(&pdev->dev, "usb_clk");
>
>    Hm, why not 'dev' like in all of the above?
Ditto.

Thanks for your review.

Best Regards,

Boris
>
>>           if (IS_ERR(uclk)) {
>>               dev_err(&pdev->dev, "failed to get uclk\n");
>>               retval = PTR_ERR(uclk);
>> -            goto err6;
>> +            goto err;
>>           }
>>       }
>>
>
> WBR, Sergei
>
>

