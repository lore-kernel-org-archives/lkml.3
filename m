Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbaCTVXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:23:41 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59338 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759971AbaCTVXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:23:38 -0400
Date: Thu, 20 Mar 2014 22:23:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH RFC] PM / Hibernate: no kernel_power_off when
 pm_power_off NULL
Message-ID: <20140320212336.GA17368@amd.pavel.ucw.cz>
References: <1395348795-8554-1-git-send-email-sebastian.capella@linaro.org>
 <1395348795-8554-2-git-send-email-sebastian.capella@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395348795-8554-2-git-send-email-sebastian.capella@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Reboot logic in kernel/reboot will avoid calling kernel_power_off
> when pm_power_off is null, and instead uses kernel_halt.  Change
> hibernate's power_down to follow the behavior in the reboot call.
> 
> Calling the notifier twice (once for SYS_POWER_OFF and again for
> SYS_HALT) causes a panic during hibernation on Kirkwood
> Openblocks A6 board.

I can't say I like this patch.

kernel_power_off should work with pm_power_off == NULL, see for
example x86.

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

. arch/arm/process.c implementation is strange:

void machine_halt(void)
{
        local_irq_disable();
	smp_send_stop();

        local_irq_disable();
        while (1);
}

## Why second disable?

/*                                                                                                 
 * Power-off simply requires that the secondary CPUs stop performing
 any                           
 * activity (executing tasks, handling interrupts). smp_send_stop()                                
 * achieves this. When the system power is turned off, it will take
 all CPUs                       
 * with it.                                                                                        
 */
void machine_power_off(void)
{
	local_irq_disable();
        smp_send_stop();

	if (pm_power_off)
                pm_power_off();
}

## It really should do while (1) here.
   
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
