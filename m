Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935744Ab3DISyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:54:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37952 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932780Ab3DISya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:54:30 -0400
Message-ID: <516463D2.2070008@ti.com>
Date: Wed, 10 Apr 2013 00:24:10 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: Re: [PATCHv3] driver: serial: prevent UART console idle on suspend
 while using "no_console_suspend"
References: <1365167733-28083-1-git-send-email-sourav.poddar@ti.com> <87mwtclvua.fsf@linaro.org>
In-Reply-To: <87mwtclvua.fsf@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,
On Friday 05 April 2013 11:10 PM, Kevin Hilman wrote:
> Sourav Poddar<sourav.poddar@ti.com>  writes:
>
>> With dt boot, uart wakeup after suspend is non functional while using
>> "no_console_suspend" in the bootargs. With "no_console_suspend" used, we
>> should prevent the runtime suspend of the uart port which is getting used
>> as an console.
>>
>> Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
>> Cc: Felipe Balbi<balbi@ti.com>
>> Cc: Rajendra nayak<rnayak@ti.com>
>> Tested on omap5430evm, omap4430sdp.
>>
>> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
> Rather than make these special checks inside the driver's runtime PM
> callbacks, you should just disable runtime PM (pm_runtime_disable())
>
> Then, this should be broken into 2 patches.
>
> 1) serial core: add the '->is_console' flag.  (nit on naming: don't call
>     it port_is_console, since the struct is already a uart_port)
>
> 2) In the OMAP UART driver's ->prepare callback, check the is_console flag
>     and pm_runtime_disable() accordingly  (then pm_runtime_enable() in
>     the drivers's ->complete callback.
>
> Kevin

I was working on your above suggestions, but realised there is not only 
console
uart which has the requirement of keeping the clocks enabled while going on
suspend.

If you see arch/arm/boot/dts/am33xx.dtsi, there is a ocmcram which has
"no_idle_on_suspend" property used.

     ocmcram: ocmcram@40300000 {
                         compatible = "ti,am3352-ocmcram";
                         reg = <0x40300000 0x10000>;
                         ti,hwmods = "ocmcram";
                         ti,no_idle_on_suspend;
         };
This property gets checked in omap_device file and correspondingly 
od->flags is set.

Based on your above inputs, the patches which I cooked up is inlined[1]. 
Though, the below
patches works fine for uart case. The patches will effect ocmcram case 
and I am inling them
"just for discussion".

I am not sure, if there is any other cleaner way of getting around this 
"no_idle_on_suspend" flag
as they are getting used for ocmcram also. ?

Thanks,
Sourav

[1]:
From: Sourav Poddar <sourav.poddar@ti.com>
Date: Wed, 13 Mar 2013 20:32:36 +0530
Subject: [PATCH 1/2] arm: mach-omap2: remove 
"OMAP_DEVICE_NO_IDLE_ON_SUSPEND" check

Remove the "OMAP_DEVICE_NO_IDLE_ON_SUSPEND" check, since serial core and 
driver
takes care of the case when "no_console_suspend" is used in the bootargs and
you need to keep the clock enable for console even while suspend.

Tested on omap5430evm, omap4430sdp.

Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
  arch/arm/mach-omap2/omap_device.c |    7 +------
  1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_device.c 
b/arch/arm/mach-omap2/omap_device.c
index 381be7a..d6dce8f 100644
--- a/arch/arm/mach-omap2/omap_device.c
+++ b/arch/arm/mach-omap2/omap_device.c
@@ -620,11 +620,8 @@ static int _od_suspend_noirq(struct device *dev)
         ret = pm_generic_suspend_noirq(dev);

         if (!ret && !pm_runtime_status_suspended(dev)) {
-               if (pm_generic_runtime_suspend(dev) == 0) {
-                       if (!(od->flags & OMAP_DEVICE_NO_IDLE_ON_SUSPEND))
-                               omap_device_idle(pdev);
+               if (pm_generic_runtime_suspend(dev) == 0)
                         od->flags |= OMAP_DEVICE_SUSPENDED;
-               }
         }

         return ret;
@@ -638,8 +635,6 @@ static int _od_resume_noirq(struct device *dev)
         if ((od->flags & OMAP_DEVICE_SUSPENDED) &&
             !pm_runtime_status_suspended(dev)) {
                 od->flags &= ~OMAP_DEVICE_SUSPENDED;
-               if (!(od->flags & OMAP_DEVICE_NO_IDLE_ON_SUSPEND))
-                       omap_device_enable(pdev);
                 pm_generic_runtime_resume(dev);
         }

--

From: Sourav Poddar <sourav.poddar@ti.com>
Date: Wed, 13 Mar 2013 20:32:36 +0530
Subject: [PATCH 2/2] driver: serial: omap: add prepare/complete callback 
for "no_console_suspend" case

This patch adapt the serial core/driver to take care of the case when 
"no_console_suspend"
is used in the bootargs. This patch will remove dependency to set 
od->flags to
"OMAP_DEVICE_NO_IDLE_ON_SUSPEND" in serial.c(non dt case) and 
omap_device.c(dt case).

Prepare and complete callbacks will ensure that clocks remain active for 
the console
uart when "no_console_suspend" is used in the bootargs.

Tested on omap5430evm, omap4430sdp.

Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
  drivers/tty/serial/omap-serial.c |   20 ++++++++++++++++++++
  drivers/tty/serial/serial_core.c |    3 +++
  include/linux/serial_core.h      |    1 +
  3 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c 
b/drivers/tty/serial/omap-serial.c
index 08332f3..b726b2b 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1278,6 +1278,24 @@ static struct uart_driver serial_omap_reg = {
  };

  #ifdef CONFIG_PM_SLEEP
+static int serial_omap_prepare(struct device *dev)
+{
+       struct uart_omap_port *up = dev_get_drvdata(dev);
+
+       if (!console_suspend_enabled && up->port.is_console)
+               pm_runtime_disable(dev);
+
+       return 0;
+}
+
+static void serial_omap_complete(struct device *dev)
+{
+       struct uart_omap_port *up = dev_get_drvdata(dev);
+
+       if (!console_suspend_enabled && up->port.is_console)
+               pm_runtime_enable(dev);
+}
+
  static int serial_omap_suspend(struct device *dev)
  {
         struct uart_omap_port *up = dev_get_drvdata(dev);
@@ -1632,6 +1650,8 @@ static const struct dev_pm_ops 
serial_omap_dev_pm_ops = {
         SET_SYSTEM_SLEEP_PM_OPS(serial_omap_suspend, serial_omap_resume)
         SET_RUNTIME_PM_OPS(serial_omap_runtime_suspend,
                                 serial_omap_runtime_resume, NULL)
+       .prepare        = serial_omap_prepare,
+       .complete       = serial_omap_complete,
  };

  #if defined(CONFIG_OF)
diff --git a/drivers/tty/serial/serial_core.c 
b/drivers/tty/serial/serial_core.c
index a400002..c4d9328 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2594,6 +2594,9 @@ int uart_add_one_port(struct uart_driver *drv, 
struct uart_port *uport)
         uport->cons = drv->cons;
         uport->state = state;

+       if (uart_console(uport))
+               uport->is_console = true;
+
         /*
          * If this port is a console, then the spinlock is already
          * initialised.
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 87d4bbc..7fcdd90 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -194,6 +194,7 @@ struct uart_port {
         unsigned char           irq_wake;
         unsigned char           unused[2];
         void                    *private_data;          /* generic 
platform data pointer */
+       bool                    is_console;
  };

  static inline int serial_port_in(struct uart_port *up, int offset)

