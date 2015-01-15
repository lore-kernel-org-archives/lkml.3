Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbbAOIuX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 03:50:23 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51882 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751175AbbAOIuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:50:21 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v4 00/13] Add ACPI _DSD and unified device properties support
Date: Thu, 15 Jan 2015 10:12:44 +0100
Message-ID: <2657331.Z9mozUByf5@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1421260943.14516.19.camel@infradead.org>
References: <2660541.BycO7TFnA2@vostro.rjw.lan> <20141015131551.GC20034@leverpostej> <1421260943.14516.19.camel@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 14, 2015 10:42:23 AM David Woodhouse wrote:
> 
> --=-3dIl43yXcWwu/nzOqQWw
> Content-Type: multipart/mixed; boundary="=-ca0AFM5hvqL+pJIndiHh"
> 
> 
> --=-ca0AFM5hvqL+pJIndiHh
> Content-Type: text/plain; charset="UTF-8"
> Content-Transfer-Encoding: quoted-printable
> 
> I'm looking again at updating of_serial to work with ACPI properties.=20
> 
> Specifically, I want to support a serial port with a non-standard baud
> rate, something like this:
> 
>     Device(COM1) {
>         Name(_HID, EisaId("PNP0501"))
>         Name(_CID, EisaId("PRP0001"))
> 	Name(_DSD, Package() {
> 	    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>             Package () {
> 		Package () {"compatible", Package () {"ns16550a"}},
> 		Package () {"clock-frequency", 2457600},
> 	    }
> 	})
>         ...
>     }
> 
> Firstly, the of_serial driver doesn't even get *invoked* unless I do
> this:
> 
> diff --git a/drivers/acpi/property.c b/drivers/acpi/property.c
> index 0d08373..eb1201a 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -2083,6 +2086,8 @@ static int acpi_add_single_object(struct acpi_device =
> **child,
>  	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Added %s [%s] parent %s\n",
>  		dev_name(&device->dev), (char *) buffer.pointer,
>  		device->parent ? dev_name(&device->parent->dev) : "(null)"));
> +	if (device->data.of_compatible)
> +		acpi_create_platform_device(device);
>  	kfree(buffer.pointer);
>  	*child =3D device;
>  	return 0;
> 
> Now it doesn't work because it uses of_match_device() to look the device
> up and find the corresponding *data* for that entry in its match table.
> And without CONFIG_OF, I don't *have* of_match_device().
> 
> We've talked about the fact that the platform bus probe function doesn't
> pass you the match ID. Is that something we could potentially fix now
> that things are a little more unified?

We can do that in my view.

> Or do we expect drivers still to have to use something like
> of_match_id() to do the lookup again for themselves... and in that case
> should we make of_match_id() available or produce a new
> device_match_id() that they are expected to switch to?

So far we've been targeting drivers that already have of_match_id() rather
than ones that want to use the unified interface from the start and not
necessarily with CONFIG_OF set.  That looks like an overlooked use case to me
to be honest.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
