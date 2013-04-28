Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab3D1BwE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 21:52:04 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:14050 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab3D1BwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 21:52:01 -0400
Message-ID: <517C808A.2060502@hp.com>
Date: Sun, 28 Apr 2013 09:51:06 +0800
From: ZhenHua <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130117 Thunderbird/19.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] driver,usb: Fix a warning in uhci-hcd driver
References: <Pine.LNX.4.44L0.1304271111530.30732-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1304271111530.30732-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2013 11:14 PM, Alan Stern wrote:
> On Sat, 27 Apr 2013, ZhenHua wrote:
>
>> On 04/27/2013 12:51 AM, Alan Stern wrote:
>>> On Fri, 26 Apr 2013, ZhenHua wrote:
>>>
>>>> There is a function  wait_for_HP() in uhci-hub.c. In this
>>>> patch, it is used in suspend_rh(),  I think this can be a
>>>> solution. And I have tested this patch, it can fix the bug.
>>>>
>>>> I think there is another patch needed. As Alan said in another
>>>> mail, in the UHCI_RH_RUNNING_NODEVS case, it should not be stopped
>>>> if the uhci device is HP iLo virtual usb.
>>> I believe that if you change the UHCI_RH_RUNNING_NODEVS case, you will
>>> find that this patch (calling wait_for_HP) isn't needed.
>>>
>>> In fact, the patch is so easy that I am including it below.  Please
>>> test this (without either of your patches) to see if it works.
>>>
>>> Alan Stern
>>>
>>>
>>>
>>>
>>> Index: usb-3.9/drivers/usb/host/uhci-hub.c
>>> ===================================================================
>>> --- usb-3.9.orig/drivers/usb/host/uhci-hub.c
>>> +++ usb-3.9/drivers/usb/host/uhci-hub.c
>>> @@ -225,7 +225,8 @@ static int uhci_hub_status_data(struct u
>>>    		/* auto-stop if nothing connected for 1 second */
>>>    		if (any_ports_active(uhci))
>>>    			uhci->rh_state = UHCI_RH_RUNNING;
>>> -		else if (time_after_eq(jiffies, uhci->auto_stop_time))
>>> +		else if (time_after_eq(jiffies, uhci->auto_stop_time) &&
>>> +				!uhci->wait_for_hp)
>>>    			suspend_rh(uhci, UHCI_RH_AUTO_STOPPED);
>>>    		break;
>>>    
>>>
>> I have tested the UHCI_RH_RUNNING_NODEVS case yeasterday, and it works.
>> But the function suspend_rh is also called in other places, so I think
>> it only fixes
>> the warning when auto stop is called, but not fix the warning when
>> uhci's bus_suspend
>> is called,  it will come out again.
> Have you tried this?  I expect the warning will not occur when the
> bus_suspend routine is called, because then there will be a 1-ms delay,
> not just a 400-us delay.
I tested this, and the warning is gone.  Is this patch committed ?
I need to paste the link to suse bugzilla.

>
>> And if you add uhci->wait_for_hp check in the UHCI_RH_RUNNING_NODEVS case,
>> all hp uhci devices will not auto stop, not only the virtual devices. I
>> guess it may waste resource.
> If you want, you can add a new flag specifically for virtual
> controllers.  But it shouldn't matter -- as long as your kernels are
> built with CONFIG_PM_RUNTIME enabled, there won't be any significant
> waste of resources.
>
> Alan Stern
>
I think we can check the product id to determine whether a device is 
virtual.
Do you know if there is another way to check this?

Thanks
Zhen-Hua
