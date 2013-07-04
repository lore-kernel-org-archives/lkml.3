Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab3GDFHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 01:07:32 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:45331 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab3GDFHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 01:07:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130703180511.GA374@sirena.org.uk>
References: <1372072858-6559-1-git-send-email-yadi.brar@samsung.com>
	<1372072858-6559-4-git-send-email-yadi.brar@samsung.com>
	<20130703180511.GA374@sirena.org.uk>
Date: Thu, 4 Jul 2013 10:37:30 +0530
Message-ID: <CAKew6eVs+D4Yf+9=e+0fj0UaZQ98gJ-1=CX30_H0p-xnF75gaw@mail.gmail.com>
Subject: Re: [PATCH 3/4] mfd: s2mps11: Add device tree support
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Yadwinder Singh Brar <yadi.brar@samsung.com>, linux-kernel@vger.kernel.org,
        sbkim73@samsung.com, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 3, 2013 at 11:35 PM, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Jun 24, 2013 at 04:50:57PM +0530, Yadwinder Singh Brar wrote:
>
>> + regulator-ramp-delay for BUCKs = [6250/12500/25000(default)/50000] uV/us
>
>> + Optional property for BUCK[2/3/4/6] only:
>> + regulator-ramp-disable: boolean, disables ramp delay on hardware.
>
> If these were device specific bindings they ought to be namespaced as
> samsung, or similar.  However I think they are generic enough that they
> could just be added to the standard regulator bindings, ramp rates are
> common enough and units of time are a simple way to express them.  I'd
> also suggest just using a ramp delay of zero for no ramp, it's simpler
> and will probably fall naturally out of the bindings.
>

Yes, I was also expecting to see regulator-ramp-disable as generic binding.
Before preparing this patch I thought of using regulator-ramp-delay = 0,
but I found it inappropriate because :
-  Currently ramp-delay (= 0) if not defined in DT, leaves the
hardware with default
ramp settings, and uses default ramp-rate defined in rdev->desc . So we need
an extra mechanism(either special(-ve) value of ramp-delay or an extra flag
(ramp_disable) in regulator constraints) to figure out whether ramp-rate is
actually set to zero or its left (by default) zero.
- As ramp time is inversely propositional to ramp-rate(i.e. ramp-delay ,
its wrongly named, my mistake :( ) so it may look weired to use ramp-rate =0
as no ramp(ramp_time = 0).

> Please just send a separate patch adding these to the generic regulator
> binding document instead of this one, we can add generic code/ops for
> this later.

I had below idea in my mind, I dropped it because I thought it may be
to early to put common code as no other driver in mainline appeared
with this requirement yet but probably may come.

8<-----------------------------------------------------------------------

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 815d6df..cf73e7c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2424,7 +2424,8 @@ static int _regulator_do_set_voltage(struct regulator_dev

        /* Call set_voltage_time_sel if successfully obtained old_selector */
        if (ret == 0 && _regulator_is_enabled(rdev) && old_selector >= 0 &&
-           old_selector != selector && rdev->desc->ops->set_voltage_time_sel)
+           old_selector != selector && rdev->desc->ops->set_voltage_time_sel
+           && !rdev->constraints->ramp_disable) {

                delay = rdev->desc->ops->set_voltage_time_sel(rdev,
                                                old_selector, selector);
diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.
index 66ca769..c579aca 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -64,6 +64,9 @@ static void of_get_regulation_constraints(struct device_node
        ramp_delay = of_get_property(np, "regulator-ramp-delay", NULL);
        if (ramp_delay)
                constraints->ramp_delay = be32_to_cpu(*ramp_delay);
+
+       if (of_find_property(np, "regulator-ramp-disable", NULL))
+               constraints->ramp_disable = true;
 }

 /**
diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machin
index 36adbc8..02592da 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -134,6 +134,7 @@ struct regulation_constraints {
        unsigned always_on:1;   /* regulator never off when system is on */
        unsigned boot_on:1;     /* bootloader/firmware enabled regulator */
        unsigned apply_uV:1;    /* apply uV constraint if min == max */
+       unsigned int ramp_disable:1;
 };

 /**


Regards,
Yadwinder
