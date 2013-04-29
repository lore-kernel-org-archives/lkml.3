Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab3D2Uuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 16:50:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60779 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757596Ab3D2Uuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 16:50:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PATCH] char/misc patches for 3.10-rc1
Date: Mon, 29 Apr 2013 22:50:47 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>, David Brown <davidb@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>
References: <20130429162115.GA6893@kroah.com> <201304292154.15920.arnd@arndb.de> <CA+55aFzefpRz2Y8oW9q0ArrR=XW0POBhy8NSNJ3DrCh9EowLqg@mail.gmail.com>
In-Reply-To: <CA+55aFzefpRz2Y8oW9q0ArrR=XW0POBhy8NSNJ3DrCh9EowLqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201304292250.47699.arnd@arndb.de>
X-Provags-ID: V02:K0:FC17XLkfaB6I/PgPJ8BP+yBIx9q5GMSozbPBtLI5xMn
 +7weQVzKc8VN4mZEKduplYSfbvexbbQj5KxUW5sUpmgVfuLWfG
 U9VuBhBeWdt2ixRbleuBvOIoq07xoMH3nCesTgcO/FbA/ltcWs
 pvX+TBJwRbwjr73NO/VZZAj5/TvDp2/PRALA/tdK55sLPzCCiz
 B1Joh163ug2T5A86/wsyefVGwNofiGnfe6TAPxu4vBGYTbD67r
 nK3gd23x1QpmUS3/eKbi5LBwCpUIJmafDxlee3nGtE2AEe9QX5
 pqVKIotaTxJMNbDnQD0DnvmADfvbp/I240TieEggl+DzeIfeVl
 zXs4dQ1MHlrn3Z/ZAzIs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 April 2013, Linus Torvalds wrote:
> On Mon, Apr 29, 2013 at 12:54 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> There are other things wrong with that whole SSBI driver crap that you
> seem to be ignoring:
> 
>  - it's not a bus, it's just a driver. Just because some people call
> it "serial bus" doesn't make it magically about a "bus". I can call an
> ethernet driver an "ethernet bus driver", and it may be technically
> correct, but it is still bullshit. And ethernet is damn more a real
> bus than that SSBI driver is. That's just a pure serial driver for a
> very specific piece of embedded hardware. Stop calling it a bus.

Fair enough. Of course the distinction here is not based on what it
does, but how it gets used. I've looked at the driver now and it
seems to do exactly the same as i2c and spi, which we certainly need
to treat as buses here. The only difference here is that this hardware
only has a single use in linux-next, which in an MFD driver. If we
had a lot of different ones, it could reasonably be called a bus
and use the bus_type and device_driver infrastructure.

>  - The whole Kconfig thing is complete and utter garbage. There is no
> excuse what-so-ever for ever asking the user about it. Not on x86, not
> on ARM. The drivers that actually use that magical serial line
> driver should just have selected it.

Agreed.

>  - I'm not seeing what commonalities this thing can have with anything
> else. Did anybody look at the code? There's nothing generic there.

It's a simple bus that has addressable registers. We have a generic
infrastructure for these things in drivers/base/regmap, currently
handling I2C, SPI and MMIO based buses, which are often used as
different methods to address the same device endpoints. I think it
would be sensible to add another one-off type here and convert the
user(s) to be based on the regmap interface rather than its own
set of exported symbols.
Alternatively, it could just be moved next to the pm8921 driver
in drivers/mfd, which is currently its only user, but the Qualcomm
people might have a better idea on whether other devices connected
to ssbi follow the same pattern or whether they are going to live
elsewhere outside of drivers/mfd.

	Arnd
