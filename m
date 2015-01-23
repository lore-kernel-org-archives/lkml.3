Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbbAWI6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:58:21 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:55723 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbbAWI6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 03:58:17 -0500
MIME-Version: 1.0
In-Reply-To: <1421683413-27075-1-git-send-email-p.osmialowsk@samsung.com>
References: <1421683413-27075-1-git-send-email-p.osmialowsk@samsung.com>
Date: Fri, 23 Jan 2015 09:58:16 +0100
X-Google-Sender-Auth: QqubxItbKID6e2RDfNdPOaOj9OQ
Message-ID: <CAJKOXPfTwkx7A6tjMaANuafsFonAunDv4CV+QPgF6SKbRZ4mzQ@mail.gmail.com>
Subject: Re: [PATCH] i2c: s3c2410: fix ABBA deadlock by keeping clock prepared
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Paul Osmialowski <p.osmialowsk@samsung.com>
Cc: Kukjin Kim <kgene@kernel.org>, Wolfram Sang <wsa@the-dreams.de>,
        Mark Brown <broonie@kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-19 17:03 GMT+01:00 Paul Osmialowski <p.osmialowsk@samsung.com>:
> This patch solves deadlock between clock prepare mutex and regmap mutex reported
> by Tomasz Figa in [1] by implementing solution from [2]: "always leave the clock
> of the i2c controller in a prepared state".
>
> [1] https://lkml.org/lkml/2014/7/2/171
> [2] https://lkml.org/lkml/2014/7/2/207
>
> On each i2c transfer handled by s3c24xx_i2c_xfer(), clk_prepare_enable() was
> called, which calls clk_prepare() then clk_enable(). clk_prepare() takes
> prepare_lock mutex before proceeding. Note that i2c transfer functions are
> invoked from many places in kernel, typically with some other additional lock
> held.
>
> It may happen that function on CPU1 (e.g. regmap_update_bits()) has taken a
> mutex (i.e. regmap lock mutex) then it attempts i2c communication in order to
> proceed (so it needs to obtain clock related prepare_lock mutex during transfer
> preparation stage due to clk_prepare() call). At the same time other task on
> CPU0 wants to operate on clock (e.g. to (un)prepare clock for some other reason)
> so it has taken prepare_lock mutex.
>
> CPU0:                        CPU1:
> clk_disable_unused()         regulator_disable()
>   clk_prepare_lock()           map->lock(map->lock_arg)
>   regmap_read()                s3c24xx_i2c_xfer()
>     map->lock(map->lock_arg)     clk_prepare_lock()
>
> Implemented solution from [2] leaves i2c clock prepared. Preparation is done in
> s3c24xx_i2c_probe() function. Without this patch, it is immediately unprepared
> by clk_disable_unprepare() call. I've replaced this call with clk_disable() and
> I've added clk_unprepare() call in s3c24xx_i2c_remove().
>
> The s3c24xx_i2c_xfer() function now uses clk_enable() instead of
> clk_prepare_enable() (and clk_disable() instead of clk_unprepare_disable()).
>
> Signed-off-by: Paul Osmialowski <p.osmialowsk@samsung.com>
> ---
>  drivers/i2c/busses/i2c-s3c2410.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)

Looks good to me.

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof
