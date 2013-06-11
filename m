Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab3FKTxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 15:53:19 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:45424 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab3FKTxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 15:53:18 -0400
MIME-Version: 1.0
In-Reply-To: <51B75148.5080701@wwwdotorg.org>
References: <1370938616-5952-1-git-send-email-linus.walleij@stericsson.com>
	<51B75148.5080701@wwwdotorg.org>
Date: Tue, 11 Jun 2013 21:53:17 +0200
Message-ID: <CACRpkdYQSO0+9tQkS=df-kpL=XL+DpnY1ijp6_Zeg0MvmFujyw@mail.gmail.com>
Subject: Re: [PATCH] drivers: pinctrl: add active state to core
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        ext Tony Lindgren <tony@atomide.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 6:33 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/11/2013 02:16 AM, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> In addition to the recently introduced pinctrl core
>> control, the PM runtime pin control for the OMAP platforms
>> require a fourth state in addtition to the default, idle and
>> sleep states already handled by the core: an explicit "active"
>> state. Let's introduce this to the core in addition to the
>> other states already defined.
>
> Surely "default" /is/ "active"? That's what it's meant so far.

I thought so too, until Tony informed us that in the OMAP world
this state is not always the active one.

But I don't know the exact reasons for.

I guess that some "default" states on the OMAP may mean these
are configured as decoupled, inactive, until explicitly activated
or something like that.

> Since the pinctrl states are represented in DT, the DT bindings of all
> devices potentially get affected by changes like this. They'd need to be
> documented in a DT binding document, and the exact semantics of the
> different states clearly explained.

Incidentally pinctrl-bindings.txt refers to the states
"active" and "idle" in the examples, but not "default".
(git blame tells me you wrote this ;-)

We should probably patch that document a bit to reflect
the semantics we agree upon here.

> It may be better for struct device, struct platform_driver, or similar,
> to contain a list of the states that are required by the driver or its
> binding. That way, the list of states (or states beyond the basic
> default) is driver-/DT-binding- specific, and custom stuff like this for
> OMAP wouldn't require explicit code in drivers/base/pinctrl.c, but
> rather simply iterating over a custom list.

Hm, I was more out to nail down some common semantics
here, especially with these helper functions:

extern int pinctrl_pm_select_default_state(struct device *dev);
extern int pinctrl_pm_select_active_state(struct device *dev);
extern int pinctrl_pm_select_sleep_state(struct device *dev);
extern int pinctrl_pm_select_idle_state(struct device *dev);

I am intending this to be *all* for the PM consensual states.
Any other states will be up to the special cases and drivers to
handle still, I have no intention of retrieveing and caching all
possible states in the core.

> Related to that, I'm not sure we should be deriving what we put into DT
> based on the runtime PM requirements of drivers; DT is supposed to be
> driven by HW definitions, although I suppose you could argue that the
> drivers implement what they do because they're implementing the HW
> requirements.

Yes that's a circular proof that we do it this way becuse this is the
way we have to do it :-)

But there is some truth to that.

The idea with these PM states is to correspond to such states
often found in electronic specifications, i.e. derived from a larger
set of hardware, not from runtime PM or Linux.

I conjured the following doc patch as a starter:

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index f6e664b..a34ea92 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -1196,6 +1196,124 @@ registered. Thus make sure that the error path
in your driver gracefully
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


Yours,
Linus Walleij
