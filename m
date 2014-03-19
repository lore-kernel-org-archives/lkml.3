Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbaCSUrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:47:41 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:42247 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbaCSUrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:47:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140319154434.GA3488@arch.cereza>
References: <1394016605-24120-1-git-send-email-sebastian.capella@linaro.org>
	<1394016605-24120-3-git-send-email-sebastian.capella@linaro.org>
	<20140316070917.GA3094@arch.cereza>
	<CADHgK6s58EJyJxB-47K8w26H8ZCBFQ2zu7PGAQU9O+2g7=fPwA@mail.gmail.com>
	<20140317204410.GA1118@arch.cereza>
	<CADHgK6tHngKVZS=jo=VYt3Nt3dhiEmiWr28iDy7q_uR9goBj=Q@mail.gmail.com>
	<20140319154434.GA3488@arch.cereza>
Date: Wed, 19 Mar 2014 13:47:38 -0700
Message-ID: <CADHgK6vLB3h0zrdpve=ZyjNu2pe1VYsGxrYgv=2C-JV37vE9tQ@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] ARM hibernation / suspend-to-disk
From: Sebastian Capella <sebastian.capella@linaro.org>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Len Brown <len.brown@intel.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Austin <jonathan.austin@arm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Sricharan R <r.sricharan@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Russ Dill <Russ.Dill@ti.com>,
        Nicolas Pitre <nico@linaro.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jiang Liu <liuj97@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 March 2014 08:44, Ezequiel Garcia
<ezequiel.garcia@free-electrons.com> wrote:
> Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Thanks!
> On the other side, this board has no pm_power_off() support, which means
> kernel_halt() is called after kernel_power_off().
>
> I'm not sure if a NULL pm_power_off() is supported, but this makes my kernel
> crash in a reboot notifier that's called twice (first in kernel_power_off
> and then in kernel_halt):

The omap board I'm using has a null pm_power_off.  I added code to
bypass kernel_power_off in the event pm_power_off is null like this:


diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index a5f702a..d96b910 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -594,7 +594,8 @@ static void power_down(void)
        case HIBERNATION_PLATFORM:
                hibernation_platform_enter();
        case HIBERNATION_SHUTDOWN:
-               kernel_power_off();
+               if (pm_power_off)
+                       kernel_power_off();
                break;
 #ifdef CONFIG_SUSPEND
        case HIBERNATION_SUSPEND:


This follows the behavior in the reboot syscall which does it this way
also.  I'm testing this now, and it seems work fine.  If this looks
good, I can add it as an additional patch.

Thanks,

Sebastian
