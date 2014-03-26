Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbaCZAvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 20:51:40 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:38986 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753126AbaCZAvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 20:51:38 -0400
Date: Wed, 26 Mar 2014 00:51:15 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Sebastian Capella <sebastian.capella@linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: machine_power_off should not return
Message-ID: <20140326005115.GW7528@n2100.arm.linux.org.uk>
References: <1395684784-12601-1-git-send-email-sebastian.capella@linaro.org> <20140325224554.GC12185@arch.cereza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140325224554.GC12185@arch.cereza>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 07:45:55PM -0300, Ezequiel Garcia wrote:
> Let's Cc: LAKML, and To: Russell.
> 
> Russell, any comments on this?
> 
> Without this patch we got the heartbeat's reboot_notifier called twice while
> testing the recent hibernation patches, which was unexpected and produced a
> kernel panic: https://lkml.org/lkml/2014/3/19/363

I don't see why we should make this change.  kernel/reboot.c handles
this function returning, so other places should do too.

Even on x86, this function can return:

void machine_power_off(void)
{
        machine_ops.power_off();
}

        .power_off = native_machine_power_off,

static void native_machine_power_off(void)
{
        if (pm_power_off) {
                if (!reboot_force)
                        machine_shutdown();
                pm_power_off();
        }
        /* A fallback in case there is no PM info available */
        tboot_shutdown(TB_SHUTDOWN_HALT);
}

void tboot_shutdown(u32 shutdown_type)
{
        void (*shutdown)(void);

        if (!tboot_enabled())
                return;

Therefore, I'd say... it's a bug in the hibernation code - or we probably
have many buggy architectures.  I'd suggest fixing the hibernation code
rather than stuffing some workaround like an endless loop into every
architecture.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
