Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762440AbaGROeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:34:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54785 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760999AbaGROeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:34:09 -0400
Date: Fri, 18 Jul 2014 10:34:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Steve Calfee <stevecalfee@gmail.com>
cc: Amit Virdi <amit.virdi@st.com>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rdunlap@infradead.org>,
        <ming.lei@canonical.com>, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] usb: core: allow zero packet flag for interrupt urbs
In-Reply-To: <CAJJ6jxv5QKwWnqAapgX=CSWoxe3_rUV0udVdb4R202AOV+TN-w@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1407181017330.979-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Steve Calfee wrote:

> Hi Alan,
> 
> It has been a few years since I was doing this, but here is my
> understanding. If a device descriptor says x bytes should be reserved
> (1 to 3072), the host will allocate that much bandwidth. If the sender
> sends some number of bytes between 1 and 3072 (must be less than or
> equal to x allocation), everything is ok the receiver will know when
> the sender is done. But (as with bulk xfers) if exactly 1024 or 2048
> bytes is sent, the receiver will not know the xfer is done. So in
> those cases, just as in bulk, the sender needs to send a ZLP.

You're getting mixed up over two different ideas here: a transfer and
the data sent during a particular microframe.  They aren't the same.

Thus, the receiver does know when a microframe's worth of data is
finished, even if exactly 1024 or 2048 bytes were sent, because the
receiver knows when the microframe ends (it gets an SOF packet).

Conversely, if a short transfer's length is a multiple of the maxpacket
size then without a zlp the receiver won't know when the transfer is
finished -- even if the transfer ends up occupying 3072 bytes.  For 
example, suppose the receiver expects the transfer to be 4096 bytes, 
but the sender has only 3072 bytes of data to send.

> The receiver will request up to 3 int xfers (depending on x>2048 or x
> >1024), and will stop issuing requests  (on a host sender) on a short
> transfer or a full xfer.

In USB, receivers do not issue requests.  The host initiates all 
transfers.

> Timeslots are guaranteed reservations, but they are not automatically
> always used. Unused bandwidth in a uframe (after reserved uses what it
> wants) will be used as needed by bulk or control transfers.

Correct.

Alan Stern

