Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbaEBKBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 06:01:47 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62499 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751678AbaEBKBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 06:01:46 -0400
Date: Fri, 2 May 2014 11:01:05 +0100
From: Will Deacon <will.deacon@arm.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/5] watchdog: Add API to trigger reboots
Message-ID: <20140502100105.GC17370@arm.com>
References: <1398958893-30049-1-git-send-email-linux@roeck-us.net>
 <1398958893-30049-2-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398958893-30049-2-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

This looks pretty sensible to me (and the arm/arm64 bits look fine too), but
I have one question below...

On Thu, May 01, 2014 at 04:41:29PM +0100, Guenter Roeck wrote:
> Some hardware implements reboot through its watchdog hardware,
> for example by triggering a watchdog timeout. Platform specific
> code starts to spread into watchdog drivers, typically by setting
> pointers to a callback functions which is then called from the
> platform reset handler.
> 
> To simplify code and provide a unified API to trigger reboots by
> watchdog drivers, provide a single API to trigger such reboots
> through the watchdog subsystem.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/watchdog/watchdog_core.c |   17 +++++++++++++++++
>  include/linux/watchdog.h         |   11 +++++++++++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
> index cec9b55..4ec6e2f 100644
> --- a/drivers/watchdog/watchdog_core.c
> +++ b/drivers/watchdog/watchdog_core.c
> @@ -43,6 +43,17 @@
>  static DEFINE_IDA(watchdog_ida);
>  static struct class *watchdog_class;
>  
> +static struct watchdog_device *wdd_reboot_dev;
> +
> +void watchdog_do_reboot(enum reboot_mode mode, const char *cmd)
> +{
> +	if (wdd_reboot_dev) {
> +		if (wdd_reboot_dev->ops->reboot)
> +			wdd_reboot_dev->ops->reboot(wdd_reboot_dev, mode, cmd);
> +	}
> +}

What reboot_mode values would you expect a watchdog to support other than
REBOOT_HARD? Also, is the cmd even useful here?

Will
