Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239Ab3GaOt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:49:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36670 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755331Ab3GaOtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:49:23 -0400
Date: Wed, 31 Jul 2013 10:49:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Julius Werner <jwerner@chromium.org>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Benson Leung <bleung@chromium.org>
Subject: Re: [PATCH] usb: core: don't try to reset_device() a port that got
 just disconnected
In-Reply-To: <CAODwPW8ZRpVPWKp0Eda4GDhNHiBqcWECW7d69H_oi4UoFQL_NQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1307311043360.1546-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jul 2013, Julius Werner wrote:

> > Wait a moment.  Why does each of these attempts lead to a 5-second
> > timeout?  Why don't they fail immediately?
> 
> Now that you mention it, that's a very good question.

I have brought this up with Sarah on more than one occasion, but we 
never found a good answer.  The effects are quite visible when somebody 
unplugs a USB-3 disk drive in the middle of a data transfer.

>  The kernel
> enqueues a control transfer to the now disconnected address because
> it's internal bookkeeping is not yet updated, but I guess that should
> usually fail very fast from an xHC-internal transaction timeout. I
> have now tried to debug the cause of this: I see the transfer being
> enqueued and the doorbell triggered, but never get a transfer event
> back from it (until the software timeout calls usb_kill_urb() which
> stops the endpoint). With the same setup on a PantherPoint system I
> get the same U1/U2 disable control messages on unplugging, but they
> fail within <5ms with a transaction error... so I guess this must be a
> LynxPoint hardware bug.

An odd sort of bug.  You'd think that not getting a response back would 
be one of the first types of error the hardware designers would check 
for.

> Regardless, calling usb_reset_device() is still wrong and will at
> least lead to pointless transfer attempts and error messages, so I
> think my patch still has merit.
> 
> > What will happen here if udev is NULL?  Maybe you should change the
> > test to (!udev || !(portstatus & ...)).
> 
> Right... I'm not sure if that can happen in practice, but I'll change
> it just in case.

Somebody said that in theory, ports can put themselves in the Disabled 
state at any time, spontaneously.  If this happened just after a device 
was attached, you would end up with udev being NULL and the connect 
status being set.

Alan Stern

