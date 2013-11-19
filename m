Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab3KSWzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:55:31 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:42053 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab3KSWz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:55:29 -0500
MIME-Version: 1.0
In-Reply-To: <528BE8F2.3030507@linaro.org>
References: <1384896471-9384-1-git-send-email-linus.walleij@linaro.org>
	<528BE8F2.3030507@linaro.org>
Date: Tue, 19 Nov 2013 23:55:28 +0100
Message-ID: <CACRpkdab=1xJtcAg-_oUBr_jC5DgDre-f9jxuzDnZmXGFShvLw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: ux500: decomission the non-DT MTU init sequence
From: Linus Walleij <linus.walleij@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 11:40 PM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
> On 11/19/2013 10:27 PM, Linus Walleij wrote:

>> -       if (!of_have_populated_dt())
>> -               nmdk_timer_init(mtu_timer_base, IRQ_MTU0);
>
> If no timer have been defined in the dt [or wrongly defined], is there a
> message to tell the user what is wrong ?

Isn't that a question to be asked about a whole lot of such
clocksource drivers and ARM platforms?

Most DT-only ARM platforms rely on
arch/arm/kernel/time.c to call clocksource_of_init() if the
machine_desc->init_time() hook is not set and has zero
code to handle any such situation.

So I guess what you're asking is whether we should patch
clocksource_of_init() to warn if it cannot find any
matching clock sources, like this:

>From e55cf038b238d96b28d9fb01b5b6cdf345990d53 Mon Sep 17 00:00:00 2001
From: Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 19 Nov 2013 23:52:56 +0100
Subject: [PATCH] clksrc-of: warn if no clock sources are found

Many platforms rely on clocksource_of_init() being implicitly
called for registering clock sources and will get zero warnings
if no working clock source is available. Let's print a critical
error message if no clock source is found.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/clocksource/clksrc-of.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clocksource/clksrc-of.c b/drivers/clocksource/clksrc-of.c
index 35639cf4e5a2..a30b42c3ac3b 100644
--- a/drivers/clocksource/clksrc-of.c
+++ b/drivers/clocksource/clksrc-of.c
@@ -28,6 +28,7 @@ void __init clocksource_of_init(void)
     struct device_node *np;
     const struct of_device_id *match;
     clocksource_of_init_fn init_func;
+    unsigned clocksources = 0;

     for_each_matching_node_and_match(np, __clksrc_of_table, &match) {
         if (!of_device_is_available(np))
@@ -36,5 +37,8 @@ void __init clocksource_of_init(void)
         init_func = match->data;
         init_func(np);
         of_node_put(np);
+        clocksources++;
     }
+    if (!clocksources)
+        pr_crit("%s: no matching clocksources found\n", __func__);
 }
-- 
1.8.3.1

You can apply this by itself to get the desired warning.
Tell me if you want me to send the patch separately.

Yours,
Linus Walleij
