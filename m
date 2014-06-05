Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaFESsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:48:36 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:46489 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbaFESse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:48:34 -0400
MIME-Version: 1.0
In-Reply-To: <1401467562-5585-1-git-send-email-dianders@chromium.org>
References: <1401398496-4624-1-git-send-email-dianders@chromium.org>
	<1401467562-5585-1-git-send-email-dianders@chromium.org>
Date: Thu, 5 Jun 2014 11:48:32 -0700
X-Google-Sender-Auth: mqv93sqTMyL3g5_kxurEG9xRfqA
Message-ID: <CAD=FV=W8-M5iOMDG190WGaeSySTd=qcp30k-H8DMUs_C5Pdwog@mail.gmail.com>
Subject: Re: [PATCH v2] clk: exynos5420: Keep aclk66_peric enabled during boot
From: Doug Anderson <dianders@chromium.org>
To: Tomasz Figa <t.figa@samsung.com>, Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: Olof Johansson <olof@lixom.net>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz / Mike,

On Fri, May 30, 2014 at 9:32 AM, Doug Anderson <dianders@chromium.org> wrote:
> Right now if you've got earlyprintk enabled on exynos5420-peach-pit
> then you'll get a hang on boot.  Here's why:
>
> 1. The i2c-s3c2410 driver will probe at subsys_initcall.  It will
>    enable its clock and disable it.  This is the clock "i2c2".
> 2. The act of disabling "i2c2" will disable its parents.  In this case
>    the parent is "aclk66_peric".  There are no other children of
>    "aclk66_peric" officially enabled, so "aclk66_peric" will be turned
>    off (despite being CLK_IGNORE_UNUSED, but that's by design).
> 3. The next time you try to earlyprintk you'll do so without the UART
>    clock enabled.  That's because the UART clocks are also children of
>    "aclk66_peric".  You'll hang.
>
> There's no good place to put a clock enable for earlyprintk, which is
> handled by a bunch of assembly code.  The best we can do is to handle
> this in the clock driver.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
> Changes in v2:
> - Use GATE_A and clk_get().  Save the clock for putting later.
> - Return 0 from exynos5420_clk_late_init().
>
>  drivers/clk/samsung/clk-exynos5420.c | 33 +++++++++++++++++++++++++++++++--
>  1 file changed, 31 insertions(+), 2 deletions(-)

Are there other changes you'd like me to make to this?  It would be
really nice to get this in for 3.16 so the system doesn't just
mysteriously hang when you use earlyprintk.

-Doug
