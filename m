Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaLMXaT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 18:30:19 -0500
Received: from senator.holtmann.net ([87.106.208.187]:56734 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaLMXaR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 18:30:17 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: bluetooth: Add hci_h4p driver
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20141213223727.GA13894@amd>
Date: Sun, 14 Dec 2014 00:30:13 +0100
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        linux-bluetooth@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <570BAC61-3137-42E5-B4F8-A61AEED380DE@holtmann.org>
References: <20141213223727.GA13894@amd>
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

> Add hci_h4p bluetooth driver to staging tree. This device is used
> for example on Nokia N900 cell phone.
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> Thanks-to: Sebastian Reichel <sre@debian.org>
> Thanks-to: Joe Perches <joe@perches.com>
> 
> ---
> 
> 
> I'd prefer to resurect the driver in staging/ in order not to lose
> history, but Marcel wanted to treat it as new submission, so I'm doing
> that.

that history is in linux.git now for all times. No need to repeat it. I rather not play around with that again. Lets get a minimal driver merged so we can give people something to improve.

> 
> Firmware load was converted to hci_cmd_sync(). Unfortunately, the
> firmware is needed after every open/close, so the setup mechanism does
> not quite fit. (But code is now way cleaner).

What is the reason for that? Does it mean that the device will always loose all its settings when powering it down. Do we know why that is that way and can we maybe change it?

If there is no way around this, we can introduce a quirk that will always run hdev->setup. However if the device keeps forgetting all settings all the time, that means it will also keep forgetting its address. So that power on procedure will be wasting time. We would need to check if we can make it so that it only has unconfigured state once and then keeps remembering the address even if we have to re-program it every time.

> Device tree bindings work for me, but they are not yet official and I
> expect some more fun there.
> 
> Hacks surrounding bluetooth address were removed; this results in
> working driver with address that is probably not unique.

Just set HCI_QUIRK_INVALID_BDADDR and let someone deal with that in userspace. You can use the btmgmt public-addr command for testing.

In the end someone needs to write a small tool that users mgmt interface and listens for unconfigured controllers, reads the address from whatever storage it is, uses the Set Public Address command and that is it.

On the kernel side you need to add hdev->set_bdaddr support. For the Broadcom based devices you can copy it from the btusb.c driver.

> HCI_QUIRK_RESET_ON_CLOSE will need to be investigated some more.

Why was that needed again? If the device loses power anyway, then that seems wasteful. Also the core changed to make sure it resets all settings on power down correctly.

> My notes say that Marcel wanted different filenames, but I'd need
> advice exactly what filenames. I guess platform data supprort should
> be removed altogether, rather than renamed.

Yes, the platform support should go away. This should be purely based on DT.

Can you also start using git format-patch so that patches get a diffstat.

Regards

Marcel

