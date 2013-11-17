Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab3KQXDC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 18:03:02 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36755 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab3KQXCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 18:02:53 -0500
Date: Mon, 18 Nov 2013 00:02:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: Arend van Spriel <arend@broadcom.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcmsmac: Fix build dep on LEDS_CLASS
Message-ID: <20131117230220.GS27323@pd.tnic>
References: <20131117133702.GA30840@pd.tnic>
 <5289359B.8090506@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5289359B.8090506@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 10:31:07PM +0100, Arend van Spriel wrote:
> Wouldn't it be better to fix it in brcmsmac.

You're right, BCMA_DRIVER_GPIO doesn't need LEDS_CLASS.

So, the only solution I can think of right now is below, maybe
adding a hidden config symbol CONFIG_BRCMSMAC_LEDS which depends on
BCMA_DRIVER_GPIO and LEDS_CLASS and then doing:

brcmsmac-$(CONFIG_BRCMSMAC_LEDS) += led.o

would be cleaner though. I could try that out tomorrow.

---
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/Makefile b/drivers/net/wireless/brcm80211/brcmsmac/Makefile
index 32464acccd90..8fd44d168cd5 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmsmac/Makefile
@@ -43,6 +43,8 @@ brcmsmac-y := \
 	brcms_trace_events.o \
 	debug.o
 
+ifdef CONFIG_LEDS_CLASS
 brcmsmac-$(CONFIG_BCMA_DRIVER_GPIO) += led.o
+endif
 
 obj-$(CONFIG_BRCMSMAC)	+= brcmsmac.o
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/led.h b/drivers/net/wireless/brcm80211/brcmsmac/led.h
index 17a0b1f5dbcf..23b4b688d9f7 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/led.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/led.h
@@ -22,7 +22,7 @@ struct brcms_led {
 	bool active_low;
 };
 
-#ifdef CONFIG_BCMA_DRIVER_GPIO
+#if defined(CONFIG_BCMA_DRIVER_GPIO) && defined(CONFIG_LEDS_CLASS)
 void brcms_led_unregister(struct brcms_info *wl);
 int brcms_led_register(struct brcms_info *wl);
 #else

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
