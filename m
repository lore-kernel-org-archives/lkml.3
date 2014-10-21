Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbaJUTF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 15:05:58 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:60051 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755139AbaJUTF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 15:05:56 -0400
Message-ID: <5446AE8E.8010904@hurleysoftware.com>
Date: Tue, 21 Oct 2014 15:05:50 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Linux kernel <linux-kernel@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: pnp bus disables serial console despite no_console_suspend
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm looking into a cpu lockup while resuming from S3.

I can't paste the warning here because the serial console comes back
scrambled. There are two issues:
1. The 16550A serial port is a pnp device that the pnp bus disables
on suspend, despite having no_console_suspend set, and
2. ACPI suspend powers off the device anyway.

I've managed to workaround these 2 issues by brute force hack,
but I think that it's worthwhile to consider making no_console_suspend
work properly in mainline.

Not disabling the pnp device of the serial console is trivial:
option 1 is to special case some return value from pnp_dev->suspend()
which prevent further action by the pnp bus but does not error out
of suspending, or
option 2 is for the device to override pnp_dev->capabilities and
turn off PNP_DISABLE. This option also requires a new capability to
prevent the pnpacpi protocol from powering off the device.
Option 2 is the workaround I'm using right now and it's pretty messy.

The second issue is less straightforward.

Since ACPI powers off the device anyway, on return from
acpi_suspend_lowlevel(), the device needs some minimal re-programming.
The workaround right now is to re-check a device register on every
console write, and perform the re-programming if it's been cleared.
This is not very robust or desirable; the power-on register value is
a valid (but unlikely) state for the device.

What's needed is a way to distinguish between a console write immediately
before and immediately after resume, before resume starts using printk :)
Ideally, consoles would get a notification before being used; optionally,
a system-wide value which identifies power transition states could work.

Thoughts?

Regards,
Peter Hurley

PS - This situation is not limited to pnpacpi on x86. Several ARM designs
power off the serial port, and require explicit re-programming for resume
using no_console_suspend.
