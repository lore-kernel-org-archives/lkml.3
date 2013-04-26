Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850Ab3DZIL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 04:11:56 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:5795 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab3DZILv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:11:51 -0400
Message-ID: <517A3690.7000806@hp.com>
Date: Fri, 26 Apr 2013 16:10:56 +0800
From: ZhenHua <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130117 Thunderbird/19.0
MIME-Version: 1.0
To: ZhenHua <zhen-hual@hp.com>, "Li, Zhen-Hua" <zhen-hual@hp.com>,
        stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] driver,usb: Fix a warning in uhci-hcd driver
References: <1366961884-14238-1-git-send-email-zhen-hual@hp.com> <517A31A9.5070504@hp.com>
In-Reply-To: <517A31A9.5070504@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2013 03:50 PM, ZhenHua wrote:

> I think there is another patch needed. As Alan said in another
> mail, in the UHCI_RH_RUNNING_NODEVS case, it should not be stopped
> if the uhci device is HP iLo virtual usb.
>
correct: it should not be auto stopped if the uhci device is HP iLo 
virtual usb.
>
> Thanks
> Zhen-Hua
>
> On 04/26/2013 03:38 PM, Li, Zhen-Hua wrote:
>> This patch is trying to fix this bug on SLES11 SP2:
>>      https://bugzilla.novell.com/show_bug.cgi?id=817035
>>
>> On a large HP system with 64T memory and 60 logical cpus, when usb
>> driver inits the iLo Virtual USB Controller, there comes a warning
>> "Controller not stopped yet!". It is because the HP iLo virtual usb
>> device requires a longer delay.
>>
>> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
>> ---
>>   drivers/usb/host/uhci-hcd.c |    5 +++++
>>   drivers/usb/host/uhci-hub.c |   12 +++++++-----
>>   2 files changed, 12 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
>> index 4a86b63..af30517 100644
>> --- a/drivers/usb/host/uhci-hcd.c
>> +++ b/drivers/usb/host/uhci-hcd.c
>> @@ -355,6 +355,11 @@ __acquires(uhci->lock)
>>           if (uhci->dead)
>>               return;
>>       }
>> +
>> +    /* HP's iLo Virtual USB Controller requires a longer delay. */
>> +    if (uhci->wait_for_hp)
>> +        wait_for_HP(uhci, USBSTS, USBSTS_HCH, 1000);
>> +
>>       if (!(uhci_readw(uhci, USBSTS) & USBSTS_HCH))
>>           dev_warn(uhci_dev(uhci), "Controller not stopped yet!\n");
>>   diff --git a/drivers/usb/host/uhci-hub.c b/drivers/usb/host/uhci-hub.c
>> index f87bee6..c3f772c 100644
>> --- a/drivers/usb/host/uhci-hub.c
>> +++ b/drivers/usb/host/uhci-hub.c
>> @@ -120,14 +120,15 @@ static void uhci_finish_suspend(struct uhci_hcd 
>> *uhci, int port,
>>   }
>>     /* Wait for the UHCI controller in HP's iLO2 server management chip.
>> - * It can take up to 250 us to finish a reset and set the CSC bit.
>> + * It can take up to max_wait us to finish the operation.
>>    */
>> -static void wait_for_HP(struct uhci_hcd *uhci, unsigned long port_addr)
>> +static void wait_for_HP(struct uhci_hcd *uhci, unsigned long port_addr,
>> +        u16 status, int max_wait)
>>   {
>>       int i;
>>   -    for (i = 10; i < 250; i += 10) {
>> -        if (uhci_readw(uhci, port_addr) & USBPORTSC_CSC)
>> +    for (i = 10; i < max_wait; i += 10) {
>> +        if (uhci_readw(uhci, port_addr) & status)
>>               return;
>>           udelay(10);
>>       }
>> @@ -151,7 +152,8 @@ static void uhci_check_ports(struct uhci_hcd *uhci)
>>                   /* HP's server management chip requires
>>                    * a longer delay. */
>>                   if (uhci->wait_for_hp)
>> -                    wait_for_HP(uhci, port_addr);
>> +                    wait_for_HP(uhci, port_addr,
>> +                        USBPORTSC_CSC, 250);
>>                     /* If the port was enabled before, turning
>>                    * reset on caused a port enable change.
>

