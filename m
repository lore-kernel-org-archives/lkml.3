Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbaAQUNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 15:13:55 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:60266 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbaAQUNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 15:13:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Chen-Yu Tsai" <wens@csie.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH RFC 4/6] net: rfkill: gpio: add device tree support
Date: Fri, 17 Jan 2014 21:13:13 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree <devicetree@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        "linux-sunxi" <linux-sunxi@googlegroups.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org
References: <1389941251-32692-1-git-send-email-wens@csie.org> <201401171747.46332.arnd@arndb.de> <CAGb2v67UKiyfJbKZ_Frk3OwZupMPoA2Ck3Hj2zsRFXBQPztavg@mail.gmail.com>
In-Reply-To: <CAGb2v67UKiyfJbKZ_Frk3OwZupMPoA2Ck3Hj2zsRFXBQPztavg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401172113.14322.arnd@arndb.de>
X-Provags-ID: V02:K0:bdQcmfSLy+ZQm2gyk3/5vS19AFQRh8Dxs5G3jYbhAfr
 DIOl1cs64rLsX82AB6LuRxQTf2Ei3FLIpmdFI8wKbVOsvuNMUA
 1JXbfk9QcC0NdK82NzFbnMIfX4F1wPb4quYPxZmxh8e2dvEQ+g
 hDDuUFklFpk9EdBTFXZDIQeu6ASeQkKLIBJS32r0L8hfpACaZh
 82gkOdtav+gureC2vF5t+RsW0nvrSuXuMDggmGA9Qtbwfi4Mhe
 am88VDGoIdRbq/BpvdHXOZCsAeWGx8sdbkcvYUWftzneYD/1d9
 GDI+76Af0mgUHooXs8YB/iEn5v2M8kqMThK1ke4JcdpoiceC2Q
 T0s6Gc3Na59K5GzBhGNE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 January 2014, Chen-Yu Tsai wrote:
> On Sat, Jan 18, 2014 at 12:47 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Friday 17 January 2014, Chen-Yu Tsai wrote:
> >> diff --git a/Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt b/Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt
> >> new file mode 100644
> >> index 0000000..8a07ea4
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt
> >> @@ -0,0 +1,26 @@
> >> +GPIO controlled RFKILL devices
> >> +
> >> +Required properties:
> >> +- compatible   : Must be "rfkill-gpio".
> >> +- rfkill-name  : Name of RFKILL device
> >> +- rfkill-type  : Type of RFKILL device: 1 for WiFi, 2 for BlueTooth
> >> +- NAME_shutdown-gpios  : GPIO phandle to shutdown control
> >> +                         (phandle must be the second)
> >> +- NAME_reset-gpios     : GPIO phandle to reset control
> >> +
> >> +NAME must match the rfkill-name property. NAME_shutdown-gpios or
> >> +NAME_reset-gpios, or both, must be defined.
> >> +
> >
> > I don't understand this part. Why do you include the name in the
> > gpios property, rather than just hardcoding the property strings
> > to "shutdown-gpios" and "reset-gpios"?
> 
> This quirk is a result of how gpiod_get_index implements device tree
> lookup. You'll also notice that the shutdown GPIO must be the second
> phandle, as the driver uses indexed lookup to support ACPI cases.
> If con_id is given, it is prepended to "gpios" as the property string.
> con_id is also used as the label passed to gpiod_request, which is
> then shown in /sys/kernel/debug/gpio.

The Linux implementation should not enforce an inferior DT binding.
I think it would be better to change the code instead and make this
work with a more sensible representation.

> I can do a seperate lookup for the device tree case, with or without
> fallback to platform lookup tables. Then the names can be "reset-gpio"
> and "shutdown-gpio". Need to promote gpiod_request to non-static so
> we can register usage of the gpio, to match non-dt code path.
> 
> Personally I prefer adding a "label" parameter to gpiod_get_index, so
> we can use a different name than con_id. con_id isn't used in the ACPI
> case, and is optional in platform lookup case. However device tree
> lookup is dependent on this. What I see is non-uniform behavior
> between the three. In my opinion this is undesirable, but I haven't
> come up with a good solution yet.

(adding the gpio people here). I don't understand enough of the
current API to make a good call here, but I agree that we should try
to make it more uniform and do it in a way that allows simpler DT
bindings for devices using it.

> About the property string, is the plural form required, even though we
> only want one?

I would keep the plural form for consistency.

	Arnd

