Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab3GXQaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:30:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:1400 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab3GXQaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:30:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,736,1367996400"; 
   d="scan'208";a="350870924"
Date: Wed, 24 Jul 2013 09:30:21 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Shuduo Sang <sangshuduo@gmail.com>
Cc: George Cherian <george.cherian@ti.com>,
        linux-usb <linux-usb@vger.kernel.org>, balbi <balbi@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        gregkh <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] usb: host: xhci: Enable XHCI_SPURIOUS_SUCCESS for all
 controllers with xhci 1.0
Message-ID: <20130724163021.GD5289@xanatos>
References: <1372656552-18824-1-git-send-email-george.cherian@ti.com>
 <20130702032712.GD6262@xanatos>
 <CANqatMA869UoTFDvSAO1P4OKsiVf+qyXbCrpHDOhm4+TMZ2cGA@mail.gmail.com>
 <51ECDDE3.1040209@ti.com>
 <CANqatMDrfV9+3ONnuZLN7xsp-TOoxHG2TV4a01EH2p8Z+zefWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANqatMDrfV9+3ONnuZLN7xsp-TOoxHG2TV4a01EH2p8Z+zefWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 03:58:19PM +0800, Shuduo Sang wrote:
> On Mon, Jul 22, 2013 at 3:23 PM, George Cherian <george.cherian@ti.com> wrote:
> Yes, I run below script to capture picture.
> 
> #!/bin/bash
> # camera_stress.sh
> # Testing the camera by BinLi
> 
> for ((i=0; i<10 ; i++))
> do
>         fswebcam --no-banner -r 352x288 -d /dev/video0 test_$i.jpg
> done
> 
> It will randomly fail at later loops. The fail rate about 20%~30%. When it fail,
> I can see error messages by dmesg as below:
> 
> [ 68.171039] xhci_hcd 0000:00:14.0: ERROR Transfer event TRB DMA ptr
> not part of current TD
> [ 68.175030] xhci_hcd 0000:00:14.0: ERROR Transfer event TRB DMA ptr
> not part of current TD
> [ 68.179026] xhci_hcd 0000:00:14.0: ERROR Transfer event TRB DMA ptr
> not part of current TD
> [ 68.180082] usb 3-12: USB disconnect, device number 4
> [ 68.450459] usb 3-12: new high-speed USB device number 5 using xhci_hcd
> [ 68.477960] usb 3-12: New USB device found, idVendor=5986, idProduct=0397
> [ 68.477964] usb 3-12: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [ 68.477966] usb 3-12: Product: Integrated Camera
> [ 68.477968] usb 3-12: Manufacturer: Vimicro corp.
> [ 68.479107] uvcvideo: Found UVC 1.00 device Integrated Camera (5986:0397)
> [ 68.479821] input: Integrated Camera as
> /devices/pci0000:00/0000:00:14.0/usb3/3-12/3-12:1.0/input/input15
> [ 321.389721] type=1400 audit(1374214638.182:29): apparmor="DENIED"
> operation="capable" parent=1 profile="/usr/sbin/cupsd" pid=1232
> comm="cupsd" pid=1232 comm="cupsd" c
> apability=36 capname="block_suspend"

That's a different issue.  The log shows that your USB webcam
disconnects, and that's why your script fails.  Then the device
re-connects.

Do other USB devices work after the camera disconnects?  Does the webcam
itself work (at least for a while) after you stop and restart the
script?  (Note that after a disconnect, the webcam may be present on
/dev/video1 instead of /dev/video0, because your script had /dev/video0
open when the webcam re-connected.)

> >> Then I manually applied George's patch against 3.10.0 but the issue
> >> still happen when I use
> >> camera to capture picture.
> >
> > Can you explain what is the exact issue you face after applying the patch?
> > Are you still getting
> >
> > "ERROR Transfer event TRB DMA ptr not part of current TD"
> 
> Yes, after I applied your patch manually, I still getting this error.
> Seems fail rate is same.

I'm still going to apply George's patch, because it does fix a different
issue.

I'm not sure if there's anything software can do if the webcam keeps
disconnecting.  That's usually an electrical issue.  Have you tried a
different USB cable?  If the webcam is behind a hub, have you tried
connecting it directly to the computer's roothub?  If it's attached to
the roothub, have you tried putting it behind an external hub?

If none of that works, I can look at your logs, and try to figure out if
there's anything software can do.  Can you recompile your kernel with
George's patch and CONFIG_USB_DEBUG and CONFIG_USB_XHCI_HCD_DEBUGGING
turned on?  Please send me the log from just before you start your
script to when the device disconnects.

Sarah Sharp
