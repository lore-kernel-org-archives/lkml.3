Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbaLQCxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 21:53:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbaLQCxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 21:53:34 -0500
Date: Tue, 16 Dec 2014 21:53:20 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Peter Wu <peter@lekensteyn.nl>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] HID: logitech-hidpp: bail out if wtp_connect fails
Message-ID: <20141217025320.GB7837@mail.corp.redhat.com>
References: <1418767562-4136-1-git-send-email-benjamin.tissoires@redhat.com>
 <CAN+gG=F0HhzXQhsaHTEb5Hy2CVTsoOSopCt4grXFnSKt+tPsWw@mail.gmail.com>
 <1754756.J50LHtmV20@al>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1754756.J50LHtmV20@al>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 17 2014 or thereabouts, Peter Wu wrote:
> Hi Benjamin,
> 
> On Tuesday 16 December 2014 17:13:05 Benjamin Tissoires wrote:
> > the logitech patches are queuing up really fast.
> > To keep track of them, I made a bundle on patchwork:
> > https://patchwork.kernel.org/bundle/bentiss/hid-logitech-hidpp/
> > (/me discovered a new tool to play with)
> > 
> > Right now, the patch "HID: logitech-hidpp: detect HID++ 2.0 errors
> > too" is waiting for Logitech's approval, and the 2 of this series need
> > review.
> > 
> > Peter, please tell me if I missed one patch.
>  
> Nice, it would be even better if a bundle could be bookmarked, or if a
> group could set review flags in this bundle :-)
> 
> There are no missing patches from my side. All changes (based on
> jikos/hid, branch for-next) are at
> https://git.lekensteyn.nl/peter/linux/log/?h=logitech-hidpp
> and are tested in QEMU with an emulated device and a real device (with
> T400/T650/M525 paired).

Thanks. The only problem with publishing these kind of tree is that at
some point you will want to rebase it, and this will break people who
pulled your tree. I found Jiri's name scheme really good (with a tag for
the current version). This allows to push several branch based on
different revisions without breaking the others.
But I am a little bit digressing here :)

> 
> I noticed that all devices would immediately get an input device (even
> if they were off), except for the T650. This apparently happens because
> the touchpad configuration cannot be retrieved or when the touchpad
> cannot be put in raw reporting mode. I cannot think of something to
> "fix" this though.

That's the design, unfortunately.

Ideally, I would have prefer having a consistant way of setting up
devices: when the receiver is plugged, create the input nodes and done.

Unfortunately, this does not apply to touchpads and mice in raw mode as
we need to query the devices for their capabilities and axis ranges.
We then need to deffer the creation upon the connection.

Unfortunately, we can not do the same for the normal DJ devices. If you
do so, you will lose the very first input reports while the device is
set up, and while the userspace is ready to read from it.
This is *really* problematic for keyboards, especially when you use it
to enter your computer encryption password. You lose the first few
chars, and the password fails, and it's a mess.

So in the end, I came up with this hybrid solution. For a few selected
and tested devices, we deffer the input creation. For the rest of the
world, we try to create them at the earliest in order not losing events.

To sum up, this is really unfortunate :)

Cheers,
Benjamin


> -- 
> Kind regards,
> Peter
> https://lekensteyn.nl
> 
