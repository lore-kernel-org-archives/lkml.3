Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386Ab3HNWkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 18:40:06 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:51752 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933291Ab3HNWkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 18:40:05 -0400
Message-ID: <520C0741.3010905@jollamobile.com>
Date: Thu, 15 Aug 2013 01:40:01 +0300
From: Philippe De Swert <philippe.deswert@jollamobile.com>
Organization: Jolla Oy
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: balbi@ti.com
CC: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget/composite : Avoid crash with bad gadget drivers
References: <1376072588-2881-1-git-send-email-philippe.deswert@jollamobile.com> <20130812180804.GE27954@radagast>
In-Reply-To: <20130812180804.GE27954@radagast>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/08/13 21:08, Felipe Balbi wrote:
> On Fri, Aug 09, 2013 at 09:23:08PM +0300, Philippe De Swert wrote:
>> Some bad gadget drivers do not check the return status of usb_add_config.
>
> fix the gadget driver

As stated in my comment (see below) that is indeed what should happen. 
But we cannot fix it in future new gadget drivers, is it thus not better
to avoid a crash? The gadget driver will not work as expected anyway 
when this occurs and the print will at least give an indication why.

>> Thus they get a not correctly initialized config and when this gadget gets
>> deactivated the whole kernel crashes. Since on initialization failure cdev
>> is set to NULL it can be used to detect this problem situation. It can be
>> argued that the faulty gadget driver should be fixed, but imho it is better
>> to avoid crashing the kernel and letting the gadget developer know he/she
>> is making a mistake. And have the developer of said gadget driver then fix
>> the problem of course.
>>
>> Signed-off-by: Philippe De Swert <philippe.deswert@jollamobile.com>
>> ---
>>   drivers/usb/gadget/composite.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
>> index 55f4df6..e019bb5 100644
>> --- a/drivers/usb/gadget/composite.c
>> +++ b/drivers/usb/gadget/composite.c
>> @@ -848,12 +848,18 @@ void usb_remove_config(struct usb_composite_dev *cdev,
>>   {
>>   	unsigned long flags;
>>
>> +	if (config->cdev == NULL) {
>> +		pr_warn("Calling usb_remove_config without a matching usb_add_config!\n");
>> +		goto end;
>> +	}
>
> I would take a WARN() only, but let the crash happen and fix the gadget
> driver.
>

Since the kernel will crash with a NULL dereference anyway is BUG_ON not 
a better approach then?

Regards,

Philippe
