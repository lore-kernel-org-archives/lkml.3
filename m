Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaAQRyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:54:14 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:43248 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbaAQRyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:54:12 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Felipe Balbi <balbi@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: phy: msm: fix compilation errors when !CONFIG_PM_SLEEP
References: <20140117132232.GC15937@n2100.arm.linux.org.uk>
	<1389979580-14812-1-git-send-email-joshc@codeaurora.org>
Date: Fri, 17 Jan 2014 09:54:09 -0800
In-Reply-To: <1389979580-14812-1-git-send-email-joshc@codeaurora.org> (Josh
	Cartwright's message of "Fri, 17 Jan 2014 11:26:20 -0600")
Message-ID: <87lhyemr3y.fsf@linaro.org>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Cartwright <joshc@codeaurora.org> writes:

> Both the PM_RUNTIME and PM_SLEEP callbacks call into the common
> msm_otg_{suspend,resume} routines, however these routines are only being
> built when CONFIG_PM_SLEEP.  In addition, msm_otg_{suspend,resume} also
> depends on msm_hsusb_config_vddcx(), which is only built when
> CONFIG_PM_SLEEP.
>
> Fix the CONFIG_PM_RUNTIME, !CONFIG_PM_SLEEP case by changing the
> preprocessor conditional, and moving msm_hsusb_config_vddcx().
>
> While we're here, eliminate the CONFIG_PM conditional for setting
> up the dev_pm_ops.
>
> This address the following errors Russell King has hit doing randconfig
> builds:
>
> drivers/usb/phy/phy-msm-usb.c: In function 'msm_otg_runtime_suspend':
> drivers/usb/phy/phy-msm-usb.c:1691:2: error: implicit declaration of function 'msm_otg_suspend'
> drivers/usb/phy/phy-msm-usb.c: In function 'msm_otg_runtime_resume':
> drivers/usb/phy/phy-msm-usb.c:1699:2: error: implicit declaration of function 'msm_otg_resume'
>
> Cc: Ivan T. Ivanov <iivanov@mm-sol.com>
> Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>

[...]

> @@ -440,7 +414,32 @@ static int msm_otg_reset(struct usb_phy *phy)
>  #define PHY_SUSPEND_TIMEOUT_USEC	(500 * 1000)
>  #define PHY_RESUME_TIMEOUT_USEC	(100 * 1000)
>  
> -#ifdef CONFIG_PM_SLEEP
> +#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_PM_RUNTIME)

nit: you should just use CONFIG_PM here since that is what it's for.

c.f. kernel/power/Kconfig:

config PM
        def_bool y
        depends on PM_SLEEP || PM_RUNTIME

Kevin
