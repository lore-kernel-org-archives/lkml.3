Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbaB1QSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 11:18:18 -0500
Received: from top.free-electrons.com ([176.31.233.9]:52742 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751447AbaB1QSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 11:18:16 -0500
Message-ID: <5310B6BF.10604@free-electrons.com>
Date: Fri, 28 Feb 2014 17:18:07 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: atmel_usba: Fix crashed during stopping
 when DEBUG is enabled
References: <1393598066-4016-1-git-send-email-gregory.clement@free-electrons.com> <20140228155027.GC2974@piout.net>
In-Reply-To: <20140228155027.GC2974@piout.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/02/2014 16:50, Alexandre Belloni wrote:
> Hi Gregory,
> 
> On 28/02/2014 at 15:34:01 +0100, Gregory CLEMENT wrote :
>> The debug trace in the atmel_usba_stop function made the assumption
>> that the driver pointer passed in parameter was not NULL. Since the
>> commit "usb: gadget: udc-core: fix a regression during gadget driver
>> unbinding", it was no more always true. This lead to a kernel crash.
>>
>> This commit now use the driver pointer stored in udc which fixes this
>> issue.
>>
>> Since the commit which have triggered this issue was backported to the
>> 3.2 stable branch, then this one should also be backported to the same
>> kernel.
>>
>> Cc: stable@vger.kernel.org # v3.2+
>> Fixes: 511f3c5326ea (usb: gadget: udc-core: fix a regression during gadget driver unbinding)
>> ---
>>  drivers/usb/gadget/atmel_usba_udc.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
>> index 52771d4c44bc..167843de2d8a 100644
>> --- a/drivers/usb/gadget/atmel_usba_udc.c
>> +++ b/drivers/usb/gadget/atmel_usba_udc.c
>> @@ -1827,12 +1827,12 @@ static int atmel_usba_stop(struct usb_gadget *gadget,
>>  	toggle_bias(0);
>>  	usba_writel(udc, CTRL, USBA_DISABLE_MASK);
>>  
>> -	udc->driver = NULL;
>> -
>>  	clk_disable_unprepare(udc->hclk);
>>  	clk_disable_unprepare(udc->pclk);
>>  
>> -	DBG(DBG_GADGET, "unregistered driver `%s'\n", driver->driver.name);
>> +	DBG(DBG_GADGET, "unregistered driver `%s'\n", udc->driver->driver.name);
>> +
>> +	udc->driver = NULL;
> 
> Shouldn't we get rid of that assignment as it is done in
> usb_gadget_remove_driver() anyway ?

usb_gadget_remove_driver() is not the only function to use it.
usb_udc_softconn_store() can call it too and doesn't have any
debug message.


Thanks,

Gregory


> 
>>  
>>  	return 0;
>>  }
>> -- 
>> 1.8.1.2
>>
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
