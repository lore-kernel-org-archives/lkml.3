Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbaIPHUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 03:20:21 -0400
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:38568 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbaIPHUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 03:20:20 -0400
X-Greylist: delayed 1947 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2014 03:20:19 EDT
X-LISTENER: [mailrelay1.bredband.net]
X-SENDER-IP: [92.33.28.242]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApcBAJ/cF1RcIRzy/2dsb2JhbAANU4Q30kkBgSeEfAEBBCcRQAEQCxgJFg8JAwIBAgEbKgYBDAEFAgEBiD+kdZcAAReOaWQHhEsBBKk4jG9qgQaBRAEBAQ
X-IPAS-Result: ApcBAJ/cF1RcIRzy/2dsb2JhbAANU4Q30kkBgSeEfAEBBCcRQAEQCxgJFg8JAwIBAgEbKgYBDAEFAgEBiD+kdZcAAReOaWQHhEsBBKk4jG9qgQaBRAEBAQ
X-IronPort-AV: E=Sophos;i="5.04,533,1406584800"; 
   d="scan'208";a="646277336"
Message-ID: <5417DCAF.5000303@gaisler.com>
Date: Tue, 16 Sep 2014 08:46:07 +0200
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: balbi@ti.com, Peter Chen <peter.chen@freescale.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, software@gaisler.com
Subject: Re: [PATCH] usb: gadget: udc_core: Use right kobj when calling sysfs_notify
References: <1410777748-28090-1-git-send-email-andreas@gaisler.com> <20140916020223.GD3379@peterchendt> <20140916051529.GB10498@saruman.home>
In-Reply-To: <20140916051529.GB10498@saruman.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-16 07:15, Felipe Balbi wrote:
> Hi,
>
> On Tue, Sep 16, 2014 at 10:02:25AM +0800, Peter Chen wrote:
>> On Mon, Sep 15, 2014 at 12:42:27PM +0200, Andreas Larsson wrote:
>>> The state attribute is connected to the kobj of the udc, not the gadget.
>>>
>>> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
>>> ---
>>>   drivers/usb/gadget/udc/udc-core.c |   14 +++++++++++++-
>>>   1 file changed, 13 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/usb/gadget/udc/udc-core.c b/drivers/usb/gadget/udc/udc-core.c
>>> index b0d9817..37c129a 100644
>>> --- a/drivers/usb/gadget/udc/udc-core.c
>>> +++ b/drivers/usb/gadget/udc/udc-core.c
>>> @@ -109,8 +109,20 @@ EXPORT_SYMBOL_GPL(usb_gadget_unmap_request);
>>>   static void usb_gadget_state_work(struct work_struct *work)
>>>   {
>>>   	struct usb_gadget	*gadget = work_to_gadget(work);
>>> +	struct usb_udc		*udc = NULL;
>>> +
>>> +	mutex_lock(&udc_lock);
>>> +	list_for_each_entry(udc, &udc_list, list)
>>> +		if (udc->gadget == gadget)
>>> +			goto found;
>>> +	mutex_unlock(&udc_lock);
>>> +
>>> +	return;
>>> +
>>> +found:
>>> +	mutex_unlock(&udc_lock);
>>>
>>> -	sysfs_notify(&gadget->dev.kobj, NULL, "state");
>>> +	sysfs_notify(&udc->dev.kobj, NULL, "state");
>>>   }
>>>
>>>   void usb_gadget_set_state(struct usb_gadget *gadget,
>>
>> What's the user mode difference with and without this patch?
>
> poll() will actually wakeup ?

Yes, that is indeed the difference.

Cheers,
Andreas Larsson
