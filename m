Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaHTNok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:44:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60810 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965AbaHTNog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:44:36 -0400
X-AuditID: cbfee61a-f79e46d00000134f-f9-53f4a64389c3
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v5 02/10] Documentation: leds: Add description of Flash
 Manager
Date: Wed, 20 Aug 2014 15:44:11 +0200
Message-id: <1408542259-415-3-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1408542259-415-1-git-send-email-j.anaszewski@samsung.com>
References: <1408542259-415-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t9jAV3nZV+CDR7d47LYOGM9q8XRnROZ
	LOYfOcdq0Xv1OaPF2aY37BaXd81hs9j6Zh2jRc+GrawWu3c9ZXXg9Ng56y67x575P1g9+ras
	YvT4vEkugCWKyyYlNSezLLVI3y6BK2P3sp/sBZ1KFV+utjM2MM6T6WLk5JAQMJG4/6GdEcIW
	k7hwbz0biC0ksIhR4sztvC5GLiC7nUli54nZTCAJNgFDiZ8vXoPZIgLlEj3vn7GBFDELrGaU
	uLP1KytIQlggVOLkqh52EJtFQFXi9dItzF2MHBy8Am4Sc8+rgpgSAgoScybZgJicAu4SW96r
	QKx1kzj9bjbLBEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCQ+uZ1A7GlQ0WhxgF
	OBiVeHgbFnwJFmJNLCuuzD3EKMHBrCTC294JFOJNSaysSi3Kjy8qzUktPsQozcGiJM57oNU6
	UEggPbEkNTs1tSC1CCbLxMEp1cCYFOL1Opa1/kbrJUazKO53xt/vxBgFlizP21wStbKqYm/V
	Kr+7PIXLOb1Dbs2/+qt7T5KLAePud91rHkmxWC+oatUwcHsv73Tg4itRH3VLRQszsbPCNwuN
	TrS2cQg47Jd11FCLibnAscew0vYhy9/GAw2hFtPnX9jj2Pam1mG+OataxIKoeUosxRmJhlrM
	RcWJAMWIO5IpAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation being added contains overall description
of the Flash Manager functionality and the related sysfs
attributes.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 Documentation/leds/leds-class-flash.txt |   64 +++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/Documentation/leds/leds-class-flash.txt b/Documentation/leds/leds-class-flash.txt
index 8a9c17e..417b984 100644
--- a/Documentation/leds/leds-class-flash.txt
+++ b/Documentation/leds/leds-class-flash.txt
@@ -52,3 +52,67 @@ exposes a number of V4L2 controls. When the V4L2_CID_FLASH_LED_MODE control
 is set to V4L2_FLASH_LED_MODE_TORCH or V4L2_FLASH_LED_MODE_FLASH the
 LED subsystem sysfs interface becomes unavailable. The interface can be
 unlocked by setting the mode back to V4L2_FLASH_LED_MODE_NONE.
+
+
+Flash Manager
+=============
+
+Flash LED devices often provide two ways of strobing the flash: software
+(e.g. by setting a bit in a register) and hardware, by asserting dedicated pin,
+which is usually connected to a camera sensor device. There are also flash led
+devices which support only hardware strobing - in such cases a multiplexer
+device is employed to route the flash strobe signal either from the SoC GPIO or
+from the external strobe signal provider, e.g. camera sensor.
+Use of multiplexers allows also to change the flash-sensor connection
+dynamically if there is more than one flash or external strobe signal provider
+available on the board.
+
+In order to address the aforementioned cases the Flash Manager functionality
+has been introduced. Flash Manager is a part of the LED Flash Class.
+It maintains information about flashes, software and external strobe signal
+providers and multiplexers that route strobe signals among them.
+Flash Manager becomes available after defining CONFIG_LEDS_FLASH_MANAGER
+symbol in the kernel config.
+
+A flash led device is registered in the Flash Manager only if its Device Tree
+node contains information about the topology of strobe signals that can be
+routed to the device. The related device node has to be passed int the third
+argument to the led_classdev_flash_register function.
+The device_node is expected to include one gate-software-strobe subnode and
+at least one gate-external-strobeN subnode. Besides that there must defined
+a flash_muxes node aggregating all the multiplexers that can be referenced
+by the flash led devices. (for mote details see Documentation/devicetree/
+bindings/leds/ leds-flash-manager.txt).
+
+Flash manager adds following sysfs attributes to the LED Flash Clash
+device sysfs interface:
+
+	- strobe_provider - id of the external strobe signal provider associated
+                            with the flash led device. It is created only if
+			    there is more than one external strobe signal
+			    provider defined (RW).
+	- strobe_providerN - names of the strobe signal providers available
+			     for the flash led device, where N is the
+			     identifier of a strobe signal provider (RO)
+
+
+LED Flash Class multiplexers
+============================
+
+Multiplexers are an indispensable part of the Flash Manager. Flash Manager has
+its own led_flash_gpio_mux* helpers for creating, releasing and operating on
+the simple gpio driven multiplexers (the ones whose lines are selected by
+changing the state of its selector pins).
+
+It is however possible that a more advanced device will be used for routing
+strobe signals. This kind of devices are known to the Flash Manager as
+"asynchronous muxes" and can be registered in arbitrary moment with use of
+led_flash_manager_bind_async_mux API and unregistered with
+led_flash_manager_unbind_async_mux. (see Documentation/leds/leds-async-mux.c
+for the exemplary implementation of the async mux driver).
+
+If a LED Flash Class device declares dependency on an async mux, then strobing
+the flash, or setting external strobe, will succeed only wnen the async mux
+has been bound to the Flash Manager. Async mux module, once bound, can be
+removed only after all LED Flash Class devices using it are unregistered
+from the Flash Manager.
-- 
1.7.9.5

