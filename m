Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab3FXRzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 13:55:50 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:61974 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab3FXRzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 13:55:47 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] ARM: OMAP2+: omap_device: add pinctrl handling
References: <1371826990-25820-1-git-send-email-grygorii.strashko@ti.com>
Date: Mon, 24 Jun 2013 10:55:43 -0700
In-Reply-To: <1371826990-25820-1-git-send-email-grygorii.strashko@ti.com>
	(Grygorii Strashko's message of "Fri, 21 Jun 2013 18:03:10 +0300")
Message-ID: <87zjuftmu8.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grygorii,

Grygorii Strashko <grygorii.strashko@ti.com> writes:

> Before switching to DT pinctrl states of OMAP IPs have been handled by hwmod
> framework. After switching to DT-boot the pinctrl handling was dropped from
> hwmod framework and, as it was recommended, OMAP IP's drivers have to be updated
> to handle pinctrl states by itself using pinctrl_pm_select_xx() helpers
> (see http://lists.infradead.org/pipermail/linux-arm-kernel/2013-June/173514.html)
>
> But this is not right for OMAP2+ SoC where real IPs state is controlled
> by omap_device core which enables/disables modules & clocks actually.
>
> For example, if OMAP I2C driver will handle pinctrl state during system wide
> suspend the following issue may occure:
> - suspend_noirq - I2C device can be still active because of PM auto-suspend
>   |-_od_suspend_noirq
>      |- omap_i2c_suspend_noirq
>         |- PINs state set to SLEEP
>   |- pm_generic_runtime_suspend
>      |- omap_i2c_runtime_suspend()
>         |- PINs state set to IDLE  <--- *oops* PINs state is IDLE and not SLEEP
>   |- omap_device_idle()
>      |- omap_hwmod_idle()
>         |- _idle()
>            |- disbale module (sysc&clocks)
>
> - resume_noirq - I2C was active before suspend
>   |-_od_resume_noirq
>      |- omap_hwmod_enable()
>         |- _enable()
>            |- enable module (sysc&clocks)
>      |- pm_generic_runtime_resume
>         |- omap_i2c_runtime_resume()
>            |- PINs state set to DEFAULT  <--- !!!!
>      |- omap_i2c_resume_noirq
>         |- PINs state set to DEFAULT
>         |- PINs state set to IDLE  <--- *big oops* we have active module and its
>                                          PINs state is IDLE
> (see https://patchwork.kernel.org/patch/2642101/)
>
> Of course, everything can be handled by adding a tons of code in ecah driver to
> check PM state of device and override default behavior of omap_device core, but
> this not good.
>
> Hence, add pinctrl handling in omap_device core:
> 1) on PM runtime resume
> - switch pinctrl state to "default" (todo: "active")
> 2) on PM runtime suspend
> - switch pinctrl state to "idle"
> 3) during system wide suspend
> - switch pinctrl state to "sleep" or "idle" if omap_device core disables device
> - switch pinctrl state to "sleep" if device is disabled already
> 4) during system wide resume
> - switch pinctrl state to "default" (todo: "active") if omap_device core has
>   disabled  device during suspend
> - switch pinctrl state to "idle" if device was already disabled before suspend
>
> This will enable pinctrl for all OMAP2+ IP's drivers by default -
> no changes in code is needed and only DT data will need to be updated
> (add "default", "active", "idle", "sleep" states).
>
> This will enable pinctrl handling for all OMAP2+ drivers by default -
> no changes in code is needed and only DT data will need to be updated
> (add "default", "active", "idle", "sleep" states).
>
> Related discussions:
> - [3/3] i2c: nomadik: use pinctrl PM helpers 
>  https://patchwork.kernel.org/patch/2670291/
> - mmc: omap_hsmmc: Remux pins to support SDIO interrupt and PM runtime
>  https://patchwork.kernel.org/patch/2690191/
> - [PATCH 00/11] drivers: Add Pinctrl PM support
>  https://lkml.org/lkml/2013/5/31/210
>
> CC: Hebbar Gururaja <gururaja.hebbar@ti.com>
> CC: Linus Walleij  <linus.walleij@linaro.org>
> CC: linux-arm-kernel@lists.infradead.org
> CC: linux-omap@vger.kernel.org
> CC: linux-kernel@vger.kernel.org 
>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
> Hi Kevin, Tony,
>
> I've verified this patch on OMAP4 SDP board:
> - PM runtime for I2C4, UART2, UART3
> - suspend/resume with I2C4, UART2, UART3
>
> seems it works and pinctrl states have been updated as expected.

Thanks for working on this.

I agree with the approach, and much prefer this to boiler plate code
throughout the drivers.

I suggest we wait until the dust settles on the active/default thread
before taking this further, but have no objections to the approach.

Kevin


