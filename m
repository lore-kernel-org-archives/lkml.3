Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbaLXBPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 20:15:14 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:2121 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaLXBPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 20:15:13 -0500
Message-ID: <549A138D.50204@atmel.com>
Date: Wed, 24 Dec 2014 09:14:53 +0800
From: "Wu, Songjun" <songjun.wu@atmel.com>
Organization: ATMEL
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nicolas.ferre@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] USB: gadget: udc: atmel: fix possible oops when unloading
 module
References: <1419240374-12179-1-git-send-email-songjun.wu@atmel.com> <20141223162419.GB9147@saruman>
In-Reply-To: <20141223162419.GB9147@saruman>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


在 12/24/2014 00:24, Felipe Balbi 写道:
> On Mon, Dec 22, 2014 at 05:26:14PM +0800, Songjun Wu wrote:
>> When unloading the module, the urb request will be dequeued
>> and the completion routine will be excuted.
>> If no urb packet, the urb request will not be added to the endpoint queue
>> and the completion routine pointer in urb request is NULL.
>> Accessing to the NULL function pointer will cause the oops issue.
>> Add the code to check the urb request is in the endpoint queue or not.
>> If the urb request is not in the endpoint queue, a negative error code
>> will be returned.
>
> have you triggered the NULL pointer oops ? Care to add it to the commit
> log.

Executing the 'insmod g_hid.ko', then executing the 'rmmod g_hid.ko', 
the NULL pointer oops will be triggered.

>
> Also, which commit is this fixing ? Does this need to be backported ?
> When was the bug introduced ?
>
>> Signed-off-by: Songjun Wu <songjun.wu@atmel.com>
>> ---
>>   drivers/usb/gadget/udc/atmel_usba_udc.c |   12 +++++++++++-
>>   1 file changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/gadget/udc/atmel_usba_udc.c b/drivers/usb/gadget/udc/atmel_usba_udc.c
>> index ce88237..48629cc 100644
>> --- a/drivers/usb/gadget/udc/atmel_usba_udc.c
>> +++ b/drivers/usb/gadget/udc/atmel_usba_udc.c
>> @@ -828,7 +828,7 @@ static int usba_ep_dequeue(struct usb_ep *_ep, struct usb_request *_req)
>>   {
>>   	struct usba_ep *ep = to_usba_ep(_ep);
>>   	struct usba_udc *udc = ep->udc;
>> -	struct usba_request *req = to_usba_req(_req);
>> +	struct usba_request *req;
>>   	unsigned long flags;
>>   	u32 status;
>>
>> @@ -837,6 +837,16 @@ static int usba_ep_dequeue(struct usb_ep *_ep, struct usb_request *_req)
>>
>>   	spin_lock_irqsave(&udc->lock, flags);
>>
>> +	list_for_each_entry(req, &ep->queue, queue) {
>> +		if (&req->req == _req)
>> +			break;
>> +	}
>> +
>> +	if (&req->req != _req) {
>> +		spin_unlock_irqrestore(&udc->lock, flags);
>> +		return -EINVAL;
>> +	}
>> +
>>   	if (req->using_dma) {
>>   		/*
>>   		 * If this request is currently being transferred,
>> --
>> 1.7.9.5
>>
>
