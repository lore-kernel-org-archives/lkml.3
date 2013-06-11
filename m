Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab3FKT7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 15:59:49 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:46666 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754014Ab3FKT7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 15:59:47 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        Tony Lindgren <tony@atomide.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH] pinctrl: document the pinctrl PM states
Date: Tue, 11 Jun 2013 21:59:09 +0200
Message-ID: <1370980749-15383-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This document snippet tries to be helpful and define the pin
PM states and helpers, and how they should be used to create
some kind of common ontology around this.

Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/pinctrl.txt | 118 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index f6e664b..a34ea92 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -1196,6 +1196,124 @@ registered. Thus make sure that the error path in your driver gracefully
 cleans up and is ready to retry the probing later in the startup process.
 
 
+Default and power management related states
+===========================================
+
+As mentioned earlier the device core will automatically try to obtain a
+pinctrl handle and activate the "default" state on all drivers.
+
+However, for power management and power saving, it is sometimes necessary
+to switch pin states at runtime. Electrically speaking this involves
+for example reconfigure some pins to be grounded or pulled-down when the
+system as a whole goes to sleep, or a pull-up could be turned off when pins
+are idle, reducing leak current.
+
+To help out with this, if CONFIG_PM is selected in the Kconfig, three
+additional states will also be obtained by the driver core and cached
+there:
+
+"active"   this is indended as an explicit active state, if the "default"
+           state is not synonymous with the active one.
+
+"idle"     this is a state that is relaxing the pins when the system as a
+           whole is up and running, but these particular pins are unused.
+
+"sleep"    this is a state that is used when the whole system goes to
+           suspend, becomes uninteractive, unresponsive to anything but
+           specific wake-up events.
+
+These correspond to the definitions found in <linux/pinctrl/pinctrl-state.h>
+where the same strings are encoded.
+
+When CONFIG_PM is set, the following functions will simultaneously be made
+available to switch between these power-related states:
+
+#include <linux/pinctrl/consumer.h>
+
+int pinctrl_pm_select_default_state(struct device *dev);
+int pinctrl_pm_select_active_state(struct device *dev);
+int pinctrl_pm_select_sleep_state(struct device *dev);
+int pinctrl_pm_select_idle_state(struct device *dev);
+
+As the corresponding pinctrl handle and states are cached in the driver
+core, nothing apart from these calls is needed to move the pins between
+these states.
+
+For a typical runtime PM enabled (see Documentation/power/runtime_pm.txt)
+driver the following outline could be followed:
+
+probe():
+    pinctrl_pm_select_default_state()
+
+runtime_suspend():
+    pinctrl_pm_select_idle_state()
+
+runtime_resume():
+    pinctrl_pm_select_default_state()
+
+suspend:
+    pinctrl_pm_select_sleep_state()
+
+resume:
+    pinctrl_pm_select_idle_state()
+
+Some of the state selectors could be skipped if the driver is for a
+certain system where e.g. the "active" state is not defined, instead
+relying on the "default" state to make the pins active at all times.
+For a driver only supporting suspend and resume, the "idle" state also
+loose its meaning.
+
+A state-chart diagram would look like this:
+
+                +---------+                          +----------+
+    probe() ->  | default |  -> runtime_suspend() -> | idle     |
+                |         |  <- runtime_resume()  <- |          |
+                +---------+                          +----------+
+                                                        |     ^
+                                                        |     |
+                                                  suspend()  resume()
+                                                        |     |
+                                                        V     |
+                                                      +---------+
+                                                      |  sleep  |
+                                                      +---------+
+
+This reflects the runtime PM concept that we are always runtime
+suspended when we go to suspend.
+
+A more complex example is a driver written for many different
+hardware configurations, some which have only the default state,
+some which have the default state and the sleep state, some that
+have no idle state but indeed a default state and so on. Since
+all states are basically optional (the core will not complain if
+they are not found) we can write our state transitions like
+this:
+
+probe():
+    pinctrl_pm_select_default_state()
+
+runtime_suspend():
+    pinctrl_pm_select_idle_state()
+
+runtime_resume():
+    pinctrl_pm_select_default_state()
+    pinctrl_pm_select_active_state()
+
+suspend:
+    pinctrl_pm_select_sleep_state()
+
+resume:
+    pinctrl_pm_select_default_state()
+    pinctrl_pm_select_idle_state()
+
+Here runtime_resume() and resume() passes through the "default"
+state to the "active" and "idle" states respectively since everything
+but "default" is optional. For example it is OK to only supply the
+"default" and "sleep" state pair with this code, and it will
+transition the pins from "default" to "sleep" and leaving the rest
+as no-ops.
+
+
 Drivers needing both pin control and GPIOs
 ==========================================
 
-- 
1.7.11.3

