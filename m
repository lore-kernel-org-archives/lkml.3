Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab3LJFXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 00:23:55 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:52343 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab3LJFXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 00:23:53 -0500
MIME-Version: 1.0
In-Reply-To: <20131209182410.GA5220@xanatos>
References: <1386592158-12086-1-git-send-email-vikas.sajjan@linaro.org>
	<Pine.LNX.4.44L0.1312091019400.1439-100000@iolanthe.rowland.org>
	<20131209182410.GA5220@xanatos>
Date: Tue, 10 Dec 2013 10:53:51 +0530
Message-ID: <CAGm_ybhgM1XLrc+inQ6qjK=fHNshdr1QAshqE=+UD9caDAPDNQ@mail.gmail.com>
Subject: Re: [PATCH] USB: core: Add warm reset while reset-resuming SuperSpeed HUBs
From: Vikas Sajjan <sajjan.linux@gmail.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Vikas Sajjan <vikas.sajjan@linaro.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, vpalatin@chromium.org, jwerner@chromium.org,
        tianyu.lan@intel.com, burzalodowa@gmail.com,
        gregkh@linuxfoundation.org, gautam.vivek@samsung.com,
        Douglas Anderson <dianders@chromium.org>, balbi@ti.com,
        sunil joshi <joshi@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sarah,

On Mon, Dec 9, 2013 at 11:54 PM, Sarah Sharp
<sarah.a.sharp@linux.intel.com> wrote:
> On Mon, Dec 09, 2013 at 10:24:52AM -0500, Alan Stern wrote:
>> On Mon, 9 Dec 2013, Vikas Sajjan wrote:
>>
>> > Does warm reset while activating SuperSpeed HUBs if the hub activate type
>> > is HUB_RESET_RESUME.
>> >
>> > When we do Suspend-to-RAM with (any one of the 16, 32, 64 Jetflash) transcend
>> > USB 3.0 device connected on 3.0 port, during resume I noticed that the
>> > XHCI controller has moved to sometimes RECOVERY, POLLING or INACTIVE STATE.
>> > This behaviour is inconsistent and the connection with connected USB 3.0 device
>> > on 3.0 port was LOST.
>
> Does the device eventually re-connect on the USB port?  Or is warm reset
> necessary to make the device connect?

Yes, warm reset was necesssary, without which the device was NOT reconnecting.

>
> Does the xHCI register restore complete after resume from S3, or is
> power lost?  I'm trying to figure out whether xhci_reset is called
> before your issue is triggered.


The reason why I came up with this solution is during xhci_resume(),
it enters below condition and marks the reset_resume flag for the
ROOT_HUB as 1

/* If restore operation fails, re-initialize the HC during resume */
        if ((temp & STS_SRE) || hibernated) {
                /* Let the USB core know _both_ roothubs lost power. */
                 usb_root_hub_lost_power(xhci->main_hcd->self.root_hub);
                 usb_root_hub_lost_power(xhci->shared_hcd->self.root_hub);


>
>> > Doing warm reset while activating SuperSpeed HUBs if the hub
>> > activate type is HUB_RESET_RESUME, gets the connected device to the stable state.
>> >
>> > Reviewed at https://chromium-review.googlesource.com/#/c/177132/
>> >
>> > Tested on exynos5420 and exynos5250 with Transcend Jetflash USB 3.0 device (8564:1000)
>
> Is this issue specific to the particular USB device manufacturer
> (Transcend)?  Does the same device lose connection on resume from S3
> with other host controller vendors?  Have you seen this issue when the
> USB 3.0 device is behind a USB 3.0 hub?


This issue was specific to this paritcular make of Transcend.

we saw this on our chromebook. I did try Suspend-to-RAM with the same
device on Intel machine running Ubuntu.
It had worked fine without any issue.

Interestingly, if I connect with analyser, Suspend-to-RAM works fine
and USB re-enumerates successfully.
so connecting Suspend-to-RAM for debugging was not helping, as it works fine.
I did put prints in multiple places to get port status, and i see that
port is in sometimes RECOVERY, POLLING or In active STATE.
The behaviour was inconsistent.


>
> I ask because this sounds like a low-level link training issue that's
> specific to the exynos host or USB device.  I would rather track down
> which hardware is to blame than generically add a warm reset for all USB
> 3.0 devices.
>
>> > rebased on Greg Kroah-Hartman's usb-next
>> > git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
>> >
>> > Signed-off-by: Vikas Sajjan <vikas.sajjan@samsung.com>
>> > ---
>> >  drivers/usb/core/hub.c |   41 +++++++++++++++++++++++++----------------
>> >  1 file changed, 25 insertions(+), 16 deletions(-)
>> >
>> > diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
>> > index a7c04e2..d8432b0 100644
>> > --- a/drivers/usb/core/hub.c
>> > +++ b/drivers/usb/core/hub.c
>>
>> > @@ -1093,6 +1108,16 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
>> >             u16 portstatus, portchange;
>> >
>> >             portstatus = portchange = 0;
>> > +
>> > +           /* Some connected devices might be still in unknown state even
>> > +            * after reset-resume, a WARM_RESET gets the connected device
>> > +            * to the normal state.
>> > +            */
>> > +           if (udev && hub_is_superspeed(hub->hdev) &&
>> > +                                           type == HUB_RESET_RESUME)
>> > +                   hub_port_reset(hub, port1, NULL,
>> > +                                           HUB_BH_RESET_TIME, true);
>>
>> Please don't do this all the time to every attached port.  Do it only
>> when it is really needed.
>
> Agreed.  Can we at least limit the warm reset to devices directly
> attached to roothubs?  You can also change this code to get the port
> status and only do the warm reset if the port link state is
> USB_SS_PORT_LS_POLLING, USB_SS_PORT_LS_RX_DETECT, or
> USB_SS_PORT_LS_SS_INACTIVE.
>
>> Shouldn't you pass udev as the third argument?  If not, please explain
>> why not.
>>
>> Finally, I don't see why you put this in hub_activate().  Isn't it more
>> closely connected with the reset-resume procedure for the child device?
>
> Sarah Sharp
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
