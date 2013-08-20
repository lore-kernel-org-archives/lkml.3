Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab3HTVAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:00:41 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52040 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273Ab3HTVAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:00:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux@roeck-us.net, dvhart@linux.intel.com, hpa@zytor.com,
        linus.walleij@linaro.org
Subject: Re: ACPI vs Device Tree - moving forward
Date: Tue, 20 Aug 2013 23:11:09 +0200
Message-ID: <2276651.WHL3SkvOZi@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130820192650.GA19470@srcf.ucam.org>
References: <20130820192650.GA19470@srcf.ucam.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 20, 2013 08:26:50 PM Matthew Garrett wrote:
> This conversation seems to have pretty much entirely ended up happening 
> on ksummit-discuss, which doesn't seem that useful. So let's have 
> another go with a wider audience (and where I don't have to sign up for 
> yet another mailing list...)
> 
> ACPI and DT overlap in that they both provide a mechanism for 
> enumerating non-enumerable devices, and both also provide a mechanism 
> for attaching additional configuration data to devices (which may or may 
> not be otherwise enumerable). There's a sufficient overlap in 
> functionality that at least one platform that's traditionally been 
> Device Tree (arm) is also adding support for ACPI - there's even 
> ACPI-based arm hardware on the market already.
> 
> Right now that's a problem for us. The same hardware may end up shipped 
> with either ACPI or DT-based firmware, and at the moment we'd need to 
> either write two drivers or one driver with two glue layers. This is 
> somewhat suboptimal.

There's one more problematic case which is that some systems ship with ACPI
tables that don't contain all of the information necessary to enumerate
hardware appropriately and it's difficult, if not impossible, to convince
the vendors of those systems to fix their ACPI firmware after the fact.
However, at least in some cases there are well defined DT bindings for the
hardware in question.

> The biggest difference between DT and ACPI is that DT is effectively a 
> somewhat structured mechanism for passing arbitrary data, while ACPI 
> tends (with exceptions) to provide standardised data. For instance, in 
> DT we might have:
> 
>         sdhci@c8000000 {
>                 status = "okay";
>                 power-gpios = <&gpio TEGRA_GPIO(K, 6) GPIO_ACTIVE_HIGH>;
>                 bus-width = <4>;
>                 keep-power-in-suspend;
>         };
> 
> In ACPI the normal way to handle this would be to have a GPIO operation 
> region that listed the GPIOs:
> 
> OperationRegion(GPO1, GeneralPurposeIO, 0, 1)
> Field(GP01, ByteAcc, NoLock, Preserve)
> {
>   Connection (GpioIo(Exclusive, PullUp,,,,,)
>   TG06, 1
> }
> 
> And then an ACPI device:
> 
> Device (\_SB.SDHC)
> {
> 	Method (_PS0, 0, NotSerialized)
> 	{
> 		Store (1, TG06)
> 	}
> 	Method (_PS3, 0, NotSerialized)
> 	{
> 		Store (0, TG06)
> 	}
> }
> 
> with the ACPI core then executing these methods whenever a device is 
> powered up or down.
> 
> How can we unify these two different representations? The only terribly 
> plausible way of doing so seems to be to push that out to a helper 
> function and then have it handled as part of device runtime power 
> management, and just have the driver make pm_runtime_get() and _put() 
> calls.
> 
> So we can theoretically handle cases like power lines without /too/ much 
> trouble, while representing the same thing in either ACPI or DT. But we 
> have plenty of other data - in the case of SDHCI alone, there's the bus 
> width and potentially card detect and write protect gpio lines. These 
> can easily be represented in ACPI, but not in a terribly generic way. We 
> could easily add new functions to retrieve this information, but doing 
> this through the standards body is likely to prove tedious, especially 
> when new hardware types appear and we want to be able to ship support 
> pretty much immediately.
> 
> The other choice is to ignore most of the existing ACPI functionality 
> and just use it as a mechanism for providing additional metadata. Apple 
> already do this using the _DSM methods:
> 
> Method (_DSM, 4, NotSerialized)
> {
> 	Store (Package (0x07)
>         {
>         	"refnum", 
>                 0x00, 
> 		"address",
> 		0x39,
> 		"device-id",
> 		0x0cc8,
>                 Buffer (0x01)
>                 {
>                 	0x00
>                 }
>         }, Local0)
>         DTGP (Arg0, Arg1, Arg2, Arg3, RefOf (Local0))
>         Return (Local0)
> }
> 
> where the DTGP() method verifies that the caller passed in an 
> appropriate UUID and then hands back this buffer.
> 
> Putting all our existing DT metadata in there would be straightforward, 
> but we would then effectively just be using ACPI to repackage DT - 
> drivers would continue to make DT-specific calls in order to obtain the 
> information they need.
> 
> This seems like the least-effort approach, but it doesn't really solve 
> much. Any other OS on the same hardware is unlikely to use the DT data, 
> and if someone wants to run Linux on hardware that was intended for 
> another OS they're unlikely to have any DT data to use.
> 
> So while unifying this seems hugely desirable, right now it's not 
> incredibly obvious how we can actually achieve that. In some cases it's 
> easy to take DT information and rewrite it the ACPI way, but in others 
> we just don't seem to have the primitives we need for that. One approach 
> would be to work through the existing DT bindings documentation and see 
> what's missing from ACPI and work on adding it, but we'll still then 
> need helper functions that are able to obtain the same information from 
> either source.
> 
> In any case, it seems like this is something that should be discussed. A 
> bunch of people in the earlier discussion mentioned that they were going 
> to be in New Orleans, so I'd suggest that we arrange a time for 
> in-person discussion there. That should give us a solid basis for 
> further mailing list discussion, and then there'll be another 
> opportunity for discussion in Edinburgh.

There is a time slot reserved for the second part of the ACPI/PM+PCI uconf
that may be used for this purpose if it's suitable for all of the interested
people.  It is scheduled at 2 PM on Thursday, September 19 at the moment
(concurrently with the containers uconf).

Thanks,
Rafael

