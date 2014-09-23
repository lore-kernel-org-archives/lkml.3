Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbaIWHAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 03:00:42 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59537 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752429AbaIWHAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 03:00:40 -0400
Date: Tue, 23 Sep 2014 14:57:56 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: "wim@iguana.be" <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] watchdog: dw_wdt: add restart handler support
Message-ID: <20140923145756.0940559e@xhacker>
In-Reply-To: <541D8A56.8070609@roeck-us.net>
References: <1411108199-1280-1-git-send-email-jszhang@marvell.com>
	<1411108199-1280-3-git-send-email-jszhang@marvell.com>
	<541CEF86.9070606@roeck-us.net>
	<541D8A56.8070609@roeck-us.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-23_03:2014-09-23,2014-09-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1409230077
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Guenter,

On Sat, 20 Sep 2014 07:08:22 -0700
Guenter Roeck <linux@roeck-us.net> wrote:

> On 09/19/2014 08:07 PM, Guenter Roeck wrote:
> > On 09/18/2014 11:29 PM, Jisheng Zhang wrote:
> >> The kernel core now provides an API to trigger a system restart.
> >> Register with it to support restarting the system via. watchdog.
> >>
> >> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> >> ---
> >>   drivers/watchdog/dw_wdt.c | 27 +++++++++++++++++++++++++++
> >>   1 file changed, 27 insertions(+)
> >>
> >> diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
> >> index ad0619d..4ca41e9 100644
> >> --- a/drivers/watchdog/dw_wdt.c
> >> +++ b/drivers/watchdog/dw_wdt.c
> >> @@ -29,9 +29,11 @@
> >>   #include <linux/miscdevice.h>
> >>   #include <linux/module.h>
> >>   #include <linux/moduleparam.h>
> >> +#include <linux/notifier.h>
> >>   #include <linux/of.h>
> >>   #include <linux/pm.h>
> >>   #include <linux/platform_device.h>
> >> +#include <linux/reboot.h>
> >>   #include <linux/spinlock.h>
> >>   #include <linux/timer.h>
> >>   #include <linux/uaccess.h>
> >> @@ -62,6 +64,7 @@ static struct {
> >>       unsigned long        next_heartbeat;
> >>       struct timer_list    timer;
> >>       int            expect_close;
> >> +    struct notifier_block    restart_handler;
> >>   } dw_wdt;
> >>
> >>   static inline int dw_wdt_is_enabled(void)
> >> @@ -119,6 +122,22 @@ static void dw_wdt_keepalive(void)
> >>              WDOG_COUNTER_RESTART_REG_OFFSET);
> >>   }
> >>
> >> +static int dw_wdt_restart_handle(struct notifier_block *this,
> >> +                unsigned long mode, void *cmd)
> >> +{
> >> +    u32 val;
> >> +
> >> +    writel(0, dw_wdt.regs + WDOG_TIMEOUT_RANGE_REG_OFFSET);
> >> +    val = readl(dw_wdt.regs + WDOG_CONTROL_REG_OFFSET);
> >> +    if (val & WDOG_CONTROL_REG_WDT_EN_MASK)
> >> +        writel(WDOG_COUNTER_RESTART_KICK_VALUE, dw_wdt.regs +
> >> +            WDOG_COUNTER_RESTART_REG_OFFSET);
> >> +    else
> >> +        writel(WDOG_CONTROL_REG_WDT_EN_MASK,
> >> +               dw_wdt.regs + WDOG_CONTROL_REG_OFFSET);

> Another comment: You should probably wait here for a bit to let the reset
> catch.

will do in next version. Thanks for pointing out

> >
> > Don't you have to write WDOG_COUNTER_RESTART_KICK_VALUE into
> > WDOG_COUNTER_RESTART_REG_OFFSET in the else case as well ?
> >
> 
> According to the datasheet, it should be sufficient to
> - Write 0 into WDOG_TIMEOUT_RANGE_REG_OFFSET to select the minimum timeout
> period
> - Write 0x1 into WDOG_CONTROL_REG_OFFSET to enable the watchdog and select
> reset as desired action. This can be unconditional.
> 
> Writing into the restart register should not be necessary.
> 

we want to handle the reboot case if wdt is in already use. In this case,
we dunno what's the timeout period, but obviously it's not as short as 2^16/clk
So we change the timeout period by writing 0 into WDOG_TIMEOUT_RANGE_REG_OFFSET
to select the minimum timeout period. But per the datasheet, a change of the
timeout period takes effect only after the next counter restart. So we programming
the restart register to kick off next counter restart.

Thanks for reviewing,
Jisheng

