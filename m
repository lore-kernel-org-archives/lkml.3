Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaABVTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 16:19:25 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38124 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740AbaABVTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 16:19:23 -0500
Message-ID: <1388697560.2399.29.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Mark Lord <mlord@pobox.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, walt <w41ter@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Laight <david.laight@aculab.com>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org
Date: Thu, 02 Jan 2014 13:19:20 -0800
In-Reply-To: <52C5D3A9.60708@pobox.com>
References: <20131218211219.461663463@linuxfoundation.org>
	 <20131218211220.412278148@linuxfoundation.org> <52C32BB0.90600@gmail.com>
	 <20140102191510.GA9621@xanatos> <52C5D3A9.60708@pobox.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-02 at 16:01 -0500, Mark Lord wrote:
> On 14-01-02 02:15 PM, Sarah Sharp wrote:
> > On Tue, Dec 31, 2013 at 12:40:16PM -0800, walt wrote:
> ..
> >> Unfortunately this patch causes a regression when copying large files to my
> >> outboard USB3 drive. (Nothing at all to do with networking.)
> >>
> >> When I try to copy a large (20GB) file to the USB3 drive, the copy dies after
> >> about 7GB, the ext4 journal aborts and the drive is remounted read-only.
> >>
> >> This bug is 100% reproducible (always pretty close to 7GB) and reverting this
> >> patch completely fixes the problem.
> > 
> > Ok, I had feared that would be a consequence of this patch.  I think the
> > problem is that the usb-storage driver submitted an URB with more
> > scatter-gather entries than would fit on the ring segment, the xHCI
> > driver rejected the URB with -ENOMEM, and the SCSI core eventually gave
> > up on the SCSI command.
> 
> 
> Is there not a block layer / scheduler tunable for max sg entries or something?

Yes, it's blk_queue_max_segments()  You can also add an indirect limit
from userspace using the queue/max_sectors_kb parameter (it doesn't
limit the number of sg elements directly, but it does limit the overall
size of the transfer, and since each segment is 4k or larger except at
the beginning and end, that limits the total number of sg elements as
well).

James


