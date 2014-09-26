Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbaIZMUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 08:20:14 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43901 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754335AbaIZMUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 08:20:12 -0400
Date: Fri, 26 Sep 2014 13:20:04 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Chenhui Zhao <chenhui.zhao@freescale.com>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, leoli@freescale.com,
        Jason.Jin@freescale.com, Zhuoyu.Zhang@freescale.com
Subject: Re: [PATCH 1/3] arm: ls1: add CPU hotplug platform support
Message-ID: <20140926122003.GP5182@n2100.arm.linux.org.uk>
References: <1411730703-25836-1-git-send-email-chenhui.zhao@freescale.com> <1411730703-25836-2-git-send-email-chenhui.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411730703-25836-2-git-send-email-chenhui.zhao@freescale.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 07:25:01PM +0800, Chenhui Zhao wrote:
> +static inline void ls1_do_lowpower(unsigned int cpu, int *spurious)
> +{
> +	/*
> +	 * there is no power-control hardware on this platform, so all
> +	 * we can do is put the core into WFI; this is safe as the calling
> +	 * code will have already disabled interrupts
> +	 */
> +	for (;;) {
> +		wfi();
> +
> +		if (pen_release == cpu_logical_map(cpu)) {
> +			/*OK, proper wakeup, we're done*/
> +			break;
> +		}
> +
> +		/*
> +		 * Getting here, means that we have come out of WFI without
> +		 * having been woken up - this shouldn't happen
> +		 *
> +		 * Just note it happening - when we're woken, we can report
> +		 * its occurrence.
> +		 */
> +		(*spurious)++;
> +	}
> +}

This is pretty much unacceptable - this breaks kexec(), and suspend
support because your secondary CPUs aren't really sleeping, they're
sitting in a loop doing nothing.

In the kexec case, the code which the secondary CPU is executing can
be overwritten, which then means that the CPU ends up executing some
random code instead.

Do you really have no way to properly power down or reset the CPU
being unplugged?  If you don't, that's a *huge* oversight in this
modern age, and it means that you're pretty much stuck with having
these features disabled.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
