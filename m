Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaLNU2X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:28:23 -0500
Received: from senator.holtmann.net ([87.106.208.187]:54352 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbaLNU2G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:28:06 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: bluetooth: Add hci_h4p driver
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20141214192124.GA22392@amd>
Date: Sun, 14 Dec 2014 21:28:02 +0100
Cc: =?utf-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, khilman@kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        linux-bluetooth@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <D1F25806-07C6-4876-8E62-A16CFB6827EA@holtmann.org>
References: <20141213223727.GA13894@amd> <570BAC61-3137-42E5-B4F8-A61AEED380DE@holtmann.org> <20141214192124.GA22392@amd>
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

>>> Hacks surrounding bluetooth address were removed; this results in
>>> working driver with address that is probably not unique.
>> 
>> Just set HCI_QUIRK_INVALID_BDADDR and let someone deal with that in userspace. You can use the btmgmt public-addr command for testing.
>> 
> 
> Ok, it took me a while to figure out that --enable-experimental is
> needed.
> 
> Then help was playing tricks with me:
> 
> For more information on the usage of each command use:
>    btmgmt <command> --help
> root@n900:/my/bluez-5.26/tools# ./btmgmt public-addr --help
> Set Public Address for hci0 failed with status 0x0b (Rejected)
> root@n900:/my/bluez-5.26/tools# ./btmgmt public-addr
> Usage: btmgmt public-addr <address>

that is indeed confusing. Something went wrong with that tool. Just keep in mind that tool is just for internal testing by the developers. Someone would still need to write a proper integration with listening for the appropriate events and dig out the actual address from the memory location.

> root@n900:/my/bluez-5.26/tools# ./btmgmt public-addr 01:02:03:04:05:06
> Set Public Address for hci0 failed with status 0x0b (Rejected)
> 
> Hmm. Since setting public address only works when interface is down,
> and we lose all the settings during up, this does not work at all,
> right?

It does keep it. The address is stored in hdev->public_addr which is actually different from hdev->bdaddr which is the current address in use.

However I am not sure that hdev->set_bdaddr is executed again. Same as hdev->setup is not executed twice. The controller loosing all states is something we have not yet encountered. At least not while the hci_dev stays around.

I wonder if the drastic power off might be better hooked into a platform RFKILL switch. And with that you would just unregister hci_dev and re-register it when the RFKILL switch is unblocked.

The other option is to introduce a quirk that allows running hdev->setup and hdev->set_bdaddr all the time when you bring up your device.

Another alternate idea for getting something upstream for testing is to ignore the whole firmware loading in the kernel and bring up the controller with HCI_QUIRK_EXTERNAL_CONFIG. Doing that would allow you to do bette testing and evolve the driver in small tests.

So what this quirk does is that the hci_dev comes up unconfigured. So mgmt interface will only show it as unconfigured controller. However you can open it with HCI User Channel and run all HCI commands manually. That is what src/shared/hci.[ch] is good at. Once you are done, you just flip the switch via btmgmt ext-config and then the kernel goes and treats it as fully configured.

Regards

Marcel

