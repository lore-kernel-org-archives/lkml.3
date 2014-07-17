Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbaGQU7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 16:59:51 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:47498 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaGQU7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 16:59:50 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1407171510570.909-100000@iolanthe.rowland.org>
References: <CAJJ6jxs9aYOZO+2dBCCa2hP8qzpchD0g2uGYGzGsnOe-e0rRjA@mail.gmail.com>
	<Pine.LNX.4.44L0.1407171510570.909-100000@iolanthe.rowland.org>
Date: Thu, 17 Jul 2014 13:59:48 -0700
Message-ID: <CAJJ6jxv5QKwWnqAapgX=CSWoxe3_rUV0udVdb4R202AOV+TN-w@mail.gmail.com>
Subject: Re: [PATCH] usb: core: allow zero packet flag for interrupt urbs
From: Steve Calfee <stevecalfee@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Amit Virdi <amit.virdi@st.com>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, rdunlap@infradead.org,
        ming.lei@canonical.com, Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 12:32 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 17 Jul 2014, Steve Calfee wrote:
>
>> Hi Alan,
>>
>> I did some testing with multi interrupt transfers some time ago. You
>> can get allocated a guaranteed 3x1024 time slot per uframe for an
>> interval of your choice on usb 2.0. So zlps are needed to send exactly
>> 1024 or 2048 bytes in that time slot.
>
> That's true, but misleading.  Use of zero-length packets is relatively
> independent of the time slot divisions.  zlps are necessary to mark the
> end of a multi-packet transfer; they aren't necessary if all you want
> to do is send less than 3072 bytes during a single 3x1024 time slot.
>
> Consider also that the URB_ZERO_PACKET flag will give you at most one
> zlp.  That won't be good enough if you want to send exactly 1024 bytes
> in the time slot; you would need two zlps.  Besides, why would you want
> to limit the amount of data that gets sent during the time slot?  If
> you have more than 1024 or 2048 bytes, why not send all of it?
>
> (For that matter, what happens if you want to send 2000 bytes during
> the time slot?  The first packet will contain 1024 bytes, the second
> will contain the remaining 976, and there won't be a zlp even if
> URB_ZERO_PACKET is set.  Instead, the third packet will contain
> whatever data has been queued next.  I was a little surprised to see
> that section 4.10.3 in the EHCI spec _doesn't_ say the controller must
> leave the Exercute Transaction state when a short packet is
> encountered -- even though not doing so would violate the USB-2.0
> spec.)
>
> Conversely, if you have only 1024 bytes to send, you don't need to do
> anything special.  Just send them.  There won't be any zlp during the
> time slot, but if no data is queued then nothing will be sent after
> those 1024 bytes.
>
Hi Alan,

It has been a few years since I was doing this, but here is my
understanding. If a device descriptor says x bytes should be reserved
(1 to 3072), the host will allocate that much bandwidth. If the sender
sends some number of bytes between 1 and 3072 (must be less than or
equal to x allocation), everything is ok the receiver will know when
the sender is done. But (as with bulk xfers) if exactly 1024 or 2048
bytes is sent, the receiver will not know the xfer is done. So in
those cases, just as in bulk, the sender needs to send a ZLP.

The receiver will request up to 3 int xfers (depending on x>2048 or x
>1024), and will stop issuing requests  (on a host sender) on a short
transfer or a full xfer.

Timeslots are guaranteed reservations, but they are not automatically
always used. Unused bandwidth in a uframe (after reserved uses what it
wants) will be used as needed by bulk or control transfers.

Regards, Steve
