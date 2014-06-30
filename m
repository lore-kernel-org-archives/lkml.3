Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096AbaF3Tzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 15:55:52 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:47941 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751299AbaF3Tzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 15:55:51 -0400
Date: Mon, 30 Jun 2014 20:55:20 +0100
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
Subject: Re: [RFC PATCH 3/6] arm: Support restart through restart notifier
	call chain
Message-ID: <20140630195520.GH32514@n2100.arm.linux.org.uk>
References: <1404155499-21177-1-git-send-email-linux@roeck-us.net> <1404155499-21177-4-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404155499-21177-4-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 12:11:36PM -0700, Guenter Roeck wrote:
> The kernel core now supports a notifier call chain for system
> restart functions.
> 
> With this change, the arm_pm_restart callback is now optional,
> so check if it is set before calling it.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  arch/arm/kernel/process.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index 81ef686..93765f2 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -32,6 +32,7 @@
>  #include <linux/hw_breakpoint.h>
>  #include <linux/leds.h>
>  #include <linux/reboot.h>
> +#include <linux/watchdog.h>
>  
>  #include <asm/cacheflush.h>
>  #include <asm/idmap.h>
> @@ -230,7 +231,10 @@ void machine_restart(char *cmd)
>  	local_irq_disable();
>  	smp_send_stop();
>  
> -	arm_pm_restart(reboot_mode, cmd);
> +	if (arm_pm_restart)
> +		arm_pm_restart(reboot_mode, cmd);
> +
> +	blocking_notifier_call_chain(&restart_notifier_list, reboot_mode, cmd);

One or the other please, because there could (and I think there are)
some implementations which tell stuff to power down, and then continue
into the mdelay() below.  In such situations, we don't want to call
the notifier.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
