Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965141Ab3CSVsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 17:48:05 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:35334 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab3CSVsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:48:03 -0400
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkR2AFDcSFFV5qjOPGdsb2JhbABDhzyFJLg4AgIBgVsXAwEBAQE4NYIkAQEEAScTHBMBDwULCAMOCgklDwUlChoTiA4KsXyQDBWNXlRHB4JfYQOWXoYNjgE7
X-IronPort-AV: E=Sophos;i="4.84,874,1355094000"; 
   d="scan'208";a="520012178"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 19 Mar 2013 22:52:32 +0100
To: Benson Leung <bleung@chromium.org>
Cc: linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Olof Johansson <olofj@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>, Dudley Du <dudl@cypress.com>
Subject: Re: [PATCH 2/4] Input: cyapa - Firmware update via request firmware
Message-ID: <20130319215232.GA7907@polaris.bitmath.org>
References: <1363218651-22457-1-git-send-email-bleung@chromium.org>
 <1363218651-22457-3-git-send-email-bleung@chromium.org>
 <20130316200047.GA6155@polaris.bitmath.org>
 <CANLzEku6s-831vfrP56eS2ZCGT==8i8JqjGNs++ujAvr8enxQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANLzEku6s-831vfrP56eS2ZCGT==8i8JqjGNs++ujAvr8enxQg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benson,

> On Sat, Mar 16, 2013 at 1:00 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> >> Userspace can initiate the firmware update procedure by copying cyapa.bin
> >> to /lib/firmware, and then writing anything to the device sysfs attribute:
> >>   /sys/bus/i2c/devices/7-0067/update_fw
> >
> > Why do you need to trigger this from userland via sysfs?
> >
> 
> It's a confluence of factors that drives the decision trigger from userland.
> - As a part of the cold-boot probe steps, the trackpad's bootloader
> will load an operational firmware from its flash memory. In the
> average case, the trackpad driver does not need to update the firmware
> because it's current. (the non-average cases are cases where on device
> firmware is corrupted or out of date)
> - The cypress firmware payloads we are working with here do not
> contain an indication of firmware version in the payload itself, so
> the driver can't tell at probe time whether what it would get if it
> request_firmware is newer, older, or the same version as what's
> already loaded on the trackpad.
> - On a 400kHz i2c bus, it takes 13 seconds to send the 31K payload to
> the device and to wait for it to jump into the operational mode
> firmware. This is too long to block probe every time.
> - Because it takes so long to do a firmware update, our user space
> would like to put up a warning message anyhow to tell the user that
> the touchpad is being updated, and not to disturb the system.
> 
> >> +     if (sysfs_create_group(&client->dev.kobj, &cyapa_sysfs_group))
> >> +             dev_warn(dev, "error creating sysfs entries.\n");
> >> +
> >
> > Would it not be neat to invoke the firmware update automatically instead?
> 
> The one situation where I could see an automatic firmware update being
> useful would be cases where the driver, during probe, discovered that
> the trackpad is in Bootloader mode because no valid firmware was found
> (a case of corruption of some kind due to the system powering down
> during a previous fw update, or example). In that case, the driver can
> request firmware and update it without user space having to trigger it
> later.
> 
> Another driver in input does it the same way. atmel_mxt_ts.c, which
> our team is actively working on as well, also has an update_fw sysfs
> for a lot of the same reasons.

Thanks for the rationale, it looks compelling enough for me.

The cyapa_firmware() function has loops that looks like they could be
simplified. With that and the previous comments said,

    Acked-by: Henrik Rydberg <rydberg@euromail.se>

Henrik
