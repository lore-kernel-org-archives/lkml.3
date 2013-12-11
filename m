Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab3LKRSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 12:18:13 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55843 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751474Ab3LKRSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 12:18:11 -0500
Date: Wed, 11 Dec 2013 12:18:09 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vikas Sajjan <sajjan.linux@gmail.com>
cc: Vikas Sajjan <vikas.sajjan@linaro.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, <vpalatin@chromium.org>,
        <jwerner@chromium.org>, <tianyu.lan@intel.com>,
        <burzalodowa@gmail.com>, <gregkh@linuxfoundation.org>,
        <gautam.vivek@samsung.com>, Douglas Anderson <dianders@chromium.org>,
        <balbi@ti.com>, sunil joshi <joshi@samsung.com>
Subject: Re: [PATCH] USB: core: Add warm reset while reset-resuming SuperSpeed
 HUBs
In-Reply-To: <CAGm_ybgC6Ca0qz6zJL0PkEUiyUi=Ct0L5t2GJOt9ZU-buP+wBQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1312111204220.1531-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Dec 2013, Vikas Sajjan wrote:

> > Finally, I don't see why you put this in hub_activate().  Isn't it more
> > closely connected with the reset-resume procedure for the child device?
> 
> 
> I was trying to add a FIX in usb_port_resume(), but in our case we
> have CONFIG_USB_DEFAULT_PERSIST disabled.
> 
> Interestingly, if I disable the CONFIG_USB_DEFAULT_PERSIST, then the
> function usb_port_resume() will never be called and transcend Jetflash
> device Suspend-to-RAM fails.

I don't know what you mean by "fails".  The system goes to sleep and 
then later on wakes up, doesn't it?

Do you mean that the Jetflash device gets disconnected when the system
wakes up?  That's _supposed_ to happen under those circumstances.  
When hub_activate() sees HUB_RESET_RESUME, all child devices get
disconnected except those where udev->persist_enabled is set.

> In normal scenario (ie., CONFIG_USB_DEFAULT_PERSIST=y) the sequence is:
> ===========================================================================
> Step 1: For Root HUB :
> usb_resume_both() ---> usb_resume_device() -> generic_resume() -->
> hcd_bus_resume() --> xhci_bus_resume().
>                               |
>                               |-->usb_resume_interface() --->
> hub_reset_resume() -->  xhci_update_hub_device()
> 
> Step 2:  For the Device connected
> usb_resume_both() ---> usb_resume_device() ->
> generic_resume()-->usb_port_resume()-->hub_port_logical_disconnect()

You lost me there.  Why does usb_port_resume call 
hub_port_logical_disconnect?  Does this happen because 
check_port_resume_type returns an error code?  What are the values of 
the portchange and portstatus arguments to check_port_resume_type?

> --> hub_port_disable() --> hub_usb3_port_disable().
> 
> 
> In our scenario (ie., CONFIG_USB_DEFAULT_PERSIST=N) the sequence is:
> ===============================================================================
> Step 1: For Root HUB
> usb_resume_both() ---> usb_resume_device() -> generic_resume() -->
> hcd_bus_resume() --> xhci_bus_resume().
>                               |
>                               |-->usb_resume_interface() --->
> hub_reset_resume() -->  xhci_update_hub_device()
> 
> Step 2 :  Never occurs

That's exactly right.

> So Suspend-to-RAM fails.

No, it succeeds in behaving the way it is intended to behave.

> Hence i added a FIX in  hub_reset_resume().
> 
> Let me know if I am wrong.

I can't tell at this point.  It depends on the reason why 
hub_port_logical_disconnect got called.

Alan Stern

