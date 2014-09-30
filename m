Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbaI3R12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:27:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbaI3R10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:27:26 -0400
Date: Tue, 30 Sep 2014 13:27:18 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jason Gerecke <killertofu@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pinglinux@gmail.com>,
        Linux Input <linux-input@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] HID: wacom: introduce generic HID handling
Message-ID: <20140930172718.GA30615@mail.corp.redhat.com>
References: <1411488489-10625-1-git-send-email-benjamin.tissoires@redhat.com>
 <alpine.LNX.2.00.1409261302520.22196@pobox.suse.cz>
 <CANRwn3Sng5nxc7YZEUYQVgFhidSMQCBdDsiWebs_zFZ7s=gsiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANRwn3Sng5nxc7YZEUYQVgFhidSMQCBdDsiWebs_zFZ7s=gsiQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 26 2014 or thereabouts, Jason Gerecke wrote:
> On Fri, Sep 26, 2014 at 4:03 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> > On Tue, 23 Sep 2014, Benjamin Tissoires wrote:
> >
> >> Hi guys,
> >>
> >> So, this patch series aims at supporting natively any future HID compliant wacom
> >> tablet. Those found on the various laptops (ISDv4/5) already are HID compliant
> >> and they should work in the future without any modification of the kernel.
> >>
> >> Few things to note here:
> >> - I used the PID 0x00E6 found on the Lenovo X230 for the tests
> >> - I did not removed its entry in the list because there is a slightly different
> >>   behavior while using this patch set: when more than two fingers are on the
> >>   screen, the tablet stops sending finger events, while with the wacom
> >>   proprietary bits, it continues to send them. Besides that, the events emitted
> >>   before and after the patch series are the same (at least on the E6)
> >> - I can not rely on hid-input directly because wacom wants to be in control of
> >>   the input devices it creates. This might be solved in the future, but for now
> >>   it is just easier to rewrite the few mapping/events handling than trying to
> >>   fit in the hid-input model.
> >> - there will still be more specific use cases to handle later (see the joke of
> >>   the MS surface 3 pen[1] for instance), but this should give a roughly working
> >>   pen/touch support for those future devices.
> >>
> >> Jason, I would be very glad if you could conduct a few tests for this on the
> >> ISDv4/5 sensors you have.
> >
> > I am waiting with this one for testing results from Jason, but if you guys
> > want this to go in the next merge window, I'd like to ask you not to
> > postpone the testing too much.
> >
> > Thanks.
> >
> 
> I'm in the process of capturing traces from hid-record for multiple
> tablet PCs both pre- and post-patch to locate any obvious issues. My
> initial results are promising on the pen side (the only things I've
> noticed so far is the 2nd barrel switch not being supported -- as
> might be suspected) but less so on the touch side (single-finger
> devices seem to work fine, but the new code doesn't seem to handle any
> of the multitouch devices I've tried).

Do you consider not having the second barrel switch a blocker or can we
ship it this and send a fix later?

As for the touch, I tested/developed it on the Lenovo X230. It presents
a hid-multitouch compatible touch interface, when the feature input_mode
is sent with the value '2'. By re-reading it, it seems to me that you
are trying to replay the touch traces you got before the patch, but this
will not work because the touch protocol is not the same. ISDv4 used to
rely on the proprietary touch protocol which is hard to describe in HID.

I would say that as long as there is no regression (actually there can
not be for old devices :-P), we should still carry this series for 3.18.
We might need to adjust the bits here and there, but if we can have a
*basic* support of the tablet out of the box, this is still much better
than silently ignoring it.

> 
> Expect more news next week :)

So?????

> 
> 
> PS: I'm pretty sure ISDv5 shouldn't be relied on for HID data :| The
> descriptor for the Cintiq Companion Hybrid, at least, is like our
> branded sensors with useful data only in the touchscreen descriptor
> (the pen descriptor is a bunch of opaque vendor-defined reports). Not
> sure if the Cintiq Companion is the same though since it runs
> Windows...

Ouch. For those, we will need to either fix the report descriptors or
handle them in the same way you always used to do: manually.

Cheers,
Benjamin

> >>
> >> [1] http://who-t.blogspot.com/2014/09/stylus-behaviour-on-microsoft-surface-3.html
> >>
> >> Benjamin Tissoires (5):
> >>   HID: wacom: rename failN with some meaningful information
> >>   HID: wacom: split out input allocation and registration
> >>   HID: wacom: move allocation of inputs earlier
> >>   HID: wacom: implement generic HID handling for pen generic devices
> >>   HID: wacom: implement the finger part of the HID generic handling
> >>
> >>  drivers/hid/hid-core.c  |   3 +
> >>  drivers/hid/wacom.h     |   6 +
> >>  drivers/hid/wacom_sys.c | 184 +++++++++++++++++++++--------
> >>  drivers/hid/wacom_wac.c | 299 ++++++++++++++++++++++++++++++++++++++++++++++++
> >>  drivers/hid/wacom_wac.h |  17 +++
> >>  include/linux/hid.h     |   2 +
> >>  6 files changed, 462 insertions(+), 49 deletions(-)
> >>
> >> --
> >> 2.1.0
> >>
> >
> > --
> > Jiri Kosina
> > SUSE Labs
