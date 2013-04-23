Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124Ab3DWX4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 19:56:14 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:23277 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab3DWX4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 19:56:12 -0400
Message-ID: <51771F66.3080801@hp.com>
Date: Wed, 24 Apr 2013 07:55:18 +0800
From: ZhenHua <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130117 Thunderbird/19.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom.vaden@hp.com
Subject: Re: [PATCH 1/1] driver,usb: Fix a warning in uhci-hcd driver
References: <1366701301-16603-1-git-send-email-zhen-hual@hp.com> <20130423140734.GA30877@kroah.com>
In-Reply-To: <20130423140734.GA30877@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2013 10:07 PM, Greg KH wrote:
> On Tue, Apr 23, 2013 at 03:15:01PM +0800, Li, Zhen-Hua wrote:
>> From: "Li, Zhen-Hua" <zhen-hual@hp.com>
>>
>> This patch is trying to fix bug QXCR1001261767.
Sorry for the bug number. Please ignore this line.

> What is that bug number?  Where can it be referenced?  If you are going
> to put it in a public place (like a kernel changelog), it needs to be
> publicly accessible.
>
>> On some HP platform, when usb driver inits the iLo Virtual USB Controller, there may be a warning "Controller not stopped yet!". It is because driver does not wait enough time.
> What happened to your line endings?
>
>> This patch adds more time waiting and retries.
> Why not only do this for your device?
>
>> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
>> ---
>>   drivers/usb/host/uhci-hcd.c |   16 +++++++++++++++-
>>   1 file changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
>> index 4a86b63..514e9d7 100644
>> --- a/drivers/usb/host/uhci-hcd.c
>> +++ b/drivers/usb/host/uhci-hcd.c
>> @@ -277,6 +277,9 @@ static int global_suspend_mode_is_broken(struct uhci_hcd *uhci)
>>   		uhci->global_suspend_mode_is_broken(uhci) : 0;
>>   }
>>   
>> +#define UHCI_SUSPENDRH_RETRY_MAX      10
>> +#define UHCI_SUSPENDRH_RETRY_DELAY    100
>> +
>>   static void suspend_rh(struct uhci_hcd *uhci, enum uhci_rh_state new_state)
>>   __releases(uhci->lock)
>>   __acquires(uhci->lock)
>> @@ -284,6 +287,7 @@ __acquires(uhci->lock)
>>   	int auto_stop;
>>   	int int_enable, egsm_enable, wakeup_enable;
>>   	struct usb_device *rhdev = uhci_to_hcd(uhci)->self.root_hub;
>> +	u16 try, stopped;
>>   
>>   	auto_stop = (new_state == UHCI_RH_AUTO_STOPPED);
>>   	dev_dbg(&rhdev->dev, "%s%s\n", __func__,
>> @@ -355,7 +359,17 @@ __acquires(uhci->lock)
>>   		if (uhci->dead)
>>   			return;
>>   	}
>> -	if (!(uhci_readw(uhci, USBSTS) & USBSTS_HCH))
>> +
>> +	for (try = 0; try < UHCI_SUSPENDRH_RETRY_MAX; try++) {
>> +		/*
>> +		 * Sometimes we may need to wait more time and try again.
>> +		 */
> "Sometimes"?  Please be more specific.  Also, a multi-line comment isn't
> needed, make it one line please.
>
> thanks,
>
> greg k-h

