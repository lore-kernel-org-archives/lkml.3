Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936525AbaH1Jw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:52:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35357 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934541AbaH1Jw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:52:26 -0400
Message-ID: <53FEFBCF.6000701@ti.com>
Date: Thu, 28 Aug 2014 12:52:15 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <stern@rowland.harvard.edu>, <balbi@ti.com>, <ming.lei@canonical.com>,
        <mwelling@emacinc.com>, <stefan@herbrechtsmeier.net>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "[3.8+]" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] usb: hub: Prevent hub autosuspend if usbcore.autosuspend
 is -1
References: <1407145486-14013-1-git-send-email-rogerq@ti.com> <53FDCADE.3040601@ti.com> <20140827192339.GA9620@kroah.com> <20140827210212.GA25562@kroah.com>
In-Reply-To: <20140827210212.GA25562@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2014 12:02 AM, Greg KH wrote:
> On Wed, Aug 27, 2014 at 12:23:39PM -0700, Greg KH wrote:
>> On Wed, Aug 27, 2014 at 03:11:10PM +0300, Roger Quadros wrote:
>>> If user specifies that USB autosuspend must be disabled by module
>>> parameter "usbcore.autosuspend=-1" then we must prevent
>>> autosuspend of USB hub devices as well.
>>>
>>> commit 596d789a211d introduced in v3.8 changed the original behaivour
>>> and stopped respecting the usbcore.autosuspend parameter for hubs.
>>>
>>> Fixes: 596d789a211d "USB: set hub's default autosuspend delay as 0"
>>>
>>> Cc: [3.8+] <stable@vger.kernel.org>
>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>> ---
>>>  drivers/usb/core/hub.c | 8 +++++++-
>>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
>>> index 8a4dcbc..59b599d 100644
>>> --- a/drivers/usb/core/hub.c
>>> +++ b/drivers/usb/core/hub.c
>>> @@ -1728,8 +1728,14 @@ static int hub_probe(struct usb_interface *intf, const struct usb_device_id *id)
>>>  	 * - Change autosuspend delay of hub can avoid unnecessary auto
>>>  	 *   suspend timer for hub, also may decrease power consumption
>>>  	 *   of USB bus.
>>> +	 *
>>> +	 * - If user has indicated to prevent autosuspend by passing
>>> +	 *   usbcore.autosuspend = -1 then keep autosuspend disabled.
>>>  	 */
>>> -	pm_runtime_set_autosuspend_delay(&hdev->dev, 0);
>>> +#ifdef CONFIG_PM_RUNTIME
>>> +	if (hdev->dev.power.autosuspend_delay >= 0)
>>> +		pm_runtime_set_autosuspend_delay(&hdev->dev, 0);
>>> +#endif
>>>  
>>>  	/*
>>>  	 * Hubs have proper suspend/resume support, except for root hubs
>>
>> Sorry, but can I have a patch that just adds the #ifdef as I already
>> have your original one in my tree.
> 
> This should be all that is needed, right?
> 
> ---------
> 
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index 003cb6b1a6bf..46f5161c7891 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -1732,8 +1732,10 @@ static int hub_probe(struct usb_interface *intf, const struct usb_device_id *id)
>  	 * - If user has indicated to prevent autosuspend by passing
>  	 *   usbcore.autosuspend = -1 then keep autosuspend disabled.
>  	 */
> +#ifdef CONFIG_PM_RUNTIME
>  	if (hdev->dev.power.autosuspend_delay >= 0)
>  		pm_runtime_set_autosuspend_delay(&hdev->dev, 0);
> +#endif
>  
>  	/*
>  	 * Hubs have proper suspend/resume support, except for root hubs
> 

Yes. Thanks Greg.

cheers,
-roger
