Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab3KRUkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 15:40:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49639 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab3KRUkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:40:06 -0500
Date: Mon, 18 Nov 2013 21:40:03 +0100
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>, lkml <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] brcmsmac: Fix build dep on LEDS_CLASS
Message-ID: <20131118204003.GK24851@pd.tnic>
References: <20131117133702.GA30840@pd.tnic>
 <5289359B.8090506@broadcom.com>
 <CACna6ryNX1=8zdYe2bjCj7aj3S_O=LnrxdjBcESvJJ63+h729Q@mail.gmail.com>
 <20131118133250.GH24851@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131118133250.GH24851@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 02:32:50PM +0100, Borislav Petkov wrote:
> On Mon, Nov 18, 2013 at 12:58:58PM +0100, Rafał Miłecki wrote:
> > Borislav: I think I didn't get your original patch.
> 
> Forget it, I'll send a better one later.

Ok, let's try another one. I've done it with depends but we
probably could select LEDS_CLASS in BRCMSMAC_LED as it is required
functionality...

---
From: Borislav Petkov <bp@suse.de>
Subject: [PATCH -v2] brcmsmac: Fix build dep on LEDS_CLASS

When building randconfigs with CONFIG_BCMA_DRIVER_GPIO=y, I get

drivers/built-in.o: In function `brcms_led_unregister':
(.text+0x351aca): undefined reference to `led_classdev_unregister'
drivers/built-in.o: In function `brcms_led_register':
(.text+0x351c65): undefined reference to `led_classdev_register'

during final linking stage because brcmsmac/led.c needs LEDS_CLASS for
registering/deregistering the led device. Add a promptless Kconfig
symbol which takes care of that dependency.

Cc: "Rafał Miłecki" <zajec5@gmail.com>
Cc: <linux-wireless@vger.kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/net/wireless/brcm80211/Kconfig           | 4 ++++
 drivers/net/wireless/brcm80211/brcmsmac/Makefile | 2 +-
 drivers/net/wireless/brcm80211/brcmsmac/led.h    | 2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/Kconfig b/drivers/net/wireless/brcm80211/Kconfig
index b00a7e92225f..c9434b7c7b9b 100644
--- a/drivers/net/wireless/brcm80211/Kconfig
+++ b/drivers/net/wireless/brcm80211/Kconfig
@@ -16,6 +16,10 @@ config BRCMSMAC
 	  be available if you select BCMA_DRIVER_GPIO. If you choose to build a
 	  module, the driver will be called brcmsmac.ko.
 
+config BRCMSMAC_LED
+	def_bool y
+	depends on BRCMSMAC && BCMA_DRIVER_GPIO && LEDS_CLASS
+
 config BRCMFMAC
 	tristate "Broadcom IEEE802.11n embedded FullMAC WLAN driver"
 	depends on CFG80211
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/Makefile b/drivers/net/wireless/brcm80211/brcmsmac/Makefile
index 32464acccd90..9ec2c8b2f26c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmsmac/Makefile
@@ -43,6 +43,6 @@ brcmsmac-y := \
 	brcms_trace_events.o \
 	debug.o
 
-brcmsmac-$(CONFIG_BCMA_DRIVER_GPIO) += led.o
+brcmsmac-$(CONFIG_BRCMSMAC_LED) += led.o
 
 obj-$(CONFIG_BRCMSMAC)	+= brcmsmac.o
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/led.h b/drivers/net/wireless/brcm80211/brcmsmac/led.h
index 17a0b1f5dbcf..b914466e687b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/led.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/led.h
@@ -22,7 +22,7 @@ struct brcms_led {
 	bool active_low;
 };
 
-#ifdef CONFIG_BCMA_DRIVER_GPIO
+#ifdef CONFIG_BRCMSMAC_LED
 void brcms_led_unregister(struct brcms_info *wl);
 int brcms_led_register(struct brcms_info *wl);
 #else
-- 
1.8.4

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
