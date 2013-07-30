Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab3G3Wsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 18:48:35 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47458 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758058Ab3G3WsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 18:48:13 -0400
X-IronPort-AV: E=Sophos;i="4.89,782,1367996400"; 
   d="scan'208";a="65649190"
X-IronPort-AV: E=Sophos;i="4.89,781,1367996400"; 
   d="scan'208";a="576425650"
Date: Tue, 30 Jul 2013 15:48:09 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Marcel Holtmann <marcel@holtmann.org>
CC: Hector Palacios <hector.palacios@digi.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "gustavo@padovan.org" <gustavo@padovan.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        <mcgrof@do-not-panic.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "surajs@qca.qualcomm.com" <surajs@qca.qualcomm.com>,
        <jjohnson@qca.qualcomm.com>, Adrian Chadd <adrian@freebsd.org>,
        <ddahlby@qca.qualcomm.com>, Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: ROM Patching (was: [PATCH] bluetooth: remove wrong dependency
 for BT_ATH3K)
Message-ID: <20130730224809.GN17130@pogo>
References: <1375114325-25498-1-git-send-email-hector.palacios@digi.com>
 <5438CD3C-E28C-485C-94B8-F743E8B13D4A@holtmann.org>
 <51F7722E.9050708@digi.com>
 <20130730205601.GI17130@pogo>
 <2C94C740-76BA-4058-B0D7-C37D44875CA1@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2C94C740-76BA-4058-B0D7-C37D44875CA1@holtmann.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC'ing linux-wireless as ROM patching is mentioned and in so far as
802.11 mobile is concerned this is a pretty frequent practice there
as well so figured we'd tie in the conversations.

On Tue, Jul 30, 2013 at 03:05:18PM -0700, Marcel Holtmann wrote:
> Hi Luis,
> 
> >> This brings an interesting question: shouldn't the firmware download
> >> part be isolated from the USB driver? After all, I want to
> >> communicate with a UART bluetooth chip.
> > 
> > There are a few BT firmware upload modules (last I checked at least 2),
> > I believe it should be possible to stuff all that code a shared
> > module or even as FreeBSD does it -- treat fw uploading in userspace,
> > however just keep in mind for quirks [0]. So patches welcomed.
> 
> it really depends on what kind of patching or firmware download has to be done.
> 
> For all the ROM patching via HCI commands, we explicitly added support
> for setup stage

This stage is what is I was referring to.

> and exposed a standard way of getting in front of
> Bluetooth core init sequence.

Nice.

> An example here would be the Intel
> Bluetooth devices that require ROM patching. This can be useful for
> many Bluetooth devices that are generally USB transport standard
> compliant, but need a few extra commands of vendor setup.

Interesting. I believe for 802.11 we just throw in a bunch of ROM
patching onto the 802.11 driver_firwmare.fw file and then assume
the driver can do the right thing. I however haven't worked on that so I
am curious if someone more familiar with this can provide details of
how that happens. I do know that the 802.11 mobile drivers get tons of
firmware updates because of this exact architectural choice and do
wonder how we can easily keep up with the firmware updates in meaninful
way to linux-firwmare.

How often do the ROM patches get updated? And do the HCI commands
trigger a userspace event?

> We are planning to take one extra step and split this into a
> mini-driver approach similar to what has been done for usbnet, but we
> are not there yet.

Neat. Perhaps we need something that we can share with 802.11 or other
hardare I highly doubt we're the only ones patching ROM. Don't we even
patch up core CPUs? I'm wondering if firmware_class could be expanded to
support serialized ROM patching. The biggest hurdle I see with splititng
ROM patching from a single firmware is serializing that, addressing
revision dependencies and of course kernel dependencies.

I've thrown this on the list of topics for the next wireless summit
at New Orleans.

> However the ROM patching drivers need to be in the kernel since
> otherwise they will race with the core init sequence.

Sure and depending on the architecture -- if this is kicked off to
userspace helpers or not then we may need to consider dbus in
kernel thing to help with speed / races, dependenecies / async
loading, -EPROBE_DEFER, etc.

> There are also just firmware download drivers that do nothing else
> than just loading the firmware. And here it can be done via userspace
> or kernel space. In the Bluetooth world we have seen both, but
> generally the kernel ones stayed around while the userspace ones had a
> hard time to work with udev, libusb, libusb1 etc.

Ah I see. Perhaps we can address this once we get some form of dbus in
kernel.

> For UART based drivers it is a little bit different since we had to
> bring up the line discipline from userspace anyway and configure all
> the UART parameters. For these drivers the firmware download or ROM
> patching has been done normally via userspace since there is full
> exclusive access before the Bluetooth subsystem knows about the
> device.

Is this something that dbus in kernel can help clean up a bit?

> With the newly introduced setup stage, the drivers could actually
> share the setup handling for UART and USB based devices. Not sure if
> any vendor is going for this approach.

Interesting... Is the architecture documented somewhere? Is this
upstream already?

  Luis
