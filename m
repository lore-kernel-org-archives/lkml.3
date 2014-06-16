Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbaFPJou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:44:50 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:56308 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528AbaFPJot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:44:49 -0400
Message-ID: <539EBC8E.6060602@dev.rtsoft.ru>
Date: Mon, 16 Jun 2014 13:44:46 +0400
From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Organization: RTSoft Software Development Center
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Andreas Larsson <andreas@gaisler.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
CC: linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru
Subject: Re: [PATCH 20/21] usb: use devm_irq_of_parse_and_map() where appropriate
References: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru> <1401880402-30091-21-git-send-email-nyushchenko@dev.rtsoft.ru> <539EBA6F.7060008@gaisler.com>
In-Reply-To: <539EBA6F.7060008@gaisler.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> diff --git a/drivers/usb/host/ehci-grlib.c
>> b/drivers/usb/host/ehci-grlib.c
>> index 495b6fb..666c03e 100644
>> --- a/drivers/usb/host/ehci-grlib.c
>> +++ b/drivers/usb/host/ehci-grlib.c
>> @@ -111,11 +111,11 @@ static int ehci_hcd_grlib_probe(struct
>> platform_device *op)
>>       hcd->rsrc_start = res.start;
>>       hcd->rsrc_len = resource_size(&res);
>>
>> -    irq = irq_of_parse_and_map(dn, 0);
>> -    if (irq == NO_IRQ) {
>> -        dev_err(&op->dev, "%s: irq_of_parse_and_map failed\n",
>> +    irq = devm_irq_of_parse_and_map(&op->dev, dn, 0);
>> +    if (irq <= 0) {
>> +        dev_err(&op->dev, "%s: devm_irq_of_parse_and_map failed\n",
>>               __FILE__);
>> -        rv = -EBUSY;
>> +        rv = irq ? irq : -EINVAL;
> 
> Here and in more places below you change the return value from -EBUSY to
> -EINVAL when irq == 0. These changes and the reason for them is not
> something that is commented upon in the commit message. Maybe these
> changes were not intended or should be in a separate patch?

Although errno codes are quite unspecific, I can't think a valid reason
to return -EBUSY on [devm_]irq_of_parse_and_map() failure. It could be
-EINVAL or -ENODEV, but not -EBUSY ...

Since changing line that sets error code anyway, I decided to change
-EBUST to -ENODEV.

But I agree that this is not the topic of the patch.

IS it better to remove this change from changeset alltogether, or to
mention it in commit's log message?
