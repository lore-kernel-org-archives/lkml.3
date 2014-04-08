Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbaDHE5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 00:57:42 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:54333 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaDHE5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 00:57:40 -0400
MIME-Version: 1.0
In-Reply-To: <227e5e019c175010b593d41cf1154e2e6505c22e.1396699157.git.viresh.kumar@linaro.org>
References: <227e5e019c175010b593d41cf1154e2e6505c22e.1396699157.git.viresh.kumar@linaro.org>
Date: Tue, 8 Apr 2014 10:27:39 +0530
Message-ID: <CAKohpom7n=cbWJttvxgYCv7uzXQeJx4FzMZuyKWvNvbM6kmqjA@mail.gmail.com>
Subject: Re: [PATCH] clocksource: register cpu notifier to remove timer from
 dying CPU
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 April 2014 17:33, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>  kernel/time/clocksource.c | 64 +++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 53 insertions(+), 11 deletions(-)
>
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index ba3e502..8054fb1 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -23,16 +23,21 @@
>   *   o Allow clocksource drivers to be unregistered
>   */
>
> +#include <linux/cpu.h>
>  #include <linux/device.h>
>  #include <linux/clocksource.h>
>  #include <linux/init.h>
>  #include <linux/module.h>
> +#include <linux/notifier.h>
>  #include <linux/sched.h> /* for spin_unlock_irq() using preempt_count() m68k */
>  #include <linux/tick.h>
>  #include <linux/kthread.h>
>
>  #include "tick-internal.h"
>
> +/* Tracks current CPU to queue watchdog timer on */
> +static int timer_cpu;
> +

Minor fixup, will send V2 after few days:

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 8054fb1..356c6c6 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -35,9 +35,6 @@

 #include "tick-internal.h"

-/* Tracks current CPU to queue watchdog timer on */
-static int timer_cpu;
-
 void timecounter_init(struct timecounter *tc,
                      const struct cyclecounter *cc,
                      u64 start_tstamp)
@@ -185,6 +182,9 @@ static char override_name[CS_NAME_LEN];
 static int finished_booting;

 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
+/* Tracks current CPU to queue watchdog timer on */
+static int timer_cpu;
+
 static void clocksource_watchdog_work(struct work_struct *work);
 static void clocksource_select(void);
