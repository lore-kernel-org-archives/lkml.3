Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161731Ab3DEHI5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 03:08:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35684 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab3DEHIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 03:08:55 -0400
Message-ID: <515E7876.3080407@ti.com>
Date: Fri, 5 Apr 2013 12:38:38 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>, Felipe Balbi <balbi@ti.com>,
        Rajendra nayak <rnayak@ti.com>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-serial@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH/Resend 2/2] arm: mach-omap2: prevent UART console idle
 on suspend while using "no_console_suspend"
References: <1363612924-349-1-git-send-email-sourav.poddar@ti.com>	<87fvzsilnv.fsf@linaro.org> <5149A221.5@ti.com>	<5149A63C.4000102@ti.com> <515AA9CD.5000004@ti.com> <87txnnzesd.fsf@linaro.org>
In-Reply-To: <87txnnzesd.fsf@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,
On Wednesday 03 April 2013 11:18 PM, Kevin Hilman wrote:
> Sourav Poddar<sourav.poddar@ti.com>  writes:
>
>> Hi Kevin,
>> On Wednesday 20 March 2013 05:36 PM, Sourav Poddar wrote:
>>> Realised the list  to whom the patch was send got dropped. Ccing
>>> them all..
>>> On Wednesday 20 March 2013 05:18 PM, Sourav Poddar wrote:
>>>> Hi Kevin,
>>>> On Tuesday 19 March 2013 12:24 AM, Kevin Hilman wrote:
>>>>> Sourav Poddar<sourav.poddar@ti.com>   writes:
>>>>>
>>>>>> With dt boot, uart wakeup after suspend is non functional on
>>>>>> omap4/5 while using
>>>>>> "no_console_suspend" in the bootargs. With "no_console_suspend"
>>>>>> used, od->flags
>>>>>> should be ORed with "OMAP_DEVICE_NO_IDLE_ON_SUSPEND", thereby not
>>>>>> allowing the console
>>>>>> to idle in the suspend path. For non-dt case, this was taken care
>>>>>> by platform data.
>>>>>>
>>>>>> Tested on omap5430evm, omap4430sdp.
>>>>>>
>>>>>> Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
>>>>>> Cc: Felipe Balbi<balbi@ti.com>
>>>>>> Cc: Rajendra nayak<rnayak@ti.com>
>>>>>> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
>>>>> This patch creates a dependency between omap_device (generic,
>>>>> device-independent code) and a specific driver (UART.)
>>>>>
>>>>> If you need to do something like this that's DT boot specific, then
>>>>> we probably need some late initcall in serial.c to handle this.
>>>>> It does
>>>>> not belong in omap_device.
>>>>>
>>>> The following function "omap_device_disable_idle_on_suspend(pdev)"
>>>> should only
>>>> be called once the omap device has been build, which in the case of
>>>> device tree is
>>>> done in omap_device.c file. Moreover, the above call should be
>>>> executed conditionally
>>>> and should depend on the following two parameter.
>>>>
>>>> [1]  a. Whether "no_console_suspend" is set and
>>>>       b.  the device build is a console uart.
>>>>
>>>> When I look closely into the serial.c file, I realised that
>>>> "core_initcall(omap_serial_early_init)" gets called irrespective
>>>> of dt/non dt boot and will take care of most of the stuff(checking
>>>> whether
>>>> "no_console_suspend" is used and which uart is used as a console
>>>> uart) which the
>>>> $subject patch is proposing.
>>>>
>>>> But the problem is that we need to exchange the parsed information
>>>> from serial.c to the omap_device file for the condtional execution of
>>>> "omap_device_disable_idle_on_suspend"
>>>>
>>>> In this case,
>>>> from "serial.c" we need
>>>>      1. no_console_suspend = true
>>>>      2. strcpy(console_name, oh_name), where oh_name corresponds to
>>>> the console uart.
>>>>
>>>> then in "omap_device.c" do
>>>>      if (no_console_suspend&&  !strcmp(oh->name, console_name))
>>>>                  omap_device_disable_idle_on_suspend(pdev);
>>>>
>>>> Please correct if I am understanding it incorrectly.
>>>>
>>>> If the above understanding looks good to you, is there a way we can
>>>> make this
>>>> exchange of information happen between serial.c and omap_device.c file?
>> Any input on this?
>> As I explained earlier, that there is a need to parse information in
>> serial.c and use that in
>> omap_device.c only after the device is build.
> As I explained earlier, any device specific hacks inside omap_device
> should be a red flag that something has gone wrong.
>
> How about fixing the UART driver/core to not runtime suspend if
> no_console_suspend is given?
>
> Then we can get rid of this no_idle_on_suspend hack all together since
> UART is the only remaining user.
>

Yes, that can be done.

I cooked up an experimental patch, based on your above suggestion. The 
patch is
inlined along with  the mail. I tested the patch and it resolves
the issue.

Depending on whether no_console_suspend is used or not, we can set a 
variable
which can be used as a condition in runtime api's in serial driver.

The information whether "no_console_suspend" is used or not is parsed in
serial.c file, and this need to be communicated to the driver layer.

In my experimental patch below, I have used an extern variable
"force_console_suspend_disable".

Do you see a better way of handling this without using extern?

---------
From: Sourav Poddar <sourav.poddar@ti.com>
Date: Wed, 13 Mar 2013 20:32:36 +0530
Subject: [PATCH] arm: mach-omap2: prevent UART console idle on suspend 
while using "no_console_suspend"

With dt boot, uart wakeup after suspend is non functional while using
"no_console_suspend" in the bootargs. With "no_console_suspend" used, 
od->flags
should be ORed with "OMAP_DEVICE_NO_IDLE_ON_SUSPEND", thereby not 
allowing the console
to idle in the suspend path.

Tested on omap5430evm, omap4430sdp.

Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
---
  arch/arm/mach-omap2/serial.c     |    6 ++++--
  drivers/tty/serial/omap-serial.c |    6 +++++-
  2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/serial.c b/arch/arm/mach-omap2/serial.c
index f660156..427c407 100644
--- a/arch/arm/mach-omap2/serial.c
+++ b/arch/arm/mach-omap2/serial.c
@@ -51,7 +51,7 @@
  #define DEFAULT_AUTOSUSPEND_DELAY    -1

  #define MAX_UART_HWMOD_NAME_LEN        16
-
+int force_console_suspend_disable;
  struct omap_uart_state {
      int num;

@@ -207,8 +207,10 @@ static int __init omap_serial_early_init(void)
                      uart_name, uart->num);
              }

-            if (cmdline_find_option("no_console_suspend"))
+            if (cmdline_find_option("no_console_suspend")) {
+                force_console_suspend_disable = 1;
                  no_console_suspend = true;
+            }

              /*
               * omap-uart can be used for earlyprintk logs
diff --git a/drivers/tty/serial/omap-serial.c 
b/drivers/tty/serial/omap-serial.c
index 08332f3..395ade8 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -43,6 +43,7 @@
  #include <linux/pinctrl/consumer.h>
  #include <linux/platform_data/serial-omap.h>

+extern int force_console_suspend_disable;
  #define OMAP_MAX_HSUART_PORTS    6

  #define UART_BUILD_REVISION(x, y)    (((x) << 8) | (y))
@@ -1582,7 +1583,7 @@ static int serial_omap_runtime_suspend(struct 
device *dev)
      struct uart_omap_port *up = dev_get_drvdata(dev);
      struct omap_uart_port_info *pdata = dev->platform_data;

-    if (!up)
+    if (!up || force_console_suspend_disable)
          return -EINVAL;

      if (!pdata)
@@ -1614,6 +1615,9 @@ static int serial_omap_runtime_resume(struct 
device *dev)

      int loss_cnt = serial_omap_get_context_loss_count(up);

+    if (force_console_suspend_disable)
+        return -EINVAL;
+
      if (loss_cnt < 0) {
          dev_err(dev, "serial_omap_get_context_loss_count failed : %d\n",
              loss_cnt);
-- 
1.7.1


