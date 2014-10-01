Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaJAH71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:59:27 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:50039 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaJAH7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:59:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 04/15] ACPI: Document ACPI device specific properties
Date: Wed, 01 Oct 2014 09:59:14 +0200
Message-ID: <1979325.jM0BQzDCTX@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5597683.oi0VxOogFu@vostro.rjw.lan>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <1852462.V1jlbi8OPt@vostro.rjw.lan> <5597683.oi0VxOogFu@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:DkPT+Amb00QPjfcTCQxmxThlR/nJRuIJK9xPyZnlWZL
 T9ozyWVinkEc3ZJlfFKqFtMnrK/R+IjnK0IWKdv8Yqs4za4s2Q
 6ETtjRFazTFZJq8mOnaVwJkncxrA10Uviu74fbJxNPMonTka+B
 00F/3NpvRoiwOp9aKBwTDlWoEexGrBsF+QW0G+Qa2urTjXvA5E
 P1ZImlX6o/JPJ6pu59fA787pVJZe1yXdpg3HbZ5Lsp055iAnLl
 QTaiQwchANKCrMwomkgsjzN+JEWO3yRUu7Wzk/BynvTRCquLTB
 YHCMGB1i8tKwX4xT8LDxYZJFF7svsGFCi6q94GB9Ncd7o+6RSN
 Xw0pLKrx6ePU50Db1FC0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 04:11:20 Rafael J. Wysocki wrote:
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> This document describes the data format and interfaces of ACPI device
> specific properties.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Overall looks sane, but I wonder if we should try harder to not duplicate
some of the mistakes we made in the DT bindings. Two points in particular
stick out:

> +2.3 Strings
> +-----------
> +String properties can be used to describe many things like labels for GPIO
> +buttons, compability ids, etc.
> +
> +A string property looks like this:
> +
> +	Package () {"pwm-names", "backlight"},

The way we name things in DT using separate "foos" and "foo-names" properties
is a bit quirky. Those are always defined on a per-subsystem level, not
a per-device level though, so it should be possible to come up with a
better representation in ACPI.

Since the device driver should never look into the "foo-names" property
itself but just pass down the name into the subsystem, the "foo" subsystem
could instead have a way to add an (optional) name for each reference.

This is something the DT syntax doesn't allow because you can't have
both a phandle and a string in a single property but I think the ACPI
packages can do it, and it wouldn't change the basic structure.

> +The referenced ACPI device is returned in args->adev if found.
> +
> +In addition to simple object references it is also possible to have object
> +references with arguments. These are represented in ASL as follows:
> +
> +	Device (\_SB.PCI0.PWM)
> +	{
> +		Name (_DSD, Package () {
> +			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +			Package () {
> +				Package () {"#pwm-cells", 2}
> +			}
> +		})
> +	}
> +

Similarly, the "#foo-cells" syntax is an artifact of the limitations of the
DT syntax, and I'd assume there would be a better way to encode this
in ACPI. Also, a "cell" in Open Firmware is defined as a big-endian
32-bit value, which doesn't directly correspond to something in ACPI,
and the '#' character is an artifact of the use of the Forth language
in Open Firmware, which you also don't have here.

	Arnd
