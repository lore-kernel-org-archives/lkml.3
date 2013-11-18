Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab3KRXcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 18:32:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37957 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab3KRXcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 18:32:50 -0500
Date: Tue, 19 Nov 2013 00:32:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] brcmsmac: Fix build dep on LEDS_CLASS
Message-ID: <20131118233247.GM24851@pd.tnic>
References: <20131117133702.GA30840@pd.tnic>
 <5289359B.8090506@broadcom.com>
 <CACna6ryNX1=8zdYe2bjCj7aj3S_O=LnrxdjBcESvJJ63+h729Q@mail.gmail.com>
 <20131118133250.GH24851@pd.tnic>
 <20131118204003.GK24851@pd.tnic>
 <528A925C.20602@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <528A925C.20602@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 11:19:08PM +0100, Arend van Spriel wrote:
> what about:
> 
> config BRCMSMAC
>         tristate "Broadcom IEEE802.11n PCIe SoftMAC WLAN driver"
>         depends on MAC80211
>         depends on BCMA_POSSIBLE
> +	select LEDS_CLASS if BCMA_DRIVER_GPIO
> 	select BCMA

I know, nice and short but too good to be true. LEDS_CLASS needs to pull
in NEW_LEDS unfortunately:

drivers/built-in.o: In function `set_brightness_delayed':
led-class.c:(.text+0x4596e5): undefined reference to `led_stop_software_blink'
drivers/built-in.o: In function `led_classdev_register':
(.text+0x4598db): undefined reference to `leds_list_lock'
drivers/built-in.o: In function `led_classdev_register':
(.text+0x4598e7): undefined reference to `leds_list'
drivers/built-in.o: In function `led_classdev_register':
(.text+0x4598f3): undefined reference to `leds_list'
drivers/built-in.o: In function `led_classdev_register':
(.text+0x4598fa): undefined reference to `leds_list_lock'
drivers/built-in.o: In function `led_classdev_register':
(.text+0x459901): undefined reference to `leds_list'
drivers/built-in.o: In function `led_classdev_unregister':
(.text+0x4599a8): undefined reference to `led_stop_software_blink'
drivers/built-in.o: In function `led_classdev_unregister':
(.text+0x4599b2): undefined reference to `led_set_brightness'
drivers/built-in.o: In function `led_classdev_unregister':
(.text+0x4599c2): undefined reference to `leds_list_lock'
drivers/built-in.o: In function `led_classdev_unregister':
(.text+0x4599d6): undefined reference to `leds_list_lock'
make: *** [vmlinux] Error 1

What works, instead, is below. I think my "depends" solution from
earlier takes care of this without you having to select other stuff
explicitly but in the end of the day, I don't really care all that much
which one you guys take.

--
diff --git a/drivers/net/wireless/brcm80211/Kconfig b/drivers/net/wireless/brcm80211/Kconfig
index b00a7e92225f..54e36fcb3954 100644
--- a/drivers/net/wireless/brcm80211/Kconfig
+++ b/drivers/net/wireless/brcm80211/Kconfig
@@ -5,6 +5,8 @@ config BRCMSMAC
        tristate "Broadcom IEEE802.11n PCIe SoftMAC WLAN driver"
        depends on MAC80211
        depends on BCMA
+       select NEW_LEDS if BCMA_DRIVER_GPIO
+       select LEDS_CLASS if BCMA_DRIVER_GPIO
        select BRCMUTIL
        select FW_LOADER
        select CRC_CCITT

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
