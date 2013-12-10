Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab3LJFao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 00:30:44 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:37794 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3LJFa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 00:30:27 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1312091019400.1439-100000@iolanthe.rowland.org>
References: <1386592158-12086-1-git-send-email-vikas.sajjan@linaro.org>
	<Pine.LNX.4.44L0.1312091019400.1439-100000@iolanthe.rowland.org>
Date: Tue, 10 Dec 2013 11:00:25 +0530
Message-ID: <CAGm_ybgC6Ca0qz6zJL0PkEUiyUi=Ct0L5t2GJOt9ZU-buP+wBQ@mail.gmail.com>
Subject: Re: [PATCH] USB: core: Add warm reset while reset-resuming SuperSpeed HUBs
From: Vikas Sajjan <sajjan.linux@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Vikas Sajjan <vikas.sajjan@linaro.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        vpalatin@chromium.org, jwerner@chromium.org, tianyu.lan@intel.com,
        burzalodowa@gmail.com, gregkh@linuxfoundation.org,
        gautam.vivek@samsung.com, Douglas Anderson <dianders@chromium.org>,
        balbi@ti.com, sunil joshi <joshi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Mon, Dec 9, 2013 at 8:54 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 9 Dec 2013, Vikas Sajjan wrote:
>
>> Does warm reset while activating SuperSpeed HUBs if the hub activate type
>> is HUB_RESET_RESUME.
>>
>> When we do Suspend-to-RAM with (any one of the 16, 32, 64 Jetflash) transcend
>> USB 3.0 device connected on 3.0 port, during resume I noticed that the
>> XHCI controller has moved to sometimes RECOVERY, POLLING or INACTIVE STATE.
>> This behaviour is inconsistent and the connection with connected USB 3.0 device
>> on 3.0 port was LOST.
>>
>> Doing warm reset while activating SuperSpeed HUBs if the hub
>> activate type is HUB_RESET_RESUME, gets the connected device to the stable state.
>>
>> Reviewed at https://chromium-review.googlesource.com/#/c/177132/
>>
>> Tested on exynos5420 and exynos5250 with Transcend Jetflash USB 3.0 device (8564:1000)
>>
>> rebased on Greg Kroah-Hartman's usb-next
>> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
>>
>> Signed-off-by: Vikas Sajjan <vikas.sajjan@samsung.com>
>> ---
>>  drivers/usb/core/hub.c |   41 +++++++++++++++++++++++++----------------
>>  1 file changed, 25 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
>> index a7c04e2..d8432b0 100644
>> --- a/drivers/usb/core/hub.c
>> +++ b/drivers/usb/core/hub.c
>
>> @@ -1093,6 +1108,16 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
>>               u16 portstatus, portchange;
>>
>>               portstatus = portchange = 0;
>> +
>> +             /* Some connected devices might be still in unknown state even
>> +              * after reset-resume, a WARM_RESET gets the connected device
>> +              * to the normal state.
>> +              */
>> +             if (udev && hub_is_superspeed(hub->hdev) &&
>> +                                             type == HUB_RESET_RESUME)
>> +                     hub_port_reset(hub, port1, NULL,
>> +                                             HUB_BH_RESET_TIME, true);
>
> Please don't do this all the time to every attached port.  Do it only
> when it is really needed.
>
> Shouldn't you pass udev as the third argument?  If not, please explain
> why not.

yea, I have NOT tried passing udev as the third argument.


>
> Finally, I don't see why you put this in hub_activate().  Isn't it more
> closely connected with the reset-resume procedure for the child device?


I was trying to add a FIX in usb_port_resume(), but in our case we
have CONFIG_USB_DEFAULT_PERSIST disabled.

Interestingly, if I disable the CONFIG_USB_DEFAULT_PERSIST, then the
function usb_port_resume() will never be called and transcend Jetflash
device Suspend-to-RAM fails.

In normal scenario (ie., CONFIG_USB_DEFAULT_PERSIST=y) the sequence is:
===========================================================================
Step 1: For Root HUB :
usb_resume_both() ---> usb_resume_device() -> generic_resume() -->
hcd_bus_resume() --> xhci_bus_resume().
                              |
                              |-->usb_resume_interface() --->
hub_reset_resume() -->  xhci_update_hub_device()

Step 2:  For the Device connected
usb_resume_both() ---> usb_resume_device() ->
generic_resume()-->usb_port_resume()-->hub_port_logical_disconnect()
--> hub_port_disable() --> hub_usb3_port_disable().


In our scenario (ie., CONFIG_USB_DEFAULT_PERSIST=N) the sequence is:
===============================================================================
Step 1: For Root HUB
usb_resume_both() ---> usb_resume_device() -> generic_resume() -->
hcd_bus_resume() --> xhci_bus_resume().
                              |
                              |-->usb_resume_interface() --->
hub_reset_resume() -->  xhci_update_hub_device()

Step 2 :  Never occurs

So Suspend-to-RAM fails.

Hence i added a FIX in  hub_reset_resume().

Let me know if I am wrong.

>
> Alan Stern
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
