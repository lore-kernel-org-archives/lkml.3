Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbbAWO4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:56:47 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63318 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750894AbbAWO4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:56:44 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Johan Hovold <johan@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Heikki Krogerus <heikki.krogerus@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 3/4] mfd: dln2: add support for ACPI
Date: Fri, 23 Jan 2015 16:19:22 +0100
Message-ID: <1999229.GgDndKFVKR@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAE1zotKyJ70ZqNoogC0ozjUsyRrTCe=oohFfawt0FqpCkRkotg@mail.gmail.com>
References: <1418746353-3481-1-git-send-email-octavian.purdila@intel.com> <1879413.uF8phu1QrE@vostro.rjw.lan> <CAE1zotKyJ70ZqNoogC0ozjUsyRrTCe=oohFfawt0FqpCkRkotg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 23, 2015 08:47:58 AM Octavian Purdila wrote:
> On Fri, Jan 23, 2015 at 12:09 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Thursday, January 22, 2015 12:13:13 PM Octavian Purdila wrote:
> >> On Thu, Jan 22, 2015 at 4:00 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> <snip>
> >> The idea here is to set the companion for the MFD sub-devices. Mika's
> >> commit "mfd: Add ACPI support" propagates the parent's companion to
> >> the MFD sub-devices, so it is sufficient to set the ACPI companion to
> >> the USB device.
> >
> > For the USB device itself you'll then end up with an incomplete binding (you
> > can't get back to the USB device from the ACPI object), so no, it isn't
> > sufficient.
> >
> >> Then, the companion will be propagated to the sub-devices after which
> >> acpi_bind_one() will be called for the sub-devices from
> >> mfd_add_devices (via platform_device_add -> device_add ->
> >> platform_notify).
> >
> > In fact, your use case doesn't seem to cover any of the use cases that
> > the Mika's commit addressed.  Namely, your parent device doesn't have
> > an ACPI companion to start with and you want your MFD cells to be bound
> > to the "DLN2000" thing.  That's why you're setting the ACPI companion
> > for the USB device, isn't it?
> >
> >> It is true that the USB dev will have its ACPI companion set without
> >> having acpi_bind_one called but I do not see any harm in that. Even
> >> though acpi_unbind_one() is called it will not find the USB dev on the
> >> physical node list so no put_device() imbalance is caused.
> >
> > Well, there are places where it matters.  Some links in sysfs will be missing
> > for one example.  Also please see the changelog of commit 52870786ff5d (ACPI:
> > Use ACPI companion to match only the first physical device).
> >
> > Bottom line: You really should be using acpi_bind_one() here and
> > acpi_unbind_one() on disconnect if you have to.
> >
> 
> OK, I understand now.
> 
> >> > And no, "Let's come up with a patch that sort of works, throw it at the maintainers
> >> > and see what happens" is not an acceptable approach, sorry.
> >>
> >> This patch is based on your feedback of the previous RFC patch set:
> >
> > Oh, is it?  I can't recall advising you to use request_firmware() for
> > uploading ACPI tables or some other questionable things that the patch is
> > doing.
> >
> > And if it still was an RFC, that wouldn't be a problem, but if you just send
> > non-RFC patches out, that means you want people to merge them.  This is bad
> > if the patches in question are not in a good enough shape and this one isn't.
> >
> 
> Yes, this should have been tagged with RFC, sorry about that.
> 
> > Now, why is this a bad idea to load ACPI tables from a driver using
> > request_firmware()?  Because those tables are not device firmare.  They are
> > not firmware that you load into a device to make it work (which then works
> > with all instances of the given hardware), they are part of system configuration
> > information and have to match what's there in the system.  For instance, if you
> > ship your example SSDT with a general-purpose distro, it may just not match the
> > hardware configuration of systems that people will try to use it with.
> >
> > So, while it is sort of OK to look up "DLN2000" and bind the USB device to
> > that by hand (although this looks ugly to me), it is not OK to load a random
> > custom SSDT if it is missing.
> >
> > We need to add a generic mechanism for loading custom SSDTs not present in the
> > firmware image and maybe even to load them on demand, but that cannot happen in
> > an ad-hoc way.  So the entire table loading-unloading code in your patch can go
> > away for now and you need to fail probing if the "DLN2000" ACPI object is not
> > present.
> >
> 
> That sounds interesting, I like the idea of a generic mechanism for
> loading custom SSDTs. Do you have any initial thoughts/pointers for
> starting that?

Thoughts - yes, pointers - not so much.  I'll get back to you when I'm done
with the e-mail backlog from the last few weeks.

> Thanks for the review and feedback.

No problem.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
