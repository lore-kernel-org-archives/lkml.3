Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaGQTcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 15:32:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51697 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753304AbaGQTcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 15:32:45 -0400
Date: Thu, 17 Jul 2014 15:32:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Steve Calfee <stevecalfee@gmail.com>
cc: Amit Virdi <amit.virdi@st.com>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rdunlap@infradead.org>,
        <ming.lei@canonical.com>, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] usb: core: allow zero packet flag for interrupt urbs
In-Reply-To: <CAJJ6jxs9aYOZO+2dBCCa2hP8qzpchD0g2uGYGzGsnOe-e0rRjA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1407171510570.909-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Steve Calfee wrote:

> On Thu, Jul 17, 2014 at 7:55 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> >
> > I can't say this is actually wrong, but have you ever encountered a
> > situation where this would be needed?  How often does anyone need to do
> > a multi-packet transfer over an interrupt endpoint?
> >
> Hi Alan,
> 
> I did some testing with multi interrupt transfers some time ago. You
> can get allocated a guaranteed 3x1024 time slot per uframe for an
> interval of your choice on usb 2.0. So zlps are needed to send exactly
> 1024 or 2048 bytes in that time slot.

That's true, but misleading.  Use of zero-length packets is relatively
independent of the time slot divisions.  zlps are necessary to mark the
end of a multi-packet transfer; they aren't necessary if all you want
to do is send less than 3072 bytes during a single 3x1024 time slot.

Consider also that the URB_ZERO_PACKET flag will give you at most one
zlp.  That won't be good enough if you want to send exactly 1024 bytes
in the time slot; you would need two zlps.  Besides, why would you want
to limit the amount of data that gets sent during the time slot?  If
you have more than 1024 or 2048 bytes, why not send all of it?

(For that matter, what happens if you want to send 2000 bytes during 
the time slot?  The first packet will contain 1024 bytes, the second 
will contain the remaining 976, and there won't be a zlp even if 
URB_ZERO_PACKET is set.  Instead, the third packet will contain 
whatever data has been queued next.  I was a little surprised to see 
that section 4.10.3 in the EHCI spec _doesn't_ say the controller must 
leave the Exercute Transaction state when a short packet is
encountered -- even though not doing so would violate the USB-2.0 
spec.)

Conversely, if you have only 1024 bytes to send, you don't need to do
anything special.  Just send them.  There won't be any zlp during the
time slot, but if no data is queued then nothing will be sent after
those 1024 bytes.

> Also, interrupt transfers are
> crc checked and resent (as long as uframe time is still available). So
> you get guaranteed timing like iso sends, and guaranteed data like
> bulk sends. This could be valuable for time sensitive apps with known
> data capacities.
> 
> Microsoft only started supporting multi-interrupt transfers in Windows
> Vista and beyond. Winxp refuses to die, so probably no one has built
> an actual hardware device for consumers that uses multi-interrupt
> xfers up to now.

Well, I don't object to the patch.  It just seems odd, because it
implies that someone is using an interrupt endpoint like a bulk
endpoint.

Amit, what is the reason for this patch?  Is it purely theoretical?  
Or is it actually needed for some real purpose?

Alan Stern

