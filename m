Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab3IWO2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:28:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58272 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753118Ab3IWO2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:28:48 -0400
Date: Mon, 23 Sep 2013 10:28:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kurt Garloff <kurt@garloff.de>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] usb/core/devio.c:tolerate wrong direction flag in control
 endpoints
In-Reply-To: <52403A4B.6070606@garloff.de>
Message-ID: <Pine.LNX.4.44L0.1309231016030.1348-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Sep 2013, Kurt Garloff wrote:

> >> that qualifies as a bug or not. Maybe it should not claim to be a
> >> HID device then?
> > Maybe not.  This particular combination of bRequestType and bRequest 
> > values (0x22, 0x09) is not defined in the HID 1.11 spec.  Do you know 
> > if it is defined somewhere else?
> These are custom commands, somewhat described at
> http://pegatech.com/_Uploads/Downloads/Documents/Protocol_Definition_Rev_1.12.pdf

That document describes a UART protocol with no mention of USB at all.

> >> (And again the behavior might not be enforced by the spec, but maybe
> >> by Windows?)
> > More likely the behavior isn't enforced at all.  The device may simply 
> > be buggy.
> With behavior here I referred to the fact that I have not yet seen a USB
> device that
> has two endpoints with the same endpoint number (but different direction).

I have.  They aren't very common but they do exist.

> Let me try inline insert (by c'n'p: I switched from mutt to Thunderbird
> recently and lack
> experience whether this breaks formatting or so ...)

It did mangle the whitespace characters.  That doesn't matter for 
reviewing, but it is important when you submit the patch.  Take a look 
at Documentation/email-clients.txt for some suggestions.

> 8<--------
> 
> From: Kurt Garloff <kurt@garloff.de>
> Date: Mon, 23 Sep 2013 14:19:02 +0200
> Subject: Tolerate wrong direction bit in endpoint address for control
> messages
>    
> Trying to read data from the Pegasus Technologies NoteTaker (0e20:0101)
> [1] with the Windows App (EasyNote) works natively but fails when
> Windows is running under KVM (and the USB device handed to KVM).
>    
> The reason is a USB control message
>  usb 4-2.2: control urb: bRequestType=22 bRequest=09 wValue=0200
> wIndex=0001 wLength=0008
> This goes to endpoint address 0x01 (wIndex); however, endpoint number 1
> is an input endpoint and thus has endpoint address 0x81.

You should say something like:

	however, endpoint 0x01 doesn't exist.  There is an endpoint
	0x81, though; perhaps the app meant that endpoint instead.

> The kernel thus rejects the IO and thus we see the failure.
>    
> Apparently, Linux is more strict here than Windows ... we can't change
> the Win app easily, so that's a problem.
> 
> It seems that the Win app/driver is buggy here and the driver does not
> behave fully according to the USB HID class that it claims to belong to.
> The device seems to happily deal with that though (and seems to not
> really care about this value much).
> 
> So the question is whether the Linux kernel should filter here.
> Rejecting has the risk that somewhat non-compliant userspace apps/
> drivers (most likely in a virtual machine) are prevented from working.
> Not rejecting has the risk of confusing an overly sensitive device with
> such a transfer. Given the fact that Windows does not filter it makes
> this risk rather small though.
> 
> The patch makes the kernel more tolerant: If the endpoint address in
> wIndex does not exist, but an endpoint with toggled direction bit does,
> it will let the transfer through. (It does NOT change the message.)
> 
> With attached patch, the app in Windows in KVM works.
>  usb 4-2.2: check_ctrlrecip: process 13073 (qemu-kvm) requesting ep 01
> but needs 81 (or 00)

You need to remove the "(or 00)" here.

> I suspect this will mostly affect apps in virtual environments; as on
> Linux the apps would have been adapted to the stricter handling of the
> kernel. I have done that for mine[2].
>  
> [1] http://www.pegatech.com/
> [2] https://sourceforge.net/projects/notetakerpen/
> 
> Signed-off-by: Kurt Garloff <kurt@garloff.de>
> Cc: stable@vger.kernel.or

Fix the spelling (.org).

> ---
>  drivers/usb/core/devio.c |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index 737e3c1..4ff61f9 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -742,6 +742,22 @@ static int check_ctrlrecip(struct dev_state *ps,
> unsigned int requesttype,
>          if ((index & ~USB_DIR_IN) == 0)
>              return 0;
>          ret = findintfep(ps->dev, index);
> +        if (ret < 0) {
> +            /*
> +             * Some not fully compliant Win apps seem to get
> +             * ndex wrong and have the endpoint number here

s/ndex/index/

> +             * rather than the endpoint address (with the
> +             * correct direction). Win does let this through,
> +             * so we'll give it a second try as well (to not
> +             * break KVM) -- but warn.
> +             */
> +            ret = findintfep(ps->dev, index ^ 0x80);
> +            if (ret >= 0)
> +                dev_info(&ps->dev->dev ,
> +                    "%s: process %i (%s) requesting ep %02x but needs
> %02x\n",
> +                    __func__, task_pid_nr(current),
> +                    current->comm, index, index ^ 0x80);
> +        }
>          if (ret >= 0)
>              ret = checkintf(ps, ret);
>          break;

After you make these changes, you can add:

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

