Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759826Ab3LHSxR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 13:53:17 -0500
Received: from 15.mo1.mail-out.ovh.net ([188.165.38.232]:43681 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755221Ab3LHSxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 13:53:15 -0500
Message-ID: <52A4C008.6050705@overkiz.com>
Date: Sun, 08 Dec 2013 19:52:56 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Grant Likely <grant.likely@linaro.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/3] usb: ohci-at91: replace request_mem_region + ioremap
 by devm_ioremap_resource
References: <1386514980-6383-1-git-send-email-b.brezillon@overkiz.com> <1386514980-6383-2-git-send-email-b.brezillon@overkiz.com> <52A4BAF6.501@cogentembedded.com>
In-Reply-To: <52A4BAF6.501@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 13838717231966550199
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Le 08/12/2013 19:31, Sergei Shtylyov a écrit :
> Hello.
>
> On 12/08/2013 06:02 PM, Boris BREZILLON wrote:
>
>> Replace the request_mem_region + ioremap calls by the
>> devm_ioremap_resource call which does the same things but with device
>> managed resources.
>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
>> ---
>>   drivers/usb/host/ohci-at91.c |   28 +++++++---------------------
>>   1 file changed, 7 insertions(+), 21 deletions(-)
>
>> diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
>> index 8c356af..fe2ecc5 100644
>> --- a/drivers/usb/host/ohci-at91.c
>> +++ b/drivers/usb/host/ohci-at91.c
>> @@ -158,24 +158,18 @@ static int usb_hcd_at91_probe(const struct 
>> hc_driver *driver,
>>       hcd->rsrc_start = res->start;
>>       hcd->rsrc_len = resource_size(res);
>>
>> -    if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, 
>> hcd_name)) {
>> -        pr_debug("request_mem_region failed\n");
>> -        retval = -EBUSY;
>> -        goto err1;
>> -    }
>> -
>> -    hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
>> -    if (!hcd->regs) {
>> -        pr_debug("ioremap failed\n");
>> -        retval = -EIO;
>> -        goto err2;
>> +    hcd->regs = devm_ioremap_resource(dev, res);
>> +    if (IS_ERR(hcd->regs)) {
>> +        dev_dbg(dev, "devm_ioremap_resource failed\n");
>
>    I've already told you devm_ioremap_resource() prints the detailed 
> error message. No need to duplicate it.
>

Oops, sorry, this is an oversight.
I'll send a new version removing this line.

Best Regards,

Boris

>> +        retval = PTR_ERR(hcd->regs);
>> +        goto err;
>>       }
>
> WBR, Sergei
>

