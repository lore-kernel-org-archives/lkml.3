Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbaF3UAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 16:00:13 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:47960 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751226AbaF3UAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 16:00:10 -0400
Date: Mon, 30 Jun 2014 20:59:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] kernel: Add support for restart notifier call
	chain
Message-ID: <20140630195946.GI32514@n2100.arm.linux.org.uk>
References: <1404155499-21177-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404155499-21177-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 12:11:33PM -0700, Guenter Roeck wrote:
> Various drivers implement architecture and/or device specific means
> to restart (reset) the system. Various mechanisms have been implemented
> to support those schemes. The best known mechanism is arm_pm_restart,
> which is a function pointer to be set either from platform specific code
> or from drivers. Another mechanism is to use hardware watchdogs to issue
> a reset; this mechanism is used if there is no other method available
> to reset a board or system. Two examples are alim7101_wdt, which currently
> uses the reboot notifier to trigger a reset, and moxart_wdt, which registers
> the arm_pm_restart function.
> 
> The existing mechanisms have a number of drawbacks. Typically only one scheme
> to restart the system is supported (at least if arm_pm_restart is used).
> At least in theory there can be mutliple means to restart the system, some of
> which may be less desirable (for example one mechanism may only reset the CPU,
> while another may reset the entire system). Using arm_pm_restart can also be
> racy if the function pointer is set from a driver, as the driver may be in
> the process of being unloaded when arm_pm_restart is called.
> Using the reboot notifier is always racy, as it is unknown if and when
> other functions using the reboot notifier have completed execution
> by the time the watchdog fires.
> 
> To solve the problem, introduce a system restart notifier. This notifier
> is expected to be called from the architecture specific machine_restart()
> function. Drivers providing system restart functionality (such as the watchdog
> drivers mentioned above) are expected to register with this notifier.
> 
> Patch 1 of this series implements the notifier function. Patches 2 and 3
> implement calling the notifier chain from arm and arm64 restart code.
> Patch 4 and 5 convert existing restart handlers in the watchdog subsystem
> to use the restart notifier. Patch 6 unexports arm_pm_restart to ensure
> that no one gets the idea to implement a restart handler as module.

I think you need to restructure stuff somewhat, because I think
you've missed drivers/power/reset/ entirely, or at least you've
missed drivers/power/reset/restart-poweroff.c which calls
arm_pm_restart directly.  I'm not quite sure how we ended up with
that...

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
