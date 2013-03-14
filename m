Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab3CNL30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:29:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36117 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756640Ab3CNL3Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 07:29:24 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/3] leds: trigger: use inline functions instead of macros
Thread-Topic: [PATCH v2 1/3] leds: trigger: use inline functions instead of
 macros
Thread-Index: Ac4gpyrhVQWaIQzjTVqhhe/4191d/A==
Date: Thu, 14 Mar 2013 11:29:19 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E488FF@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.62]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macros are used in case that an inline function doesn't work.
Otherwise, use an empty inline function.

(a) Case of !CONFIG_LEDS_TRIGGERS
Following macros are replaced with inline functions.
  led_trigger_register_simple()
  led_trigger_unregister_simple()
  led_trigger_event()
To make inline types, the structure, 'led_trigger' should be defined.
This structure has no member at all.

(b) Case of !CONFIG_LEDS_TRIGGER_IDE_DISK
ledtrig_ide_activity() macro is replaced with an inline function as well.

(c) DEFINE_LED_TRIGGER() and DEFINE_LED_TRIGGER_GLOBAL()
Struct 'led_trigger' is defined both cases, with CONFIG_LEDS_TRIGGERS and
without CONFIG_LEDS_TRIGGERS.
Those macros are moved out of CONFIG_LED_TRIGGERS because of no-dependency
on CONFIG_LEDS_TRIGGERS.

(d) Fix build errors in mmc-core driver
After replacing macros with inline functions, following build errors occur.
(condition: CONFIG_LEDS_TRIGGERS is not set)

  drivers/mmc/core/core.c: In function 'mmc_request_done':
  drivers/mmc/core/core.c:164:25: error: 'struct mmc_host' has no member named 'led'
  drivers/mmc/core/core.c: In function 'mmc_start_request':
  drivers/mmc/core/core.c:254:24: error: 'struct mmc_host' has no member named 'led'
  make[3]: *** [drivers/mmc/core/core.o] Error 1

The reason of these errors is non-existent member variable, 'led'.
It is only valid when CONFIG_LEDS_TRIGGERS is set.
But now, it can be used without this dependency.
To fix build errors, member 'led' is always used without its config option in
'include/linux/mmc/host.h'.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 include/linux/leds.h     |   25 ++++++++++++++-----------
 include/linux/mmc/host.h |    2 --
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/include/linux/leds.h b/include/linux/leds.h
index 0d9b5ee..2d8c0b4 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -142,6 +142,10 @@ extern void led_set_brightness(struct led_classdev *led_cdev,
 /*
  * LED Triggers
  */
+/* Registration functions for simple triggers */
+#define DEFINE_LED_TRIGGER(x)		static struct led_trigger *x;
+#define DEFINE_LED_TRIGGER_GLOBAL(x)	struct led_trigger *x;
+
 #ifdef CONFIG_LEDS_TRIGGERS
 
 #define TRIG_NAME_MAX 50
@@ -164,9 +168,6 @@ struct led_trigger {
 extern int led_trigger_register(struct led_trigger *trigger);
 extern void led_trigger_unregister(struct led_trigger *trigger);
 
-/* Registration functions for simple triggers */
-#define DEFINE_LED_TRIGGER(x)		static struct led_trigger *x;
-#define DEFINE_LED_TRIGGER_GLOBAL(x)	struct led_trigger *x;
 extern void led_trigger_register_simple(const char *name,
 				struct led_trigger **trigger);
 extern void led_trigger_unregister_simple(struct led_trigger *trigger);
@@ -199,20 +200,22 @@ extern void led_trigger_rename_static(const char *name,
 
 #else
 
-/* Triggers aren't active - null macros */
-#define DEFINE_LED_TRIGGER(x)
-#define DEFINE_LED_TRIGGER_GLOBAL(x)
-#define led_trigger_register_simple(x, y) do {} while(0)
-#define led_trigger_unregister_simple(x) do {} while(0)
-#define led_trigger_event(x, y) do {} while(0)
+/* Trigger has no members */
+struct led_trigger {};
 
-#endif
+/* Trigger inline empty functions */
+static inline void led_trigger_register_simple(const char *name,
+					struct led_trigger **trigger) {}
+static inline void led_trigger_unregister_simple(struct led_trigger *trigger) {}
+static inline void led_trigger_event(struct led_trigger *trigger,
+				enum led_brightness event) {}
+#endif /* CONFIG_LEDS_TRIGGERS */
 
 /* Trigger specific functions */
 #ifdef CONFIG_LEDS_TRIGGER_IDE_DISK
 extern void ledtrig_ide_activity(void);
 #else
-#define ledtrig_ide_activity() do {} while(0)
+static inline void ledtrig_ide_activity(void) {}
 #endif
 
 /*
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index d6f20cc..357e80e 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -341,9 +341,7 @@ struct mmc_host {
 
 	mmc_pm_flag_t		pm_flags;	/* requested pm features */
 
-#ifdef CONFIG_LEDS_TRIGGERS
 	struct led_trigger	*led;		/* activity led */
-#endif
 
 #ifdef CONFIG_REGULATOR
 	bool			regulator_enabled; /* regulator state */
-- 
1.7.9.5


Best Regards,
Milo


